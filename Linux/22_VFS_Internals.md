# 22: Virtual Filesystem (VFS) Internals

<p align="center">
  <img src="images/vfs_memory_internals.png" alt="VFS & Memory Architecture" width="800"/>
</p>

When you type `cat /etc/passwd`, you don't care whether the file lives on an ext4 disk, an XFS RAID array, or a remote NFS server. It just works.

This "magic" is **VFS**—the Virtual Filesystem Switch. It's a brilliant layer of abstraction inside the kernel that makes every filesystem speak the same language.

---

## 1. The "Universal Translator" Analogy

Imagine a United Nations conference. Every country speaks a different language (ext4 speaks "French," XFS speaks "German," tmpfs speaks "Japanese"). The VFS is the **real-time translator** sitting between you and every delegate, allowing you to say `open()`, `read()`, `write()`, and `close()` and have every filesystem understand perfectly.

---

## 2. The Four Sacred Objects

The VFS operates through four core data structures that the kernel maintains for every mounted filesystem:

| Object | What it Represents | The Analogy |
| :--- | :--- | :--- |
| **Superblock** | The filesystem as a whole (its type, size, status). | The building's master blueprint. |
| **Inode** | A single file's metadata (permissions, size, timestamps). | A file's "passport" — everything about it *except* its name. |
| **Dentry** | A directory entry — the link between a *name* and an *inode*. | The name tag on the office door pointing to the passport. |
| **File** | An open file. Created when a process calls `open()`. | The conversation currently happening in the office. |

> [!IMPORTANT]
> A filename is **NOT** stored in the inode. Filenames live in `dentry` objects. This is why hard links work: multiple names (dentries) can point to the same inode.

---

## 3. Guided Experiment: Prove Inodes Are Real

```bash
# 1. Create a file
echo "Hello VFS" > /tmp/vfs_test.txt

# 2. See its inode number
ls -i /tmp/vfs_test.txt
# Output: 1234567  /tmp/vfs_test.txt

# 3. Create a HARD LINK (a second dentry pointing to the same inode)
ln /tmp/vfs_test.txt /tmp/vfs_link.txt

# 4. Verify both files share the SAME inode
ls -i /tmp/vfs_test.txt /tmp/vfs_link.txt
# Output: 1234567  /tmp/vfs_test.txt
#         1234567  /tmp/vfs_link.txt

# 5. Delete the original — the data SURVIVES because the inode still has a link!
rm /tmp/vfs_test.txt
cat /tmp/vfs_link.txt
# Output: Hello VFS
```

---

## 4. How `open()` Really Works

When you call `open("/etc/passwd", O_RDONLY)`, the kernel performs a **path walk**:

1.  Start at the **root dentry** (`/`).
2.  Look up `etc` in the root's dentry cache → find its inode.
3.  Look up `passwd` in `etc`'s dentry cache → find its inode.
4.  Check inode permissions against your UID/GID.
5.  Allocate a **File object**, link it to the inode, and return a file descriptor (`fd`).

Every subsequent `read(fd, ...)` goes through the File → Inode → actual filesystem driver chain.

---

## 5. The Dentry Cache (`dcache`)

Path lookups are expensive. The kernel caches dentry-to-inode mappings in a hash table called the **dcache**. The first time you access `/etc/passwd`, it's slow. Every subsequent access is nearly instant because the kernel already knows where the inode is.

```bash
# See cache statistics
cat /proc/sys/fs/dentry-state
```

---

*In Chapter 23, we will learn how the kernel uses memory-mapped I/O to bypass the `read()`/`write()` system call overhead entirely.*

---
---

## 🧪 Sandbox: Practice VFS Experiments

All VFS experiments can be run safely inside the **Kernel Dev Sandbox**:

**`docker-compose.yml`** — save this file in a new folder and run from there:

```yaml
services:
  # Full C development environment with kernel headers for VFS, mmap, FUSE, and module work
  kernel-dev:
    image: ubuntu:22.04
    container_name: kernel-dev-sandbox
    cap_add:
      - SYS_ADMIN          # Required for mount operations and FUSE
      - NET_ADMIN           # Required for Netfilter hooks
    devices:
      - /dev/fuse           # Required for FUSE filesystem mounting
    security_opt:
      - apparmor:unconfined  # Allow kernel-level experimentation
    volumes:
      - ./lab-work:/work
    working_dir: /work
    command: >
      bash -c "apt-get update && apt-get install -y 
      gcc make pkg-config strace ltrace
      libfuse3-dev fuse3
      linux-headers-generic
      libseccomp-dev
      iproute2 iputils-ping net-tools curl
      && echo '--- KERNEL DEV SANDBOX READY ---'
      && sleep infinity"
    networks:
      - lab-net

  # A target node for network experiments
  target:
    image: alpine:latest
    container_name: kernel-dev-target
    command: >
      sh -c "apk add --no-cache python3 curl && 
            python3 -m http.server 80"
    networks:
      - lab-net

networks:
  lab-net:
    driver: bridge
```

```bash
# Start the sandbox
docker compose up -d

# Enter the container
docker exec -it kernel-dev-sandbox bash
```

**Try inside the container:**
```bash
# Create a file and inspect its inode
echo "VFS Test" > /tmp/vfs.txt
ls -i /tmp/vfs.txt

# Create a hard link and verify shared inode
ln /tmp/vfs.txt /tmp/vfs_link.txt
ls -i /tmp/vfs.txt /tmp/vfs_link.txt

# Inspect dentry cache stats
cat /proc/sys/fs/dentry-state
```

[<< Previous: Container from Scratch](./21_Container_from_Scratch.md) | [Home: Curriculum Map](./README.md) | [Next: Memory-Mapped I/O >>](./23_Memory_Mapped_IO.md)
