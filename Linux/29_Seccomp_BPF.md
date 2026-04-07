<div align="center">
  <img src="./images/linux_ch29_seccomp.png" alt="Seccomp Architecture Cover" width="800"/>
</div>

# 29: Seccomp-BPF - Syscall Lockdown

> 🧠 **The Feynman Hook:** Imagine a high-security bank app. Even if you use Cgroups to limit its memory, Namespaces to isolate its view, and SELinux to block file access, the app can still try to talk to the Kernel by using any of the ~450 native Linux System Calls. If there's a bug in the `reboot` or `kexec` syscall, a hacker could exploit it. 
> **Seccomp (Secure Computing Mode)** is like presenting the app with a heavily redacted restaurant menu. You tell the Kernel: "This specific process is only legally allowed to use `read()`, `write()`, and `exit()`. If they attempt to order anything else off the menu, shoot them instantly." 

**🎯 The Big Goal:** Understand how Docker and web browsers use eBPF instruction sets to violently terminate processes that attempt unauthorized System Calls.

---

## 1. The Seccomp Paradigm

When a process initiates a syscall, the CPU switches context to the Kernel. Before the Kernel actually executes the requested action, the Seccomp filter intercepts it.

### Strict Mode vs. Filter Mode
- **Strict Mode:** The original implementation. The process can *only* read, write, and exit. Extremely secure, but useless for complex programs like Python or Node.
- **Filter Mode (Seccomp-BPF):** You write a tiny logical filter (using Berkeley Packet Filter syntax) that inspects the syscall number. If the filter returns `SECCOMP_RET_KILL`, the Kernel immediately sends a `SIGSYS` signal, terminating the process without warning.

---

## 2. Docker's Default Seccomp Profile

> **Feynman Insight:** When you run `docker run ubuntu`, Docker silently attaches a 20KB JSON Seccomp profile to your container before it starts. This is why containers are safe.

Docker's default profile completely blocks around 44 highly dangerous syscalls. For example:
- **`reboot`**: A container should never be able to reboot the host.
- **`unshare`**: A container should not be creating nested namespaces.
- **`mount`**: A container should not be mounting host hard drives.
- **`ptrace`**: A container cannot attach a debugger to inspect external memory.

If you test a hacking tool inside a Docker container and it mysteriously crashes with `Bad system call (core dumped)`, it wasn't a bug. Seccomp sniped it.

---

## 3. Creating a Custom Seccomp Sandbox in C

Using the high-level `libseccomp` library, we can easily build an indestructible jail around our own code.

```c
#include <seccomp.h>
#include <stdio.h>
#include <unistd.h>

int main() {
    // 1. Initialize the filter: "KILL anything not explicitly allowed"
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_KILL);
    
    // 2. Safelist the essential syscalls
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(write), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit_group), 0);
    
    // 3. Lock the door. (Cannot be undone once loaded!)
    seccomp_load(ctx);
    
    // This will succeed, because 'write' is safelisted.
    write(1, "I am operating inside the sandbox!\n", 35);
    
    // If you uncomment this line, the process will instantly die. 
    // 'open' is not on the menu.
    // fopen("/etc/passwd", "r"); 
    
    seccomp_release(ctx);
    return 0;
}
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Why does Google Chrome use Seccomp for every single browser tab?</summary>

Chrome executes untrusted JavaScript from random websites constantly. If a malicious website discovers a zero-day vulnerability in the V8 JavaScript engine that allows them to execute arbitrary binary code, their first step is usually to invoke system calls to download malware or read local files. By wrapping the isolated V8 rendering process in a strict Seccomp filter, even if the hacker achieves execution, any attempt to call `open()`, `execve()`, or `socket()` results in the Kernel safely terminating the tab immediately.
</details>

<details>
<summary>💡 View Answer: How does Seccomp complement SELinux? Don't they do the same thing?</summary>

They operate at different architectural layers. Seccomp blocks the *mechanism* (the syscall itself). SELinux blocks the *resource* (the target file). If you use Seccomp to block the `mount` syscall, a process can't mount anything. If you use SELinux, the process can technically call `mount`, but the Kernel checks the labels and decides if it's allowed on that specific device. Defense-in-depth requires both: Seccomp reduces the attack surface of the Kernel itself, while SELinux protects the file system taxonomy.
</details>

---
[<< Previous: SELinux & AppArmor](./28_SELinux_AppArmor.md) | [Home: Curriculum Map](./README.md) | [Next: Linux Capabilities >>](./30_Linux_Capabilities.md)
