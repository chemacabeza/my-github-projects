# 45: Disk & System Info

<p align="center">
  <img src="images/linux_disk_system.png" alt="Disk & System Info" width="600"/>
</p>

Essential commands for monitoring disk usage, partition layout, memory, and system identity.

---

## 1. `df` — Disk Free Space

```bash
df                                         # All filesystems
df -h                                      # Human-readable sizes (GB, MB)
df -hT                                     # Include filesystem type
df -h /home                                # Specific mount point
df -i                                      # Inode usage (can run out before space!)
```

**Example output:**
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       100G   45G   50G  48% /
/dev/sda2       500G  200G  275G  43% /home
tmpfs           8.0G   12M  8.0G   1% /tmp
```

---

## 2. `du` — Disk Usage

Check how much space files and directories consume.

```bash
du -sh /var/log                            # Total size of directory
du -sh *                                   # Size of each item in current dir
du -sh /home/*                             # Size per user home directory
du -ah /var/log | sort -rh | head -20      # Top 20 largest files
du -d 1 -h /                               # One level deep from root
```

| Flag | Meaning |
| :--- | :--- |
| `-s` | Summary (total only) |
| `-h` | Human-readable |
| `-a` | All files (not just directories) |
| `-d N` | Max depth N |

---

## 3. `lsblk` — List Block Devices

```bash
lsblk                                     # Show disk/partition tree
lsblk -f                                  # Include filesystem types and UUIDs
lsblk -d                                  # Disks only (no partitions)
```

---

## 4. `fdisk` — Partition Manager

```bash
sudo fdisk -l                              # List all partitions
sudo fdisk /dev/sda                        # Interactive partition editor
```

> **Modern alternatives:** `parted` (supports GPT), `gdisk` (GPT-specific)

---

## 5. `mount` / `umount` — Mount Filesystems

```bash
mount                                      # Show all mounted filesystems
mount | grep ext4                          # Filter by type
sudo mount /dev/sdb1 /mnt/usb             # Mount a partition
sudo umount /mnt/usb                       # Unmount
sudo mount -o ro /dev/sdb1 /mnt/readonly  # Mount read-only
```

### `/etc/fstab` — Permanent Mounts

```bash
cat /etc/fstab
# /dev/sda1  /       ext4  defaults  0 1
# /dev/sda2  /home   ext4  defaults  0 2
```

---

## 6. `uname` — System Identity

```bash
uname                                      # Kernel name (Linux)
uname -r                                   # Kernel version
uname -a                                   # All system info
uname -m                                   # Architecture (x86_64, aarch64)
uname -n                                   # Hostname
```

---

## 7. `uptime` — System Uptime

```bash
uptime
# 17:30:00 up 45 days, 3:12,  2 users,  load average: 0.15, 0.20, 0.18
```

The three **load averages** represent CPU demand over 1, 5, and 15 minutes.

---

## 8. `free` — Memory Usage

```bash
free                                       # In kilobytes
free -h                                    # Human-readable
free -m                                    # In megabytes
free -s 5                                  # Update every 5 seconds
```

**Example output:**
```
              total        used        free      shared  buff/cache   available
Mem:           16Gi       4.2Gi       2.1Gi       512Mi       9.7Gi        11Gi
Swap:          4.0Gi          0B       4.0Gi
```

> **Key insight:** `available` (not `free`) is the real memory available. Linux aggressively caches disk data in "buff/cache".

---

## 9. Additional System Commands

```bash
hostname                                   # Show hostname
hostnamectl                                # Detailed hostname + OS info
lscpu                                      # CPU architecture details
lsmem                                      # Memory layout
lspci                                      # PCI devices (GPUs, NICs)
lsusb                                      # USB devices
cat /etc/os-release                        # Distro name and version
cat /proc/cpuinfo                          # Detailed CPU info
cat /proc/meminfo                          # Detailed memory info
```

---

## 10. Quick Reference Table

| Command | Purpose | Key Flag |
| :--- | :--- | :--- |
| `df` | Free disk space | `-h` (human-readable) |
| `du` | Directory disk usage | `-sh` (summary, human) |
| `lsblk` | Block device listing | `-f` (filesystems) |
| `fdisk` | Partition editor | `-l` (list) |
| `mount` | Mount filesystems | `-o ro` (read-only) |
| `uname` | System info | `-a` (all) |
| `uptime` | Uptime + load | — |
| `free` | Memory usage | `-h` (human-readable) |

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox

```bash
docker run -it --rm ubuntu:latest bash
```

---

### Exercise 1: Check Disk Free Space
> **Goal:** See how much space is available on each filesystem.

```bash
df -hT
```
✅ **Observe:** The overlay filesystem (root), tmpfs mounts, and their usage percentages.

---

### Exercise 2: Find Directory Sizes
> **Goal:** Discover which directories consume the most space.

```bash
du -sh /usr/*  | sort -rh | head -10
```
✅ **Expected:** `/usr/lib` and `/usr/bin` are typically the largest. The output is sorted.

---

### Exercise 3: Create Files and Measure Usage
> **Goal:** Create test data and see `du` reflect the change.

```bash
mkdir -p /root/lab45 && cd /root/lab45
dd if=/dev/zero of=bigfile.bin bs=1M count=50 2>/dev/null
du -sh .                          # Total size of the lab directory
du -sh bigfile.bin                # Size of the single file
```
✅ **Expected:** Both `du` commands confirm approximately 50MB.

---

### Exercise 4: List Block Devices
> **Goal:** View the container's disk layout.

```bash
lsblk 2>/dev/null || echo "lsblk not available in this container"
cat /proc/partitions              # Alternative: kernel partition table
```
✅ **Observe:** The underlying host disk partitions visible from within the container.

---

### Exercise 5: View Memory Usage
> **Goal:** Understand the `free` command output.

```bash
free -h
```
✅ **Key insight:** Focus on the `available` column — **not** `free`. Linux uses "free" RAM as disk cache (`buff/cache`), so `available` = truly usable memory.

---

### Exercise 6: System Identity with `uname`
> **Goal:** Discover your system's kernel and architecture.

```bash
uname -a                          # All info in one line
uname -r                          # Kernel version
uname -m                          # Architecture (x86_64, aarch64)
```
✅ **Expected:** Full kernel version, hostname, and architecture type.

---

### Exercise 7: Check System Uptime
> **Goal:** See how long the system has been running.

```bash
uptime
cat /proc/uptime                  # Raw: seconds up, seconds idle
```
✅ **Observe:** The three load averages (1, 5, 15 min). Values above your CPU count = overloaded.

---

### Exercise 8: Explore `/proc` for System Info
> **Goal:** Read system information directly from the kernel virtual filesystem.

```bash
cat /proc/cpuinfo | head -20      # CPU details
cat /proc/meminfo | head -10      # Memory breakdown
cat /etc/os-release               # Distribution info
```
✅ **Expected:** Low-level hardware info straight from the kernel, plus distro identification.

---

[<< Previous: User Management](./44_User_Management.md) | [Home: Curriculum Map](./README.md) | [Next: Process Management >>](./46_Process_Management.md)
