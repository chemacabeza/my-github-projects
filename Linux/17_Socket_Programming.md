# 17: Socket Programming & TCP/IP

<p align="center">
  <img src="images/socket_programming.png" alt="Socket Programming and TCP/IP" width="800"/>
</p>

Inter-Process Communication (IPC) via Pipes or shared memory is powerful, but it's physically trapped within a single motherboard. **Sockets** are the portal to the outside world. They allow code running on an isolated processor thousands of miles away to exchange binary streams flawlessly.

Building on *The Linux Programming Interface* (Chapters 56-59), this chapter explains how the Linux kernel manages global network communication.

---

## 1. The Protocol Stack: Encapsulation

When you call `write()` on a standard network socket, your bytes descend through four primary layers of the Linux Kernel:

1. **Application Layer:** Your code (HTTP, SSH, SMTP).
2. **Transport Layer (TCP/UDP):** The Kernel adds a 20-byte TCP header ensuring guaranteed in-order delivery and retransmission logic.
3. **Network Layer (IP):** The Kernel adds a 20-byte IP header containing the destination IP address. This allows the packet to hop through unpredictable routers globally.
4. **Link Layer (Ethernet/WiFi):** The driver wraps the packet in Ethernet frames, targeting physical MAC addresses on the local switch.

---

## 2. Stream vs. Datagram Sockets

Linux provides two fundamental ways to communicate over the network:

### SOCK_STREAM (TCP)
- **Analogy:** A telephone call.
- **Behavior:** Connection-oriented. Reliable, in-order delivery. If a packet is lost, the kernel retransmits it automatically. 
- **The Stream Nature:** You might write "Hello" and then "World", but the receiver might get "HelloWor" in one read and "ld" in the next. There are NO message boundaries.

### SOCK_DGRAM (UDP)
- **Analogy:** Sending postcards.
- **Behavior:** Connectionless. Faster than TCP because there's no handshake or error checking. If a packet is lost, it's gone forever.
- **The Datagram Nature:** Each `sendto()` creates one distinct packet. Boundaries are perfectly preserved. If you send "Hello" and "World", the receiver gets two separate messages.

---

## 3. The Modern Legend: `getaddrinfo()`

Ancient networking code used `gethostbyname()`, which is **NOT thread-safe** and **IPv6-incompatible**. Never use it. Modern professional software exclusively uses `getaddrinfo()`.

It is a protocol-independent way to resolve "google.com" to "142.250.190.46". It handles both IPv4 and IPv6 automatically.

```c
struct addrinfo hints, *res;
memset(&hints, 0, sizeof(hints));
hints.ai_family = AF_UNSPEC;    // Support IPv4 OR IPv6
hints.ai_socktype = SOCK_STREAM; // TCP

if (getaddrinfo("example.com", "80", &hints, &res) != 0) {
    perror("Resolution Failed");
}

// Res now contains a linked list of potential IP addresses to connect to!
int sfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
connect(sfd, res->ai_addr, res->ai_addrlen);
```

---

## 4. UNIX Domain Sockets (`AF_UNIX`)

If you want two microservices on the *same server* to talk, **do not use `127.0.0.1`**. It is slow because the Kernel still fragments data into IP packets and calculates TCP checksums.

Instead, use **UNIX Domain Sockets**. They use a literal file path on the disk (e.g., `/var/run/docker.sock`) instead of an IP address. Data is copied directly between memory buffers with zero protocol overhead. They are the engine behind high-performance local microservices.

---

## 5. Byte Order: The Endianness Problem

Computers violently disagree on how to store numbers in RAM.
- **Intel (x86):** Little Endian (least significant byte first).
- **The Internet:** Big Endian (most significant byte first).

If you want to connect to Port 80, which is `0x0050` in hex, an Intel CPU sees `50 00`. The internet expects `00 50`. **Failure to convert will result in connecting to Port 20480 by mistake.**

Always use:
- `htons()` (Host To Network Short)
- `ntohs()` (Network To Host Short)

---

## 6. Advanced Socket Options

You can tune the kernel's network behavior using `setsockopt()`.

### `SO_REUSEADDR`
Normally, when a server crashes, the OS prevents you from binding to the same port for ~60 seconds (the `TIME_WAIT` state). This is maddening during development.
```c
int opt = 1;
setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
```
This flag tells the kernel: "Allow me to bind to this port immediately, even if the previous socket is still closing."

---

## 7. The 3-Way Handshake & Backlog

When a Client calls `connect()`, the hardware dance begins:
1. Client sends **SYN**.
2. Server responds **SYN-ACK**.
3. Client responds **ACK**.

The `listen(sfd, backlog)` system call defines how many incomplete handshakes the kernel will buffer. If 1,000 clients connect at once, and your `backlog` is only 5, the kernel will physically drop the 6th client's connection request immediately.

---

## 8. Sandbox Execution

```bash
# Terminal A: Start the Server natively
gcc server.c -o server
./server

# Terminal B: Probe the protocol stack
telnet 127.0.0.1 5000
```

*This concludes the Phase 5 expansion based on the Linux Programming Interface. You have mastered the absolute technical plumbing of the Linux OS.*

---
[<< Previous: POSIX Threads](./16_POSIX_Threads.md) | [Home: Curriculum Map](./README.md) | [Next: Linux Firewalls & iptables >>](./18_Linux_Firewalls_iptables.md)
