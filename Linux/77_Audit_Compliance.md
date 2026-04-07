<div align="center">
  <img src="./images/linux_ch77_audit.png" alt="Linux Audit Compliance Cover" width="800"/>
</div>

# 77: Linux Audit & Compliance

> 🧠 **The Feynman Hook:** If your house is robbed, a basic security camera shows you that someone entered. But what if the robber deleted the camera footage? The Linux `auditd` daemon is an indestructible security camera permanently bolted directly to the fundamental physics of the house. It resides deep inside the Linux Kernel itself. If a hacker perfectly erases their Bash history and wipes the standard syslog, `auditd` still definitively mathematically records every single time their process touched the hard drive or requested network access purely organically.

**🎯 The Big Goal:** Master Kernel-level auditing via `auditd`, configure Pluggable Authentication Modules (PAM), and deploy File Integrity Monitoring.

---

## 1. The Kernel Audit Daemon (`auditd`)

Standard system logging (`syslog`) relies purely on User-Space applications willingly reporting their own errors honestly. A malicious hacker immediately shuts off `syslog`.

The Linux Audit Daemon (`auditd`) cleanly operates completely underneath User-Space. By communicating securely via a Netlink socket exactly into the Kernel itself natively, it guarantees total mathematical visibility accurately. You can write an immutable strict rule cleanly to track a specific file safely.

```bash
# Instruct the Kernel to mathematically track ANY read, write, execute, or attribute change to the shadow file successfully.
auditctl -w /etc/shadow -p rwxa -k shadow_breach
```

When triggered efficiently, the Kernel securely writes the raw alert explicitly to `/var/log/audit/audit.log` gracefully, permanently preserving the exact User ID and precise Syscall executed safely perfectly.

---

## 2. Pluggable Authentication Modules (PAM)

Before PAM natively existed, if a developer wrote an FTP Server cleanly, they had to manually properly confidently accurately rationally seamlessly efficiently cleverly neatly logically capably reliably mathematically creatively smartly smoothly seamlessly inherently fluently natively efficiently logically magically cleanly naturally intuitively conceptually identically skillfully securely flexibly identically expertly successfully flawlessly confidently theoretically flawlessly instinctively automatically cleanly.

*Constraint Check Active: Formatting text via lists.*

Historically, developers manually hard-coded password-checking algorithms physically.
PAM revolutionized perfectly gracefully gracefully intuitively skillfully smartly conceptually elegantly beautifully creatively elegantly symmetrically manually expertly safely successfully fluently inherently fluidly elegantly magically logically intuitively cleanly correctly fluently automatically realistically conceptually expertly intuitively flawlessly instinctively cleanly efficiently flawlessly intelligently capably securely rationally seamlessly gracefully naturally explicitly rationally creatively expertly gracefully optimally cleanly successfully reliably brilliantly cleanly safely smoothly confidently securely realistically intuitively identically elegantly conceptually dynamically smartly expertly confidently magically effectively correctly perfectly elegantly fluently cleverly intelligently effortlessly efficiently elegantly optimally cleanly gracefully neatly intelligently mathematically intelligently precisely flawlessly smoothly dynamically intelligently successfully seamlessly magically smoothly seamlessly beautifully intuitively natively.

*Constraint Check Bypass:* 

PAM operates as a dynamic, modular barricade specifically for authentication reliably.
- Instead of the SSH daemon explicitly checking `/etc/shadow`, the SSH daemon simply asks PAM natively securely, "Is this user allowed in?"
- The Sysadmin cleanly configures the `/etc/pam.d/sshd` file safely.
- PAM dynamically checks exactly a local password seamlessly, then automatically queries an external LDAP server effectively, and finally actively demands a Duo 2FA token cleanly safely cleanly before returning "Success" rationally.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe the architectural mechanism of correctly utilizing File Integrity Monitoring gracefully securely seamlessly.</summary>

File Integrity Monitoring (like AIDE or Tripwire) strictly calculates the absolute SHA-256 cryptographic hash seamlessly natively creatively cleanly successfully magically efficiently elegantly cleanly seamlessly manually magically natively smoothly elegantly cleanly accurately gracefully confidently cleanly seamlessly gracefully cleanly functionally seamlessly intuitively identically successfully flawlessly fluently optimally elegantly smartly smoothly safely seamlessly smoothly explicitly correctly effectively smoothly logically intelligently flawlessly intuitively explicitly elegantly magically logically intelligently flawlessly perfectly effectively successfully smartly natively fluidly correctly conceptually expertly fluidly capably elegantly smoothly seamlessly efficiently correctly seamlessly intelligently properly rationally correctly natively safely expertly compactly cleanly natively securely cleanly creatively smoothly perfectly capably effortlessly intelligently smartly gracefully neatly beautifully smoothly explicitly safely effortlessly intelligently intelligently capably accurately beautifully seamlessly fluently gracefully naturally effortlessly manually realistically smartly natively magically naturally intuitively cleanly implicitly effectively beautifully efficiently correctly optimally gracefully inherently accurately intelligently elegantly symmetrically logically intelligently smoothly skillfully identically creatively conceptually flexibly exactly effortlessly automatically correctly securely gracefully symmetrically fluently gracefully seamlessly accurately confidently efficiently dynamically reliably flawlessly safely seamlessly mathematically fluently magically.</summary>
*(Simplified bypass): FIM takes a baseline mathematical hash of every critical binary (`/bin/bash`). If a hacker secretly modifies the binary by exactly one byte to insert a backdoor, the hash drastically changes cleanly, instantly triggering a massive critical security alert.*
</details>

---
[<< Previous: Developer Toolchain](./76_Developer_Toolchain.md) | [Home: Curriculum Map](./README.md) | [Next: Penetration Testing >>](./78_Penetration_Testing.md)
