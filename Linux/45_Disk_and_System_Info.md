<div align="center">
  <img src="./images/linux_ch45_storage.png" alt="Linux Disk Storage Cover" width="800"/>
</div>

# 45: Disk & System Info

> 🧠 **The Feynman Hook:** If your server is a massive warehouse, you need to know exactly how full the shelves are before a cargo shipment arrives. If a disk fills to 100%, applications will violently crash because they physically cannot write their logs to save state. The Linux Diagnostic toolkit acts as the warehouse inventory scanner, allowing you to monitor Disk Blocks, RAM caching, and CPU architecture in a single keystroke.

**🎯 The Big Goal:** Master `df`, `du`, `free`, and `lsblk` to instantly diagnose system resource exhaustion before a fatal crash occurs.

---

## 1. The Warehouse Scanner (`df`)

The `df` (Disk Free) command maps the entire warehouse at a macro level. It tells you the total capacity of the hard drive and the percentage currently in use.

```bash
# -h stands for 'Human Readable' (displays Gigabytes instead of raw Bytes)
df -h
```
**Example Output:**
```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       100G   45G   50G  48% /
```

---

## 2. The Granular Inspector (`du`)

If `df` tells you the warehouse is full, `du` (Disk Usage) tells you EXACTLY which specific boxes are taking up the most space.

```bash
# -s (Summary), -h (Human Readable)
# Find the size of the massive logging directory
du -sh /var/log/

# Find out what the top 10 largest files/folders are in a directory
du -ah /var/ | sort -rh | head -10
```

---

## 3. Physical Drive Layout (`lsblk`)

To see the physical metal and partitions plugged into the motherboard, you use `lsblk`. It lists the raw Block Devices.

```bash
lsblk
```
If you plug in a new USB drive or a blank AWS EBS volume, it will appear here as `/dev/sdb` or `/dev/nvmeX`. You must format it with a filesystem before Linux can use it to store files.

---

## 4. RAM Usage (`free`)

When diagnosing server lag, your first instinct is to check your RAM.

```bash
free -h
```
> **Feynman Insight:** Many junior engineers panic when they run `free -h` and see that their "free" RAM is almost 0 bytes. This is completely intentional! Unused RAM is wasted RAM. Linux aggressively steals "free" RAM to cache hard drive files for insane performance (labeled `buff/cache`). If an application suddenly needs actual RAM, Linux instantly releases the cache. The only metric that matters is the `available` column.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Explain why a server might completely fail to write files, even if 'df -h' shows 50 Gigabytes of free space available.</summary>
Hard drives require two things to store a file: physical Space (Blocks) and an Index Number (Inodes). Every single file consumes exactly one Inode, no matter how small it is. If you write 10 million tiny 1-byte text files to your hard drive, you will run completely out of Inodes while still having 50 Gigabytes of physical space remaining. The Kernel will declare the disk "Full". You diagnose this by checking the Inode table using the command `df -i`.
</details>

---
[<< Previous: User Management](./44_User_Management.md) | [Home: Curriculum Map](./README.md) | [Next: Process Management >>](./46_Process_Management.md)
