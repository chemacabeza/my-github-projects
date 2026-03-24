# 16: POSIX Threads (Pthreads)

<p align="center">
  <img src="images/posix_threads.png" alt="POSIX Threads" width="800"/>
</p>

Process creation (`fork()`) is incredibly safe because variables are completely duplicated. If one process mutates an array, the other process sees nothing. They are entirely memory-isolated.

However, inter-process communication (IPC) via pipes or sockets carries overhead. What if you want 100 parallel workers manipulating a single massive 10GB array in RAM simultaneously?

Enter **POSIX Threads (`pthreads`)**.

---

## 1. The Threat of Threads

Threads operate extremely differently than processes:
- Threads *share* the exact same Global Memory (`.data` / `.bss`) and `malloc()` Heap.
- Threads *share* all open File Descriptors (`fd`).
- Threads have absolutely completely separate **Stacks** (local variables).

Because the Heap is universally shared, if two CPU Cores attempt to write `count++` simultaneously, they will read the value simultaneously, increment it, and overwrite each other. **Data Corruption is instantaneous and guaranteed computationally.**

---

## 2. Mutexes (Mutual Exclusion)

To prevent data destruction, we lock physical access to the shared RAM using a `pthread_mutex_t`. This fundamentally guarantees that only exactly ONE CPU core is physically processing the locked memory addressing at any microsecond.

**`mutex_demo.c`**
```c
#include <pthread.h>
#include <stdio.h>

int shared_database = 0;  // Shared globally across all threads
pthread_mutex_t lck = PTHREAD_MUTEX_INITIALIZER;

void *worker_node(void *arg) {
    for (int i = 0; i < 1000000; i++) {
        // Lock the memory physically! 
        // If another thread holds the lock, this thread entirely freezes (blocks).
        pthread_mutex_lock(&lck);
        
        // Critical Section: Nobody else affects memory right now.
        shared_database++;
        
        // Unlock immediately so the frozen threads can resume processing!
        pthread_mutex_unlock(&lck);
    }
    return NULL;
}

int main() {
    pthread_t thread1, thread2;

    // Spawn two native parallel execution contexts
    pthread_create(&thread1, NULL, worker_node, NULL);
    pthread_create(&thread2, NULL, worker_node, NULL);

    // Wait strictly for both threads to completely extinguish.
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    // If done correctly, this will permanently equal 2,000,000 exactly natively.
    printf("Total Computed Entries: %d\n", shared_database);
    return 0;
}
```

### The Deadlock Abyss
If Thread 1 locks `Mutex A` and requests `Mutex B`, while simultaneous Thread 2 locks `Mutex B` and requests `Mutex A`, both threads freeze infinitely waiting for each other. This is a **Deadlock**.

Always acquire multiple locks in exactly the same strict hierarchical order universally across your codebase.

---

## 3. Condition Variables (Producer / Consumer)

How does a Consumer Thread know the Producer Thread just finished uploading data into a linked list? Should it run an infinite `while` loop aggressively checking the list size? No, that burns 100% of the CPU dynamically spinning in raw code.

We use `pthread_cond_t`.

A **Condition Variable** puts a thread permanently into a zero-CPU sleep state natively deep inside the kernel until another physical thread explicitly wakes it up!

### The Producer
```c
pthread_mutex_lock(&lck);
add_task_to_queue("Process Image");

// Instantly signal explicitly any 1 sleeping consumer to wake up!
pthread_cond_signal(&cond);
// (Or use `pthread_cond_broadcast` to wake up all 50 sleeping consumers!)

pthread_mutex_unlock(&lck);
```

### The Consumer
```c
pthread_mutex_lock(&lck);

// Because spurious (fake) wakeups occur inherently in Linux CPUs, ALWAYS use a while loop!
while (queue_is_empty()) {
    // Atomically UNLOCKS the mutex completely, and goes permanently to SLEEP!
    // The precise instant it is awakened by the Producer's signal, it physically
    // re-acquires the mutex lock exclusively natively!
    pthread_cond_wait(&cond, &lck);
}

// Safely consume the queue!
process_queue_item();
pthread_mutex_unlock(&lck);
```

---

## 4. `errno` and Thread Safety
Historically in ancient UNIX, `errno` was a literal global C integer. Obviously, if a system call failed on Thread 1, mutating the global integer would instantaneously destroy the error handling of Thread 2 simultaneously natively!

Modern Linux explicitly defines `errno` as a preprocessor macro wrapped around **Thread-Local Storage (TLS)**. Every unique thread receives its own uniquely isolated physical memory address mapping natively exclusively representing `errno` universally.

### `strtok()`: The Arch Enemy
The standard C function `strtok()` splits strings by implicitly storing pointers internally in a deeply hidden C library static variable. If two different threads call `strtok()` simultaneously natively, it absolutely corrupts memory instantly. 

Always use `strtok_r()` for Thread-Safe reentrant string execution natively targeting user-provided memory explicit pointers!

---

## 5. NPTL vs LinuxThreads
Linux originally mapped User Threads completely to independent Process IDs using the obsolete *LinuxThreads* implementation natively. This violated severe POSIX standard mandates natively regarding Signal routing universally.

Modern Linux utilizes **NPTL (Native POSIX Thread Library)**. The Kernel perfectly perceives threads via `clone()` uniquely scheduling independent execution contexts sharing identical Memory Management (MMU) architectures completely correctly aligning identically against POSIX compliance targets.

---

## 6. Containerized Execution (MacBook / Linux)

```dockerfile
FROM gcc:latest
WORKDIR /threads
# CRITICAL: Always link the pthread library dynamically!
CMD ["gcc", "mutex_demo.c", "-lpthread", "-o", "demo", "&&", "./demo"]
```
