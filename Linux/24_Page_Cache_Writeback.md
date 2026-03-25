# 24: Page Cache & Dirty Writeback

<p align="center">
  <img src="images/vfs_memory_internals.png" alt="Page Cache Architecture" width="800"/>
</p>

Your SSD can read at 3,500 MB/s. Your RAM can read at 50,000 MB/s. The kernel exploits this by keeping a copy of recently accessed disk data **in RAM**. This is the **Page Cache**.

---

## 1. The "Library Desk" Analogy

Imagine a massive library (your disk). Every time you need a book (a file), you walk to the shelf, retrieve it, and bring it to your desk (RAM). Instead of returning the book after reading, you leave it on the desk. Next time you need it, it's already there — instantly.

The kernel does this automatically for **every file you touch**.

---

## 2. Seeing the Page Cache in Action

```bash
# Check how much RAM the kernel is using for caching
free -h
```

The `buff/cache` column shows how much RAM is occupied by the Page Cache. This is **not wasted RAM** — the kernel will give it back to applications instantly if they need it.

### Proving the Cache Works:
```bash
# 1. Drop the cache (forces cold read)
echo 3 | sudo tee /proc/sys/vm/drop_caches

# 2. Time a cold read (from disk)
time cat /var/log/syslog > /dev/null
# real    0.150s (SLOW — reading from SSD)

# 3. Time a hot read (from cache)
time cat /var/log/syslog > /dev/null
# real    0.003s (FAST — reading from RAM!)
```

> [!IMPORTANT]
> The 50x speed improvement between cold and hot reads is entirely due to the Page Cache. The kernel cached the file's pages in RAM without being asked.

---

## 3. Dirty Pages: When Writes Stack Up

When you `write()` to a file, the data doesn't go to disk immediately. It stays in RAM as a **dirty page**. The kernel eventually flushes it to disk through a process called **writeback**.

Why? Because:
- The application can continue immediately (no waiting for the slow disk).
- If you write to the same page 100 times in one second, only the final version needs to hit the disk.

### The Writeback Timer:
```bash
# How long (in centiseconds) the kernel waits before flushing dirty pages
cat /proc/sys/vm/dirty_writeback_centisecs
# Default: 500 (5 seconds)

# Maximum percentage of RAM that can be "dirty" before the kernel forces a flush
cat /proc/sys/vm/dirty_ratio
# Default: 20 (20% of total RAM)
```

---

## 4. The Danger: Data Loss on Crash

If the power goes out while dirty pages are still in RAM, **that data is lost forever**. This is why databases use `fsync()` — it forces the kernel to flush dirty pages to disk *right now*.

```c
int fd = open("critical.db", O_WRONLY);
write(fd, data, sizeof(data));
fsync(fd);  // BLOCK until the data is physically on disk
close(fd);
```

---

## 5. Tuning the Page Cache for Production

**For databases (safety):** Reduce dirty thresholds so data reaches disk faster.
```bash
echo 5 | sudo tee /proc/sys/vm/dirty_ratio
echo 2 | sudo tee /proc/sys/vm/dirty_background_ratio
```

**For throughput workloads (streaming):** Increase thresholds so more data accumulates before flushing.
```bash
echo 40 | sudo tee /proc/sys/vm/dirty_ratio
echo 10 | sudo tee /proc/sys/vm/dirty_background_ratio
```

---

*Phase 8 Complete. You now understand how Linux turns slow disks into fast virtual memory. In Phase 9, we will write kernel-level code: FUSE filesystems, Netfilter hooks, and device drivers.*

---
---

## 🧪 Sandbox: Observe the Page Cache

Use the **Kernel Dev Sandbox** to see the cache in action:

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

**Experiment:**
```bash
# Check current cache usage
free -h

# Time a cold read vs hot read
time cat /usr/share/doc/gcc/README > /dev/null
time cat /usr/share/doc/gcc/README > /dev/null

# View dirty writeback settings
cat /proc/sys/vm/dirty_writeback_centisecs
cat /proc/sys/vm/dirty_ratio
```

[<< Previous: Memory-Mapped I/O](./23_Memory_Mapped_IO.md) | [Home: Curriculum Map](./README.md) | [Next: Writing a FUSE Filesystem >>](./25_FUSE_Filesystem.md)
