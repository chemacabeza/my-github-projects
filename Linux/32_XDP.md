# 32: XDP (eXpress Data Path)

<p align="center">
  <img src="images/xdp_express_datapath.png" alt="XDP Architecture" width="800"/>
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
---

## 🧪 Sandbox: Compile XDP Programs

The **Networking Sandbox** includes `clang`, `llvm`, and `libbpf-dev`:

**`docker-compose.yml`** — save this file in a new folder and run from there:

```yaml
services:
  # Networking sandbox with tc, XDP, and advanced packet tools
  net-node:
    image: ubuntu:22.04
    container_name: networking-sandbox
    cap_add:
      - NET_ADMIN           # Required for tc, XDP, iptables
      - SYS_ADMIN           # Required for BPF programs
    volumes:
      - ./lab-work:/work
    working_dir: /work
    command: >
      bash -c "apt-get update && apt-get install -y
      iproute2 iptables iputils-ping net-tools curl tcpdump
      clang llvm libbpf-dev
      gcc make
      && echo '--- NETWORKING SANDBOX READY ---'
      && sleep infinity"
    networks:
      lab-net:
        ipv4_address: 172.28.0.10

  # Traffic target for QoS and shaping experiments
  traffic-target:
    image: alpine:latest
    container_name: traffic-target
    command: >
      sh -c "apk add --no-cache python3 iperf3 curl &&
            iperf3 -s &
            python3 -m http.server 80"
    networks:
      lab-net:
        ipv4_address: 172.28.0.20

networks:
  lab-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.28.0.0/16
```

```bash
# Start the sandbox
docker compose up -d

# Enter the container
docker exec -it networking-sandbox bash
```

**Compile an XDP program (requires BPF support on host kernel):**
```bash
# Write the XDP C source to /work/xdp_drop.c (from this chapter)
clang -O2 -target bpf -c /work/xdp_drop.c -o /work/xdp_drop.o

# If BPF is available, attach it:
# ip link set dev eth0 xdpgeneric obj /work/xdp_drop.o sec xdp

# Test with iptables as a safe alternative:
iptables -A INPUT -p udp -j DROP
```

[<< Previous: Traffic Control & QoS](./31_Traffic_Control_QoS.md) | [Home: Curriculum Map](./README.md) | [Next: DPDK & AF_XDP >>](./33_DPDK_AF_XDP.md)
