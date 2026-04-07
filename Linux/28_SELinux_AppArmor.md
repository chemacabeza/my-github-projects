<div align="center">
  <img src="./images/linux_ch28_selinux.png" alt="SELinux MAC Architecture Cover" width="800"/>
</div>

# 28: SELinux & AppArmor - Mandatory Access Control

> 🧠 **The Feynman Hook:** Traditional Linux permissions are like giving someone a copy of the front door key. Once they are inside (they have `root` or user permissions), they can walk into any room. This is **Discretionary Access Control (DAC)**. But what if a hacker compromises a basic web server running as `root`? They now have master keys to the whole building. 
> Enter **Mandatory Access Control (MAC)**. SELinux and AppArmor act as invisible, bulletproof glass walls. Even if a process has the `root` master key, the invisible MAC wall says: "You are the Web Server. You may only look at the `/var/www/` folder. You are physically incapable of opening the `/etc/shadow` password room, even with the master key."

**🎯 The Big Goal:** Understand how SELinux and AppArmor fundamentally override standard root permissions to isolate containerized workloads and secure vulnerable daemons.

---

## 1. SELinux (Security-Enhanced Linux)

Developed by the NSA, SELinux is the default MAC system on Red Hat, CentOS, and Fedora.

> **Feynman Insight:** SELinux does not care about folders. It cares exclusively about **Labels**. Every single process running in memory has a sticker on it. Every single file on the hard drive has a sticker on it. If the process's sticker does not explicitly match the policy for the file's sticker, the action is blocked—even if the process is `root`.

### The Three States of SELinux
1. **Enforcing:** Active. Blocks invalid actions and logs them.
2. **Permissive:** Passive. Allows invalid actions but heavily logs them (Crucial for debugging!).
3. **Disabled:** Off. (Never do this in production).

### Practical Diagnostic Workflow
When a web server mysteriously gets a "Permission Denied" error, follow the stickers:
```bash
# 1. View the System Status
sestatus

# 2. View the Sticker (Context) on the Web Server Process
ps -eZ | grep nginx
# Output: system_u:system_r:httpd_t:s0 (The sticker is 'httpd_t')

# 3. View the Sticker on the target HTML file
ls -Z /var/www/html/index.html
# Output: system_u:object_r:user_home_t:s0 (The sticker is 'user_home_t')

# The Kernel blocks it! A web server (httpd_t) cannot read a user home directory file (user_home_t).
# Fix it by restoring the correct default Web Server sticker to the file:
sudo restorecon -v /var/www/html/index.html
```

---

## 2. AppArmor

AppArmor is the default MAC system on Ubuntu and Debian. It is significantly more human-readable.

> **Feynman Insight:** Instead of abstract NSA stickers, AppArmor uses simple **Paths**. You write a literal profile for a specific binary (like `/usr/sbin/nginx`) and just list the exact file paths it is allowed to touch.

### A Typical AppArmor Profile (`/etc/apparmor.d/usr.sbin.nginx`)
```text
/usr/sbin/nginx {
    # Allow reading web content
    /var/www/** r,
    
    # Allow writing to exact log files
    /var/log/nginx/*.log w,
    
    # Explicitly deny access to password files, even for root
    deny /etc/shadow r,
}
```

If you modify a profile, you simply reload it. If it blocks something unexpectedly, you use `aa-complain` to switch it to logging-only mode.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: If you run a Docker container, does it use SELinux or AppArmor?</summary>

It uses whichever MAC framework is active on the underlying Host OS. Docker on Ubuntu automatically generates and applies a default AppArmor profile to every newly spawned container. Docker on RHEL leverages SELinux labels seamlessly. The container engine simply acts as a translator, dynamically writing rules for the host's native MAC system.
</details>

<details>
<summary>💡 View Answer: Describe why 'setenforce 0' is preferred over permanently disabling SELinux in the boot configuration.</summary>

Disabling SELinux in the boot config stops the Kernel from assigning labels to newly created files entirely. If you ever turn it back on, the filesystem will be completely unlabelled and the server will likely fail to boot, requiring a massive relabeling operation. `setenforce 0` simply switches to Permissive mode—the Kernel continues applying and tracking labels properly, it just temporarily stops blocking violations.
</details>

---
[<< Previous: Device Drivers](./27_Device_Drivers.md) | [Home: Curriculum Map](./README.md) | [Next: Seccomp-BPF >>](./29_Seccomp_BPF.md)
