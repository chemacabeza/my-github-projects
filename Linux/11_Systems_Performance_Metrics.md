# 10: Systems Performance and The USE Method

Welcome to **Phase 4: The Capstone**. Based heavily on Brendan Gregg's masterpiece *Systems Performance*, this phase separates the seniors from the true architecture masters.

When a server is "slow," amateurs guess. They restart Nginx. They reboot the machine.
Experts use the **USE Method**.

---

## 1. The USE Method 

For every single hardware resource on the machine (CPU, Memory, Disk, Network), you must check precisely three metrics:

1. **Utilization:** Is the resource heavily busy? (e.g., CPU is at 99%)
2. **Saturation:** Is there a queue of work physically waiting for the resource? (e.g., 50 threads waiting for 1 CPU core)
3. **Errors:** Are there hardware/software errors dropping requests?

### Identifying the Bottleneck

1. **CPU Saturation:** Your CPU is at 100% Utilization, and your Load Average is 15.0 on a 4-core machine. 11 processes are *Saturated* and desperately waiting in the Linux run queue.
2. **Disk Saturation:** Your CPU is at 5% Utilization, but the application takes 10 seconds to respond. You check Disc I/O. The disk is 100% Utilized, and 200 filesystem requests are waiting in the queue. You are bottlenecked on the spinning hard drive!
3. **Network Errors:** Network Utilization is only 100Mbps (on a 1Gbps link). No saturation. But `netstat` shows exactly 5000 TCP Retransmits per second. You have a failing switch dropping packets!

---

## 2. Load Averages (`uptime`)

The most misunderstood metric in Linux is Load Average.
```bash
# Output: load average: 2.15, 1.83, 1.50
uptime
```
The three numbers represent the exponentially damped moving average of the Load over the last **1 minute**, **5 minutes**, and **15 minutes**.

### What exactly is "Load"?
In Linux, Load is the number of processes currently executing on a CPU core *PLUS* the number of processes stuck in the Uninterruptible Sleep state (`D` state in `htop`). 

An Uninterruptible Sleep process is physically waiting for a slow spinning hard drive to fetch data. It cannot be killed by `kill -9`. It is completely frozen.

**The Golden Rule of Load:**
If your server has exactly **4 CPU Cores**, a Load Average of `4.00` means your CPUs are perfectly 100% utilized. No one is waiting. No one is idle.
If your Load hits `10.00` on a 4-core machine, 6 processes are Saturated and screaming for CPU time! The server will feel incredibly slow.

---

## 3. High-Speed Resource Tools

Amateurs use `top`. Experts use specialized probes to isolate subsystems.

### Virtual Memory Statistics (`vmstat`)
`vmstat` gives a high-level overview of RAM, Swapping, and CPU context switches instantly.

```bash
# Update the metrics every 1 second, exactly 5 times.
vmstat 1 5

# Notice the 'si' (Swap In) and 'so' (Swap Out) columns. 
# If they are persistently higher than 0, your server is completely out of RAM 
# and desperately Thrashing the hard drive linearly to survive!
```

### I/O Statistics (`iostat`)
When the database is unresponsive, always check the physical disks.

```bash
# Advanced disk metrics, looking specifically at wait queues
# Requires the 'sysstat' package (sudo apt install sysstat)
iostat -xz 1
```

Look at the `%util` (Utilization) column. If it is 100%, your disk is pinned to the absolute limit. Look at `await` (Average Wait Time in milliseconds). If your disk `await` is 500ms, your users are experiencing massive latency.

### Network Statistics (`sar` / `nload`)
```bash
# Instantly see all active TCP resets, retransmits, and dropped packets
sar -n TCP,ETCP 1
```

---

## 4. The Linux Profiler (`perf`)

If your Go or C++ application is using 100% of a CPU core, you need to know exactly *which function* is causing the infinite loop without modifying or restarting the code.

The `perf` tool samples the CPU execution pointers 99 times a second and builds a Call Graph.

```bash
# 1. Record the CPU samples across the entire system for exactly 10 seconds
sudo perf record -F 99 -a -g -- sleep 10

# 2. Automatically analyze the binary memory dump into a massive interactive UI!
sudo perf report
```
You will literally see: `std::vector::push_back` taking 45% of the CPU dynamically. You have proven the exact line of code causing the outage directly from the Linux Kernel space without a debugger!

### Summary
Never trust application logs alone. Applications do not know they are running in a namespace, they do not know they are swapping to disk, and they do not know how many TCP packets are being dropped by the Hypervisor. You must measure the OS directly utilizing the *USE Method*.

---

## 5. Containerized Execution (MacBook / Linux)
Profiling CPU hardware call graphs inside a virtualized container requires absolute physical system privileges.

**`Dockerfile`**
```dockerfile
FROM ubuntu:latest
# Install Brendan Gregg's performance hunting tools
RUN apt-get update && apt-get install -y sysstat linux-tools-common linux-tools-generic stress
WORKDIR /root
CMD ["/bin/bash"]
```

**`docker-compose.yml`**
```yaml
services:
  perf-sandbox:
    build: .
    privileged: true # CRITICAL: Required to read the CPU architecture execution rings!
    pid: "host"      # CRITICAL: Share the Host's PID namespace so we can profile REAL processes!
    stdin_open: true
    tty: true
```

**To Run:**
```bash
docker compose run perf-sandbox

# Instantly hunt for CPU bottlenecks across the entire Host machine natively:
perf top
```

---
[<< Previous: Unix Systems Programming](./10_Unix_Systems_Programming.md) | [Home: Curriculum Map](./README.md) | [Next: Deep Packet Inspection >>](./12_Deep_Packet_Inspection.md)
