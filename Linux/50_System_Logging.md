# 50: System Logging

<p align="center">
  <img src="images/linux_system_logging.png" alt="Linux System Logging" width="800"/>
</p>

Every kernel message, every failed SSH login, every cron job output — **logs capture it all**. Mastering Linux logging means you can find the needle in a haystack when a server goes down at 3 AM.

---

## 1. The Logging Architecture

Modern Linux uses a **dual-logging** system:

| Component | Storage | Format | Tool |
| :--- | :--- | :--- | :--- |
| **journald** (systemd) | Binary (`/run/log/journal/`) | Structured (key=value) | `journalctl` |
| **rsyslog** / **syslog** | Text (`/var/log/`) | Plain text lines | `cat`, `grep`, `tail` |

Both work together: `journald` captures everything, and `rsyslog` writes filtered subsets to traditional log files.

---

## 2. journalctl — The Modern Way

### Basic Usage:
```bash
# View all logs (newest last)
journalctl

# Follow logs in real-time (like tail -f)
journalctl -f

# Show logs since last boot
journalctl -b

# Show logs from previous boot
journalctl -b -1
```

### Filtering:
```bash
# By service/unit
journalctl -u nginx.service
journalctl -u sshd.service --since "1 hour ago"

# By priority (0=emerg → 7=debug)
journalctl -p err                # Errors and above
journalctl -p warning..err       # Warning through Error

# By time range
journalctl --since "2024-01-15 10:00" --until "2024-01-15 12:00"
journalctl --since yesterday

# By PID
journalctl _PID=1234

# Kernel messages only (like dmesg)
journalctl -k
```

### Output Formats:
```bash
journalctl -o json-pretty        # Full structured JSON
journalctl -o short-iso          # ISO timestamps
journalctl -o verbose            # All metadata fields
```

---

## 3. Traditional Log Files

### Key Files in `/var/log/`:
| File | Contents |
| :--- | :--- |
| `syslog` / `messages` | General system messages |
| `auth.log` / `secure` | Authentication events (login, sudo, SSH) |
| `kern.log` | Kernel messages |
| `dmesg` | Hardware/driver boot messages |
| `dpkg.log` | Package installation history |
| `apt/history.log` | APT operations |
| `cron.log` | Cron job execution |
| `faillog` | Failed login attempts |

```bash
# Watch auth logs in real-time
sudo tail -f /var/log/auth.log

# Find failed SSH logins
grep "Failed password" /var/log/auth.log

# Check recent package installs
tail -20 /var/log/dpkg.log
```

---

## 4. Syslog Facilities and Severities

The syslog protocol categorizes messages by **facility** (source) and **severity** (importance):

### Severities (0 = most critical):
| Code | Name | Meaning |
| :--- | :--- | :--- |
| 0 | `emerg` | System is unusable |
| 1 | `alert` | Immediate action required |
| 2 | `crit` | Critical conditions |
| 3 | `err` | Error conditions |
| 4 | `warning` | Warning conditions |
| 5 | `notice` | Normal but significant |
| 6 | `info` | Informational |
| 7 | `debug` | Debug-level messages |

### Facilities:
| Facility | Source |
| :--- | :--- |
| `kern` | Kernel messages |
| `auth` / `authpriv` | Authentication |
| `cron` | Cron scheduler |
| `daemon` | System daemons |
| `mail` | Mail subsystem |
| `local0`–`local7` | Custom application use |

---

## 5. Log Rotation with `logrotate`

Without rotation, logs would consume all disk space. `logrotate` compresses and archives old logs automatically.

```bash
# Main config
cat /etc/logrotate.conf

# Per-application configs
ls /etc/logrotate.d/
```

### Example logrotate config:
```
/var/log/myapp/*.log {
    daily                    # Rotate daily
    rotate 14                # Keep 14 days
    compress                 # gzip old logs
    delaycompress            # Don't compress yesterday's
    missingok                # Don't error if log is missing
    notifempty               # Don't rotate empty files
    create 0640 root adm     # Permissions for new log file
    postrotate
        systemctl reload myapp    # Signal app to reopen log
    endscript
}
```

---

## 6. Making Logs Persistent

By default, `journald` stores logs in volatile memory (`/run/log/journal/`). To survive reboots:

```bash
# Create persistent storage
sudo mkdir -p /var/log/journal
sudo systemd-tmpfiles --create --prefix /var/log/journal

# Configure in /etc/systemd/journald.conf:
# Storage=persistent
# SystemMaxUse=500M
# MaxRetentionSec=1month

sudo systemctl restart systemd-journald
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update > /dev/null 2>&1 && apt-get install -y rsyslog > /dev/null 2>&1
```

### Exercise 1: Read the Kernel Ring Buffer
> **Goal:** Access hardware/driver messages.
```bash
dmesg | head -15
dmesg | grep -i memory
```
✅ **Expected:** Boot-time kernel messages showing memory detection and driver initialization.

### Exercise 2: Explore /var/log
> **Goal:** Identify what log files exist in the container.
```bash
ls -la /var/log/
cat /var/log/dpkg.log | tail -10
```
✅ **Expected:** A list of log files; `dpkg.log` shows recent package installations.

### Exercise 3: Generate and Find Custom Log Entries
> **Goal:** Write to syslog and find your message.
```bash
service rsyslog start 2>/dev/null
logger "Lab test: Hello from Chapter 50!"
grep "Lab test" /var/log/syslog 2>/dev/null || grep "Lab test" /var/log/messages 2>/dev/null || echo "Check journalctl instead"
```
✅ **Expected:** Your custom message appears in the system log with a timestamp.

---

[<< Previous: Boot Process & GRUB](./49_Boot_Process_and_GRUB.md) | [Home: Curriculum Map](./README.md) | [Next: Vim Mastery >>](./51_Vim_Mastery.md)
