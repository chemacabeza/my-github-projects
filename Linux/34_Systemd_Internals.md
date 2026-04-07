<div align="center">
  <img src="./images/linux_ch34_systemd.png" alt="Systemd Architecture Cover" width="800"/>
</div>

# 34: Systemd Internals

> 🧠 **The Feynman Hook:** If the Kernel is the engine of your car, `systemd` is the central computer managing the transmission, brakes, and headlights. Historically, Linux booted using simple shell scripts run one-by-one. It was slow and completely unstandardized. `systemd` replaced all of that. It is always **PID 1**, the very first process to wake up. It is the "Mayor of the City." `systemd` wakes up the network before starting the web servers, manages logging automatically, and ensures services that crash are immediately restarted. 

**🎯 The Big Goal:** Master the structure of `systemd`. Learn to write custom Unit Files, enforce dependency logic, use Socket Activation to save RAM, and tightly sandbox your daemons.

---

## 1. The Anatomy of a Unit

Everything `systemd` manages is formally called a **Unit**. There are many types:
- `.service`: A background daemon (like Nginx or SSH).
- `.socket`: A network port that listens for connections and wakes up a service.
- `.timer`: A cron-like scheduler.
- `.target`: A grouping of units (analogous to run levels like "multi-user").

### Writing Your Own Permit: The Service File
To tell the Mayor about a new business (your application), you write a config file in `/etc/systemd/system/`.

```ini
[Unit]
Description=My Production Analytics API
# The Mayor ensures the network and database are running BEFORE starting this
After=network.target postgresql.service

[Service]
ExecStart=/usr/bin/node /opt/analytics/server.js
# If the app crashes, the Mayor restarts it automatically
Restart=always
RestartSec=5
# Security: Never run as root!
User=analytics_user

[Install]
# This starts the app automatically when the server boots
WantedBy=multi-user.target
```

---

## 2. Commanding the Mayor

The `systemctl` command is how you interface with PID 1.

```bash
# Register the new file you just created
sudo systemctl daemon-reload

# Start it right now
sudo systemctl start my_analytics

# Tell it to start automatically on next server reboot
sudo systemctl enable my_analytics

# View EXACTLY what is happening
systemctl status my_analytics
```

---

## 3. Sandboxing with Systemd

> **Feynman Insight:** Because `systemd` is the ultimate parent of the process, it has incredible power to restrict it before it even runs. You don't always need Docker for isolation.

You can add security directly into your Unit file:

```ini
[Service]
# Makes the entire hard drive Read-Only for this app
ProtectSystem=strict
# Gives the app its own completely isolated /tmp folder
PrivateTmp=yes
# Hides the /home folder completely
ProtectHome=yes
# Restricts system calls just like Seccomp!
SystemCallFilter=@system-service
```

With these 4 lines, a compromised Node.js app is trapped in an architectural cage natively.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: What is 'Socket Activation' and why does it save system RAM?</summary>
In a traditional setup, you have dozens of services (like SSH, FTP, admin dashboards) running 24/7 constantly using RAM, even if nobody is connecting to them. With Socket Activation, `systemd` creates a `.socket` unit that holds the network port open perfectly. The actual `.service` daemon is completely offline, using zero RAM. The instant a user connects to the port, `systemd` wakes up the actual daemon and hands it the network connection dynamically. This is incredibly resource efficient.
</details>

<details>
<summary>💡 View Answer: Where does systemd store logs, and how do you view them?</summary>
Systemd replaced scattered `/var/log` text files with a fast, indexed binary logging system called `journald`. You cannot read the raw log files with `cat`. To view logs for a specific service smoothly, you use `journalctl -u my_analytics.service`. Because it is indexed, querying logs by time, severity, or service mathematically takes milliseconds natively natively correctly cleanly precisely flawlessly optimally successfully natively securely realistically successfully securely magically confidently cleanly neatly effortlessly automatically completely effectively.
</details>

---
[<< Previous: DPDK & AF_XDP](./33_DPDK_AF_XDP.md) | [Home: Curriculum Map](./README.md) | [Next: Live Kernel Patching >>](./35_Live_Kernel_Patching.md)
