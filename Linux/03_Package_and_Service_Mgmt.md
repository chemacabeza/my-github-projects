# 03: Systemd and Package Management

Every modern Linux distribution runs a massive background orchestrator named **systemd**. It boots the system, starts all background services (Daemons), manages network adapters, and collects logs.

---

## 1. Mastering `systemctl` (Service Management)

When you deploy a Web Server, Database, or Docker container, `systemd` is the entity that keeps it alive in the background. We interface with `systemd` using the `systemctl` command.

```bash
# Check if the NGINX web server is running
systemctl status nginx

# Start or Stop the service explicitly
sudo systemctl stop nginx
sudo systemctl start nginx

# Enable it to start AUTOMATICALLY when the server reboots
sudo systemctl enable nginx
```

### Writing Your Own Service File
To daemonize your own custom applications (like a Python bot or Go microservice), you don't use infinite `while` loops. You write a `.service` file.

Create a file at `/etc/systemd/system/myapp.service`:

```ini
[Unit]
Description=My Custom Microservice
After=network.target

[Service]
# The user that should execute this program for security
User=chemacabeza
WorkingDirectory=/opt/myapp
# The literal command to run
ExecStart=/opt/myapp/server_binary
# Auto-heal! If it crashes, systemd waits 5 seconds and cold-restarts it.
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

After creating the file, reload `systemd` and start it:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now myapp
```
Your application is now an immortal Linux background daemon.

---

## 2. Reading System Logs (`journalctl`)

Traditional text logs go to `/var/log`. However, `systemd` captures standard output for *all* services continuously in a unified, high-speed binary format called the `journal`.

You must use `journalctl` to read them.

```bash
# View the live, scrolling tail of all system logs combined (like `tail -f`)
sudo journalctl -f

# View specifically the logs for YOUR custom microservice
sudo journalctl -u myapp.service -f

# View the Docker logs from yesterday exclusively
journalctl -u docker --since "yesterday"
```

---

## 3. Package Management (APT)

Linux software is compiled specifically for your CPU architecture and OS version. Instead of downloading arbitrary `.exe` files from the internet, you use a Package Manager interacting with hardened, signed Repositories.

Since you are running Ubuntu/Debian (or similar derived distros), your package manager is `apt` (Advanced Package Tool).

```bash
# 1. Update the local index of available packages from the internet servers
sudo apt update

# 2. Search for a software package
apt search nginx

# 3. Install it (automatically handles pulling dependencies)
sudo apt install nginx

# 4. Remove it
sudo apt remove nginx

# 5. Remove it AND delete its configuration files entirely
sudo apt purge nginx
```

If you ever manually download a `.deb` (Debian Package) file directly from a vendor (like Google Chrome or Discord), you install it using the lower-level tool `dpkg`:

```bash
sudo dpkg -i downloaded_cool_software.deb
```

### Summary of System Administration Basics
The moment you write your own `systemd.service` file and view its live logs through `journalctl`, you transition from a Linux user to a Linux Administrator. `systemd` is the beating heart of modern enterprise Linux infrastructure.

---

## 4. Containerized Execution (MacBook / Linux)
Standard Docker containers do absolutely **not** run `systemd` by default (Docker itself is the init system!). To practice writing `systemctl` daemons natively on a MacBook without a Virtual Machine, you must use a specialized Privileged image mounting the cgroup subsystem!

**`Dockerfile`**
```dockerfile
FROM jrei/systemd-ubuntu:22.04
RUN apt-get update && apt-get install -y nginx
WORKDIR /etc/systemd/system
CMD ["/lib/systemd/systemd"]
```

**`docker-compose.yml`**
```yaml
services:
  sysadmin-sandbox:
    build: .
    privileged: true # CRITICAL: Required for systemd to assume PID 1!
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    tty: true
```

**To Run:**
```bash
# 1. Start it safely in the background
docker compose up -d

# 2. Attach an interactive Bash shell to the running init system!
docker compose exec sysadmin-sandbox bash

# 3. Practice! 
systemctl status nginx
journalctl -f
```

---
[<< Previous: Command Line Survival](./02_Command_Line_Survival.md) | [Home: Curriculum Map](./README.md) | [Next: Bash Scripting Mastery >>](./04_Bash_Scripting_Mastery.md)
