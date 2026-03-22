# 12: eBPF Observability (The Capstone)

Based on *BPF Performance Tools*, this is the absolute pinnacle of Modern Linux runtime engineering. 

Historically, discovering exactly *why* a database query took 5 seconds was nearly impossible in production. Adding print statements requires restarting the database. Running `strace` (Module 07) stops the process completely for hundreds of milliseconds randomly, causing catastrophic customer outages.

Enter **eBPF (Extended Berkeley Packet Filter)**.

---

## 1. What is eBPF?

eBPF is a revolutionary technology that allows you to run sandboxed programs natively *inside* the Linux kernel without changing kernel source code or loading malicious kernel modules (`.ko`).

It is literally a mini Virtual Machine residing purely in Kernel space.

You write a tiny C program. eBPF identically verifies it is safely incapable of crashing the Kernel (`infinite loops` are explicitly forbidden by the verifier). It then **JIT (Just-In-Time) Compiles** the C directly into raw machine code and attaches it invisibly to almost any event happening on the machine.

---

## 2. Kprobes and Uprobes (The Hooks)

You attach your eBPF programs to specific Hook Points.

- **`kprobes` (Kernel Probes):** Triggers your code identically every single time a specific *Kernel* function executes. E.g., You can hook `vfs_read()` to perfectly log every single file read occurring on the server, across all Docker containers, simultaneously.
- **`uprobes` (User Probes):** Triggers your code identically every single time a specific *Application* function executes! E.g., You can attach to a specific `PostgreSQL` C function to capture exactly how long it takes to process queries natively.
- **Tracepoints:** Statically defined, perfectly stable Kernel hooks used heavily for tracing networking events.
- **XDP (eXpress Data Path):** A networking hook that executes the instant an Ethernet packet lands on the physically active Network Card, *before* the Linux Kernel even realizes a packet arrived! You can drop a 10Gbps DDoS attack using eBPF natively on the hardware before CPU utilization even registers it!

---

## 3. The `bcc` Toolkit (BPF Compiler Collection)

Writing raw eBPF assembly is brutal. We use the `bcc` tools, written by Brendan Gregg, which provide elegant Python wrappers around the low-level C code.

Ubuntu includes these pre-compiled:
```bash
sudo apt-get install bpfcc-tools linux-headers-$(uname -r)
```

### The Magic of Pre-Built Tools
You don't even have to write the code yourself. The toolkit provides dozens of pre-written eBPF probes.

```bash
# Analyze all slow I/O Disk Latency in real-time natively!
# This traces the exact block device queue inside the Kernel natively.
sudo biolatency-bpfcc

# Print exactly which process on the machine is constantly opening files!
# It intercepts the exact `do_sys_open()` kernel function.
sudo opensnoop-bpfcc

# View active database queries arriving globally to the massive MySQL daemon using Uprobes!
sudo dbslower-bpfcc mysql -p $(pgrep -n mysqld) 5 
```

---

## 4. Writing Your Own eBPF Program (The Capstone Architecture)

If we want to explicitly trace whenever ANY process on the machine calls `clone()` (used by `fork()` to spawn children/containers), we write a tiny Python script.

**`trace_clone.py`**
```python
#!/usr/bin/python3
from bcc import BPF

# 1. Define the eBPF Program in pure C
# This C code will be dynamically injected directly into the running Kernel.
bpf_program = """
    int trace_sys_clone(struct pt_regs *ctx) {
        
        // bpf_trace_printk is a highly optimized, extremely lightweight logger 
        // that prints directly into a special Kernel buffer completely bypassing stdout
        bpf_trace_printk("eBPF ALERT: A process just called clone()!\\n");
        return 0; // Success
    }
"""

# 2. Compile and interact with the Kernel
b = BPF(text=bpf_program)

# 3. Attach the Hook!
# We attach our tiny C function to the literal Linux syscall tracking 'clone'
b.attach_kprobe(event=b.get_syscall_fnname("clone"), fn_name="trace_sys_clone")

print("Successfully injected eBPF into the Linux Kernel. Tracing clone() syscalls... Ctrl+C to stop.")

# 4. Continuously read the specialized Kernel print buffer infinitely.
b.trace_print()
```

**To Execute:**
```bash
sudo ./trace_clone.py
```
Open a completely separate terminal. Simply type `ls`. You will instantly see your Python script scream `eBPF ALERT: A process just called clone()!` because the Shell natively forks a child instantly to execute `ls`.

### The True Capstone
You have successfully bypassed the Linux Kernel's isolated boundary. You wrote code dynamically evaluated, verified, JIT compiled, and securely injected into the very heart of the OS dynamically while millions of packets flew perfectly past it. 

You no longer manage the system; you *are* the system. This concludes the Linux Mastery Tracking Guide.
