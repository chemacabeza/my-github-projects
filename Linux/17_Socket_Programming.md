<div align="center">
  <img src="./images/linux_ch17_sockets.png" alt="Socket Programming Cover" width="800"/>
</div>

# 17: Socket Programming & TCP/IP

> 🧠 **The Feynman Hook:** Inter-Process Communication (IPC, Module 10) like Pipes is incredibly fast, but physics traps it inside a single motherboard. **Sockets** are the global portal. Think of a Socket as an electrical outlet on your wall. Your code (a lamp) plugs into the outlet. The wall (the Linux Kernel) handles the insanely complex global wiring of submarine cables, routers, and cross-continental switching required to deliver your electricity (data) perfectly intact to an outlet on the other side of the planet.

**🎯 The Big Goal:** Bypass HTTP entirely and manipulate the Linux universal network API natively in C. Master the distinction between TCP (Stream) and UDP (Datagram), the mathematical necessity of Endianness handling, and compiling custom daemons.

---

## 1. The Protocol Stack: Encapsulation

> **Feynman Insight:** When you `write("Hello")` to a network socket, the text does not travel natively. The Linux Kernel brutally encapsulates it in layers, like a Russian Nesting Doll, before it hits the ethernet cable.

1. **Application Layer:** Your string payload `"Hello"`.
2. **Transport Layer (TCP):** The Kernel wraps `"Hello"` in a 20-byte TCP header. This header contains the Port Numbers (`80`) and sequence numbers guaranteeing mathematically flawless perfect-order delivery.
3. **Network Layer (IP):** The Kernel wraps the TCP block in a 20-byte IP header. This holds the global destination IP address (`142.250.0.1`), allowing unpredictable global routers to pass the packet along.
4. **Link Layer (Ethernet/MAC):** The physical network driver wraps the IP block in an Ethernet frame targeting the literal hardware hexadecimal MAC address of the very next physical router in your bedroom.

---

## 2. Stream vs. Datagram Sockets

Linux enforces two mathematically irreconcilable paradigms for sockets.

### SOCK_STREAM (TCP)
- **The Analogy:** A continuous water pipe.
- **The Behavior:** Reliable, connection-oriented, guaranteed in-order delivery. If a packet is lost in the Atlantic Ocean, the OS Kernel silently retransmits it. 
- **The Catch (No Boundaries):** If you execute `write("A")` then `write("B")`, the data enters the water pipe. The receiving server might execute `read()` and receive exactly `"AB"` simultaneously. TCP does NOT magically separate consecutive messages!

### SOCK_DGRAM (UDP)
- **The Analogy:** Sending distinct, separate physical postcards.
- **The Behavior:** Connectionless. Blisteringly fast. If a postcard is lost by a router, it is **permanently destroyed**. No retransmits.
- **The Benefit (Absolute Boundaries):** Every single `sendto()` generates exactly one distinct kernel packet natively. If you send "A" and then send "B", the receiver will strictly read two completely distinct independent messages universally. 

---

## 3. The Endianness Problem (Byte Order)

Computers violently disagree globally on how to store large numbers sequentially in physical RAM.

- **Intel / AMD (x86):** Little Endian (Stores the *least* significant mathematical byte first).
- **The Global Internet:** Big Endian (Stores the *most* significant byte first natively).

If you command your Intel processor to connect to HTTP Port `80` (which is `0x0050` in hex), your CPU physically stores it in RAM as `50 00`. The internet reads this backward as `00 50`. **Failure to convert means your application accidentally tries to connect to Port 20,480!**

Whenever passing IP addresses or Ports to the Linux Kernel, you strictly legally MUST convert them:
- `htons()` (Host To Network Short - for 16-bit Ports)
- `htonl()` (Host To Network Long - for 32-bit IPv4s)

---

## 4. Modern Resolution: `getaddrinfo()`

Ancient networking explicitly utilized `gethostbyname()`. **It is entirely deprecated, non-thread-safe, and instantly breaks on IPv6 networks.** Professional architectures explicitly utilize `getaddrinfo()`.

It abstracts DNS resolution effortlessly, returning exactly the correct Protocol family (IPv4 vs IPv6) dynamically!

```c
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>

int main() {
    struct addrinfo hints, *res;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;     // Dynamically handle IPv4 OR IPv6 natively!
    hints.ai_socktype = SOCK_STREAM; // Request a TCP connection
    
    // Natively resolves Google's DNS to an exact memory structure!
    if (getaddrinfo("google.com", "80", &hints, &res) != 0) {
        perror("DNS Resolution structurally failed!");
        return 1;
    }
    
    // Create the Socket utilizing the exact OS parameters returned by DNS
    int sfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    
    // Physically connect!
    if (connect(sfd, res->ai_addr, res->ai_addrlen) == 0) {
        printf("Successfully connected to Google Port 80!\n");
    }
    
    freeaddrinfo(res);
    return 0;
}
```

---

## 5. Overriding the OS (`SO_REUSEADDR`)

When a developer kills an active C networking server (`Ctrl+C`), they often try to restart it and get an aggressive `Bind: Address Already in Use` error permanently for 60 seconds.

**Why?** The Kernel fiercely protects closing connections. It places the port in a `TIME_WAIT` state natively for 60 seconds to ensure no delayed, lost internet packets randomly arrive later and corrupt the next application running on that port.

During development, you override this explicitly natively:
```c
int opt = 1;
// Commands the OS: "I know what I'm doing. Instantly force-bind this port regardless of TIME_WAIT status."
setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe the relationship between TCP Backlog and SYN flood attacks.</summary>

When you call `listen(fd, backlog)` natively, the `backlog` integer defines the strict maximum capacity of the Kernel's Queue for half-open (incomplete) TCP 3-way handshakes. In a **SYN Flood Attack**, an attacker aggressively blasts thousands of `SYN` packets to your server but intentionally never returns the final `ACK`. Your Kernel allocates memory in the backlog queue waiting for them. If `backlog` is 50, the 51st legitimate customer's `SYN` request is mathematically physically dropped by the Kernel.
</details>

<details>
<summary>💡 View Answer: Why are UNIX Domain Sockets significantly faster for local microservices than TCP "localhost" (127.0.0.1)?</summary>

TCP inherently enforces a massive protocol stack. Even if routing to `127.0.0.1`, the Kernel still physically fragments the data into IP packets, calculates mathematically intensive checksums, executes TCP congestion window algorithms, and unwraps the payload sequentially. **UNIX Domain Sockets (`AF_UNIX`)** entirely bypass the network stack physically. Using a literal file path on disk (e.g., `/var/run/docker.sock`), the OS perfectly perfectly copies identical data directly between the two process memory buffers natively at maximum RAM speed with practically zero overhead natively.
</details>

---

## 🐳 Hands-On Lab: Practice Socket Programming

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update -qq && apt-get install -y -qq gcc netcat-openbsd ss iproute2
```

### Exercise 1: Build a Native TCP Echo Server
> **Goal:** Run C code to natively bind to the Linux networking stack.
```bash
cat > server.c << 'EOF'
#include <stdio.h>
#include <netinet/in.h>
#include <string.h>
#include <unistd.h>
int main() {
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    // Explicitly configure Port 5000 and force Big Endian conversion!
    struct sockaddr_in addr = {AF_INET, htons(5000), {INADDR_ANY}};
    
    bind(fd, (struct sockaddr*)&addr, sizeof(addr));
    listen(fd, 5); // Allow 5 connections queueing natively
    
    printf("Server completely actively listening universally on Port :5000\n");
    int client = accept(fd, NULL, NULL);
    
    char buf[256] = {0}; 
    read(client, buf, sizeof(buf));
    printf("Natively Received exact sequence: %s\n", buf);
    
    close(client); close(fd);
    return 0;
}
EOF
gcc server.c -o server

# Run the server dynamically
./server &
sleep 1

# Exploit arbitrary socket connections!
echo "Raw Payload Execution" | nc 127.0.0.1 5000
```
✅ **Expected:** The server executes, binds to port 5000, `nc` connects successfully natively fulfilling the 3-way handshake, transmits the string perfectly, and cleanly destructs.

---
[<< Previous: POSIX Threads](./16_POSIX_Threads.md) | [Home: Curriculum Map](./README.md) | [Next: Linux Firewalls & iptables >>](./18_Linux_Firewalls_iptables.md)
