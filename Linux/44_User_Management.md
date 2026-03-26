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

## 🧪 Hands-On Lab

### Setup: Docker Sandbox

```bash
docker run -it --rm ubuntu:latest bash
```

---

### Exercise 1: Create a New User
> **Goal:** Create a user with a home directory and bash shell.

```bash
useradd -m -s /bin/bash alice
ls /home/alice/                    # Home directory created
grep alice /etc/passwd             # Check the user entry
```
✅ **Expected:** Alice's home directory exists, and her entry appears in `/etc/passwd`.

---

### Exercise 2: Set a Password
> **Goal:** Set and verify a password for the user.

```bash
passwd alice                       # Enter a password when prompted
passwd -S alice                    # Show password status
```
✅ **Expected:** Password status shows `P` (password set).

---

### Exercise 3: Create a Group and Add Users
> **Goal:** Create a developers group and add alice to it.

```bash
groupadd developers
usermod -aG developers alice
groups alice                       # Show alice's groups
id alice                           # Full UID/GID details
```
✅ **Expected:** Alice belongs to both her primary group and `developers`.

---

### Exercise 4: Create a Second User
> **Goal:** Create bob and add him to the same group.

```bash
useradd -m -s /bin/bash -G developers bob
groups bob
```
✅ **Expected:** Bob is automatically in the `developers` group.

---

### Exercise 5: Inspect System Files
> **Goal:** Read the user and group databases.

```bash
cat /etc/passwd | grep -E "alice|bob"     # User entries
cat /etc/shadow | grep -E "alice|bob"     # Password hashes (root only)
cat /etc/group | grep developers          # Group membership
```
✅ **Observe:** The structure — username, UID, GID, home dir, shell in passwd; hash in shadow.

---

### Exercise 6: Switch Users with `su`
> **Goal:** Log in as alice.

```bash
su - alice                         # Full login shell
whoami                             # Should say "alice"
pwd                                # Should be /home/alice
exit                               # Return to root
```
✅ **Expected:** You're now operating as alice with her home directory.

---

### Exercise 7: Lock and Unlock an Account
> **Goal:** Disable and re-enable login for a user.

```bash
passwd -l bob                      # Lock bob's account
passwd -S bob                      # Status: L (locked)
su - bob                           # Should fail: authentication failure
passwd -u bob                      # Unlock
```
✅ **Expected:** Locked accounts show `L` status and reject login.

---

### Exercise 8: Delete a User
> **Goal:** Remove a user and their home directory.

```bash
userdel -r bob                     # Delete user + home dir
ls /home/                          # bob's directory is gone
grep bob /etc/passwd               # No entry
```
✅ **Expected:** Bob is completely removed from the system.

---

[<< Previous: File Management](./43_File_Management.md) | [Home: Curriculum Map](./README.md) | [Next: Disk & System Info >>](./45_Disk_and_System_Info.md)
