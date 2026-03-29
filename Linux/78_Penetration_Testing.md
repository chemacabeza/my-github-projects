# 78: Linux for Penetration Testing

<p align="center">
  <img src="images/linux_pentest.png" alt="Linux Penetration Testing Environment" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll comprehend how Linux serves as the definitive platform for offensive security, mastering service exploitation concepts, network mapping, and the operational framework utilized by penetration testers.**

Unlike Windows or macOS, Linux provides unified access to raw sockets, network drivers, and programmable interfaces, making it the bedrock for attack distributions like Kali Linux and Parrot OS.

---

## 1. Network Reconnaissance and Mapping

Before attacking, a penetration tester maps the terrain using **nmap**.

### Port Scanning Phases
- **Host Discovery**: ICMP sweeps (`Ping`) or TCP ACKs (`-sn`).
- **Port Scanning**: Identifying open sockets. `SYN` Stealth scans (`-sS`) avoid completing the 3-way handshake to minimize logging footprint.
- **Service Enumeration**: Mapping open ports to exact server software and versions natively (`-sV`).
- **OS Fingerprinting**: Analyzing packet headers and TTLs to identify the host operating system (`-O`).

```bash
# Comprehensive scan: Top 1000 ports, TCP SYN, Version detection, OS detection
nmap -sS -sV -O 192.168.1.100
```

---

## 2. Exploitation Frameworks (Metasploit)

The **Metasploit Framework** is a ruby-based ecosystem organizing thousands of exploits, payloads, and encoders.

### The Attack Lexicon
- **Vulnerability**: A flaw in software logic (e.g., buffer overflow in an old Apache version).
- **Exploit**: The precise code required to trigger the vulnerability.
- **Payload**: The code executed *after* the exploit succeeds (e.g., opening a reverse shell).

### Reverse vs Bind Shells
If a server sits behind a firewall, blocking inbound connections:
- A **Bind Shell** opens a local port on the target and waits for you to connect (Firewall likely blocks this).
- A **Reverse Shell** instructs the target to connect outwards to your listening machine (Firewall often allows outbound traffic).

```bash
# Setting up a Netcat listener for a Reverse Shell
nc -lvnp 4444
```

---

## 3. Wireless Interception and 802.11

Linux's ability to put Wireless interfaces into **Monitor Mode** is devastating for perimeter security.

### WPA2 PSK Attacks
WPA2 Personal enforces encryption utilizing exactly the 4-way Handshake network process.
1. `airmon-ng` places the wireless card in monitor mode to capture raw radio frames natively.
2. `airodump-ng` captures the 4-way WPA handshake when a legitimate client authenticates.
3. Once captured, offline dictionary and brute-force attacks via `hashcat` attempt to crack the underlying Pre-Shared Key (PSK) against the captured mathematical hash.

---

## 4. Privilege Escalation

Gaining a shell typically yields low-level user access (e.g., the `www-data` account). To fully compromise the Linux host, privilege escalation into `root` is required.

**Vectors:**
- **SUID Binaries**: Misconfigured files with the SetUID bit execute as `root`. (`find / -perm -4000 2>/dev/null`)
- **Kernel Exploits**: Utilizing exploits against outdated Linux kernel processes (e.g., Dirty COW).
- **Sudo Misconfigs**: Accounts with `sudo` permissions lacking comprehensive command restrictions natively.

---

## 🤔 Reflection Questions

1. **Why does a `SYN` Scan (`-sS`) require `root` privileges on a Linux machine, whereas a `TCP Connect` Scan (`-sT`) does not?** (Hint: raw sockets).
2. **If you gain a shell via a web vulnerability but notice you are running under a restricted AppArmor profile, how does this affect privilege escalation?**
3. **During wireless hacking, why must the cracking of the WPA2 4-way Handshake be performed offline rather than injecting packets?**

---

## 📝 Key Interview Talking Points

- Describe the complete methodology of a penetration test: Reconnaissance -> Scanning -> Gaining Access -> Maintaining Access -> Covering Tracks.
- Articulate the technical distinction between a Bind Shell and a Reverse Shell against NAT routers.
- Understand the methodology for hunting SUID binaries during post-exploitation.

---

[<< Previous: Audit & Compliance](./77_Audit_Compliance.md) | [Home: Curriculum Map](./README.md) | [Next: Digital Forensics & IR >>](./79_Digital_Forensics_IR.md)
