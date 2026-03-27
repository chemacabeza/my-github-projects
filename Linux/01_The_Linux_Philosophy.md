# 01: The Linux Philosophy and the Filesystem

Welcome to **Phase 1** of your Linux mastery journey. Linux is not just an operating system; it is an architectural philosophy. Distilling knowledge from *Ubuntu Linux Unleashed* and the *UNIX and Linux System Administration Handbook*, we begin by understanding the two golden rules of UNIX-like systems.

---

## 1. Golden Rule #1: Everything is a File

In Windows, hardware (like a hard drive or a webcam) is hidden behind complex driver APIs and graphical menus. 
In Linux, **everything is a file**.

- Your hard drive is a file (`/dev/sda`).
- Your webcam is a file (`/dev/video0`).
- The memory space of a running program is a file (`/proc/1234/mem`).
- Remote network connections are represented by file descriptors.

Because everything is a file, the exact same commands you use to read a text document (`cat`, `less`, `grep`) can be used to interact with hardware and network streams!

---

## 2. The Filesystem Hierarchy Standard (FHS)

Linux does not have `C:\` or `D:\` drives. It has a single, unified filesystem tree starting at the **Root Directory** `/`.

Here are the most critical directories every administrator must know:

| Directory | Purpose |
| :--- | :--- |
| `/` | The Root. Everything branches from here. Only the `root` user has full access. |
| `/bin` | **Bin**aries. Essential system commands (`ls`, `cp`, `bash`). |
| `/sbin` | **S**ystem **Bin**aries. Admin commands that require `root` privileges (`fdisk`, `iptables`). |
| `/etc` | System-wide configuration files (`/etc/ssh/sshd_config`, `/etc/fstab`). **No binaries go here.** |
| `/dev` | **Dev**ice files. This is where your hardware "files" live. |
| `/proc` | A virtual, RAM-based filesystem. It doesn't exist on disk. It exposes running processes and kernel parameters. |
| `/var` | **Var**iable data. Things that grow continuously (logs in `/var/log`, databases in `/var/lib`). |
| `/home` | Personal directories for standard users (`/home/alice`, `/home/bob`). |
| `/tmp` | Temporary files. Erased upon system reboot. |
| `/usr` | **U**NIX **S**ystem **R**esources. Secondary hierarchy for non-essential software (`/usr/bin`, `/usr/local/bin`). |

---

## 3. Permissions, Owners, and `chmod`

Security is baked into the filesystem via a 9-bit permission system. 
Run `ls -l` in any directory to see the permissions.

```text
-rw-r--r-- 1 alice staff  4096 Mar 22 10:00 report.txt
drwxr-xr-x 2 alice staff  4096 Mar 22 10:00 private_folder
```

### The Breakdown
Look at the 10 characters at the beginning: `-rw-r--r--`
1. **Character 1 (Type):** `-` means File. `d` means Directory. `l` means Symlink.
2. **Characters 2-4 (Owner):** What can the file's owner do? `rw-` (Read, Write).
3. **Characters 5-7 (Group):** What can the group do? `r--` (Read-only).
4. **Characters 8-10 (Others):** What can everyone else in the world do? `r--` (Read-only).

### The Octal System (Math for `chmod`)
Permissions are manipulated using binary octals:
- `Read (r) = 4`
- `Write (w) = 2`
- `Execute (x) = 1`

To give the Owner full access (4+2+1 = 7), the Group read/execute (4+1 = 5), and Others read-only (4):
```bash
# syntax: chmod <owner><group><others> file
chmod 754 script.sh
```

### Changing Ownership (`chown`)
To change who owns a file, use `chown`. Only the `root` user can change ownership.
```bash
# Format: chown user:group filename
sudo chown bob:developers project_code
```

---

## 4. Absolute vs. Relative Paths

When navigating using `cd` (Change Directory), understand the difference.

- **Absolute Path:** Always starts from the absolute root (`/`). It is a fixed map coordinate.
  - `cd /var/log/nginx`
- **Relative Path:** Starts from where you *currently* are.
  - `cd ../../var/log` (Go up two directories, then down into var/log)

**Special Symbols:**
- `~` : Points to your home directory (`cd ~` takes you to `/home/username`)
- `.` : Points to the current directory (`./script.sh` executes the script in this exact folder)
- `..` : Points to the parent directory (`cd ..` goes up a level)

### Summary
The UNIX philosophy asserts that small, modular tools operating on text files provide maximum power. Once you memorize the FHS and master Octal permissions, you control who has access to every program and hardware device on the system.

---

## 5. Containerized Execution (MacBook / Linux)
Do not practice `chmod` or `chown` on your host machine's root filesystem! We have provided an isolated Ubuntu Docker container to practice safely.

**`Dockerfile`**
```dockerfile
FROM ubuntu:latest
# Create a dummy test environment
RUN mkdir -p /root/playground && \
    touch /root/playground/secret.txt && \
    touch /root/playground/script.sh
WORKDIR /root/playground
CMD ["/bin/bash"]
```

**`docker-compose.yml`**
```yaml
services:
  linux-sandbox:
    build: .
    stdin_open: true # Equivalent to -i
    tty: true        # Equivalent to -t
```

**To Run:**
```bash
docker compose run linux-sandbox
# Now inside the container, practice!
ls -l
chmod 755 script.sh
```


## 🧪 Hands-On Lab: The Filesystem Hierarchy

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
```

### Exercise 1: Explore the Root
> **Goal:** See the top-level directories.
```bash
ls -l /
```
✅ **Expected:** You see directories like `/bin`, `/etc`, `/var`, `/home`, `/tmp`, and `/usr`.

### Exercise 2: Identify "Everything is a File"
> **Goal:** Inspect device files.
```bash
ls -l /dev/null /dev/zero /dev/random
```
✅ **Expected:** Look at the first character of the permissions (it's a `c` for character device, not a `-` for file).

### Exercise 3: Temporary Files
> **Goal:** Observe the volatile nature of `/tmp`.
```bash
echo "Important data" > /tmp/test.txt
cat /tmp/test.txt
# When the container stops, this file gets destroyed automatically.
```
✅ **Expected:** The file is easily created. On a real system, `/tmp` is wiped on reboot.

---
[Home: Curriculum Map](./README.md) | [Next: Command Line Survival >>](./02_Command_Line_Survival.md)