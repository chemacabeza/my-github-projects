# 23: Memory-Mapped I/O (`mmap`) & Shared Memory

<p align="center">
  <img src="images/vfs_memory_internals.png" alt="Memory-Mapped I/O" width="800"/>
</p>

Every system call (`read()`, `write()`) has overhead. The CPU must switch from User Mode to Kernel Mode, copy data between buffers, and then switch back. For high-performance applications moving gigabytes of data, this overhead is unacceptable.

**Memory-Mapped I/O** eliminates the middleman. Instead of asking the kernel to "read 4KB and copy it to my buffer," you tell the kernel: "Map that file directly into my address space. I'll read it like RAM."

---

## 1. The "Window" Analogy

Imagine a file as a painting in a museum vault. Normally, you must fill out a form (`read()`), a guard fetches a copy, and you look at the copy. With `mmap()`, the museum installs a **window** directly into the vault wall. You look straight at the painting. No copying. No guards. No forms.

---

## 2. The `mmap()` System Call

```c
#include <sys/mman.h>

void *mmap(void *addr,      // Where in memory (NULL = let kernel decide)
           size_t length,   // How many bytes to map
           int prot,        // PROT_READ, PROT_WRITE, PROT_EXEC
           int flags,       // MAP_SHARED or MAP_PRIVATE
           int fd,          // File descriptor to map
           off_t offset);   // Starting offset in the file
```

### The Two Flavors:
| Flag | Behavior | Use Case |
| :--- | :--- | :--- |
| **MAP_PRIVATE** | Changes are private to you (copy-on-write). | Reading config files, loading libraries. |
| **MAP_SHARED** | Changes are visible to all processes AND persisted to disk. | Inter-process communication, databases. |

---

## 3. Guided Experiment: Read a File Without `read()`

```c
#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

int main() {
    int fd = open("/etc/hostname", O_RDONLY);
    
    // Get file size
    struct stat sb;
    fstat(fd, &sb);
    
    // Map the ENTIRE file into memory
    char *data = mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    close(fd);  // We can close the fd! The mapping survives.
    
    // Read the file like a char array — NO read() needed!
    printf("Hostname: %.*s\n", (int)sb.st_size, data);
    
    munmap(data, sb.st_size);  // Release the mapping
    return 0;
}
```

> [!TIP]
> After `mmap()`, you can close the file descriptor immediately. The kernel maintains the mapping independently. This surprises many beginners.

---

## 4. Shared Memory: IPC Without Sockets

Two processes can share a region of memory using `shm_open()` + `mmap()`. This is the **fastest** form of inter-process communication because no data is ever copied.

```c
// Process A: Create shared memory
int fd = shm_open("/my_channel", O_CREAT | O_RDWR, 0666);
ftruncate(fd, 4096);
char *shared = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
sprintf(shared, "Hello from Process A!");

// Process B: Read shared memory
int fd = shm_open("/my_channel", O_RDONLY, 0);
char *shared = mmap(NULL, 4096, PROT_READ, MAP_SHARED, fd, 0);
printf("Message: %s\n", shared);  // "Hello from Process A!"
```

---

## 5. Why Databases Love `mmap`

MongoDB, SQLite (in WAL mode), and many high-performance databases use `mmap()` to map their data files directly into memory. The kernel manages page faults, caching, and writeback automatically — the database gets near-RAM speed without writing its own caching layer.

---

*In Chapter 24, we will explore the Page Cache — the invisible layer of RAM that makes your disk feel fast.*

---
---

## 🧪 Sandbox: Practice Memory-Mapped I/O

Compile and test mmap programs in the **Kernel Dev Sandbox**:

```bash
cd sandbox/kernel-dev-lab
docker compose up -d
docker exec -it kernel-dev-sandbox bash
```

**Create and test `mmap_demo.c`:**
```bash
cat > /work/mmap_demo.c << 'CEOF'
#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
int main() {
    int fd = open("/etc/hostname", O_RDONLY);
    struct stat sb; fstat(fd, &sb);
    char *data = mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    close(fd);
    printf("Hostname: %.*s\n", (int)sb.st_size, data);
    munmap(data, sb.st_size);
    return 0;
}
CEOF
gcc -o /work/mmap_demo /work/mmap_demo.c
/work/mmap_demo
```

[<< Previous: VFS Internals](./22_VFS_Internals.md) | [Home: Curriculum Map](./README.md) | [Next: Page Cache & Writeback >>](./24_Page_Cache_Writeback.md)
