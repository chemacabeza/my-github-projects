<div align="center">
  <img src="./images/linux_ch31_traffic_control.png" alt="Traffic Control Architecture Cover" width="800"/>
</div>

# 31: Traffic Control (`tc`) & QoS

> 🧠 **The Feynman Hook:** In Chapter 18 (`iptables`) and Chapter 26 (Netfilter), we learned how to act like a Security Guard, violently blocking or accepting packets. But what if you don't want to block traffic? What if you just want to *slow it down*? Imagine your network is a massive highway. Without **Traffic Control (TC)**, every car (packet) uses any lane at top speed. Your 50GB file backup might saturate the highway, causing your VoIP phone call to completely drop out. TC is the traffic light algorithm. It creates a dedicated "Fast Lane" specifically for VoIP, a "Normal Lane" for web browsing, and a "Slow Lane" for backups.

**🎯 The Big Goal:** Master the Linux Traffic Control subsystem. Emulate degraded mobile networks for application testing, and engineer Quality of Service (QoS) constraints using Hierarchical Token Buckets.

---

## 1. The Anatomy of Traffic Control

> **Feynman Insight:** The Linux Kernel structures traffic control using three conceptual puzzle pieces. Understanding their relationship is the key to mastering `tc`.

| Component | Scientific Role | The Highway Analogy |
| :--- | :--- | :--- |
| **Qdisc** (Queuing Discipline) | The root mathematical algorithm that dictates exactly how packets are stored in memory and released to the network card. | The Traffic Light System and the Toll Booth structure. |
| **Class** | A specific defined compartment or bandwidth pool inside an active Qdisc. | A specific designated lane on the highway (e.g., "Carpools Only"). |
| **Filter** | The condition that explicitly matches a packet and pushes it into a specific Class. | The Highway Sign reading: "All Trucks must enter the Right Lane." |

---

## 2. Emulating a Bad Connection

Want to prove your React frontend doesn't crash when a user connects from a 3G mobile tower in an area with poor signal? You simply ask the Linux Kernel to sabotage your own network card intentionally.

```bash
# 1. Add 200ms of sheer latency to all outgoing traffic on 'eth0'
sudo tc qdisc add dev eth0 root netem delay 200ms

# 2. Simulate 10% packet loss (simulating a mobile connection dropping out)
sudo tc qdisc change dev eth0 root netem loss 10%

# 3. Limit bandwidth to a slow 1Mbit/s connection
sudo tc qdisc change dev eth0 root tbf rate 1mbit burst 32kbit latency 400ms

# 4. Remove all rules and restore the connection to perfection
sudo tc qdisc del dev eth0 root
```

> [!TIP]
> This is exactly how Netflix's Chaos Monkey and Google's internal testing platforms ensure global reliability. They systematically inject latency into production microservices using `netem`.

---

## 3. High-Performance QoS with HTB

**HTB (Hierarchical Token Bucket)** allows you to guarantee a minimum bandwidth limit to critical services while ruthlessly capping lower-priority downloads.

```bash
# 1. Create a root Qdisc that uses the HTB algorithm
sudo tc qdisc add dev eth0 root handle 1: htb default 30

# 2. Add a Parent Class that defines the total available pipe (100Mbit)
sudo tc class add dev eth0 parent 1: classid 1:1 htb rate 100mbit

# 3. Create a High Priority Line (e.g., SSH/VoIP) guaranteed 30Mbit
sudo tc class add dev eth0 parent 1:1 classid 1:10 htb rate 30mbit ceil 100mbit

# 4. Create a Low Priority Line (e.g., Torrents/Backups) locked at 20Mbit max
sudo tc class add dev eth0 parent 1:1 classid 1:30 htb rate 20mbit ceil 50mbit

# 5. Tell the Kernel Filter: Send Port 22 (SSH) directly into the High Priority Lane
sudo tc filter add dev eth0 parent 1: protocol ip u32 match ip dport 22 0xffff flowid 1:10
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe why 'tc' predominantly operates on egress (outgoing) traffic rather than ingress (incoming) traffic.</summary>
You cannot mathematically control how fast the Internet sends packets to you. By the time an incoming packet hits your network card, it has already saturated your incoming bandwidth pipe! You can drop it, but the bandwidth is already spent. However, you have absolute mathematical control over how fast your Kernel queues and transmits packets outward (egress). Therefore, Traffic Control is phenomenally effective at shaping outgoing responses and requests.
</details>

<details>
<summary>💡 View Answer: In the netem module, what does adding 'jitter' conceptually accomplish?</summary>
Adding a static 200ms delay to a connection is unrealistic. In the real world, latency fluctuates constantly as network congestion changes dynamically jump from router to router. Adding 'jitter' (e.g., `delay 200ms 50ms`) tells the Kernel to delay packets by 200ms, plus or minus a random variable up to 50ms. This generates highly erratic, chaotic packet arrival times, which perfectly simulates real-world WiFi or mobile cellular network conditions.
</details>

---
[<< Previous: Linux Capabilities](./30_Linux_Capabilities.md) | [Home: Curriculum Map](./README.md) | [Next: XDP (eXpress Data Path) >>](./32_XDP.md)
