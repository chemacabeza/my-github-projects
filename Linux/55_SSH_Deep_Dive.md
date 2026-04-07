<div align="center">
  <img src="./images/linux_ch55_ssh.png" alt="Linux SSH Deep Dive Cover" width="800"/>
</div>

# 55: SSH Deep Dive

> 🧠 **The Feynman Hook:** In the early days of Linux, administrators logged into remote servers using Telnet. Telnet was a glass pipe. If a hacker listened on the network, they could see your password traveling in perfectly readable plaintext. Secure Shell (`SSH`) replaces the glass pipe with an impenetrable titanium tunnel. It uses brilliant cryptography to guarantee that even if a hacker intercepts every single byte on the wire, it looks like pure, meaningless static noise.

**🎯 The Big Goal:** Master Asymmetric Cryptography, abandon password-based authentication, and securely tunnel traffic using SSH Port Forwarding.

---

## 1. The Vault Keys (Asymmetric Cryptography)

Passwords can be brute-forced or stolen. SSH relies on Public Key Cryptography. You generate two mathematically linked keys: a **Public Key** (the Padlock) and a **Private Key** (the Laser Key).

```bash
# Generate a modern, highly secure Ed25519 keypair
ssh-keygen -t ed25519
```

You give the Public Padlock to the target server. You keep the Private Key strictly hidden on your local laptop. When you connect, the server challenges you with a mathematically locked puzzle. Only your specific private key can solve it. Because the private key never actually leaves your laptop, it cannot be intercepted.

---

## 2. Hardening the SSH Daemon

The SSH program running on the server is called `sshd`. It listens on Port 22. You must lock it down by editing its central configuration:

```bash
sudo nano /etc/ssh/sshd_config
```

### The Three Golden Rules of SSH Hardening:
1. `PermitRootLogin no` — Hackers always try to brute-force the 'root' user. Block direct root login entirely.
2. `PasswordAuthentication no` — Turn off typing passwords. If a user does not have a cryptographic private key, they are instantly rejected.
3. `Port 2222` — Changing the default port from 22 stops 99% of automated script-kiddie bots from constantly pinging your server.

---

## 3. The Transport Tunnel (Port Forwarding)

SSH is not just a terminal. Because the tunnel is completely encrypted, you can route other, unencrypted applications through it securely. 

Imagine you are at a coffee shop and want to reach your company's internal, insecure database running on Port 3306.

```bash
# Local Port Forwarding:
# Take my local port 8000, shove it through the SSH tunnel to secure_server.com, 
# and spit it out into the internal database at localhost:3306
ssh -L 8000:localhost:3306 root@secure_server.com
```

Now, when you connect your database software to your own local laptop at Port 8000, SSH silently encrypts the traffic, routes it to the secure server, and hands it sequentially to the database inside the firewall.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe why relying exclusively on 'PasswordAuthentication no' secures a server against Brute Force attacks mathematically.</summary>
A brute-force attack relies on systematically guessing every possible password (e.g., "password123", "admin"). An Ed25519 Private Key is a massive 256-bit cryptographic string. Guessing it mathematically requires checking 115 quattuorvigintillion combinations. It would take a supercomputer billions of years to guess the key. Therefore, if the SSH daemon absolutely refuses passwords and only accepts keys, brute-forcing becomes mathematically impossible and ceases to be a threat vector completely.
</details>

---
[<< Previous: Web Servers](./54_Web_Servers.md) | [Home: Curriculum Map](./README.md) | [Next: Virtualization >>](./56_Virtualization.md)
