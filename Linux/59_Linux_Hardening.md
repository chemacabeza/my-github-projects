<div align="center">
  <img src="./images/linux_ch59_hardening.png" alt="Linux Security Hardening Cover" width="800"/>
</div>

# 59: Security Hardening

> 🧠 **The Feynman Hook:** Installing a Linux server is like dropping a wooden fort into a forest full of wolves. Out of the box, it runs unnecessary services, leaves ports open, and relies on default passwords. Hardening is the process of physically upgrading the fort. You rip out the wooden doors, pour a titanium moat, disable the guest entrances, and station an automated sniper (`fail2ban`) on the roof to instantly eliminate anyone who knocks incorrectly more than three times.

**🎯 The Big Goal:** Master defensive architecture: UFW firewall restrictions, automated brute-force bans, disabling root execution, and the principle of Least Privilege.

---

## 1. The Titanium Drawbridge (UFW)

A firewall determines who is allowed to talk to the server. By default, Linux accepts traffic from anywhere. The Uncomplicated Firewall (`UFW`) is native software that securely seals the drawbridge.

```bash
# The Universal Rule: Deny everything incoming, Allow everything outgoing
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Punch exactly two explicit holes through the titanium wall
sudo ufw allow 22/tcp  # Allow SSH Management
sudo ufw allow 443/tcp # Allow HTTPS Web Traffic

# Activate the security shield
sudo ufw enable
```

---

## 2. The Roof Sniper (`fail2ban`)

If you leave Port 22 open for SSH, automated botnets will aggressively guess "root / password" 10,000 times a second forever. `fail2ban` is a daemon that strictly monitors your authentication logs in real time. 

If it detects an IP address failing a password 5 times sequentially, it dynamically re-writes the Kernel's strictly enforced `iptables` drop rule, instantly banishing that IP address from ever reaching the server again for 24 hours.

```bash
# Install the security daemon
sudo apt install fail2ban

# Verify which angry bots have been sniped and banished
sudo fail2ban-client status sshd
```

---

## 3. Disabling Default Superusers

If hackers know your username is `root`, they only have to guess your password. Banish root login entirely. 

```bash
# 1. Create a non-obvious user
sudo adduser sysadmin_frank

# 2. Grant them the ability to use 'sudo' temporarily
sudo usermod -aG sudo sysadmin_frank

# 3. Enter the SSH config and mathematically annihilate Root Login
sudo nano /etc/ssh/sshd_config
# Change: PermitRootLogin no

# 4. Restart the daemon
sudo systemctl restart ssh
```

---

## 4. Minimum Surface Area

Every running software package is a potential zero-day vulnerability waiting to be exploited. Hardening explicitly requires you to violently delete anything you do not mathematically require.

```bash
# List every single port currently open on the network
sudo ss -tulpn

# Stop and uninstall the legacy FTP server you didn't know was running
sudo systemctl stop vsftpd
sudo apt purge vsftpd
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe the architectural flaw in leaving a database port (e.g., MySQL 3306) open in UFW, even if the password is extremely strong.</summary>
Cryptographic passwords protect against unauthorized *authentication*, but they do absolutely zero to protect against Kernel *exploits*. If a Zero-Day buffer overflow vulnerability is discovered within the MySQL codebase itself, a hacker simply sends a perfectly formatted malicious packet to Port 3306. The packet bypasses the password prompt entirely and hijacks the CPU. By dropping the port in UFW, the packet physically bounces off the Kernel before the MySQL software even knows it arrived. The architecture must always defend the inner walls.
</details>

---
[<< Previous: Regular Expressions](./58_Regular_Expressions.md) | [Home: Curriculum Map](./README.md) | [Next: Troubleshooting >>](./60_Troubleshooting.md)
