# 26: Netfilter Hooks in C

<p align="center">
  <img src="images/firewall_architecture.png" alt="Netfilter Hook Architecture" width="800"/>
</p>

In Chapter 18, you learned to use `iptables` — the **command-line interface** to Netfilter. Now, we go behind the curtain and write our own **kernel module** that hooks directly into the Netfilter framework. This is how real firewalls, intrusion detection systems, and packet manipulators are built.

---

## 1. The "Security Camera vs. Security Guard" Analogy

`iptables` is like configuring a security camera: you set rules, and the camera passively enforces them. A **Netfilter Hook** is like hiring a security guard who stands at the door, inspects every person (packet), and can:
- **Let them through** (`NF_ACCEPT`)
- **Send them away** (`NF_DROP`)
- **Modify their ID badge** (change packet headers)

---

## 2. The Five Hook Points

Every packet passes through specific checkpoints in the kernel. Your module can register a function at any of these:

| Hook | When it Fires |
| :--- | :--- |
| `NF_INET_PRE_ROUTING` | Packet just arrived, before routing decision. |
| `NF_INET_LOCAL_IN` | Packet is destined for this machine. |
| `NF_INET_FORWARD` | Packet is being routed to another machine. |
| `NF_INET_LOCAL_OUT` | Packet was generated locally, about to be sent. |
| `NF_INET_POST_ROUTING` | Packet is about to leave the network interface. |

---

## 3. Writing a Packet Dropper Module

This kernel module drops all ICMP (ping) packets:

```c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/ip.h>

static struct nf_hook_ops my_hook;

static unsigned int hook_fn(void *priv,
                            struct sk_buff *skb,
                            const struct nf_hook_state *state) {
    struct iphdr *ip_header = ip_hdr(skb);
    
    // ICMP protocol number is 1
    if (ip_header->protocol == IPPROTO_ICMP) {
        printk(KERN_INFO "BLOCKED: ICMP packet from %pI4\n",
               &ip_header->saddr);
        return NF_DROP;   // Destroy the packet
    }
    return NF_ACCEPT;     // Let everything else through
}

static int __init my_init(void) {
    my_hook.hook     = hook_fn;
    my_hook.hooknum  = NF_INET_PRE_ROUTING;
    my_hook.pf       = PF_INET;
    my_hook.priority = NF_IP_PRI_FIRST;
    nf_register_net_hook(&init_net, &my_hook);
    printk(KERN_INFO "Netfilter ICMP Blocker loaded.\n");
    return 0;
}

static void __exit my_exit(void) {
    nf_unregister_net_hook(&init_net, &my_hook);
    printk(KERN_INFO "Netfilter ICMP Blocker unloaded.\n");
}

module_init(my_init);
module_exit(my_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Drops all incoming ICMP packets");
```

### Build & Test:
```bash
# Makefile
obj-m += icmp_blocker.o
make -C /lib/modules/$(uname -r)/build M=$(pwd) modules

# Load the module
sudo insmod icmp_blocker.ko

# Test — pings to this machine will now FAIL
ping localhost  # No response!

# Check kernel log
dmesg | tail  # "BLOCKED: ICMP packet from 127.0.0.1"

# Unload
sudo rmmod icmp_blocker
```

> [!CAUTION]
> Kernel modules run with **full kernel privileges**. A bug in your hook function can crash the entire system (kernel panic). Always test in a virtual machine first!

---

## 4. Beyond Dropping: Packet Modification

You can also **modify** packets in transit. For example, changing the TTL:
```c
ip_header->ttl = 64;
ip_send_check(ip_header);  // Recalculate checksum!
```

This is how NAT routers, VPN tunnels, and traffic shapers work at the kernel level.

---

*In Chapter 27, we will create a character device driver — making a custom `/dev/mydevice` file that your applications can talk to.*

---
[<< Previous: FUSE Filesystem](./25_FUSE_Filesystem.md) | [Home: Curriculum Map](./README.md) | [Next: Character Device Drivers >>](./27_Device_Drivers.md)
