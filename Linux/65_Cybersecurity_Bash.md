# 65: Cybersecurity Operations with Bash

<p align="center">
  <img src="images/linux_cybersec_bash.png" alt="Cybersecurity Operations with Bash" width="800"/>
</p>

The command line is a cybersecurity operator's most versatile weapon. This chapter teaches you to **collect, process, and analyze security data** using nothing but Bash, turning everyday tools into a defensive security operations center.

---

## 1. The Security Operations Pipeline

```
Data Collection → Data Processing → Data Analysis → Alerting/Response
   (curl, logs)    (sed, awk, sort)   (uniq, grep)    (logger, mail)
```

---

## 2. Data Collection: Gathering Intelligence

### System Inventory:
```bash
# Operating system info
cat /etc/os-release
uname -a

# All installed packages (Debian)
dpkg -l | awk '{print $2, $3}' > /tmp/installed_packages.txt

# All listening services
ss -tulnp | awk 'NR>1 {print $1, $5, $7}'

# All user accounts
awk -F: '{print $1, $3, $7}' /etc/passwd

# SUID binaries (potential privilege escalation vectors)
find / -perm -4000 -type f 2>/dev/null
```

### Network Data:
```bash
# Active connections
ss -tun | awk 'NR>1 {print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn

# Capture DNS queries (requires tcpdump)
tcpdump -i eth0 port 53 -l 2>/dev/null | head -20

# Download a remote file and verify its hash
curl -sO https://example.com/file.bin
sha256sum file.bin
```

---

## 3. Log Analysis

### Failed SSH Login Analysis:
```bash
# Count failed attempts by IP
grep "Failed password" /var/log/auth.log | \
    awk '{print $(NF-3)}' | \
    sort | uniq -c | sort -rn | head -10

# Failed attempts by username
grep "Failed password" /var/log/auth.log | \
    awk '{print $(NF-5)}' | \
    sort | uniq -c | sort -rn | head -10

# Timeline of failed logins
grep "Failed password" /var/log/auth.log | \
    awk '{print $1, $2, $3}' | \
    uniq -c | sort -rn
```

### Web Server Log Analysis:
```bash
# Top 10 requesting IPs
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# HTTP status code distribution
awk '{print $9}' access.log | sort | uniq -c | sort -rn

# Top requested URLs
awk '{print $7}' access.log | sort | uniq -c | sort -rn | head -10

# Requests per hour
awk -F'[/:]' '{print $4":"$5}' access.log | sort | uniq -c
```

---

## 4. Real-Time Log Monitoring

```bash
# Monitor auth log for suspicious activity
tail -f /var/log/auth.log | while read line; do
    if echo "$line" | grep -q "Failed password"; then
        IP=$(echo "$line" | awk '{print $(NF-3)}')
        echo "[ALERT] Failed SSH from $IP at $(date)" | tee -a /tmp/alerts.log
    fi
done
```

---

## 5. Filesystem Integrity Monitoring

```bash
# Create a baseline of critical file checksums
sha256sum /etc/passwd /etc/shadow /etc/sudoers /usr/bin/sudo \
    /usr/sbin/sshd /bin/bash > /tmp/baseline.sha256

# Later — verify integrity
sha256sum -c /tmp/baseline.sha256
# Output: /etc/passwd: OK  or  /etc/passwd: FAILED
```

### Automated Integrity Checker:
```bash
#!/bin/bash
BASELINE="/root/baseline.sha256"
ALERT_LOG="/var/log/integrity_alerts.log"

sha256sum -c "$BASELINE" 2>/dev/null | grep FAILED | while read line; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INTEGRITY VIOLATION: $line" | \
        tee -a "$ALERT_LOG"
done
```

---

## 6. Password & Account Auditing

```bash
# Find accounts with empty passwords
awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow

# Find accounts with UID 0 (root equivalent)
awk -F: '$3 == 0 {print $1}' /etc/passwd

# Find accounts with no password aging
awk -F: '$5 == "" {print $1}' /etc/shadow

# List users who can sudo
grep -v '^#' /etc/sudoers 2>/dev/null | grep -v '^$'
getent group sudo
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update > /dev/null 2>&1 && apt-get install -y net-tools > /dev/null 2>&1
```

### Exercise 1: System Inventory
> **Goal:** Build a quick security snapshot of the system.
```bash
echo "=== OS ==="
cat /etc/os-release | grep PRETTY_NAME
echo -e "\n=== Users with shells ==="
awk -F: '$7 ~ /bash|sh/ {print $1, $7}' /etc/passwd
echo -e "\n=== Listening ports ==="
ss -tulnp 2>/dev/null || netstat -tulnp 2>/dev/null || echo "No listeners"
echo -e "\n=== SUID binaries ==="
find / -perm -4000 -type f 2>/dev/null | head -5
```
✅ **Expected:** A security overview showing OS, shell users, open ports, and SUID binaries.

### Exercise 2: Filesystem Integrity
> **Goal:** Create and verify a file integrity baseline.
```bash
sha256sum /etc/passwd /etc/hostname > /tmp/baseline.sha256
cat /tmp/baseline.sha256
echo "# Modifying a file..."
echo "testuser:x:9999:9999::/tmp:/bin/false" >> /etc/passwd
sha256sum -c /tmp/baseline.sha256
```
✅ **Expected:** `/etc/passwd: FAILED` — the integrity check detects the modification.

### Exercise 3: Account Auditing
> **Goal:** Find security-relevant account configurations.
```bash
echo "=== UID 0 (root-level) accounts ==="
awk -F: '$3 == 0 {print $1}' /etc/passwd
echo -e "\n=== Accounts without passwords ==="
awk -F: '($2 == "" || $2 == "!" || $2 == "*") {print $1}' /etc/shadow 2>/dev/null | head -5
```
✅ **Expected:** `root` as the UID-0 account, and several system accounts without real passwords.

---

[<< Previous: Shell Environment](./64_Shell_Environment.md) | [Home: Curriculum Map](./README.md) | [Next: Reconnaissance & Forensics >>](./66_Reconnaissance_Forensics.md)
