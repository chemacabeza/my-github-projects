# 44: User Management

<p align="center">
  <img src="images/linux_user_mgmt.png" alt="User Management" width="600"/>
</p>

Linux is a multi-user operating system. Managing users and groups is a core sysadmin responsibility.

---

## 1. `useradd` — Create Users

```bash
sudo useradd alice                         # Create user (minimal)
sudo useradd -m alice                      # Create user with home directory
sudo useradd -m -s /bin/bash alice         # Set default shell
sudo useradd -m -G sudo,docker alice       # Add to groups during creation
sudo useradd -m -e 2026-12-31 contractor   # Set account expiry date
sudo useradd -r serviceaccount             # Create system (service) user
```

---

## 2. `usermod` — Modify Users

```bash
sudo usermod -aG docker alice              # Add user to group (APPEND)
sudo usermod -l newname oldname            # Rename user login
sudo usermod -d /new/home -m alice         # Change and move home directory
sudo usermod -s /bin/zsh alice             # Change default shell
sudo usermod -L alice                      # Lock account (disable login)
sudo usermod -U alice                      # Unlock account
sudo usermod -e 2026-06-30 alice           # Set expiry date
```

> ⚠️ **Critical:** Always use `-aG` (append) when adding groups. Without `-a`, the command **replaces** all existing groups!

---

## 3. `userdel` — Delete Users

```bash
sudo userdel alice                         # Delete user (keep home dir)
sudo userdel -r alice                      # Delete user AND home directory
```

---

## 4. `passwd` — Manage Passwords

```bash
passwd                                     # Change your own password
sudo passwd alice                          # Set password for another user
sudo passwd -l alice                       # Lock account
sudo passwd -u alice                       # Unlock account
sudo passwd -e alice                       # Force password change on next login
sudo passwd -S alice                       # Show password status
```

---

## 5. Group Management

```bash
sudo groupadd developers                  # Create group
sudo groupdel developers                  # Delete group
sudo groupmod -n newname oldname          # Rename group
groups alice                              # Show user's groups
id alice                                  # Show UID, GID, and groups
```

---

## 6. Critical System Files

### `/etc/passwd` — User Database

```
alice:x:1001:1001:Alice Smith:/home/alice:/bin/bash
│      │  │    │       │          │           └── Shell
│      │  │    │       │          └── Home directory
│      │  │    │       └── Full name (GECOS field)
│      │  │    └── Primary GID
│      │  └── UID
│      └── Password placeholder (actual hash in /etc/shadow)
└── Username
```

### `/etc/shadow` — Password Hashes

```bash
sudo cat /etc/shadow                       # Only root can read
# alice:$6$salt$hash:19000:0:99999:7:::
```

### `/etc/group` — Group Database

```bash
cat /etc/group
# developers:x:1002:alice,bob
```

---

## 7. `su` and `sudo` — Privilege Escalation

```bash
su - alice                                 # Switch to alice (full login shell)
su -                                       # Switch to root
sudo command                               # Run single command as root
sudo -u alice command                      # Run as specific user
sudo -i                                    # Interactive root shell
sudo -l                                    # List your sudo privileges
visudo                                     # Safely edit /etc/sudoers
```

### Adding Sudo Access

```bash
# Method 1: Add user to sudo group
sudo usermod -aG sudo alice               # Debian/Ubuntu
sudo usermod -aG wheel alice              # RHEL/Fedora

# Method 2: Edit sudoers file
sudo visudo
# Add: alice ALL=(ALL:ALL) ALL
```

---

## 8. Quick Reference Table

| Command | Purpose | Example |
| :--- | :--- | :--- |
| `useradd` | Create user | `useradd -m -s /bin/bash alice` |
| `usermod` | Modify user | `usermod -aG docker alice` |
| `userdel` | Delete user | `userdel -r alice` |
| `passwd` | Set password | `passwd alice` |
| `groupadd` | Create group | `groupadd developers` |
| `groups` | Show user's groups | `groups alice` |
| `id` | Show UID/GID | `id alice` |
| `su` | Switch user | `su - alice` |
| `sudo` | Run as root | `sudo apt update` |

---

[<< Previous: File Management](./43_File_Management.md) | [Home: Curriculum Map](./README.md) | [Next: Disk & System Info >>](./45_Disk_and_System_Info.md)
