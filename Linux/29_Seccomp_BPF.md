# 29: Seccomp-BPF - Syscall Lockdown

<p align="center">
  <img src="images/container_internals.png" alt="Seccomp Architecture" width="800"/>
</p>

Even with MAC (SELinux/AppArmor) controlling *which files* a process can access, the process can still call ~450 different system calls. A vulnerability could exploit any one of them.

**Seccomp-BPF** restricts *which system calls* a process is allowed to make. If it tries to call something not on the allow-list, the kernel kills it instantly.

---

## 1. The "Restaurant Menu" Analogy

Normally, a process can order anything from the kernel's menu (450+ syscalls). Seccomp rips out pages from the menu: "You may only use `read`, `write`, `exit`, and `sigreturn`. Try anything else and you're ejected."

---

## 2. Who Uses Seccomp?

- **Docker:** Every container runs with a default seccomp profile that blocks ~44 dangerous syscalls.
- **Chrome/Firefox:** Each browser tab is sandboxed with seccomp.
- **systemd:** Services can declare `SystemCallFilter=` to restrict their syscalls.

---

## 3. Seccomp Modes

| Mode | Behavior |
| :--- | :--- |
| **Strict** | Only `read`, `write`, `exit`, and `sigreturn` are allowed. |
| **Filter (BPF)** | You define a custom BPF program that inspects every syscall and decides: ALLOW, KILL, ERRNO, or LOG. |

---

## 4. Hands-on: Restricting a Process

Using `libseccomp` (higher-level API):

```c
#include <seccomp.h>
#include <stdio.h>
#include <unistd.h>

int main() {
    // Start by BLOCKING everything
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_KILL);
    
    // Allow only these syscalls
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(write), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit_group), 0);
    
    // Activate the filter
    seccomp_load(ctx);
    
    // This WORKS (write is allowed)
    write(1, "I am sandboxed!\n", 16);
    
    // This would KILL the process (open is NOT allowed):
    // fopen("/etc/passwd", "r");
    
    seccomp_release(ctx);
    return 0;
}
```

```bash
gcc -o sandbox sandbox.c -lseccomp
./sandbox
# Output: "I am sandboxed!"
```

---

## 5. Docker's Default Seccomp Profile

Docker blocks syscalls that could break container isolation:
```bash
# View Docker's default profile
docker info --format '{{ .SecurityOptions }}'

# Run a container WITHOUT seccomp (dangerous!)
docker run --security-opt seccomp=unconfined alpine sh

# Run with a custom profile
docker run --security-opt seccomp=my-profile.json alpine sh
```

Key blocked syscalls: `mount`, `reboot`, `kexec_load`, `clock_settime`, `ptrace`.

---

*In Chapter 30, we explore Capabilities — the fine-grained replacement for the "all-or-nothing" root privilege model.*

---
---

## 🧪 Sandbox: Build a Seccomp Jail

The **Security Sandbox** has `libseccomp-dev` ready to go:

```bash
cd sandbox/security-lab
docker compose up -d
docker exec -it security-sandbox bash
```

**Compile and test the sandbox program from this chapter:**
```bash
cat > /work/seccomp_demo.c << 'CEOF'
#include <seccomp.h>
#include <stdio.h>
#include <unistd.h>
int main() {
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_KILL);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(write), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit_group), 0);
    seccomp_load(ctx);
    write(1, "I am sandboxed!\n", 16);
    seccomp_release(ctx);
    return 0;
}
CEOF
gcc -o /work/seccomp_demo /work/seccomp_demo.c -lseccomp
/work/seccomp_demo
```

[<< Previous: SELinux & AppArmor](./28_SELinux_AppArmor.md) | [Home: Curriculum Map](./README.md) | [Next: Linux Capabilities >>](./30_Linux_Capabilities.md)
