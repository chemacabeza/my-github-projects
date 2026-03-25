# 34: Systemd Internals

<p align="center">
  <img src="images/container_internals.png" alt="Systemd Architecture" width="800"/>
</p>

`systemd` is PID 1 — the very first process the kernel launches after boot. It manages boot, services, logging, networking, timers, and more. Love it or hate it, you **must** understand it to operate any modern Linux system.

---

## 1. The "City Mayor" Analogy

`systemd` is the mayor of your Linux city. It wakes up every building (service), ensures the power plant (network) starts before the factories (web servers), manages the city journal (logging), and shuts everything down gracefully when the city sleeps.

---

## 2. Unit Files: The Building Permits

Everything systemd manages is defined in a **Unit File**. There are several types:

| Unit Type | Purpose | Example |
| :--- | :--- | :--- |
| `.service` | A daemon or process. | `nginx.service` |
| `.socket` | A network socket (for on-demand activation). | `sshd.socket` |
| `.timer` | A cron-like scheduler. | `logrotate.timer` |
| `.mount` | A filesystem mount point. | `home.mount` |
| `.target` | A group of units (like a "runlevel"). | `multi-user.target` |

### Anatomy of a Service Unit:
```ini
[Unit]
Description=My Production Web Server
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=notify
ExecStart=/usr/bin/myapp --production
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=5
User=www-data
MemoryMax=512M
CPUQuota=200%

[Install]
WantedBy=multi-user.target
```

---

## 3. Essential Commands

```bash
# Start / Stop / Restart
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx

# Enable (auto-start on boot) / Disable
sudo systemctl enable nginx
sudo systemctl disable nginx

# View the real-time status and last log lines
systemctl status nginx

# View ALL logs for a service
journalctl -u nginx -f        # Follow live
journalctl -u nginx --since today

# List all running services
systemctl list-units --type=service --state=running

# Analyze boot time
systemd-analyze blame
```

---

## 4. Socket Activation: Start on Demand

Instead of running a service 24/7, systemd can start it **only when someone connects** to its port:

```ini
# sshd.socket
[Socket]
ListenStream=22
Accept=yes

[Install]
WantedBy=sockets.target
```

When a connection arrives on port 22, systemd starts `sshd.service` automatically and hands over the socket. If nobody connects, the service sleeps — saving resources.

---

## 5. Hardening with systemd

Modern systemd provides **built-in sandboxing** at the service level:
```ini
[Service]
ProtectSystem=strict        # Mount / as read-only
ProtectHome=yes             # Hide /home
PrivateTmp=yes              # Each service gets its own /tmp
NoNewPrivileges=yes         # Cannot gain more capabilities
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
SystemCallFilter=@system-service
```

```bash
# Analyze how well a service is sandboxed (higher = safer)
systemd-analyze security nginx.service
```

---

*In Chapter 35, we learn how to patch a running kernel without rebooting.*

---
---

## 🧪 Sandbox: Practice Systemd Operations

The **Production Sandbox** provides a systemd-enabled environment:

```bash
cd sandbox/production-lab
docker compose up -d
docker exec -it production-sandbox bash
```

**Experiments:**
```bash
# Create a custom service unit
cat > /etc/systemd/system/hello.service << EOF
[Unit]
Description=Hello World Service

[Service]
ExecStart=/bin/echo "Hello from systemd!"
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

# Manage it
systemctl daemon-reload
systemctl start hello
journalctl -u hello

# Analyze boot performance
systemd-analyze blame 2>/dev/null || echo "Limited in container"
```

[<< Previous: DPDK & AF_XDP](./33_DPDK_AF_XDP.md) | [Home: Curriculum Map](./README.md) | [Next: Live Kernel Patching >>](./35_Live_Kernel_Patching.md)
