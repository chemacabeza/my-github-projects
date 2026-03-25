# 31: Traffic Control (`tc`) & QoS

<p align="center">
  <img src="images/traffic_control_qos.png" alt="Traffic Control Architecture" width="800"/>
</p>

In Chapter 18, you learned to **accept or drop** packets with `iptables`. But what if you don't want to block traffic — you want to **slow it down**, **prioritize** it, or **shape** it? This is **Traffic Control (TC)**.

---

## 1. The "Highway Lanes" Analogy

Your network is a highway. Without TC, every car (packet) uses any lane at any speed. With TC, you create:
- A **fast lane** for VoIP and video calls.
- A **regular lane** for web browsing.
- A **slow lane** for file downloads and backups.

---

## 2. The Three TC Components

| Component | Role | Analogy |
| :--- | :--- | :--- |
| **Qdisc** (Queuing Discipline) | Decides *how* packets are queued and sent. | The traffic light algorithm. |
| **Class** | A category of traffic within a qdisc. | A specific lane on the highway. |
| **Filter** | Assigns packets to classes based on rules. | The sign that says "Trucks → Right Lane." |

---

## 3. Hands-on: Simulating a Slow Network

Want to test how your application behaves on a bad connection? TC can simulate latency, packet loss, and bandwidth limits.

```bash
# Add 200ms latency to all outgoing traffic on eth0
sudo tc qdisc add dev eth0 root netem delay 200ms

# Simulate 10% packet loss
sudo tc qdisc change dev eth0 root netem loss 10%

# Limit bandwidth to 1Mbit/s
sudo tc qdisc add dev eth0 root tbf rate 1mbit burst 32kbit latency 400ms

# Remove all rules
sudo tc qdisc del dev eth0 root
```

> [!TIP]
> This is **invaluable** for testing mobile applications or services deployed in high-latency regions. Netflix and Google use TC extensively in their testing pipelines.

---

## 4. Priority-Based QoS with HTB

**HTB** (Hierarchical Token Bucket) lets you guarantee minimum bandwidth to critical services while capping less important ones.

```bash
# Create an HTB root qdisc
sudo tc qdisc add dev eth0 root handle 1: htb default 30

# Parent class: total bandwidth = 100Mbit
sudo tc class add dev eth0 parent 1: classid 1:1 htb rate 100mbit

# High priority class (SSH): guaranteed 30Mbit
sudo tc class add dev eth0 parent 1:1 classid 1:10 htb rate 30mbit ceil 100mbit

# Low priority class (downloads): limited to 20Mbit
sudo tc class add dev eth0 parent 1:1 classid 1:30 htb rate 20mbit ceil 50mbit

# Filter: Send SSH traffic to the high-priority class
sudo tc filter add dev eth0 parent 1: protocol ip u32 \
    match ip dport 22 0xffff flowid 1:10
```

---

*In Chapter 32, we push packet processing to the absolute limit with XDP.*

---
---

## 🧪 Sandbox: Practice Traffic Shaping

The **Networking Sandbox** has `tc`, `iperf3`, and a traffic target ready:

```bash
cd sandbox/networking-lab
docker compose up -d
docker exec -it networking-sandbox bash
```

**Experiments:**
```bash
# Verify connectivity to the target
ping -c 2 172.28.0.20

# Add 200ms latency
tc qdisc add dev eth0 root netem delay 200ms
ping -c 3 172.28.0.20  # Notice the delay!

# Remove the rule
tc qdisc del dev eth0 root

# Bandwidth test with iperf3
iperf3 -c 172.28.0.20 -t 5
```

[<< Previous: Linux Capabilities](./30_Linux_Capabilities.md) | [Home: Curriculum Map](./README.md) | [Next: XDP (eXpress Data Path) >>](./32_XDP.md)
