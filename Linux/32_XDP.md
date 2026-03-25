# 32: XDP (eXpress Data Path)

<p align="center">
  <img src="images/firewall_architecture.png" alt="XDP Architecture" width="800"/>
</p>

In Chapter 13, you learned about eBPF — attaching tiny programs to kernel events. **XDP** takes eBPF to the extreme: it processes packets at the **NIC driver level**, *before* the kernel even builds an `sk_buff` structure. This means decisions happen in **nanoseconds**, not microseconds.

---

## 1. The "Bouncer at the Door" Analogy

Normal packet processing is like a guest entering a hotel, checking in at reception, going through security, and finding their room. XDP is a **bouncer at the front door** who decides in a split second: "You can come in" (`XDP_PASS`), "Go away" (`XDP_DROP`), or "Go to the hotel next door" (`XDP_TX`/`XDP_REDIRECT`).

---

## 2. XDP vs iptables Performance

| Feature | iptables | XDP |
| :--- | :--- | :--- |
| **Processing Point** | After full sk_buff creation. | Before sk_buff — raw NIC driver. |
| **Speed** | ~1-5 million packets/sec. | ~20-40 million packets/sec. |
| **Language** | Rule syntax. | C compiled to eBPF bytecode. |
| **Use Case** | General firewall. | DDoS mitigation, load balancing. |

---

## 3. Your First XDP Program

This program drops all UDP packets:

```c
// xdp_drop_udp.c
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int drop_udp(struct xdp_md *ctx) {
    void *data     = (void *)(long)ctx->data;
    void *data_end = (void *)(long)ctx->data_end;
    
    struct ethhdr *eth = data;
    if ((void *)(eth + 1) > data_end) return XDP_PASS;
    if (eth->h_proto != __constant_htons(ETH_P_IP)) return XDP_PASS;
    
    struct iphdr *ip = (void *)(eth + 1);
    if ((void *)(ip + 1) > data_end) return XDP_PASS;
    
    if (ip->protocol == IPPROTO_UDP) {
        return XDP_DROP;  // Silently destroy all UDP packets
    }
    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
```

### Compile and Attach:
```bash
# Compile to BPF bytecode
clang -O2 -target bpf -c xdp_drop_udp.c -o xdp_drop_udp.o

# Attach to network interface
sudo ip link set dev eth0 xdpgeneric obj xdp_drop_udp.o sec xdp

# Verify it's running
ip link show eth0
# "prog/xdp id 42"

# Detach
sudo ip link set dev eth0 xdpgeneric off
```

---

## 4. Real-World XDP Applications

- **Cloudflare:** Mitigates DDoS attacks at 10+ Tbps using XDP.
- **Facebook/Meta:** Uses XDP for L4 load balancing (`katran`).
- **Cilium:** Kubernetes networking powered by XDP & eBPF.

---

*In Chapter 33, we explore the ultimate performance frontier: bypassing the kernel entirely.*

---
[<< Previous: Traffic Control & QoS](./31_Traffic_Control_QoS.md) | [Home: Curriculum Map](./README.md) | [Next: DPDK & AF_XDP >>](./33_DPDK_AF_XDP.md)
