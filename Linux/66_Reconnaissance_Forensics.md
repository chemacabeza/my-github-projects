<div align="center">
  <img src="./images/linux_ch66_recon.png" alt="Linux Reconnaissance Cover" width="800"/>
</div>

# 66: Reconnaissance & Forensics

> 🧠 **The Feynman Hook:** If a physical bank is robbed, a detective does not just walk through the front door. They dust for fingerprints on the vault, check the exact timestamps on the security cameras, and monitor the highway traffic leaving the bank. Linux Forensics is the exact same discipline. A sysadmin must mathematically extract hidden network traffic using a Sniffer (`tcpdump`), audit the binary footprints of a malicious executable, and trace exactly who the hacker communicated with.

**🎯 The Big Goal:** Master `tcpdump` packet capture, read underlying binary metadata, and execute deep system auditing.

---

## 1. Dusting for Network Fingerprints (`tcpdump`)

Hackers cannot hack without communicating. They must send packets through your network card. `tcpdump` physically intercepts the copper wire of your server and copies every single electrical pulse traveling across it securely.

```bash
# Sneeze every single packet hitting the main ethernet interface directly to the screen
sudo tcpdump -i eth0

# Sieve violently: Only capture traffic originating from a specific hostile IP
sudo tcpdump -i eth0 src 192.168.1.50

# Sieve cleanly: Only capture standard HTTP traffic, ignoring the rest
sudo tcpdump -i eth0 port 80
```

Because reading thousands of packets in real-time is impossible, you save the raw network footprints to a `PCAP` (Packet Capture) file for deeper forensic autopsies using Wireshark later.
```bash
sudo tcpdump -i eth0 -w surveillance_capture.pcap
```

---

## 2. Interrogating the Executable (`strings` & `file`)

If you find a suspicious file named `update.sh` running blindly in `/tmp`, you never, *ever* execute it to see what it does. You interrogate it safely.

First, determine what the data actually is. Hackers often name Linux ELF binaries "update.sh" to fake out sysadmins.
```bash
# Read the literal binary header of the file regardless of the filename extension
file /tmp/update.sh
# Output: ELF 64-bit LSB executable (LIES! It is a compiled program, not a bash script)
```

Next, use the `strings` command. This violently rips the binary apart and extracts any perfectly legible English words baked inside the compiled code (like hardcoded IP addresses or password files).
```bash
strings /tmp/update.sh | grep "http"
# Output: http://malicious-command-server.com/payload.bin
```
You instantly mapped the hacker's domain securely without ever executing the virus.

---

## 3. Investigating Process Anomalies

A hidden virus must run in RAM to do damage. 

```bash
# Show every single open network connection and map it instantly to the specific driving Process ID (PID)
sudo netstat -tulpn

# Alternatively, use ss (Socket Statistics)
sudo ss -tulpn
```

If you discover a completely unknown process connected out to a Russian IP address on Port 4444, you immediately use `lsof` (List Open Files) to violently map exactly what files that process is quietly modifying on the hard drive underneath you.

```bash
sudo lsof -p 9994
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe the critical forensic difference between running 'cat /tmp/virus' versus running 'strings /tmp/virus'.</summary>
Running `cat` on a pure compiled binary file is destructive to the terminal. `cat` forcibly attempts to print raw non-printable control characters squarely to the screen, frequently corrupting the bash output physically into mathematical garbage. `strings` is a forensic tool scientifically engineered to surgically bypass all extreme non-printable binary hexadecimal instructions, filtering the file to explicitly output strictly human-readable ASCII text characters, permitting you to cleanly map the virus architecture securely.
</details>

---
[<< Previous: Cybersecurity Bash](./65_Cybersecurity_Bash.md) | [Home: Curriculum Map](./README.md) | [Next: inotify File Monitoring >>](./67_inotify_File_Monitoring.md)
