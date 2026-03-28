# 55: SSH Deep Dive

<p align="center">
  <img src="images/linux_ssh_deep_dive.png" alt="SSH Secure Tunneling" width="800"/>
</p>

SSH (Secure Shell) is the backbone of Linux remote administration. Beyond simple logins, SSH enables tunnels, port forwarding, agent forwarding, jump hosts, and file transfers — all through a single encrypted channel.

---

## 1. Key-Based Authentication

Password authentication is vulnerable to brute-force attacks. **Key-based auth is the standard.**

```bash
# Generate a modern keypair (Ed25519 — fastest, most secure)
ssh-keygen -t ed25519 -C "user@workstation"

# Copy your public key to a remote server
ssh-copy-id user@server

# Now login without a password
ssh user@server
```

### How It Works:
1. Your **private key** stays on your machine (`~/.ssh/id_ed25519`)
2. Your **public key** is placed on the server (`~/.ssh/authorized_keys`)
3. The server challenges you with data encrypted using your public key
4. Only the matching private key can decrypt it — proving your identity

---

## 2. SSH Config File

Instead of typing long commands, create `~/.ssh/config`:

```
# ~/.ssh/config
Host prod
    HostName 192.168.1.100
    User deploy
    Port 2222
    IdentityFile ~/.ssh/prod_key

Host staging
    HostName 10.0.0.50
    User admin
    ProxyJump bastion

Host bastion
    HostName bastion.company.com
    User ops
```

Now: `ssh prod` expands to the full connection parameters.

---

## 3. Port Forwarding (Tunneling)

### Local Forward (access remote service locally):
```bash
# Access remote PostgreSQL (port 5432) on your localhost:15432
ssh -L 15432:localhost:5432 user@dbserver
# Now connect to: psql -h localhost -p 15432
```

### Remote Forward (expose local service to remote):
```bash
# Let the remote server access your local web app on port 3000
ssh -R 8080:localhost:3000 user@server
# Remote users access: http://server:8080
```

### Dynamic SOCKS Proxy:
```bash
# Create a SOCKS5 proxy through the SSH tunnel
ssh -D 1080 user@server
# Configure browser to use SOCKS proxy at localhost:1080
```

---

## 4. ProxyJump (Bastion/Jump Hosts)

Access servers behind a firewall through an intermediary:

```bash
# One-liner: jump through bastion to reach internal server
ssh -J bastion.company.com user@internal-server

# Multiple hops
ssh -J hop1,hop2,hop3 user@destination
```

---

## 5. SSH Agent (Key Management)

```bash
# Start the agent
eval "$(ssh-agent -s)"

# Add your key (remembers passphrase)
ssh-add ~/.ssh/id_ed25519

# List loaded keys
ssh-add -l

# Forward your agent to remote sessions (for git, etc.)
ssh -A user@server
```

---

## 6. Hardening `sshd_config`

```bash
# /etc/ssh/sshd_config — critical security settings
PermitRootLogin no                 # Never allow root login
PasswordAuthentication no          # Keys only
PubkeyAuthentication yes
MaxAuthTries 3
AllowUsers deploy admin            # Whitelist specific users
Port 2222                          # Change from default 22
LoginGraceTime 30                  # 30 seconds to authenticate
```

```bash
# Validate and apply
sudo sshd -t                       # Test config syntax
sudo systemctl restart sshd
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update > /dev/null 2>&1 && apt-get install -y openssh-client > /dev/null 2>&1
```

### Exercise 1: Generate a Keypair
> **Goal:** Create an Ed25519 SSH key.
```bash
ssh-keygen -t ed25519 -f /root/.ssh/lab_key -N ""
cat /root/.ssh/lab_key.pub
ls -la /root/.ssh/
```
✅ **Expected:** A private key (`lab_key`) and public key (`lab_key.pub`) are generated.

### Exercise 2: Inspect Key Fingerprints
> **Goal:** Verify a key's identity.
```bash
ssh-keygen -lf /root/.ssh/lab_key.pub
ssh-keygen -lf /root/.ssh/lab_key.pub -E md5
```
✅ **Expected:** SHA256 and MD5 fingerprints that uniquely identify the key.

### Exercise 3: Create an SSH Config
> **Goal:** Write a config file for quick connections.
```bash
cat > /root/.ssh/config << 'EOF'
Host myserver
    HostName 192.168.1.100
    User admin
    Port 22
    IdentityFile ~/.ssh/lab_key
EOF
cat /root/.ssh/config
```
✅ **Expected:** A clean config that would allow `ssh myserver` instead of typing the full command.

---

[<< Previous: Web Servers](./54_Web_Servers.md) | [Home: Curriculum Map](./README.md) | [Next: Virtualization >>](./56_Virtualization.md)
