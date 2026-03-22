# 06: Networking, Firewalls, and SSH Tunnels

Linux networking has moved far beyond the legacy `ifconfig` and `netstat` commands. Modern distributions rely exclusively on the `iproute2` suite.

---

## 1. Network Interfaces (`ip`)

The `ip` command allows administrators to view, modify, and route everything happening on the physical Ethernet cards.

```bash
# View all Network Interfaces (NICs) and their IP addresses
ip addr show

# View the Default Gateway (Routing table)
ip route show

# Completely disable a network interface!
sudo ip link set eth0 down

# Assign a static IP address temporarily instantly
sudo ip addr add 192.168.1.150/24 dev eth0
```

---

## 2. Port Hunting (`ss`)

When your Python or Go application won't start because "Port 8080 is already in use," you must isolate the process holding the port hostage.

`ss` (Socket Statistics) is vastly superior and infinitely faster than the deprecated `netstat`.

```bash
# View all actively LISTENING ports with their associated PID program name
sudo ss -tulpen

# t = TCP
# u = UDP
# l = Listening (Waiting for connections)
# p = Show exactly WHICH Program PID is doing the listening
# n = Show the numeric Port/IP instead of resolving DNS "http" 

# Isolate port 8080 specifically
sudo ss -tulpen | grep ":8080"
```

Once you find the offending `PID` (e.g., 5432), you send a `SIGKILL` (Module 05) to rip it out of memory:
```bash
sudo kill -9 5432
```

---

## 3. The Uncomplicated Firewall (`UFW` / `iptables`)

At its absolute core, the Linux network firewall is `iptables`. It intercepts packets within the Kernel perfectly (before they even reach the Application Layer) and drops them. 
However, `iptables` syntax is famously brutal. Ubuntu and Debian wrap it in `ufw` (Uncomplicated Firewall).

```bash
# 1. Check current status
sudo ufw status verbose

# 2. Add an explicit Allow rule before enabling!
sudo ufw allow ssh          # Standard Port 22
sudo ufw allow 80/tcp       # Web HTTP
sudo ufw allow 443/tcp      # Web HTTPS

# 3. Add an explicit Block rule
sudo ufw deny from 192.168.1.50 to any

# 4. Turn the firewall on
# DANGER: If you are connected remotely and did not `allow ssh` first, 
# you will permanently lock yourself out of the server forever!
sudo ufw enable
```

---

## 4. SSH (Secure Shell) Mastery

SSH is not just a remote terminal; it is an encrypted military-grade transport tunnel.

### Public-Key Authentication
Never use passwords for servers. They are brute-forced continuously. Generate an asymmetric RSA or Ed25519 keypair.

```bash
# 1. Generate the absolute strongest algorithm key locally
ssh-keygen -t ed25519 -C "admin_key"

# 2. Push the highly sensitive PUBLIC Key to the remote server automatically
ssh-copy-id username@remote-server.com

# 3. Connect securely!
ssh username@remote-server.com
```

### SSH Tunnels (Port Forwarding)
A developer's ultimate secret weapon. If an internal database is safely locked behind a firewall (Port 5432) and you cannot access it directly from your home laptop, you can instruct SSH to drill a hole through the firewall.

```bash
# Local Port Forwarding Syntax (-L)
ssh -L <Local_Port>:<Target_IP>:<Target_Port> username@jump-server

# Example Scenario:
# 1. We bind our Laptop's port 9000
# 2. We tell SSH to tunnel that traffic down the encrypted channel perfectly securely
# 3. We tell the jump server to unwrap the packets and blindly forward them to localhost:5432!
ssh -N -L 9000:localhost:5432 production_user@db-server.com
```

The `-N` flag means "Do not open an interactive shell, just hold the tunnel open."
Now, you open DataGrip or pgAdmin on your laptop, connect to `localhost:9000`, and you instantly have direct access to the heavily guarded production database through the encrypted SSH pipeline. 

### Summary
Sysadmin networking revolves entirely around isolating processes holding sockets (`ss`), configuring robust kernel firewalls (`ufw`), and manipulating encrypted streams (`ssh`). 

As you transition into Phase 3, you are no longer learning *how* to construct the machine; you begin learning **why** the machine ticks: the Linux Kernel itself.
