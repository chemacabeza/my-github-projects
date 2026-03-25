# 36: Kdump & Crash Analysis

<p align="center">
  <img src="images/container_internals.png" alt="Kdump Architecture" width="800"/>
</p>

When a Linux kernel panics, the screen fills with cryptic hex addresses and the system locks up. Without preparation, that information is **lost forever** on reboot.

**Kdump** captures a snapshot of the kernel's memory at the moment of the crash, saving it to a file for post-mortem analysis. This is the Linux equivalent of an airplane's **black box**.

---

## 1. The "Crime Scene Photographer" Analogy

When a crime (kernel panic) happens, a normal camera (the crashed kernel) is destroyed. Kdump is a **second, hidden camera** (a reserve kernel) that activates automatically, takes photos of the crime scene (memory dump), saves them, and then reboots normally.

---

## 2. How Kdump Works

1.  At boot, the system reserves a chunk of RAM for a **crash kernel**.
2.  When a panic occurs, the crashed kernel transfers control to the crash kernel.
3.  The crash kernel writes the memory dump (`vmcore`) to disk.
4.  The system reboots normally.
5.  Engineers analyze the `vmcore` to find the root cause.

---

## 3. Setting Up Kdump

### Installation:
```bash
# Debian/Ubuntu
sudo apt install kdump-tools crash linux-image-$(uname -r)-dbgsym

# Red Hat/CentOS
sudo yum install kexec-tools crash kernel-debuginfo
```

### Configuration:
```bash
# Reserve 256MB for the crash kernel (in GRUB)
# Edit /etc/default/grub:
GRUB_CMDLINE_LINUX="crashkernel=256M"

# Apply
sudo update-grub
sudo reboot
```

### Verify:
```bash
# Check that kdump is active
sudo kdumpctl status   # Red Hat
sudo kdump-config show # Ubuntu

# Check reserved memory
cat /proc/iomem | grep "Crash kernel"
# e.g., 0x31000000-0x40ffffff : Crash kernel
```

---

## 4. Triggering a Test Crash

> [!CAUTION]
> This will intentionally crash your kernel. Only do this on a test machine or VM!

```bash
# Enable SysRq
echo 1 | sudo tee /proc/sys/kernel/sysrq

# Trigger a kernel panic
echo c | sudo tee /proc/sysrq-trigger
```

After reboot, the crash dump will be in `/var/crash/`.

---

## 5. Analyzing the Crash with `crash`

```bash
# Open the crash dump
sudo crash /usr/lib/debug/boot/vmlinux-$(uname -r) /var/crash/*/vmcore

# Inside the crash tool:
crash> bt           # Backtrace — what function was running when it died?
crash> log          # Kernel log at the moment of crash
crash> ps           # Process list at the moment of crash
crash> files <PID>  # What files was a process holding open?
crash> exit
```

### Common Root Causes:
- **NULL pointer dereference** → A kernel module accessed invalid memory.
- **Soft lockup** → A CPU was stuck in kernel code for too long.
- **Out of Memory** → The OOM killer failed to free enough RAM.

---

## Final Summary: The Complete Journey

You started at Chapter 1 learning what `ls` does. You are now capturing kernel crash dumps and performing forensic analysis on the kernel's memory state at the moment of failure.

**You are a Linux Kernel Architect.**

---
[<< Previous: Live Kernel Patching](./35_Live_Kernel_Patching.md) | [Home: Curriculum Map](./README.md)
