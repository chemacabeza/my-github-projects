# 53: DNS & DHCP

<p align="center">
  <img src="images/linux_dns_dhcp.png" alt="DNS and DHCP" width="800"/>
</p>

Every time you type `google.com`, the Domain Name System translates it to an IP address. Every time your laptop connects to Wi-Fi, DHCP assigns it a network configuration. Together, DNS and DHCP are the invisible backbone of every network.

---

## 1. DNS — Domain Name System

### The Resolution Hierarchy:
```
Your App → Local Resolver Cache → Recursive Resolver → Root Servers (.)
                                                        → TLD Servers (.com)
                                                          → Authoritative NS (google.com)
```

### DNS Record Types:
| Type | Purpose | Example |
| :--- | :--- | :--- |
| **A** | IPv4 address | `google.com → 142.250.80.46` |
| **AAAA** | IPv6 address | `google.com → 2607:f8b0::200e` |
| **CNAME** | Alias (canonical name) | `www.example.com → example.com` |
| **MX** | Mail server | `example.com → mail.example.com` |
| **NS** | Nameserver delegation | `example.com → ns1.example.com` |
| **TXT** | Text data (SPF, DKIM) | `v=spf1 include:_spf.google.com` |
| **PTR** | Reverse lookup (IP → name) | `46.80.250.142 → google.com` |
| **SOA** | Zone authority info | Serial, refresh, retry, expire |

---

## 2. DNS Query Tools

```bash
# Quick lookup
dig google.com                    # Full response
dig +short google.com             # Just the IP
dig google.com MX                 # Mail servers
dig google.com NS                 # Nameservers
dig -x 8.8.8.8                   # Reverse lookup

# Trace the full resolution path
dig +trace google.com

# Use a specific DNS server
dig @8.8.8.8 example.com

# Alternative tools
nslookup google.com
host google.com
resolvectl query google.com       # systemd-resolved
```

---

## 3. Local DNS Configuration

### `/etc/resolv.conf`:
```
# DNS servers (queried in order)
nameserver 8.8.8.8
nameserver 1.1.1.1
search example.com               # Default domain suffix
```

### `/etc/hosts` (Static overrides):
```
127.0.0.1    localhost
192.168.1.10 myserver.local myserver
```

### Resolution Order (`/etc/nsswitch.conf`):
```
hosts: files dns                  # Check /etc/hosts first, then DNS
```

---

## 4. DHCP — Dynamic Host Configuration Protocol

### The DORA Process:
| Step | Message | Direction | Purpose |
| :--- | :--- | :--- | :--- |
| **D** | DHCPDISCOVER | Client → Broadcast | "I need an IP!" |
| **O** | DHCPOFFER | Server → Client | "Here's 192.168.1.50" |
| **R** | DHCPREQUEST | Client → Server | "I'll take that IP" |
| **A** | DHCPACK | Server → Client | "Confirmed. Lease granted." |

### What DHCP Provides:
- IP address
- Subnet mask
- Default gateway
- DNS server addresses
- Lease duration

### Viewing DHCP Leases:
```bash
# View current DHCP lease
cat /var/lib/dhcp/dhclient.leases 2>/dev/null

# Release and renew
sudo dhclient -r eth0             # Release
sudo dhclient eth0                # Renew
```

---

## 5. systemd-resolved (Modern Ubuntu)

```bash
# Check resolver status
resolvectl status

# View DNS configuration per interface
resolvectl dns

# Flush the DNS cache
resolvectl flush-caches
resolvectl statistics             # Cache hit/miss stats
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update > /dev/null 2>&1 && apt-get install -y dnsutils iputils-ping > /dev/null 2>&1
```

### Exercise 1: DNS Resolution Chain
> **Goal:** Trace how a domain name gets resolved.
```bash
dig +trace example.com
```
✅ **Expected:** The full journey from root (`.`) → TLD (`.com`) → authoritative nameserver → final IP.

### Exercise 2: Query Different Record Types
> **Goal:** Explore the various DNS records for a domain.
```bash
dig +short google.com A
dig +short google.com AAAA
dig +short google.com MX
dig +short google.com NS
```
✅ **Expected:** IPv4, IPv6, mail servers, and nameservers for Google.

### Exercise 3: Override DNS Locally
> **Goal:** Use `/etc/hosts` to create a fake domain.
```bash
echo "127.0.0.1 myapp.local" >> /etc/hosts
ping -c 1 myapp.local
```
✅ **Expected:** Ping resolves `myapp.local` to `127.0.0.1` — no DNS server needed!

---

[<< Previous: Storage Management](./52_Storage_Management.md) | [Home: Curriculum Map](./README.md) | [Next: Web Servers >>](./54_Web_Servers.md)
