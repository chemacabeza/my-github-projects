<div align="center">
  <img src="./images/linux_ch47_systemd.png" alt="Linux System Control Cover" width="800"/>
</div>

# 47: System Control

> 🧠 **The Feynman Hook:** If programs are individual workers in an office, you need an Office Manager to turn the lights on at 8 AM, ensure front desk staff are at their posts before opening the doors, and fire workers who fall asleep. In Linux, this supreme manager is called `systemd`. It dictates exactly how the system boots, which services launch, and the chronological order in which they start.

**🎯 The Big Goal:** Master `systemctl` and `journalctl`, and conquer task scheduling using `cron`.

---

## 1. The Manager Interface (`systemctl`)

You interface with `systemd` using the `systemctl` command. 

```bash
# Start the web server right now
sudo systemctl start nginx

# Verify that it is actually running
sudo systemctl status nginx

# Tell the manager: "Always start the web server automatically if the server reboots"
sudo systemctl enable nginx
```

If you make a change to an application's configuration file, you must tell the manager to restart the app so it actually loads the new settings:
```bash
sudo systemctl restart nginx
```

---

## 2. Reading the Logs (`journalctl`)

Historically, Linux stored logs in basic text files located in `/var/log`. While those still exist, `systemd` acts as a vacuum cleaner, capturing every single log from every single service and shoving them into a massive binary database called the `journal`.

You cannot read the journal with `cat` or `grep`. You must use `journalctl`.

```bash
# View the live logs specifically for the nginx service (Updating in real time)
journalctl -u nginx -f

# View all system logs that occurred after the server was last booted
journalctl -b

# Filter to show only severe Crash errors
journalctl -p err
```

---

## 3. Scheduling Robots (`cron`)

`cron` is a time-based job scheduler. It is an alarm clock that runs scripts continuously at scheduled intervals without human intervention.

To edit your alarm clock, you run:
```bash
crontab -e
```

The syntax looks terrifying but is simply five numbers followed by a command:
```text
MINUTE HOUR DAY_OF_MONTH MONTH DAY_OF_WEEK     COMMAND
```

```bash
# Run the backup script every single day exactly at 3:30 AM
30 3 * * * /root/backup.sh

# Run the health check every 15 minutes, forever
*/15 * * * * /root/healthcheck.sh
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: What is the risk of reloading a systemd service versus restarting it?</summary>
When you `restart` a service, `systemd` violently kills the active process and spins up a brand new one. Any user actively connected to the server will instantly be dropped and get a network error. When you `reload` a service, the server continues processing its active user connections gracefully, but silently reads the new config file into memory to use for all *future* connections. Reloading ensures zero downtime.
</details>

---
[<< Previous: Process Management](./46_Process_Management.md) | [Home: Curriculum Map](./README.md) | [Next: Help & Reference >>](./48_Help_and_Reference.md)
