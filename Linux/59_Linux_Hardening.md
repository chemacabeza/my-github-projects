# 59: Linux Hardening

<p align="center">
  <img src="images/linux_hardening.png" alt="Linux Security Hardening" width="800"/>
</p>

A freshly installed Linux server is **not secure by default**. Hardening transforms a vanilla installation into a fortified production system — reducing the attack surface, enforcing least-privilege access, and enabling intrusion detection.

---

## 1. The Hardening Philosophy

> **Goal:** Make the system as difficult to compromise as possible, even if an attacker gains initial access.

| Principle | Action |
| :--- | :--- |
| **Minimize Attack Surface** | Remove unused services, packages, ports |
| **Least Privilege** | Users get minimum required permissions |
| **Defense in Depth** | Multiple overlapping security layers |
| **Audit Everything** | Log all access, changes, and anomalies |

---

## 2. System Updates

The single most important security action:

```bash
# Debian/Ubuntu
sudo apt update && sudo apt upgrade -y
sudo apt autoremove                # Remove unused packages

# RHEL/Fedora
sudo dnf upgrade -y

# Enable automatic security updates (Ubuntu)
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

---

## 3. User Account Hardening

```bash
# Lock unused accounts
sudo passwd -l unused_user

# Set password expiration policy
sudo chage -M 90 -W 14 username   # Max 90 days, warn 14 days before

# View password aging info
sudo chage -l username

# Enforce strong passwords
sudo apt install libpam-pwquality
# Edit /etc/security/pwquality.conf:
# minlen = 12
# dcredit = -1  (require a digit)
# ucredit = -1  (require uppercase)
```

---

## 4. SSH Hardening

```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
AllowUsers deploy admin
Protocol 2
```

---

## 5. Firewall Configuration

```bash
# UFW (Ubuntu)
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp              # SSH
sudo ufw allow 443/tcp             # HTTPS
sudo ufw enable
sudo ufw status verbose

# Firewalld (RHEL)
sudo firewall-cmd --set-default-zone=drop
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

---

## 6. fail2ban — Brute-Force Protection

```bash
sudo apt install fail2ban

# Custom jail for SSH
cat > /etc/fail2ban/jail.local << 'EOF'
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
EOF

sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo fail2ban-client status sshd   # View banned IPs
```

---

## 7. Security Auditing with Lynis

```bash
sudo apt install lynis

# Run a full system audit
sudo lynis audit system

# View the report
cat /var/log/lynis-report.dat | grep suggestion
```

Lynis checks: file permissions, kernel parameters, network config, authentication, logging, and more.

---

## 8. Kernel Hardening via `sysctl`

```bash
# /etc/sysctl.d/99-hardening.conf
net.ipv4.ip_forward = 0                    # Disable IP forwarding
net.ipv4.conf.all.accept_redirects = 0     # No ICMP redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.rp_filter = 1            # Reverse path filtering
net.ipv4.tcp_syncookies = 1                # SYN flood protection
kernel.randomize_va_space = 2              # Full ASLR
fs.suid_dumpable = 0                       # No core dumps from SUID
kernel.core_uses_pid = 1

# Apply immediately
sudo sysctl -p /etc/sysctl.d/99-hardening.conf
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
```

### Exercise 1: Check for Open Ports
> **Goal:** Identify listening services.
```bash
apt-get update > /dev/null 2>&1 && apt-get install -y net-tools > /dev/null 2>&1
netstat -tulnp 2>/dev/null || ss -tulnp
```
✅ **Expected:** A list of services with their ports. In a hardened system, this list should be minimal.

### Exercise 2: Review Password Policy
> **Goal:** Inspect account security settings.
```bash
cat /etc/login.defs | grep -E "PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_WARN_AGE"
cat /etc/shadow | head -3
```
✅ **Expected:** Default password aging values and the shadow file format (showing hashed passwords).

### Exercise 3: Inspect Kernel Security Parameters
> **Goal:** Check if key hardening parameters are active.
```bash
sysctl net.ipv4.tcp_syncookies
sysctl kernel.randomize_va_space
sysctl net.ipv4.conf.all.accept_redirects
```
✅ **Expected:** SYN cookies = 1 (enabled), ASLR = 2 (full), ICMP redirects = 0 (disabled).

---

[<< Previous: Regular Expressions](./58_Regular_Expressions.md) | [Home: Curriculum Map](./README.md) | [Next: Troubleshooting >>](./60_Troubleshooting.md)
