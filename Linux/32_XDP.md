<div align="center">
  <img src="./images/linux_ch32_xdp.png" alt="XDP Architecture Cover" width="800"/>
</div>

# 32: XDP (eXpress Data Path)

> 🧠 **The Feynman Hook:** When a packet hits a standard Linux server, it's like a guest entering a fancy hotel. They have to walk through the doors, check in at the front desk, get their bags tagged (the Kernel building an `sk_buff` data structure), and be escorted to their room (the Application). This takes microseconds. **XDP** puts a bouncer physically *outside* the front door. The bouncer reads their ID the millisecond they step onto the property. If they are on a ban list (a DDoS attack), the bouncer drops them instantly. The front desk (the Kernel) never even knows they were there. 

**🎯 The Big Goal:** Learn how Cloudflare and Facebook process tens of millions of packets per second by writing eBPF C programs that execute directly inside the physical Network Interface Card (NIC) driver.

---

## 1. The Performance Revolution

A standard `iptables` firewall drops a packet *after* the Kernel has done the heavy lifting of allocating memory and building a Socket Buffer (`sk_buff`). `iptables` maxes out around 2–5 million packets per second.

XDP executes your custom eBPF bytecode locally in the NIC driver ring buffer *before* memory allocation. 
XDP can drop packets at the absolute limit of the physical wire speed: **20-40 million packets per second**.

### The XDP Action Verbs
Your tiny C program runs on every single packet and must return one of three simple integers:
1. `XDP_PASS`: "You're good. Go inside to the normal Kernel Front Desk."
2. `XDP_DROP`: "You are attacking us. Die instantly."
3. `XDP_TX`: "Bounce right back out the door you came in from." (Used for ultra-fast load balancing).

---

## 2. A Basic XDP Drop Program in C

This program inspects the raw ethernet framing. If the protocol is UDP, it drops the packet instantly.

```c
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int drop_udp(struct xdp_md *ctx) {
    // 1. Get the raw memory pointers to the start and end of the packet
    void *data     = (void *)(long)ctx->data;
    void *data_end = (void *)(long)ctx->data_end;
    
    // 2. Cast the raw bytes as an Ethernet Header
    struct ethhdr *eth = data;
    if ((void *)(eth + 1) > data_end) return XDP_PASS;
    
    // 3. Cast the next bytes as an IP Header
    struct iphdr *ip = (void *)(eth + 1);
    if ((void *)(ip + 1) > data_end) return XDP_PASS;
    
    // 4. Inspect the protocol. If it's UDP, Drop!
    if (ip->protocol == IPPROTO_UDP) {
        return XDP_DROP; 
    }
    
    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
```

### Loading the Program
You use the standard `ip` command to attach the BPF object code to your network card:
```bash
# Attach
sudo ip link set dev eth0 xdpgeneric obj xdp_drop_udp.o sec xdp

# Detach
sudo ip link set dev eth0 xdpgeneric off
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: If XDP runs in the NIC driver, how is it prevented from crashing the host by memory corruption?</summary>
XDP code is fundamentally written in eBPF. Before the Linux Kernel allows the XDP code to physically attach to the network card, it pushes the compiled bytecode through the **eBPF Verifier**. This mathematical verifier ensures there are no infinite loops, no unauthorized memory access, and that the program will safely terminate in bounded time. Only mathematically proven code is loaded.
</details>

<details>
<summary>💡 View Answer: Describe the architectural difference between XDP 'Native' and XDP 'Generic' modes.</summary>
`Generic Mode` (xdpgeneric) runs the XDP program inside the Kernel's standard networking stack just after `sk_buff` allocation. It is slower but works on every single network card for testing. `Native Mode` (xdp) requires specific support built into the physical hardware NIC driver itself. In Native mode, the XDP program runs inside the driver's early receive path, achieving maximum possible bare-metal performance.
</details>

---
[<< Previous: Traffic Control](./31_Traffic_Control_QoS.md) | [Home: Curriculum Map](./README.md) | [Next: DPDK & AF_XDP >>](./33_DPDK_AF_XDP.md)
