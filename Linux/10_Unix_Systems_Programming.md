# 09: UNIX Systems Programming & IPC

Welcome to the pinnacle of software architecture. Based on *Advanced Programming in the UNIX Environment* (W. Richard Stevens), this module covers exactly how programs talk to the Kernel using C (or any language calling `glibc`).

No web framework can save you when you hit extreme multi-processing bottlenecks. You must understand absolute Inter-Process Communication (IPC).

---

## 1. Creating Life (`fork` and `wait`) in C

As discussed in Module 05, the Kernel only understands `fork()` and `exec()`.

When we write high-performance custom daemon software, we invoke `fork()` explicitly in C.

**`daemon.c`**
```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid < 0) {
        // Fork Failed! (System completely out of memory or process limits hit)
        fprintf(stderr, "FATAL: Fork Failed\n");
        return 1;
    } 
    else if (pid == 0) {
        // We are the duplicated CHILD PROCESS!
        printf("[CHILD] My PID is %d. I will do CPU-heavy work now...\n", getpid());
        sleep(2);
        printf("[CHILD] Work complete. Terminating successfully.\n");
        exit(0); // Exit Code 0 (Success)
    } 
    else {
        // We are the original PARENT PROCESS!
        // The fork returned the exact PID of the newly created Child.
        printf("[PARENT] I spawned Child %d.\n", pid);

        // DO NOT CREATE ZOMBIES!
        // We strictly halt execution and wait for the child to die and collect its exit code.
        int status;
        waitpid(pid, &status, 0);

        if (WIFEXITED(status)) {
            printf("[PARENT] Child exited gracefully with Exit Code: %d\n", WEXITSTATUS(status));
        }
    }

    return 0;
}
```

```bash
# Compile and run natively!
gcc daemon.c -o daemon
./daemon
```

---

## 2. IPC: The UNIX Pipe (`|`)

You know how to pipe commands (`ls | grep`). But how does the Kernel do it?

A Pipe is simply an invisible in-memory buffer natively created by the Kernel linking two File Descriptors securely. It is unidirectional. One process purely writes. The other process purely reads.

If the Reader stops reading, the Writer will entirely freeze (`wait`) the moment the 64KB kernel buffer fills up!

**`pipe_example.c`**
```c
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main() {
    int fd[2];
    
    // Create the pipeline before forking!
    // fd[0] is the Read End.
    // fd[1] is the Write End.
    if (pipe(fd) == -1) return 1;

    pid_t pid = fork();

    if (pid == 0) { // CHILD
        close(fd[0]); // Complete isolation: Close the Read end (because we only write)
        
        char message[] = "Hello Parent! This is binary IPC data.";
        write(fd[1], message, strlen(message) + 1); // Shoot data down the pipe!
        
        close(fd[1]); // Close our write connection
    } 
    else { // PARENT
        close(fd[1]); // Complete isolation: Close the Write end (because we only read)
        
        char buffer[100];
        // The Parent completely freezes (blocks) here until the child writes data!
        read(fd[0], buffer, sizeof(buffer)); 
        
        printf("Received via Kernel Pipe: %s\n", buffer);
        
        close(fd[0]);
        wait(NULL); // Reap the child
    }

    return 0;
}
```

---

## 3. UNIX Domain Sockets (`.sock`)

If you want complex two-way HTTP-like communication between two microservices running safely on the exact same physical server, **DO NOT USE TCP/IP `localhost:8080`!**

Using IP sockets (`net/tcp`) severely burdens the Kernel. It has to wrap the data in Ethernet frames, route it through the network stack, calculate TCP checksums, handle congestion, and unwrap it sequentially. This is insanely slow for local data.

Instead, we use **UNIX Domain Sockets (`AF_UNIX`)**.
They act fundamentally like IP sockets but they use a *literal file path* natively (e.g., `/var/run/docker.sock`) instead of an IP address. The communication happens entirely inside pure Kernel RAM with absolutely zero network stack overhead!

### Why Docker breaks without `sudo`
When you type `docker ps`, your terminal perfectly creates an `AF_UNIX` network connection to the socket file `/var/run/docker.sock`. Because everything is a file, that socket has Octal permissions and ownership (`root`). If your user group lacks `read/write` permissions to that socket file, the connection completely fails!

### Summary
To master UNIX Systems Programming is to understand that all processes dynamically split themselves utilizing `fork()`, communicate safely across isolated process memory utilizing Pipes and UNIX Sockets, and strictly orchestrate lifecycle teardowns utilizing `wait()`. This concludes Phase 3. 

We now advance to Phase 4: Extreme Observability.

---

## 4. Containerized Execution (MacBook / Linux)
Compile and test your raw C code inside an isolated native GCC container to ensure binary compatibility across platforms.

**`Dockerfile`**
```dockerfile
FROM gcc:latest
WORKDIR /src
CMD ["/bin/bash"]
```

**`docker-compose.yml`**
```yaml
services:
  ipc-sandbox:
    build: .
    volumes:
      - .:/src  # Mount your local C files directly into the container
    stdin_open: true
    tty: true
```

**To Run:**
```bash
docker compose run ipc-sandbox

# Inside the container, compile and hunt for zombies!
gcc pipe_example.c -o pipe_example
./pipe_example
```


## 🧪 Hands-On Lab: System Calls via strace

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update && apt-get install -y strace
```

### Exercise 1: Trace a Simple Command
> **Goal:** Watch the kernel system calls an application makes.
```bash
strace echo "Hello Syscalls" > /dev/null
```
✅ **Expected:** A flood of output. You will see `execve`, `mmap`, `openat`, and finally the `write` system call outputting "Hello Syscalls".

### Exercise 2: Trace File Operations
> **Goal:** See exactly what `cat` does under the hood.
```bash
echo "data" > test.txt
strace -e openat,read,write,close cat test.txt
```
✅ **Expected:** By filtering with `-e`, you clearly see `cat` opening the file, reading it, writing it to stdout (fd 1), and closing it.

### Exercise 3: Count System Calls
> **Goal:** Profile an application's kernel interaction.
```bash
strace -c ls /
```
✅ **Expected:** A clean summary table showing which system calls `ls` spent the most time executing.

---
[<< Previous: Memory & Storage Internals](./09_Memory_and_Storage_Internals.md) | [Home: Curriculum Map](./README.md) | [Next: Systems Performance Metrics >>](./11_Systems_Performance_Metrics.md)