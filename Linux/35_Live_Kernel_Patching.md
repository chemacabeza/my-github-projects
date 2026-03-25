# 35: Live Kernel Patching

<p align="center">
  <img src="images/container_internals.png" alt="Live Patching Architecture" width="800"/>
</p>

A critical security vulnerability is discovered in the Linux kernel. Traditionally, you must reboot to apply the fix. But your server handles 10,000 active connections — a reboot means downtime, dropped connections, and angry users.

**Live Kernel Patching** applies security patches to a running kernel **without rebooting**.

---

## 1. The "Surgery on a Beating Heart" Analogy

Traditional patching is like stopping a patient's heart, performing surgery, and restarting it. Live patching is performing **open-heart surgery while the heart is beating**. Incredibly precise, incredibly powerful.

---

## 2. How It Works: `ftrace` + Function Replacement

1.  A vulnerable function `foo()` exists in the running kernel.
2.  The live patch module provides a fixed version: `foo_patched()`.
3.  Using the `ftrace` framework, the kernel redirects all calls to `foo()` → `foo_patched()`.
4.  The original function remains in memory but is never called again.

```
Before:  syscall → foo()          [VULNERABLE]
After:   syscall → foo_patched()  [FIXED, no reboot]
```

---

## 3. Using `kpatch` (Red Hat)

```bash
# Install kpatch utilities
sudo yum install kpatch kpatch-dnf

# List available live patches
sudo kpatch list

# Apply a patch
sudo kpatch load kpatch-CVE-2024-XXXX.ko

# Verify
sudo kpatch list
# State: enabled

# Enable automatic patching through dnf
sudo kpatch-dnf auto-update
```

---

## 4. Using `livepatch` (Ubuntu / Canonical)

```bash
# Enable Canonical Livepatch (requires Ubuntu Pro token)
sudo canonical-livepatch enable YOUR-TOKEN

# Check status
canonical-livepatch status --verbose

# Output: patches applied, kernel version, CVEs fixed
```

---

## 5. Writing a Custom Live Patch Module

For advanced users, you can write your own:

```c
#include <linux/module.h>
#include <linux/livepatch.h>

static int patched_cmdline_proc_show(struct seq_file *m, void *v) {
    seq_printf(m, "PATCHED: %s\n", current->comm);
    return 0;
}

static struct klp_func funcs[] = {
    {
        .old_name = "cmdline_proc_show",
        .new_func = patched_cmdline_proc_show,
    }, { }
};

static struct klp_object objs[] = {
    { .funcs = funcs }, { }
};

static struct klp_patch patch = { .objs = objs };

static int __init my_init(void) { return klp_enable_patch(&patch); }
static void __exit my_exit(void) { }

module_init(my_init);
module_exit(my_exit);
MODULE_LICENSE("GPL");
MODULE_INFO(livepatch, "Y");
```

> [!IMPORTANT]
> Live patching is not a replacement for regular kernel updates. It's a **bridge** that keeps you secure until your next scheduled maintenance window.

---

*In Chapter 36, the final chapter, we learn to capture and analyze kernel crashes.*

---
[<< Previous: Systemd Internals](./34_Systemd_Internals.md) | [Home: Curriculum Map](./README.md) | [Next: Kdump & Crash Analysis >>](./36_Kdump_Crash_Analysis.md)
