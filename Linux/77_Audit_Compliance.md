# 77: Linux Audit & Compliance

<p align="center">
  <img src="images/linux_audit_compliance.png" alt="Linux Audit and Compliance Architecture" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand enterprise-grade Linux security compliance, File Integrity Monitoring (FIM), PAM authentication layers, and leveraging the Linux Audit System (`auditd`) to enforce definitive accountability.**

In a corporate or government environment, simply securing a system isn't enough; you must definitively prove it's secure. Audit and compliance frameworks provide the non-repudiation and tracking necessary for standards like PCI-DSS, HIPAA, and SOC2.

---

## 1. Pluggable Authentication Modules (PAM)

PAM acts as the flexible bridge between Linux applications and the actual authentication mechanisms (LDAP, local `/etc/passwd`, Kerberos, MFA).

### The PAM Logic Layering
Configured in `/etc/pam.d/`, configurations use a stack of four module interfaces:
- **auth**: Validates identity (passwords, biometrics).
- **account**: Verifies account validity (expired, locked out, time-based access).
- **password**: Defines rules for updating authentication tokens (complexity, history).
- **session**: Pre/Post login tasks (mounting homes, configuring environment limits natively, MOTD).

```bash
# Example /etc/pam.d/common-auth
auth    required        pam_unix.so nullok
auth    optional        pam_permit.so
```

---

## 2. System Auditing with `auditd`

The `auditd` daemon and kernel subsystem track security-relevant information directly from the kernel before user-space processes can mask their footprints.

### Key Tools:
- `auditctl`: Configure the kernel audit rules.
- `aureport`: Generate aggregated summaries (e.g., failed logins, executed commands).
- `ausearch`: Query the encrypted binary `audit.log` effectively.

### Watching Files
You can enforce atomic tracking of unauthorized changes to critical files:
```bash
# Watch /etc/passwd for Writes and Attribute changes, tagging it "identity"
auditctl -w /etc/passwd -p wa -k identity

# Search the audit log for that specific tag
ausearch -k identity
```

---

## 3. File Integrity Monitoring (FIM)

How do you prove a system wasn't quietly backdoored? FIM tools like **AIDE** (Advanced Intrusion Detection Environment) or **Tripwire**.

1. **Initialization:** AIDE scans critical directories (`/bin`, `/sbin`, `/etc`) and generates a cryptographic database containing SHA256 hashes, inodes, and ownerships.
2. **Storage:** This database is moved to secure, immutable offline storage.
3. **Verification:** AIDE is systematically executed. It hashes current files and diffs them against the immutable database.

```bash
# AIDE verification check detecting a modified binary
aide --check
# Summary:
#   Total number of files:  25102
#   Added files:            0
#   Removed files:          0
#   Changed files:          1 (e.g., /bin/bash payload altered)
```

---

## 4. Compliance Automation Frameworks

Validating against STIGs (Security Technical Implementation Guides) manually is impossible.
- **OpenSCAP**: A standard for expressing and evaluating compliance.
- Integrates with system configuration tools to automatically scan parameters (firewalls, ciphers, password lifespans) and enforce compliance states universally.

---

## 🤔 Reflection Questions

1. **Why is `auditd` fundamentally more secure for tracking operations than simply relying on `syslog` or `bash_history`?**
2. **If a root attacker alters `/etc/passwd`, how does the combination of `auditd` and AIDE trap them?** What if they alter the AIDE database on disk?
3. **Analyze a PAM vulnerability:** What happens if you insert an `auth sufficient pam_permit.so` rule at the top of an SSH PAM stack?

---

## 📝 Key Interview Talking Points

- Describe the 4 types of PAM management interfaces (Auth, Account, Password, Session).
- Demonstrate knowledge of the kernel-level nature of `auditd` vs userspace logging.
- Explain the baseline-and-compare methodology of File Integrity Management (FIM).

---

[<< Previous: Linux Developer Toolchain](./76_Developer_Toolchain.md) | [Home: Curriculum Map](./README.md) | [Next: Linux for Penetration Testing >>](./78_Penetration_Testing.md)
