# 28: SELinux & AppArmor - Mandatory Access Control

<p align="center">
  <img src="images/container_internals.png" alt="MAC Security Architecture" width="800"/>
</p>

Traditional Linux permissions (`rwx`) are **Discretionary** — the file owner decides who gets access. But what if a compromised web server changes its own permissions? Game over.

**Mandatory Access Control (MAC)** puts the **system administrator** in charge. Even if a process is running as `root`, MAC can say: "You are a web server. You may *only* read `/var/www`. Nothing else. Ever."

---

## 1. The "Prison Warden" Analogy

Regular permissions are like a house with normal locks (the homeowner decides who gets a key). MAC is like a **maximum-security prison**: even if an inmate picks a lock, the warden's rules still prevent them from leaving their wing.

---

## 2. SELinux (Red Hat / Fedora / CentOS)

SELinux assigns a **security label** to every process, file, and port. A policy defines which labels can interact.

### Key Concepts:
| Component | What it Does |
| :--- | :--- |
| **Subject** | A process (e.g., `httpd_t` — the Apache web server). |
| **Object** | A file or resource (e.g., `httpd_sys_content_t` — web content files). |
| **Policy** | "Subject `httpd_t` may read objects labeled `httpd_sys_content_t`." |

### Essential Commands:
```bash
# Check SELinux status
sestatus

# View the security label of a file
ls -Z /var/www/html/index.html
# → system_u:object_r:httpd_sys_content_t:s0

# View the security label of a process
ps -eZ | grep httpd
# → system_u:system_r:httpd_t:s0

# Temporarily set SELinux to permissive (log but don't block)
sudo setenforce 0

# Fix file labels after moving files
sudo restorecon -Rv /var/www/html/
```

> [!CAUTION]
> Never disable SELinux in production. If something breaks, set it to `Permissive`, read the logs (`/var/log/audit/audit.log`), and fix the policy.

---

## 3. AppArmor (Ubuntu / SUSE / Debian)

AppArmor uses **path-based profiles** instead of labels. Each profile defines exactly which files and capabilities a program may use.

### Viewing Profiles:
```bash
# List all loaded profiles
sudo aa-status

# A profile looks like this (simplified):
# /etc/apparmor.d/usr.sbin.nginx
/usr/sbin/nginx {
    /var/www/** r,            # Read web content
    /var/log/nginx/** w,      # Write logs
    /run/nginx.pid rw,        # Read/write PID file
    deny /etc/shadow r,       # NEVER read passwords
    capability net_bind_service,  # Bind to port 80/443
}
```

### Profile Management:
```bash
# Put a profile in "complain" mode (log violations but don't block)
sudo aa-complain /usr/sbin/nginx

# Put it back in "enforce" mode
sudo aa-enforce /usr/sbin/nginx
```

---

## 4. SELinux vs AppArmor

| Feature | SELinux | AppArmor |
| :--- | :--- | :--- |
| **Approach** | Label-based (every object has a type). | Path-based (rules reference file paths). |
| **Complexity** | Very complex, very powerful. | Simpler to configure. |
| **Distros** | Red Hat, Fedora, CentOS. | Ubuntu, Debian, SUSE. |
| **Philosophy** | "Deny everything not explicitly allowed." | "Allow everything, then restrict specific programs." |

---

*In Chapter 29, we restrict which system calls a process is even allowed to make.*

---
---

## �� Sandbox: Practice MAC Policies

The **Security Sandbox** comes with AppArmor tools pre-installed:

```bash
cd sandbox/security-lab
docker compose up -d
docker exec -it security-sandbox bash
```

**Experiment with AppArmor:**
```bash
# Check AppArmor status
aa-status

# View loaded profiles
cat /etc/apparmor.d/usr.sbin.nginx 2>/dev/null || echo "Create your own profile!"

# Test capability restrictions
capsh --print
```

[<< Previous: Device Drivers](./27_Device_Drivers.md) | [Home: Curriculum Map](./README.md) | [Next: Seccomp-BPF >>](./29_Seccomp_BPF.md)
