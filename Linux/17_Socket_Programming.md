# 17: Socket Programming & TCP/IP

<p align="center">
  <img src="images/socket_programming.png" alt="Socket Programming and TCP/IP" width="800"/>
</p>

Inter-Process Communication (IPC) utilizing Pipes (`|`) restricts data exclusively between a Parent and a Child.
Networking entirely escapes the physical motherboard boundary. Sockets allow isolated processors thousands of miles apart to exchange binary arrays flawlessly reliably. 

This chapter dives directly into the core fundamental API powering the Internet. Derived from *The Linux Programming Interface*.

---

## 1. The Internet Protocol (IP) Stack

When you invoke `write()` against a Network Socket, the payload natively descends through 4 strict hierarchical Operating System Layers inside the Linux Kernel before ever touching the physical Copper/Fiber:

1. **Application Layer (HTTP/SSH):** Raw user payload bytes natively processed by your Application Code.
2. **Transport Layer (TCP / UDP):** The Kernel strictly wraps your raw bytes in a TCP Header ensuring connection-oriented, guaranteed in-order delivery globally using extreme Retransmission Timer algorithms.
3. **Network Layer (IP):** The Kernel wraps the TCP block identically inside an IP header routing universally across interconnected Subnets towards the destination globally using routers (IPv4/IPv6).
4. **Link Layer (Ethernet/WiFi):** The underlying Device Driver fragments the IP packet exclusively framing the datagram targeting physical MAC addresses over the local Switch fabric.

---

## 2. Unix Domain Sockets vs Internet Sockets

The Socket API natively supports dozens of "Domains". Two are absolutely critical:

1. `AF_INET`: Standard IPv4 Internet domain routing exclusively outside the server.
2. `AF_UNIX`: Crucial UNIX domain sockets binding completely internally restricted fundamentally traversing purely across physical RAM leveraging exact File Paths uniquely (`/var/run/docker.sock`). Orders of magnitude faster than `localhost` TCP connections. 

---

## 3. The Grand Socket API Architecture 

Servers and Clients construct communication circuits utilizing absolutely completely distinct system calls natively:

### The Server Lifecycle
Creates an endpoint definitively waiting infinitely forever for Client connections universally:
1. `socket()`: Natively requests the Kernel dynamically allocate a standard File Descriptor (`fd`) exclusively designated for network processing identically.
2. `bind()`: Anchors the socket inherently to a definitive local IP address and Port globally resolving precisely (e.g., `0.0.0.0:8080`).
3. `listen()`: Configures the socket securely accepting passive connections completely buffering the connection queue length statically natively (the `backlog`).
4. `accept()`: **BLOCKS** infinitely natively fundamentally until a physical Client completely executes the TCP 3-Way Handshake successfully. It natively spawns a brand new, discrete secondary `fd` purely for that single Client's dynamic Data Transfer universally.

### The Client Lifecycle
Actively initiates extreme outbound connection requests natively:
1. `socket()`: Secures an outbound network pointer dynamically.
2. `connect()`: Fires the critical initial `SYN` packet synchronously initiating the TCP 3-Way Handshake natively blocking until the Server responds `SYN-ACK`.

---

## 4. The Complete `echo` Server (TCP)

This completely pure native C server binds directly to Port 5000 unconditionally echoing every single received byte exclusively back permanently exactly mirroring `netcat`.

**`server.c`**
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

int main() {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);
    char buffer[1024];

    // 1. Create a raw IPv4 TCP Socket FD
    server_fd = socket(AF_INET, SOCK_STREAM, 0);

    // 2. Bind exclusively to Port 5000 on ANY Interface
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY; 
    server_addr.sin_port = htons(5000); // Big Endian conversion!

    bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr));

    // 3. Mark FD natively passively Listening exclusively!
    listen(server_fd, 5); // Allow max 5 queued clients dynamically!
    printf("Natively securely Listening dynamically on Port 5000...\n");

    // 4. Infinite Processing Loop!
    while (1) {
        // Block infinitely permanently awaiting 3-way Handshakes natively
        client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &client_len);
        printf("[+] Client successfully Connected unconditionally.\n");

        while (1) {
            memset(buffer, 0, sizeof(buffer));
            // Read incoming frames natively
            int bytes_read = read(client_fd, buffer, sizeof(buffer));
            if (bytes_read <= 0) break; // Client disconnected natively

            // Exactly echo natively directly unconditionally!
            write(client_fd, buffer, bytes_read);
        }

        printf("[-] Client safely terminated identically.\n");
        close(client_fd);
    }
    close(server_fd);
    return 0;
}
```

### Endianness: The `htons()` necessity
CPUs violently disagree inherently on memory arrangement completely natively natively architecture. Intel (x86) stores the least significant byte first (Little Endian). The internet overwhelmingly expects the most significant byte first (Big Endian). 

You **must** wrap all numerical Port declarations explicitly using `htons()` (Host To Network Short) converting byte-order completely resolving routing collisions flawlessly flawlessly.

---

## 5. Execution Sandboxing (MacBook / Linux)

```bash
# Terminal 1: Compile explicitly and Execute natively!
gcc server.c -o server
./server
```

```bash
# Terminal 2: Interact precisely completely utilizing explicitly absolute TCP circuits!
nc 127.0.0.1 5000
> Hello World!
Hello World!
```
