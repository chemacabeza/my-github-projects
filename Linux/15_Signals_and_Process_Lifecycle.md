# 15: Signals & Process Lifecycle

<p align="center">
  <img src="images/signals_process_lifecycle.png" alt="Signals and Process Lifecycle" width="800"/>
</p>

Building heavily upon *The Linux Programming Interface*, this module confronts the most hostile and unpredictable territory in UNIX: Asynchronous Signals and the violent mechanics of Process Creation.

---

## 1. The Anatomy of Process Creation (`fork`)

When a process wants to spawn a child in UNIX, it does not build it from scratch. It aggressively clones itself using `fork()`.

### Copy-On-Write (COW)
Historically, `fork()` duplicated the entire physical RAM of the Parent into the Child. This was paralyzingly slow. Modern Linux exclusively utilizes **Copy-On-Write (COW)**.

When `fork()` executes, the Kernel simply points the Child to the exact same Physical Memory Pages as the Parent and marks those pages as Read-Only.
If either the Parent or the Child attempts to modify a variable (e.g., an array), the MMU triggers a Hardware Exception. The Kernel catches it instantly, physically copies only that specific 4KB page of RAM exclusively for the writer, and resumes execution seamlessly.

### `vfork()` Architecture
During severe memory constraints where `fork()` fails, ancient systems created `vfork()`. 
`vfork()` completely suspends the Parent Process. The Child executes directly utilizing the Parent's exact Memory space (no COW protection!). If the Child modifies a variable, it literally overwrites the Parent's variable! The child *must* immediately call `exec()` to replace itself, unlocking the Parent.

---

## 2. Program Execution (`execve`)

`fork()` simply clones the current binary. To run brand new binaries (like `ls` or `grep`), the Child process immediately calls the `exec` family.

The definitive system call is `execve(pathname, argv, envp)`.

It obliterates the current process's RAM. It fundamentally replaces the Text Segment (the Machine Code), Data Segments, Heap, and Stack perfectly with the new Binary executable image loaded directly from the hard drive, preserving only the integer Process ID (PID). 

```c
// Replacing the cloned child with the `ls` binary instantly
char *argv[] = {"ls", "-la", NULL};
char *envp[] = {NULL}; // Clean environment
execve("/bin/ls", argv, envp);

// If execve returns, it 100% failed!
perror("execve deeply failed");
```

---

## 3. Asynchronous Execution: Signals

A Signal is an extremely crude, violent Software Interrupt delivered instantly by the Kernel to a process. It is used to kill processes (`SIGKILL`), pause processes (`SIGSTOP`), or indicate fatal memory segmentation faults (`SIGSEGV`).

A process can establish a Custom Signal Handler using `sigaction()`.

### Why `signal()` is obsolete
Do not use the standard C library function `signal()`. Its behavior historically mutates across different UNIX implementations (System V vs BSD). The POSIX standard strictly defined `sigaction()` to guarantee identical cross-platform behavior regarding whether signals are blocked during execution.

---

## 4. Reentrant Handlers & `sig_atomic_t`

Signal Handlers interrupt the exact CPU cycle of your Main function randomly. If your Main function was halfway through updating a Linked List, the Signal Handler executes immediately on the same data.

If your Signal Handler attempts to call `printf()`, and your Main function had currently locked the global `stdio` buffer, the process will infinitely Deadlock against itself.

**Signal Handlers must only call Async-Signal-Safe functions.**
Functions like `malloc()`, `printf()`, or `exit()` are absolutely forbidden. Handlers should utilize strictly `write()` and `_exit()`.

### Global Variables 
When modifying a global variable inside a Signal Handler (e.g., a simple boolean flag shutting down the server gracefully), the Kernel might context switch halfway through writing the integer to RAM!

Variables shared between Main and Signal Handlers must be defined utilizing `volatile sig_atomic_t`. This guarantees that writing to the variable is physically handled in one atomic CPU instruction natively.

```c
#include <signal.h>
#include <unistd.h>
#include <stdio.h>

// Guaranteed Atomic CPU variable update!
volatile sig_atomic_t graceful_shutdown = 0;

void sigint_handler(int sig) {
    // OnlyAsync-Signal-Safe functions! No printf!
    write(STDOUT_FILENO, "\nShutting down...\n", 18);
    graceful_shutdown = 1; 
}

int main() {
    struct sigaction sa;
    sa.sa_handler = sigint_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0; // Standard POSIX behavior

    // Overriding Ctrl+C explicitly!
    if (sigaction(SIGINT, &sa, NULL) == -1) {
        perror("sigaction");
        return 1;
    }

    // Infinite Main Loop
    while (!graceful_shutdown) {
        printf("Running High-Performance Server...\n");
        sleep(2);
    }

    printf("Graceful Termination complete.\n");
    return 0;
}
```

---

## 5. Containerized Execution (MacBook / Linux)

```dockerfile
FROM gcc:latest
WORKDIR /signals
CMD ["/bin/bash"]
```

```yaml
services:
  signals-sandbox:
    build: .
    volumes:
      - .:/signals
    stdin_open: true
    tty: true
```

*Proceed to Chapter 16 to fundamentally comprehend Parallel Execution using POSIX Threads.*
