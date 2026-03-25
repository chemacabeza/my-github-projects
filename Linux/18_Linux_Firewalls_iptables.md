# 18: Linux Netfilter & iptables Architecture

<p align="center">
  <img src="images/firewall_architecture.png" alt="Linux Firewall Architecture" width="800"/>
</p>

Most people think of a firewall as a "wall." This is a mistake. In Linux, a firewall is a **series of high-speed checkpoints** along a highway. 

In this chapter, you will learn to manage **Netfilter**—the kernel's internal traffic control system—using the `iptables` interface.

---

## 1. The "Packet Passenger" Analogy

To understand `iptables`, imagine a packet is a passenger on a bus entering a city (your server).

1.  **PREROUTING (The City Gates):** Before the bus even decides which station to go to, you can change its destination address. "You thought you were going to the Museum? No, you're going to the Library."
2.  **INPUT (The Local Station):** If the bus is staying in the city, it goes through a local security check. If the passenger is on the blacklist, they are kicked off the bus.
3.  **FORWARD (The Transit Terminal):** If the bus is just passing through to another city, it goes through a different security line.
4.  **OUTPUT (The Departure Lounge):** If a local resident starts a new journey, they are checked before they leave.
5.  **POSTROUTING (The Highway Ramp):** Just as the bus hits the open road, you can change its name tag (Source IP) so the outside world thinks it came from a different place.

---

## 2. Tables: The Specialized Security Teams

Inside each checkpoint (Chain), there are different teams (Tables) with specific jobs. They always work in this order:

| Team | Mission | Real-world Use |
| :--- | :--- | :--- |
| **RAW** | "Don't look at their ID." | Bypassing tracking for high-performance traffic. |
| **MANGLE** | "Change their clothes." | Modifying packet headers (TTL, TOS) or marking them for routing. |
| **NAT** | "Change their name/address." | Network Address Translation (sharing one internet connection). |
| **FILTER** | "Allow or Deny entry." | The core of your security. Dropping unauthorized traffic. |

---

## 3. The Golden Rule of Rule Order

`iptables` reads rules like a script: **Top to Bottom**. Once a packet matches a rule that says `DROP` or `ACCEPT`, it stops checking the rest.

> [!IMPORTANT]
> Always put your most common traffic and your "Establishment" rules at the **top**. If you put a "Drop All" rule at the top, you will lock yourself out of your server instantly.

---

## 4. Mastering the State Machine (`conntrack`)

A "Dumb" firewall checks every packet individually. A "Smart" (Stateful) firewall remembers conversations.

- **NEW:** "Hello, I'd like to start a chat."
- **ESTABLISHED:** "We are already talking, let me through."
- **RELATED:** "I'm the friend of the guy you just let in" (e.g., a file transfer part of an FTP session).
- **INVALID:** "I don't know who you are or why you're here." **(DROP THESE!)**

**The Ultimate Rule:**
```bash
# Allow anyone you've already started talking to safely:
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

---

## 5. Guided Exercise: Build a High-Security Fortress

Let's build a firewall one piece at a time. Run these inside your **Sandbox Container**.

### Step 1: Default to "Death"
Silence is the ultimate security. We start by telling the kernel to ignore everything unless we say otherwise.
```bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
```

### Step 2: The "Safe Passage" (Loopback)
Your system needs to talk to itself to function.
```bash
iptables -A INPUT -i lo -j ACCEPT
```

### Step 3: Enable the "Connection Memory"
Allow all return traffic for connections you started.
```bash
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

### Step 4: Open the front door (SSH)
Only allow the outside world to reach you on Port 22.
```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

---

## 6. Persistence: Don't Lose Your Work
On a standard Linux system, your `iptables` rules are **erased on reboot**.

```bash
# Export your masterpiece
iptables-save > /etc/iptables.rules

# Import it back
iptables-restore < /etc/iptables.rules
```

---

## 7. EXPERT LAB: The IPTables Sandbox

It is dangerous to experiment with firewalls on your main machine. One wrong command could lock you out of the internet. 

We have provided a **Docker Sandbox** in the `sandbox/iptables-lab/` directory. This creates a two-node network where you can play "God" with the packets.

### How to use it:
1.  **Navigate to the lab:** `cd sandbox/iptables-lab`
2.  **Start the environment:** `docker compose up -d`
3.  **Enter the "Firewall" node:** `docker exec -it iptables-sandbox sh`

Inside this node, you have a "Target" server at the IP `target-server`. You can practice blocking pings, web traffic, and setting up stateful rules without fear.

*See the [Sandbox README](./sandbox/iptables-lab/README.md) for a list of experiments to try.*

---

*You have graduated from "shouting at the terminal" to "engineering the kernel's network stack." In Phase 7, we will explore containerization internals.*
