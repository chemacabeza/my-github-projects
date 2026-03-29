# 79: Digital Forensics & Incident Response

<p align="center">
  <img src="images/linux_forensics.png" alt="Digital Forensics and Incident Response" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand the rigorous methodologies utilized by Incident Responders to preserve, acquire, and analyze digital evidence from compromised Linux systems without altering volatile state or disk structures.**

When a server is breached, every action you take alters potential evidence. Mastering DFIR means prioritizing preservation and uncovering truth through timeline reconstruction and artifact analysis. 

---

## 1. The Order of Volatility

When acquiring digital evidence during a live response, you must follow the Order of Volatility, collecting data that evaporates first.

1. **CPU Registers and Cache**: Essentially impossible to acquire without specialized hardware.
2. **Routing Tables, ARP Cache, Process Tables, Memory**: Volatile. Lost immediately upon power loss.
3. **Temporary File Systems**: Data residing in `/tmp/` if mounted as `tmpfs`.
4. **Disk Data**: Non-volatile storage (logs, binaries).
5. **Remote Logging Data**: Data shipped to a SIEM.
6. **Physical Topologies**: Archival media.

---

## 2. Live Memory Acquisition

Memory (RAM) contains the "ground truth" of a system—unencrypted keys, active network connections, and hidden malware processes that hide from `ps` but appear to the kernel.

### The Problem with `/dev/mem`
Historically, `dd if=/dev/mem of=dump.raw` worked. Modern kernels restrict `/dev/mem` severely (`CONFIG_STRICT_DEVMEM`). 

### Utilizing LiME (Linux Memory Extractor)
A Loadable Kernel Module (LKM) specifically compiled and inserted to dump RAM safely into an image file.

```bash
# Example acquiring memory via LiME locally
insmod lime.ko "path=/usb_drive/ram_dump.lime format=lime"
```

Once acquired, **Volatility 3** is utilized to analyze the dump, extracting process trees, open sockets, and injected assembly.

---

## 3. Storage Forensics and Bit-for-Bit Imaging

Simply running `cp` on files alters access times (atime) and entirely misses deleted files, slack space, and unallocated blocks.

### The `dd` Clone
To create a mathematically exact bit-stream image of a drive:

```bash
# Create an image image using dd
dd if=/dev/sda of=/mnt/forensic_drive/suspect_drive.dd bs=4M status=progress

# Or use dcfldd for hashing during acquisition:
dcfldd if=/dev/sda of=/mnt/forensic_drive/suspect.img hash=sha256 hashlog=hash.txt
```

### Analyzing the Image (Autopsy / SleuthKit)
With the `.dd` image mounted as read-only natively, investigators utilize The Sleuth Kit (TSK) toolkit:
- `ils` / `fls`: List inodes and file/directory structures.
- `icat`: Extract a file based purely on its inode, even if deleted but un-overwritten.
- `blkcalc`: Determine where file slack space ends.

---

## 4. Timeline Analysis

A "Super Timeline" marries MACB times (Modified, Accessed, Changed, Birth) from the filesystem with Syslog timestamps.

- **M**odified: Content altered (`mtime`).
- **A**ccessed: File read (`atime`).
- **C**hanged: Metadata/Permissions altered (`ctime`).
- **B**irth: Creation (supported in ext4/XFS as `crtime` or `btime`).

Using tools like `log2timeline` (Plaso), responders overlay Web Server logs against SSH logins and File creation times to reconstruct the attacker's precise path.

---

## 🤔 Reflection Questions

1. **Why is pulling the power cord on a compromised server considered a severe tactical error by forensic investigators?** (Hint: consider disk encryption keys).
2. **If an attacker deletes a malware binary using `rm`, why can an investigator still recover it from the `.dd` image?** When does the binary truly disappear?
3. **If `atime` (Access Time) is utilized for tracking file reads, how does the mount option `relatime` impact forensic visibility?**

---

## 📝 Key Interview Talking Points

- Explain the Order of Volatility during an initial Incident Response.
- Define what a bit-for-bit physical disk image is and why it explicitly differs from logical file copies.
- Demonstrate an understanding of the MACB timestamps tracked by Ext4 filesystems.

---

[<< Previous: Linux for Penetration Testing](./78_Penetration_Testing.md) | [Home: Curriculum Map](./README.md) | [Next: Shell Scripting Cookbook >>](./80_Shell_Scripting_Cookbook.md)
