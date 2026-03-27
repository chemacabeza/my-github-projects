# 07: The Linux Kernel

Welcome to **Phase 3: The Expert Track**. Drawing directly from Robert Love's *Linux Kernel Development*, we must fundamentally unlearn user-space application development and step directly into Ring-0 hardware context.

Everything you have ever written (Java, Go, Python, Bash Scripts) runs safely in **User Space**. If your application crashes, it only kills itself. 

The Kernel runs in **Kernel Space**. It manages all memory, raw electrical signals, and CPU scheduling. If a Kernel Module crashes, the entire physical machine instantly drops dead into a Kernel Panic.

---

## 1. Monolithic vs. Microkernel

Linux is profoundly unique because it is a **Monolithic Kernel**.

- **Microkernel (e.g., Windows NT, macOS Mach):** Hardware drivers and filesystems isolated into modular services. Safer, but incredibly slow due to heavy IPC (Inter-Process Communication) overhead.
- **Monolithic (Linux, BSD):** Everything resides perfectly packed inside one massive binary executable executing natively. It is phenomenally, dangerously fast. All components (Networking, ext4 Filesystem, Memory Scheduler) communicate with zero overhead directly via simple C function calls. 

---

## 2. System Calls (Syscalls)

Your User Space program literally has zero authority to talk to the hardware. 

If your Python program wants to print `"Hello World"` to the terminal monitor, it cannot independently send electrical signals to the GPU. 
It must trap into the Kernel and explicitly **request permission**.

This is called a **System Call**.

When you write `fmt.Println("Hi")` in Go:
1. Go places `"Hi"` into a memory buffer.
2. Go executes the exact CPU instruction `syscall (0x01)` (SYS_WRITE).
3. The CPU **Context Switches**. It completely halts User Space execution, dramatically switches its hardware privilege ring from Ring-3 to Ring-0, and launches into the locked Linux Kernel code.
4. The Kernel verifies you have permission to write to that terminal mapping File Descriptor (`stdout`).
5. The Kernel explicitly talks to the hardware buffer and renders the pixels.
6. The CPU execution Context Switches *again* back out to User Space.

### You DO NOT write Syscalls Directly
No C programmer actually writes assembly `syscall` instructions. They rely heavily on the **C Standard Library** (`glibc`). When you call `printf()` in C, Linux's `glibc` perfectly handles the ugly architecture-specific `syscall` wrapper for you.

---

## 3. The `strace` Diagnostics Tool

As an expert, when a process mysteriously freezes, you do not guess. You trace its Syscalls using `strace`.

```bash
# Attach 'strace' directly onto the running Nginx proxy server PID
sudo strace -p 1234
```

You will see exactly what the Kernel is currently holding.
- `openat("/etc/nginx/nginx.conf")` -> Wait, the config file is missing?
- `connect(...)` -> Wait, it's hanging forever on a network socket? 

### A classic scenario:
Developer: *"My Python software architecture is completely broken on production, but works locally! Fix it!"*
Sysadmin: *Runs `strace`* -> `open("/var/log/app.log", O_WRONLY) = -1 EACCES (Permission denied)`
Sysadmin: *"Linux denied your software permission to write to that file. Run chmod."*

`strace` bypasses all application logging (which is likely broken) and reveals the absolute truth occurring between the software request and the Kernel execution.

---

## 4. Kernel Modules (.ko)

Because Linux is Monolithic, traditionally you would have to entirely recompile the massive Kernel binary and reboot the whole system just to add a new hardware driver.

To avoid this downtime, Linux supports Loadable Kernel Modules (`.ko` objects). They can be injected securely into the running Kernel's memory layout dynamically.

```bash
# List every currently loaded kernel module explicitly
lsmod

# Inject a new module (driver) into the running kernel
sudo modprobe my_custom_driver

# Manually remove a module
sudo rmmod usb_storage
```

### Summary
The Kernel operates ruthlessly and efficiently, acting as the absolute authority mediating between hardware electrical signals and User Space requests. We never bypass the Kernel; we use APIs (`glibc`) to submit securely sanitized Syscalls. 

In the next guide (`08_Kernel_Module_Development.md`), we will literally write our own Kernel Module and inject it directly into Ring 0.

---

## 5. Containerized Execution (MacBook / Linux)
Standard Docker containers block the `ptrace` system call for security reasons, meaning `strace` will fail! You must explicitly grant `SYS_PTRACE` capabilities to trace processes inside a container.

**`Dockerfile`**
```dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y strace curl
WORKDIR /root
CMD ["/bin/bash"]
```

**`docker-compose.yml`**
```yaml
services:
  strace-sandbox:
    build: .
    cap_add:
      - SYS_PTRACE  # CRITICAL: Required for strace to hook into other processes!
    stdin_open: true
    tty: true
```

**To Run:**
```bash
docker compose run strace-sandbox

# Experiment! Watch exactly what the Kernel does when you curl Google:
strace curl https://google.com
```


## 🧪 Hands-On Lab: Probing the Kernel

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update && apt-get install -y kmod pciutils
```

### Exercise 1: Kernel Version
> **Goal:** Identify the running kernel architecture.
```bash
uname -a
uname -r
```
✅ **Expected:** Shows the exact kernel release string (e.g., `6.5.0-xx-generic`) inherited from the Docker host machine.

### Exercise 2: View Kernel Boot Parameters
> **Goal:** Read the command line passed to the kernel at boot.
```bash
cat /proc/cmdline
```
✅ **Expected:** Options like `ro quiet splash` or similar, depending on the host OS.

### Exercise 3: Inspect Loaded Modules
> **Goal:** View dynamically loaded kernel modules.
```bash
lsmod | head -10
```
✅ **Expected:** A list of modules (drivers, filesystems) currently loaded in the host kernel.

---
[<< Previous: Networking & Security](./06_Networking_and_Security.md) | [Home: Curriculum Map](./README.md) | [Next: Kernel Module Development >>](./08_Kernel_Module_Development.md)