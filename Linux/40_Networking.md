# 40: Networking

<p align="center">
  <img src="images/linux_networking.png" alt="Networking" width="600"/>
</p>

Essential networking commands for diagnostics, connectivity testing, and data transfer.

---

## 1. `ip` — Network Interface Configuration

The modern replacement for `ifconfig`.

```bash
ip addr show                      # Show all interfaces and IP addresses
ip addr show eth0                 # Show specific interface
ip link show                      # Show link layer info (MAC, state)
ip link set eth0 up               # Bring interface up
ip link set eth0 down             # Bring interface down
ip route show                     # Show routing table
ip route add default via 192.168.1.1  # Add default gateway
ip neigh show                     # Show ARP cache (neighbors)
```

---

## 2. `ss` — Socket Statistics

The modern replacement for `netstat`. Faster and more informative.

```bash
ss -tuln                          # Show TCP/UDP listening ports (numeric)
ss -tlnp                          # Show listening ports with process names
ss -s                             # Summary statistics
ss -t state established           # Show established TCP connections
ss dst 10.0.0.1                   # Connections to specific destination
```

| Flag | Meaning |
| :--- | :--- |
| `-t` | TCP sockets |
| `-u` | UDP sockets |
| `-l` | Listening only |
| `-n` | Numeric (don't resolve names) |
| `-p` | Show process using the socket |

---

## 3. `ping` — Connectivity Test

```bash
ping google.com                   # Continuous ping (Ctrl+C to stop)
ping -c 4 google.com              # Send exactly 4 packets
ping -i 0.5 192.168.1.1           # Ping every 0.5 seconds
ping -W 2 10.0.0.1                # Timeout after 2 seconds
ping6 ::1                         # IPv6 ping
```

---

## 4. `traceroute` / `tracepath` — Route Tracing

```bash
traceroute google.com             # Trace packet path through routers
traceroute -n google.com          # Numeric only (faster)
tracepath google.com              # Similar, no root required
mtr google.com                    # Combines ping + traceroute (live)
```

---

## 5. `dig` — DNS Lookup

The most powerful DNS diagnostic tool.

```bash
dig google.com                    # Full DNS query
dig google.com A                  # Query A records (IPv4)
dig google.com AAAA               # Query AAAA records (IPv6)
dig google.com MX                 # Query mail servers
dig google.com NS                 # Query nameservers
dig @8.8.8.8 google.com           # Use specific DNS server
dig +short google.com             # Short answer only
dig -x 8.8.8.8                    # Reverse DNS lookup
```

### Alternatives

```bash
nslookup google.com               # Simpler DNS lookup
host google.com                   # Compact DNS lookup
```

---

## 6. `curl` — Transfer Data

The Swiss Army knife of HTTP (and more).

```bash
curl https://example.com                    # GET request
curl -I https://example.com                 # HEAD only (response headers)
curl -o file.html https://example.com       # Save to file
curl -O https://example.com/image.png       # Save with original filename
curl -L https://short.url/xyz               # Follow redirects
curl -d "user=admin&pass=secret" https://api.com/login  # POST data
curl -H "Authorization: Bearer TOKEN" https://api.com   # Custom headers
curl -X PUT -d '{"key":"val"}' https://api.com/resource  # PUT request
curl -s https://api.com/data | jq .          # Silent mode + JSON parse
```

---

## 7. `wget` — Download Files

```bash
wget https://example.com/file.zip           # Download file
wget -c https://example.com/large.iso       # Resume interrupted download
wget -r -l 2 https://example.com            # Recursive download (depth 2)
wget -q -O - https://api.com/data           # Quiet mode, output to stdout
wget --mirror https://example.com           # Mirror entire site
```

---

## 8. `netstat` — Network Statistics (Legacy)

Replaced by `ss`, but still widely used.

```bash
netstat -tuln                     # Listening TCP/UDP ports
netstat -anp                      # All connections with PIDs
netstat -rn                       # Routing table
```

---

## 9. Quick Reference Table

| Command | Purpose | Key Flag |
| :--- | :--- | :--- |
| `ip` | Interface & routing | `addr`, `route`, `link` |
| `ss` | Socket statistics | `-tuln` (TCP/UDP listening) |
| `ping` | Connectivity test | `-c N` (count) |
| `traceroute` | Route tracing | `-n` (numeric) |
| `dig` | DNS lookup | `+short` |
| `curl` | HTTP transfers | `-I` (headers), `-d` (POST) |
| `wget` | File download | `-c` (resume) |
| `netstat` | Legacy socket stats | `-tuln` |

---

[<< Previous: Permissions](./39_Permissions.md) | [Home: Curriculum Map](./README.md) | [Next: Archiving >>](./41_Archiving.md)
