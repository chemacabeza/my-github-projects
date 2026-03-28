# 66: Reconnaissance & Forensics

<p align="center">
  <img src="images/linux_recon_forensics.png" alt="Reconnaissance and Forensics" width="800"/>
</p>

Understanding offensive techniques is essential for defense. This chapter covers **network reconnaissance**, **port scanning**, **hash verification**, **script obfuscation**, and **digital evidence collection** — the techniques used by both attackers and incident responders.

---

## 1. Network Reconnaissance

### Host Discovery:
```bash
# Ping sweep a subnet
for ip in $(seq 1 254); do
    ping -c 1 -W 1 192.168.1.$ip > /dev/null 2>&1 && \
        echo "192.168.1.$ip is UP" &
done
wait

# ARP scan (faster, LAN only)
arp-scan --localnet 2>/dev/null || echo "Install: apt install arp-scan"
```

### Port Scanning with Bash:
```bash
# TCP connect scan (no nmap needed)
target="scanme.nmap.org"
for port in 22 80 443 8080 3306 5432; do
    (echo > /dev/tcp/$target/$port) 2>/dev/null && \
        echo "Port $port: OPEN" || echo "Port $port: closed"
done

# Nmap (when available)
nmap -sV -O target_host                # Service versions + OS detection
nmap -sS -p 1-65535 target_host        # SYN scan all ports
nmap -sU -p 53,67,161 target_host      # UDP scan (DNS, DHCP, SNMP)
```

---

## 2. Service Banner Grabbing

```bash
# HTTP banner
curl -sI http://target | head -5

# SSH banner
echo "" | nc -w 3 target 22

# SMTP banner
echo "QUIT" | nc -w 3 target 25

# Generic banner grab
echo "" | timeout 3 bash -c "cat < /dev/tcp/target/80" 2>/dev/null
```

---

## 3. DNS Reconnaissance

```bash
# Zone transfer attempt (often blocked)
dig axfr example.com @ns1.example.com

# Subdomain enumeration
for sub in www mail ftp vpn admin api; do
    host "$sub.example.com" 2>/dev/null | grep "has address" && \
        echo "Found: $sub.example.com"
done

# Reverse DNS sweep
for ip in $(seq 1 254); do
    result=$(dig -x 192.168.1.$ip +short 2>/dev/null)
    [ -n "$result" ] && echo "192.168.1.$ip → $result"
done
```

---

## 4. Hash Verification & Forensics

```bash
# Generate hashes of suspicious files
md5sum suspicious_file
sha256sum suspicious_file

# Compare with known-good hash
echo "expected_hash  filename" | sha256sum -c

# File type identification (magic bytes)
file suspicious_file
xxd suspicious_file | head -5          # Hex dump

# Extract strings from a binary
strings suspicious_file | grep -iE "http|password|api_key|secret"

# Check if a file is a known malware (VirusTotal CLI)
# sha256sum file | cut -d' ' -f1 | xargs -I{} curl -s "https://www.virustotal.com/api/v3/files/{}"
```

---

## 5. Script Obfuscation (& Detection)

### How Attackers Obfuscate:
```bash
# Base64 encoding
echo 'echo "hello"' | base64          # ZWNobyAiaGVsbG8iCg==
echo "ZWNobyAiaGVsbG8iCg==" | base64 -d | bash    # Execute decoded

# Variable-based obfuscation
a="ec"; b="ho"; c=" pwned"
$a$b$c                                 # Runs: echo pwned
```

### How Defenders Detect It:
```bash
# Find base64-encoded commands in scripts
grep -rn "base64" /tmp/ /var/tmp/ /home/ 2>/dev/null

# Find eval usage (common in obfuscated code)
grep -rn "eval\|exec\|bash -c\|sh -c" /tmp/ 2>/dev/null

# Decode and inspect
echo "suspicious_base64_string" | base64 -d
```

---

## 6. Evidence Collection

### Volatile Data (Collect FIRST):
```bash
# Order of volatility (most volatile first)
date > /tmp/evidence/timestamp.txt
cat /proc/meminfo > /tmp/evidence/memory.txt
ps aux > /tmp/evidence/processes.txt
ss -tulnp > /tmp/evidence/network.txt
who > /tmp/evidence/logged_in_users.txt
last -10 > /tmp/evidence/recent_logins.txt
ip addr show > /tmp/evidence/interfaces.txt
ip route show > /tmp/evidence/routes.txt
mount > /tmp/evidence/mounts.txt
```

### Non-Volatile Data:
```bash
# Hash all evidence files for chain of custody
find /tmp/evidence/ -type f -exec sha256sum {} \; > /tmp/evidence/hashes.txt

# System logs
cp /var/log/auth.log /tmp/evidence/
cp /var/log/syslog /tmp/evidence/

# Timeline of recently modified files
find / -mtime -1 -type f 2>/dev/null > /tmp/evidence/recent_files.txt
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update > /dev/null 2>&1 && apt-get install -y nmap curl dnsutils netcat-openbsd > /dev/null 2>&1
```

### Exercise 1: Port Scan with Pure Bash
> **Goal:** Scan ports without any external tools.
```bash
for port in 22 53 80 443; do
    (echo > /dev/tcp/8.8.8.8/$port) 2>/dev/null && \
        echo "8.8.8.8:$port OPEN" || echo "8.8.8.8:$port closed"
done
```
✅ **Expected:** Port 53 (DNS) is OPEN on Google's DNS server; others likely closed/filtered.

### Exercise 2: String Analysis of a Binary
> **Goal:** Extract readable strings from a system binary.
```bash
strings /usr/bin/ls | grep -i "usage\|version\|copyright" | head -5
file /usr/bin/ls
```
✅ **Expected:** Version strings and usage info extracted from the `ls` binary. `file` identifies it as an ELF executable.

### Exercise 3: Evidence Collection Drill
> **Goal:** Practice volatile data collection in order of priority.
```bash
mkdir -p /tmp/evidence
date > /tmp/evidence/timestamp.txt
ps aux > /tmp/evidence/processes.txt
ss -tulnp > /tmp/evidence/network.txt 2>/dev/null
cat /etc/passwd > /tmp/evidence/users.txt
sha256sum /tmp/evidence/* > /tmp/evidence/checksums.txt
cat /tmp/evidence/checksums.txt
```
✅ **Expected:** A set of evidence files with cryptographic checksums for chain-of-custody integrity.

---

[<< Previous: Cybersecurity Ops](./65_Cybersecurity_Bash.md) | [Home: Curriculum Map](./README.md) | [Next: inotify & File Monitoring >>](./67_inotify_File_Monitoring.md)
