# 47: System Control

<p align="center">
  <img src="images/linux_system_control.png" alt="System Control" width="600"/>
</p>

Commands for managing system services, scheduling tasks, and controlling the system lifecycle.

---

## 1. `systemctl` — Service Manager

The primary interface to `systemd`, which manages all services on modern Linux distributions.

### Service Operations

```bash
sudo systemctl start nginx                 # Start a service
sudo systemctl stop nginx                  # Stop a service
sudo systemctl restart nginx               # Restart a service
sudo systemctl reload nginx                # Reload config without restart
sudo systemctl status nginx                # Check service status
sudo systemctl enable nginx                # Start on boot
sudo systemctl disable nginx               # Don't start on boot
sudo systemctl is-active nginx             # Check if currently running
sudo systemctl is-enabled nginx            # Check if enabled on boot
```

### Listing Services

```bash
systemctl list-units --type=service        # All loaded services
systemctl list-units --type=service --state=running  # Running only
systemctl list-unit-files --type=service   # All available services + state
systemctl list-units --failed              # Failed services
```

### Logs (journalctl)

```bash
journalctl -u nginx                        # Logs for specific service
journalctl -u nginx --since "1 hour ago"   # Recent logs
journalctl -u nginx -f                     # Follow (live tail)
journalctl -p err                          # Only errors
journalctl --disk-usage                    # Log disk usage
sudo journalctl --vacuum-size=500M         # Clean old logs
```

---

## 2. `shutdown` — Power Off

```bash
sudo shutdown now                          # Immediate shutdown
sudo shutdown -h now                       # Halt (power off)
sudo shutdown -h +10                       # Shutdown in 10 minutes
sudo shutdown -h 22:00                     # Shutdown at 10 PM
sudo shutdown -c                           # Cancel scheduled shutdown
```

---

## 3. `reboot` — Restart

```bash
sudo reboot                                # Immediate reboot
sudo reboot -f                             # Force (skip shutdown scripts)
sudo systemctl reboot                      # Systemd method
```

---

## 4. `timedatectl` — Time and Timezone

```bash
timedatectl                                # Show current time/date/timezone
timedatectl list-timezones                 # List all timezones
sudo timedatectl set-timezone Europe/Madrid  # Set timezone
sudo timedatectl set-time "2026-03-26 18:00:00"  # Set time manually
sudo timedatectl set-ntp true              # Enable NTP synchronization
```

---

## 5. `hostnamectl` — Hostname Management

```bash
hostnamectl                                # Show hostname and OS info
sudo hostnamectl set-hostname webserver01  # Change hostname
```

---

## 6. `cron` / `crontab` — Task Scheduling

### Managing Crontab

```bash
crontab -e                                 # Edit your crontab
crontab -l                                 # List your cron jobs
crontab -r                                 # Remove all cron jobs
sudo crontab -u alice -e                   # Edit alice's crontab
```

### Crontab Syntax

```
┌────── Minute (0-59)
│ ┌──── Hour (0-23)
│ │ ┌── Day of Month (1-31)
│ │ │ ┌ Month (1-12)
│ │ │ │ ┌ Day of Week (0-7, 0=Sun, 7=Sun)
│ │ │ │ │
* * * * * command
```

### Examples

```bash
# Run every day at 2:30 AM
30 2 * * * /home/user/backup.sh

# Run every 15 minutes
*/15 * * * * /usr/bin/health_check.sh

# Run Mon-Fri at 9 AM
0 9 * * 1-5 /home/user/report.sh

# Run on the 1st of every month
0 0 1 * * /home/user/monthly_cleanup.sh

# Run every Sunday at midnight
0 0 * * 0 /home/user/weekly_backup.sh
```

### System-Wide Cron Directories

```bash
ls /etc/cron.daily/                        # Scripts run daily
ls /etc/cron.weekly/                       # Scripts run weekly
ls /etc/cron.monthly/                      # Scripts run monthly
```

---

## 7. Systemd Timers (Modern Cron Alternative)

```bash
systemctl list-timers                      # List all active timers
systemctl list-timers --all                # Include inactive
```

---

## 8. `loginctl` — Session Management

```bash
loginctl                                   # List active sessions
loginctl list-users                        # List logged-in users
loginctl show-user alice                   # User session details
loginctl terminate-user alice              # Kill all sessions for user
```

---

## 9. Quick Reference Table

| Command | Purpose | Key Usage |
| :--- | :--- | :--- |
| `systemctl` | Service management | `start`, `stop`, `enable`, `status` |
| `journalctl` | Service logs | `-u service`, `-f` (follow) |
| `shutdown` | Power off | `now`, `+10`, `22:00` |
| `reboot` | Restart system | *(immediate)* |
| `timedatectl` | Time/timezone | `set-timezone` |
| `hostnamectl` | Hostname | `set-hostname` |
| `crontab` | Task scheduling | `-e` (edit), `-l` (list) |

---

[<< Previous: Process Management](./46_Process_Management.md) | [Home: Curriculum Map](./README.md) | [Next: Help & Reference >>](./48_Help_and_Reference.md)
