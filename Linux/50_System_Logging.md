<div align="center">
  <img src="./images/linux_ch50_logging.png" alt="Linux System Logging Cover" width="800"/>
</div>

# 50: System Logging

> 🧠 **The Feynman Hook:** If a server crashes at 3:00 AM, the CPU does not have a memory of what happened. It simply reboots blankly. System Logging is the Black Box Flight Recorder. Every single time an app connects, a user logs in, or a disk fails, the Kernel writes a timestamped diary entry. Mastering log analysis means you do not guess why a server crashed; you simply read the exact autopsy report.

**🎯 The Big Goal:** Master `journalctl` to filter and mine the systemd binary log vault, and navigate legacy text logs in `/var/log`.

---

## 1. The Central Vault (`journalctl`)

In the past, thousands of apps wrote logs to thousands of random text files. `systemd` fixed this chaos by introducing the **Journal**—a centralized, structured, binary database that captures every log from the Kernel and every service simultaneously.

Because it is a database, you can execute precise filters against it:

```bash
# 1. Show all logs since the server was last booted
journalctl -b

# 2. Show logs exclusively for the SSH daemon
journalctl -u sshd

# 3. Filter by Severity: Only show Critical Errors (Drop all warnings/info)
journalctl -p err

# 4. Filter by precise time
journalctl --since "2024-03-20 14:00" --until "2024-03-20 15:00"
```

### The Live Tail
When you are actively deploying a new website and want to watch errors happen in real-time, you "Tail" the logs:
```bash
journalctl -u nginx -f
```

---

## 2. Legacy Text Logs (`/var/log`)

While `journalctl` is the modern standard, many applications still stream plaintext logs directly to `/var/log`.

- `/var/log/syslog` -> The general dump of system messages.
- `/var/log/auth.log` -> Tracks every single `sudo` execution, SSH login, and failed password attempt. Extremely vital for security audits.
- `/var/log/dmesg` -> The absolute lowest-level hardware detection logs from the Kernel.

Since these are pure text files, you parse them with standard text processing tools:
```bash
grep "Failed password" /var/log/auth.log
```

---

## 3. The Archives (`logrotate`)

If a web server generates 10 GB of text logs per day, your hard drive will fill up and crash the server within a week. Linux solves this automatically using `logrotate`. 

This background service runs daily, takes yesterday's active log file, zips it using `gzip` to save 90% of the space, and re-labels it (e.g., `syslog.1.gz`). If it gets older than 30 days, `logrotate` permanently deletes it.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe why reading logs with 'journalctl' is architecturally superior to using 'grep' on a text file.</summary>
Text files are raw strings. If you want to find all logs from yesterday, `grep` forces you to write complex Regular Expressions to parse arbitrary date formats string by string. `journalctl` queries a structured binary database. Every log entry contains dedicated, indexed metadata fields for `_TIME`, `_PID`, and `_SYSTEMD_UNIT`. This makes queries mathematically precise and vastly faster than reading Gigabytes of plaintext strings sequentially.
</details>

---
[<< Previous: Boot Process & GRUB](./49_Boot_Process_and_GRUB.md) | [Home: Curriculum Map](./README.md) | [Next: Networking Concepts Core >>](./51_Networking_Core.md)
