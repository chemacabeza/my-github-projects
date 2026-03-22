# 11: Deep Packet Inspection (TCP/IP)

Following *TCP/IP Illustrated*, we venture below the Application Layer (HTTP) to analyze the Transport Layer streams themselves natively.

When a microservice completely drops a connection without logging an error, you must inspect the raw network packets crossing the Linux network card. 

---

## 1. The TCP 3-Way Handshake

TCP (Transmission Control Protocol) is incredibly reliable, but it requires massive setup latency.
Every single time you open a connection to `google.com:443`, the Operating Systems perform a highly synchronized dance before a single byte of HTTP data is sent.

1. **Client sends `SYN` (Synchronize):** "Hi Server, my random sequence number is 1000. Let's talk securely."
2. **Server sends `SYN-ACK` (Acknowledge):** "I acknowledge 1000! My random sequence number is 5000."
3. **Client sends `ACK` (Acknowledge):** "I acknowledge 5000! Data transmission can formally begin."

If a firewall (`UFW` from Module 06) blocks port 443, the Server's Kernel will ignore the `SYN`. The Client will wait for 3 seconds, timeout, and send another `SYN` (TCP Retransmit). The connection will hang indefinitely!

If the Server is online but the specific application (e.g., Nginx) is dead, the Linux Kernel intercepts the `SYN`, realizes nothing is listening on port 443, and instantly fires back an aggressive `RST` (Reset) packet. The connection instantly drops with "Connection Refused."

---

## 2. Deep Inspection with `tcpdump`

If Nginx keeps returning `502 Bad Gateway` while trying to talk to an upstream Python server, we can intercept the exact binary packets flowing between them via `tcpdump`.

`tcpdump` is an extreme sniffer that copies packets perfectly silently out of the Kernel before they reach the Python layer.

```bash
# 1. Capture absolute everything passing through Ethernet card 0!
# (-n prevents slow DNS resolution, -nn prevents slow port resolution)
sudo tcpdump -i eth0 -n -nn

# 2. Extreme Filtering: Isolate traffic strictly going to Port 8080 OR coming from 10.0.0.5
sudo tcpdump -i eth0 -n -nn 'port 8080 or host 10.0.0.5'

# 3. Reading the HTTP payload dynamically!
# -A prints the packets in ASCII text so you can read the unencrypted HTTP Headers
# -s 0 captures the entire gigantic packet instead of truncating it
sudo tcpdump -i eth0 -n -nn -A -s 0 'port 80'
```

### Analyzing the Output
You will see output resembling:
`IP 192.168.1.5.54321 > 10.0.0.1.80: Flags [S], seq 1234567, length 0`

- `Flags [S]`: This is the `SYN` packet!
- `Flags [.]`: An invisible `ACK` packet!
- `Flags [P.]`: A `PSH+ACK`. Real data is flowing!
- `Flags [R.]`: Oh no. Overloaded. A brutal TCP `RST` reset!
- `Flags [F.]`: A `FIN` (Finish). The connection is politely closing gracefully.

---

## 3. Saving and Wireshark Translation

`tcpdump` output moves entirely too fast natively on a busy 10Gbps enterprise switch.
Instead of reading it in the terminal, you write the exact binary Kernel capture to a `.pcap` file.

```bash
# Captures 5000 massive packets rapidly to disk and then halts automatically
sudo tcpdump -i eth0 -w outage_capture.pcap -c 5000
```

You can then securely `scp` (Secure Copy) that `outage_capture.pcap` file back to your laptop and open it cleanly inside **Wireshark**. 
Wireshark provides a beautiful graphical interface allowing you to uniquely filter out the specific HTTP request that caused the Nginx timeout 502 error!

### Summary
When Application Logs silently fail, `tcpdump` proves precisely where the network is bleeding. By identifying `FIN` termination timeouts or aggressive `RST` connection drops, you stop hunting ghost bugs in your HTTP Router and begin fixing your underlying network proxy architectures!
