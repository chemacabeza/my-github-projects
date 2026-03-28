# The Linux Mastery Curriculum

<p align="center">
  <img src="images/cover.png" alt="Linux Mastery Cover" width="800"/>
</p>

Welcome to the **Linux Mastery Guide**. This repository contains a complete, **60-part curriculum** spanning 15 phases, designed to take you from basic terminal survival to live kernel patching, kernel-bypass networking, and production infrastructure management.

This hardcore curriculum was synthesized from 15 professional-grade textbooks procured from a Humble Bundle collection, representing the absolute bibles of system administration and engineering: *UNIX and Linux System Administration Handbook*, *Systems Performance*, *BPF Performance Tools*, *Linux Kernel Development*, and *Advanced Programming in the UNIX Environment*.

---

## 📚 Curriculum Structure

### Phase 1: Foundations (The CLI & Operating System)
*Understand the Linux philosophy: Everything is a file, and everything is composable.*

* [**01: The Linux Philosophy and Filesystem**](./01_The_Linux_Philosophy.md) - The FHS hierarchy (`/etc`, `/proc`, `/var`), Golden Rules, and `chmod` Octal mathematics.
* [**02: Command Line Survival**](./02_Command_Line_Survival.md) - The Mighty Pipe (`|`), `stdout`/`stderr` redirection, and parsing massive files with `grep`, `awk`, and `sed`.
* [**03: Systemd and Package Management**](./03_Package_and_Service_Mgmt.md) - Writing immortal background daemons (`systemctl`), binary logging (`journalctl`), and APT repositories.

### Phase 2: Administration & Automation (Sysadmin Level)
*Transition from typing interactive commands to building fully isolated, secure automated environments.*

* [**04: Bash Scripting Mastery**](./04_Bash_Scripting_Mastery.md) - The Shebang, strict mode execution (`set -euo pipefail`), exact exit codes (`$?`), and Crontab scheduling.
* [**05: Process and Resource Management**](./05_Process_and_Resource_Management.md) - The `fork/exec` lifecycle, Zombies, POSIX Signals (`kill`), `/proc`, and the underlying `cgroup` foundation of Docker.
* [**06: Networking, Firewalls, and SSH**](./06_Networking_and_Security.md) - Port hunting with `ss`, absolute security via the Uncomplicated Firewall (`ufw`), and encrypted DataGrip tunneling through SSH.

### Phase 3: Systems Programming & The Kernel (Expert Level)
*Fundamentally unlearn user-space logic. Enter Ring-0 hardware context natively.*

* [**07: The Linux Kernel**](./07_The_Linux_Kernel.md) - Monolithic architecture perfectly mapped against Microkernels, Loadable Modules (`.ko`), and diagnosing silent HTTP crashes via `strace` Syscall tracking.
* [**08: Kernel Module Development**](./08_Kernel_Module_Development.md) - Writing a fully-fledged Character Device Driver from scratch utilizing C `copy_to_user` buffers, `fops` pointer mappings, and Atomic vs Process hardware context constraints. 
* [**09: Memory and Storage Internals**](./09_Memory_and_Storage_Internals.md) - The MMU Virtual Memory illusion, aggressive disk Paging/Swapping, Inodes, and Enterprise LVM logical volumes.
* [**10: UNIX Systems Programming & IPC**](./10_Unix_Systems_Programming.md) - Creating UNIX pipelines entirely in C memory, reaping `wait()` exit codes, and bypassing TCP with high-speed `AF_UNIX` Sockets natively.

### Phase 4: Extreme Observability & Performance (The Capstone)
*When the database is randomly stopping for 5 seconds, amateurs restart the machine. Experts use the USE Method.*

* [**11: Systems Performance and Metrics**](./11_Systems_Performance_Metrics.md) - Brendan Gregg's **USE Method**, the terrifying truth behind Load Averages, I/O wait saturation (`iostat`), and CPU profiling via `perf`.
* [**12: Deep Packet Inspection (TCP/IP)**](./12_Deep_Packet_Inspection.md) - Tracing brutal connection-refused failures down to the exact `RST` flag during TCP Handshakes utilizing `tcpdump` and Wireshark.
* [**13: Capstone: eBPF Observability**](./13_eBPF_Observability.md) - The absolute pinnacle. Utilizing Python `bcc` wrappers to verify, JIT Compile, and securely inject tiny C architectures directly into the isolated Linux Kernel hooking active Syscalls.

### Phase 5: The UNIX Programming Interface (TLPI)
*Descending natively into C, managing raw Memory locks, Sockets, and the absolute File I/O architecture.*

* [**14: File I/O Internals & Buffering**](./14_File_IO_Internals.md) - The 3-layer `fd`/open-file/inode tracking hierarchy, File descriptor mapping, `O_DIRECT` caching, and absolute Atomicity utilizing `O_APPEND`.
* [**15: Signals and Process Lifecycle**](./15_Signals_and_Process_Lifecycle.md) - Physical UNIX process cloning via `fork()`, exact binary execution via `execve()`, and capturing Asynchronous hardware Signals safely with `sig_atomic_t`.
* [**16: POSIX Threads (Pthreads)**](./16_POSIX_Threads.md) - Safe Multi-Core Parallel Native execution, avoiding Deadlocks utilizing extreme Mutex synchronization (`pthread_mutex_t`), and Condition Variables for Producer/Consumer modeling natively.
* [**17: Socket Programming & TCP/IP**](./17_Socket_Programming.md) - Escaping the OS motherboard universally. The complete architectural `socket()`/`bind()`/`accept()` API, Network Byte order constraints natively, and UNIX Server/Client echoing dynamically natively.

### Phase 6: Advanced Network Security
*Master the kernel-level packet filtering engine that protects every Linux server on Earth.*

* [**18: Linux Netfilter & iptables Architecture**](./18_Linux_Firewalls_iptables.md) - Deep-diving into the Kernel Hook points (Chains), Table hierarchies (`filter`, `nat`, `mangle`), and utilizing the `conntrack` state machine for sophisticated 'Bare Metal' rule engineering.

### Phase 7: Containerization Internals
*Deconstruct Docker and Kubernetes into the core Linux Kernel primitives that make them possible.*

* [**19: Linux Namespaces - The Illusion of Isolation**](./19_Linux_Namespaces.md) - Virtualizing the system view via PID, Network, and Mount namespaces.
* [**20: Control Groups (cgroups) - Resource Mastery**](./20_Control_Groups_cgroups.md) - Enforcing hard CPU/RAM limits via the `/sys/fs/cgroup` filesystem interface.
* [**21: Creating a Container from Scratch**](./21_Container_from_Scratch.md) - Integrating Namespaces, Cgroups, and `chroot` into a single functional container runner from scratch (C/Bash).

### Phase 8: VFS & Memory Management
*Understand how Linux turns slow disks into fast virtual memory.*

* [**22: Virtual Filesystem (VFS) Internals**](./22_VFS_Internals.md) - Superblocks, Inodes, Dentries, and the path-walk algorithm that makes every filesystem speak the same language.
* [**23: Memory-Mapped I/O (`mmap`)**](./23_Memory_Mapped_IO.md) - Eliminating `read()`/`write()` overhead by mapping files directly into process address space.
* [**24: Page Cache & Dirty Writeback**](./24_Page_Cache_Writeback.md) - The invisible RAM cache that makes your disk feel fast, and the dangers of dirty page loss.

### Phase 9: Advanced Kernel Development
*Extend the Linux Kernel itself with custom filesystems, packet interceptors, and device drivers.*

* [**25: Writing a FUSE Filesystem**](./25_FUSE_Filesystem.md) - Build a custom filesystem in userspace that generates files on-the-fly.
* [**26: Netfilter Hooks in C**](./26_Netfilter_Hooks_C.md) - Write kernel modules that intercept, inspect, and modify network packets in real-time.
* [**27: Character Device Drivers**](./27_Device_Drivers.md) - Create a custom `/dev/` device with read, write, and ioctl operations.

### Phase 10: Linux Security Architecture
*The three pillars of kernel-level security enforcement.*

* [**28: SELinux & AppArmor (MAC)**](./28_SELinux_AppArmor.md) - Mandatory Access Control: even root obeys the policy.
* [**29: Seccomp-BPF**](./29_Seccomp_BPF.md) - Restricting which system calls a process can make (used by Docker & Chrome).
* [**30: Linux Capabilities**](./30_Linux_Capabilities.md) - Replacing the all-or-nothing root model with fine-grained permissions.

### Phase 11: High-Performance Networking
*From traffic shaping to kernel-bypass packet processing at 100M+ packets/sec.*

* [**31: Traffic Control (`tc`) & QoS**](./31_Traffic_Control_QoS.md) - Bandwidth shaping, latency simulation, and priority-based queuing.
* [**32: XDP (eXpress Data Path)**](./32_XDP.md) - Processing packets at the NIC driver level using eBPF programs.
* [**33: DPDK & AF_XDP**](./33_DPDK_AF_XDP.md) - Kernel-bypass networking for extreme throughput (telecom, HFT, 5G).

### Phase 12: Production Linux Engineering
*Operating, patching, and debugging Linux systems in production.*

* [**34: Systemd Internals**](./34_Systemd_Internals.md) - Unit files, socket activation, journal, and service hardening.
* [**35: Live Kernel Patching**](./35_Live_Kernel_Patching.md) - Applying security patches to a running kernel without rebooting.
* [**36: Kdump & Crash Analysis**](./36_Kdump_Crash_Analysis.md) - Capturing and analyzing kernel crash dumps for post-mortem forensics.

### Phase 13: Essential Administration
*The command-line toolkit every Linux administrator must have at their fingertips.*

* [**37: File Viewing**](./37_File_Viewing.md) - Inspecting files with `cat`, `less`, `more`, `head`, `tail`, `tac`, and `nl`.
* [**38: Text Processing**](./38_Text_Processing.md) - Transforming data with `grep`, `sed`, `awk`, `cut`, `sort`, `uniq`, `tr`, and `wc`.
* [**39: Permissions**](./39_Permissions.md) - Controlling access with `chmod`, `chown`, `chgrp`, `umask`, SUID, SGID, and the Sticky Bit.
* [**40: Networking**](./40_Networking.md) - Diagnostics and transfers with `ip`, `ss`, `ping`, `traceroute`, `dig`, `curl`, and `wget`.
* [**41: Archiving & Compression**](./41_Archiving.md) - Bundling and compressing with `tar`, `gzip`, `bzip2`, `xz`, `zip`, and `rsync`.
* [**42: Package Management**](./42_Package_Management.md) - Installing software with `apt`, `dpkg`, `dnf`, `rpm`, `snap`, and `flatpak`.
* [**43: File Management**](./43_File_Management.md) - Operating on files with `cp`, `mv`, `rm`, `mkdir`, `find`, `locate`, `ln`, and `stat`.
* [**44: User Management**](./44_User_Management.md) - Managing users and groups with `useradd`, `usermod`, `userdel`, `passwd`, and `sudo`.
* [**45: Disk & System Info**](./45_Disk_and_System_Info.md) - Monitoring with `df`, `du`, `lsblk`, `fdisk`, `mount`, `uname`, `uptime`, and `free`.
* [**46: Process Management**](./46_Process_Management.md) - Controlling processes with `ps`, `top`, `htop`, `kill`, `nice`, `bg`, `fg`, and `nohup`.
* [**47: System Control**](./47_System_Control.md) - Managing services and scheduling with `systemctl`, `shutdown`, `reboot`, `cron`, and `timedatectl`.
* [**48: Help & Reference**](./48_Help_and_Reference.md) - Finding answers with `man`, `info`, `apropos`, `whatis`, `type`, `which`, and `alias`.

### Phase 14: Infrastructure Services
*Running and securing the services that power real Linux infrastructure.*

* [**49: The Boot Process & GRUB**](./49_Boot_Process_and_GRUB.md) - BIOS/UEFI firmware, GRUB2 configuration and recovery, initramfs, kernel parameters, and the full startup chain to `systemd`.
* [**50: System Logging**](./50_System_Logging.md) - `journalctl` structured queries, syslog facilities and severities, `rsyslog`, `logrotate`, and persistent journal storage.
* [**51: Vim Mastery**](./51_Vim_Mastery.md) - Modal editing philosophy, Normal/Insert/Visual modes, the Verb-Noun grammar (`dw`, `ciw`), macros, `.vimrc`, and search/replace.
* [**52: Storage Management**](./52_Storage_Management.md) - Partitioning (`fdisk`, `parted`), LVM (PV/VG/LV), software RAID with `mdadm`, NFS/SMB mounts, and `/etc/fstab`.
* [**53: DNS & DHCP**](./53_DNS_and_DHCP.md) - DNS resolution hierarchy, record types (A/AAAA/MX/CNAME), `dig`, the DHCP DORA handshake, and `systemd-resolved`.
* [**54: Web Servers (Apache & Nginx)**](./54_Web_Servers.md) - Virtual hosts, server blocks, reverse proxy configuration, TLS with Let's Encrypt, and access logging.

### Phase 15: DevOps & Security Hardening
*Modern operational practices and comprehensive security posture.*

* [**55: SSH Deep Dive**](./55_SSH_Deep_Dive.md) - Ed25519 key-based auth, `~/.ssh/config`, local/remote port forwarding, ProxyJump, agent forwarding, and `sshd_config` hardening.
* [**56: Virtualization (KVM/QEMU)**](./56_Virtualization.md) - Hardware-assisted virtualization, the KVM/QEMU/libvirt stack, `virsh`, `virt-install`, snapshots, qcow2, and cloud-init.
* [**57: Git Version Control**](./57_Git_Version_Control.md) - `init`/`clone`, branching strategies, merge vs rebase, undoing mistakes, `.gitignore`, tags, and collaborative workflows.
* [**58: Regular Expressions**](./58_Regular_Expressions.md) - BRE/ERE syntax, character classes, quantifiers, anchors, groups, backreferences, and practical `grep`/`sed` patterns.
* [**59: Linux Hardening**](./59_Linux_Hardening.md) - System updates, user policy, SSH lockdown, `ufw`/`firewalld`, `fail2ban`, Lynis auditing, and `sysctl` kernel hardening.
* [**60: Troubleshooting Methodology**](./60_Troubleshooting.md) - Systematic CPU/memory/disk/network diagnosis framework, boot recovery, the USE Method, and rescue mode.

---

## 🚀 Execution

The scripts and files enclosed within these lessons are structurally dangerous if utilized incorrectly. You are executing native C `fork` bombs, firewall manipulations, and kernel memory traces. **Do not execute Phase 3 or 4 scripts outside of an isolated Docker Container or a disposable Virtual Machine.**
