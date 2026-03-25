# 25: Writing a FUSE Filesystem

<p align="center">
  <img src="images/container_internals.png" alt="FUSE Architecture" width="800"/>
</p>

In Chapter 22, you learned that the VFS is a "Universal Translator" between your code and every filesystem. What if you want to create your **own** filesystem — one where files are generated on-the-fly, or where reading a file actually queries a database?

**FUSE** (Filesystem in Userspace) lets you build a full filesystem in a language like C or Python — **without writing a kernel module**.

---

## 1. The "Puppet Master" Analogy

Normally, when you `cat /mnt/myfs/hello.txt`, the kernel asks a built-in driver (ext4, XFS) to supply the data. With FUSE, the kernel instead sends a message to a **regular program you wrote** running in userspace. Your program is the puppet master, deciding what every file contains.

---

## 2. How FUSE Works

```
User runs: cat /mnt/myfs/hello.txt
    │
    ▼
[VFS Layer] → "I don't have a kernel driver for this mount."
    │
    ▼
[FUSE Kernel Module] → Forwards the request to userspace via /dev/fuse
    │
    ▼
[Your FUSE Program] → Receives the request, generates data, sends it back
    │
    ▼
[User sees]: "Hello from my custom filesystem!"
```

---

## 3. Building a "Hello World" Filesystem in C

Install the FUSE library:
```bash
sudo apt install libfuse3-dev
```

### The Minimal Filesystem:
```c
#define FUSE_USE_VERSION 31
#include <fuse3/fuse.h>
#include <string.h>
#include <errno.h>

static const char *hello_path = "/hello.txt";
static const char *hello_content = "Hello from your custom FUSE filesystem!\n";

// Called when 'ls' runs — what files exist?
static int my_readdir(const char *path, void *buf, fuse_fill_dir_t filler,
                      off_t offset, struct fuse_file_info *fi,
                      enum fuse_readdir_flags flags) {
    filler(buf, ".", NULL, 0, 0);
    filler(buf, "..", NULL, 0, 0);
    filler(buf, "hello.txt", NULL, 0, 0);
    return 0;
}

// Called when 'cat' runs — what is the file content?
static int my_read(const char *path, char *buf, size_t size, off_t offset,
                   struct fuse_file_info *fi) {
    if (strcmp(path, hello_path) != 0) return -ENOENT;
    size_t len = strlen(hello_content);
    if (offset >= len) return 0;
    if (offset + size > len) size = len - offset;
    memcpy(buf, hello_content + offset, size);
    return size;
}

// Called for 'stat' / 'ls -l' — what are the file attributes?
static int my_getattr(const char *path, struct stat *st,
                      struct fuse_file_info *fi) {
    memset(st, 0, sizeof(struct stat));
    if (strcmp(path, "/") == 0) {
        st->st_mode = S_IFDIR | 0755;
        st->st_nlink = 2;
    } else if (strcmp(path, hello_path) == 0) {
        st->st_mode = S_IFREG | 0444;
        st->st_nlink = 1;
        st->st_size = strlen(hello_content);
    } else {
        return -ENOENT;
    }
    return 0;
}

static struct fuse_operations ops = {
    .getattr = my_getattr,
    .readdir = my_readdir,
    .read    = my_read,
};

int main(int argc, char *argv[]) {
    return fuse_main(argc, argv, &ops, NULL);
}
```

### Compile and Mount:
```bash
gcc -Wall hello_fuse.c -o hello_fuse $(pkg-config fuse3 --cflags --libs)
mkdir /tmp/myfs
./hello_fuse /tmp/myfs

# Now use it!
ls /tmp/myfs          # → hello.txt
cat /tmp/myfs/hello.txt   # → Hello from your custom FUSE filesystem!

# Unmount
fusermount3 -u /tmp/myfs
```

---

## 4. Real-World FUSE Filesystems

- **sshfs:** Mount a remote server's directory over SSH as a local folder.
- **s3fs:** Mount an Amazon S3 bucket as a local directory.
- **GlusterFS:** Distributed network filesystem.

---

*In Chapter 26, we go deeper — writing C code that intercepts network packets inside the kernel itself.*

---
---

## 🧪 Sandbox: Build Your FUSE Filesystem

The **Kernel Dev Sandbox** comes pre-installed with `libfuse3-dev`:

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

**Inside the container:**
```bash
# Copy the hello_fuse.c example from this chapter into /work/
gcc -Wall /work/hello_fuse.c -o /work/hello_fuse $(pkg-config fuse3 --cflags --libs)
mkdir /tmp/myfs
/work/hello_fuse /tmp/myfs
ls /tmp/myfs
cat /tmp/myfs/hello.txt
fusermount3 -u /tmp/myfs
```

[<< Previous: Page Cache & Writeback](./24_Page_Cache_Writeback.md) | [Home: Curriculum Map](./README.md) | [Next: Netfilter Hooks in C >>](./26_Netfilter_Hooks_C.md)
