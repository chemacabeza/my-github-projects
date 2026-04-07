<div align="center">
  <img src="./images/linux_ch44_users.png" alt="Linux User Management Cover" width="800"/>
</div>

# 44: User Management

> 🧠 **The Feynman Hook:** Building a Linux Server is like building an office building. You have the CEO (`root`), employees (`users`), and departments (`groups`). When a new employee is hired, they are given an ID Badge (`useradd`) and assigned to a specific department (`usermod -aG`). They also get their very own locked office (`/home/username`) where they can work privately.

**🎯 The Big Goal:** Master User and Group manipulation, understand the `/etc/passwd` database, and configure secure privilege escalation using `sudo`.

---

## 1. Hiring Employees (`useradd`)

To create a new user, you must provision their ID and their private office space.

```bash
# Create user 'alice', generate her private /home/alice folder (-m), and give her a terminal shell (-s)
sudo useradd -m -s /bin/bash alice
```

---

## 2. Department Assignments (`usermod`)

If Alice is promoted to the Administration department, you add her to the `sudo` group.

```bash
# -a (Append), -G (Group). Adding her to the 'sudo' group grants her admin privileges.
sudo usermod -aG sudo alice

# IMPORTANT: If you forget the -a (Append) flag, you will violently remove her from all her existing groups!
```

---

## 3. The Identification Databases

Linux does not store users in an external database like SQL. It stores them in plaintext files.

### `/etc/passwd` — The Directory
This file is readable by everyone. It lists the Username, the numerical User ID (UID), and the location of their Home directory.
```bash
cat /etc/passwd | grep alice
# Output: alice:x:1001:1001::/home/alice:/bin/bash
```

### `/etc/shadow` — The Vault
This file contains the extremely sensitive cryptographic hashes of everyone's passwords. It can ONLY be read by `root`.
```bash
sudo cat /etc/shadow | grep alice
```

---

## 4. Privilege Escalation (`sudo`)

If Alice is logged in and tries to restart the network, Linux blocks her. She is just an employee. But because she is in the `sudo` department, she can briefly put on the "CEO Hat" to run specific administrative tasks.

```bash
# Without sudo: Permission Denied
systemctl restart networking

# With sudo: Executes as the root user mathematically
sudo systemctl restart networking
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe the security flaw of allowing every user to log into the 'root' account directly instead of using 'sudo'.</summary>
If five system administrators all share the main `root` password, accountability is explicitly destroyed. If a critical database is maliciously deleted, the system logs will only show that `root` did it. You cannot determine which human was responsible. By forcing administrators to log in with their own named accounts (e.g., `alice` or `bob`) and then using `sudo` to execute commands, the Linux system logs exactly which user invoked the `sudo` escalation, ensuring perfect auditing and security accountability.
</details>

---
[<< Previous: File Management](./43_File_Management.md) | [Home: Curriculum Map](./README.md) | [Next: Disk & System Info >>](./45_Disk_and_System_Info.md)
