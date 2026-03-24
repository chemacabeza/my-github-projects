# 16: POSIX Threads (Pthreads)

<p align="center">
  <img src="images/posix_threads.png" alt="POSIX Threads" width="800"/>
</p>

Process creation via `fork()` provides absolute memory isolation—an elegant but expensive security blanket. If you need 1,000 parallel workers to share a 100GB in-memory database, the overhead of IPC (Inter-Process Communication) will crush your performance. 

Threads provide a lighter alternative: multiple execution streams within a *single* process. But this power comes with a terrifying cost: **shared memory is a battlefield**.

---

## 1. Thread Anatomy vs. Process Anatomy

When you spawn a thread using `pthread_create()`, it does not receive a new memory space. Instead, it shares almost everything with the parent process:
- **Shared:** Global variables (`.data`, `.bss`), the Heap, Open File Descriptors, Signal Dispositions, and the Process ID (PID).
- **Private:** A unique **Stack**, a unique set of CPU Registers (including the Program Counter), and specialized **Thread-Local Storage (TLS)**.

### The Problem of Concurrency
Because the Heap and Global variables are shared, two CPU cores executing different threads can try to update a simple counter `i++` at the exact same nanosecond. In assembly, `i++` is three operations: `read`, `increment`, `write`. If both threads read `10` at once, both increment to `11`, and both write `11` back. You just lost an update. This is a **Race Condition**.

---

## 2. Mutexes (Mutual Exclusion)

To prevent shared memory destruction, we use `pthread_mutex_t`. A mutex is a kernel-backed lock that ensures only one thread can enter a "Critical Section" of code at a time.

```c
#include <pthread.h>

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
int shared_resource = 0;

void* worker(void* arg) {
    for(int i = 0; i < 1000000; i++) {
        pthread_mutex_lock(&mtx);   // Acquire ownership
        shared_resource++;          // CRITICAL SECTION
        pthread_mutex_unlock(&mtx); // Release ownership
    }
    return NULL;
}
```

### Deadlocks
If Thread A locks Mutex 1 and waits for Mutex 2, while Thread B locks Mutex 2 and waits for Mutex 1, the program stops forever. 
**Golden Rule:** Always acquire multiple mutexes in the same strict order (e.g., always lock 1 then 2) to mathematically prove your program is deadlock-free.

---

## 3. Condition Variables: Intelligent Sleeping

How does a Consumer thread know when a Producer has added data to a shared queue? 
- **Spinning (Bad):** `while(queue.empty()) {}` — Burns 100% CPU on a void loop.
- **Sleep (Bad):** `sleep(1)` — Latency is too high; data might sit for a full second.
- **Condition Variables (Perfect):** `pthread_cond_t` allows a thread to sleep with **zero CPU usage** until it is explicitly signaled by another thread.

### The Consumer Flow:
```c
pthread_mutex_lock(&mtx);
while (queue_is_empty()) {
    // Atomically UNLOCKS the mutex and goes to SLEEP.
    // When signaled, it re-acquires the mutex before returning.
    pthread_cond_wait(&cond, &mtx);
}
data = get_from_queue();
pthread_mutex_unlock(&mtx);
```

---

## 4. Thread Safety and Reentrancy

A function is **Thread-Safe** if it can be called by multiple threads simultaneously without corrupting data. 
A function is **Reentrant** if it doesn't use any static or global memory at all.

### The `errno` Evolution
In original C, `errno` was a global integer. In a threaded environment, if Thread A fails a syscall and sets `errno = 2`, and then Thread B fails a different syscall and sets `errno = 5`, Thread A's error is gone.
Under the hood, Linux uses **Thread-Local Storage (TLS)**. `errno` is now a macro that points to a memory address unique to *each* thread's stack.

### Avoiding the "Unsafe" Functions
Many classic C functions are NOT thread-safe because they use internal static buffers:
- `strtok()` (Use `strtok_r()`)
- `asctime()` (Use `asctime_r()`)
- `gethostbyname()` (Use `getaddrinfo()`)

---

## 5. Thread Cancellation and Cleanup

What happens if you kill a thread while it is holding a Mutex? The Mutex remains locked forever, deadlocking the entire process. This is why you should avoid `pthread_cancel()` unless you have registered **Cleanup Handlers**.

```c
void cleanup_handler(void *arg) {
    pthread_mutex_unlock((pthread_mutex_t *)arg);
}

void* worker(void* arg) {
    pthread_cleanup_push(cleanup_handler, &mtx);
    pthread_mutex_lock(&mtx);
    
    // Do work that might be cancelled...
    
    pthread_mutex_unlock(&mtx);
    pthread_cleanup_pop(0);
}
```

---

## 6. Linux Implementation: NPTL

Linux originally used **LinuxThreads**, where every thread was actually a separate process with a shared memory space (created via `clone()`). This caused issues with signal handling and PID management.

Modern Linux uses **NPTL (Native POSIX Thread Library)**. Threads are still created via the `clone()` system call with specific flags (`CLONE_VM`, `CLONE_FILES`, `CLONE_SIGHAND`, `CLONE_THREAD`), but they are grouped under a single **Thread Group** with a shared Process ID.

- **PID:** The Process ID (shared by all threads).
- **TID:** The Thread ID (unique to each thread, returned by `gettid()`).

---

## 7. Sandbox Execution

```bash
# Compile with the pthread library linked!
gcc threaded_app.c -o threaded_app -lpthread
./threaded_app
```

*Proceed to Chapter 17 to explore the world of Network Sockets and the TCP/IP stack.*
