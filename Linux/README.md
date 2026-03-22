# The Linux Mastery Curriculum

<p align="center">
  <img src="images/cover.png" alt="Linux Mastery Cover" width="800"/>
</p>

Welcome to the **Linux Mastery Guide**. This repository contains a complete, 12-part curriculum designed to take you from basic terminal survival to injecting custom eBPF probes directly into a live running Linux kernel.

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
* [**08: Memory and Storage Internals**](./08_Memory_and_Storage_Internals.md) - The MMU Virtual Memory illusion, aggressive disk Paging/Swapping, Inodes, and Enterprise LVM logical volumes.
* [**09: UNIX Systems Programming & IPC**](./09_Unix_Systems_Programming.md) - Creating UNIX pipelines entirely in C memory, reaping `wait()` exit codes, and bypassing TCP with high-speed `AF_UNIX` Sockets natively.

### Phase 4: Extreme Observability & Performance (The Capstone)
*When the database is randomly stopping for 5 seconds, amateurs restart the machine. Experts use the USE Method.*

* [**10: Systems Performance and Metrics**](./10_Systems_Performance_Metrics.md) - Brendan Gregg's **USE Method**, the terrifying truth behind Load Averages, I/O wait saturation (`iostat`), and CPU profiling via `perf`.
* [**11: Deep Packet Inspection (TCP/IP)**](./11_Deep_Packet_Inspection.md) - Tracing brutal connection-refused failures down to the exact `RST` flag during TCP Handshakes utilizing `tcpdump` and Wireshark.
* [**12: Capstone: eBPF Observability**](./12_eBPF_Observability.md) - The absolute pinnacle. Utilizing Python `bcc` wrappers to verify, JIT Compile, and securely inject tiny C architectures directly into the isolated Linux Kernel hooking active Syscalls.

---

## 🚀 Execution

The scripts and files enclosed within these lessons are structurally dangerous if utilized incorrectly. You are executing native C `fork` bombs, firewall manipulations, and kernel memory traces. **Do not execute Phase 3 or 4 scripts outside of an isolated Docker Container or a disposable Virtual Machine.**
