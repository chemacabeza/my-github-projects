# Part 8: Concurrency & Multithreading

> **Sources:** *Thinking in Java* (Ch. 13) · *OCP Java SE 8 Programmer II* (Ch. 7) · *Java Coding Problems* (Ch. 10–11) · *Java 8 Lambdas* (Ch. 9)

---

## 🎯 Learning Objectives

- Create and manage threads using `Thread`, `Runnable`, and `ExecutorService`
- Understand synchronization, locks, and atomic operations
- Use the `java.util.concurrent` utilities (`CountDownLatch`, `CyclicBarrier`, `Semaphore`)
- Master **Virtual Threads** (Project Loom) and **Structured Concurrency**
- Avoid deadlocks, race conditions, and common concurrency bugs

---

## 1. Threads Fundamentals

### Creating Threads

```java
// Method 1: Extend Thread
class MyThread extends Thread {
    @Override
    public void run() {
        System.out.println("Running in: " + Thread.currentThread().getName());
    }
}
new MyThread().start();

// Method 2: Implement Runnable (preferred)
Runnable task = () -> System.out.println("Running in: " + Thread.currentThread().getName());
new Thread(task).start();

// Method 3: Callable — returns a value
Callable<Integer> computation = () -> {
    Thread.sleep(1000);
    return 42;
};
```

### Thread Lifecycle

```
NEW → RUNNABLE → RUNNING → BLOCKED/WAITING/TIMED_WAITING → TERMINATED
```

```java
Thread t = new Thread(() -> {
    try {
        Thread.sleep(2000);
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
});
t.start();                     // NEW → RUNNABLE
t.join();                      // Wait for t to finish
System.out.println(t.getState()); // TERMINATED
```

---

## 2. Synchronization

### The Problem — Race Condition

```java
class Counter {
    private int count = 0;
    public void increment() { count++; }  // NOT thread-safe! (read-modify-write)
    public int getCount() { return count; }
}
```

### synchronized Keyword

```java
class SafeCounter {
    private int count = 0;

    public synchronized void increment() { count++; }
    public synchronized int getCount() { return count; }

    // Or synchronized block
    public void incrementBlock() {
        synchronized (this) {
            count++;
        }
    }
}
```

### Atomic Classes

```java
import java.util.concurrent.atomic.*;

AtomicInteger counter = new AtomicInteger(0);
counter.incrementAndGet();        // thread-safe ++
counter.addAndGet(5);             // thread-safe +=
counter.compareAndSet(6, 10);     // CAS operation

AtomicLong longCounter = new AtomicLong(0);
AtomicBoolean flag = new AtomicBoolean(false);
AtomicReference<String> ref = new AtomicReference<>("initial");
```

---

## 3. ExecutorService

### Thread Pool Basics

```java
// Fixed thread pool — reuses a fixed number of threads
ExecutorService executor = Executors.newFixedThreadPool(4);

// Submit tasks
executor.submit(() -> System.out.println("Task 1"));
executor.submit(() -> System.out.println("Task 2"));

// Submit Callable — returns Future
Future<Integer> future = executor.submit(() -> {
    Thread.sleep(1000);
    return 42;
});

int result = future.get();           // Blocks until result is ready
int result2 = future.get(5, TimeUnit.SECONDS); // With timeout

// Shutdown
executor.shutdown();                 // Finish current tasks
executor.awaitTermination(10, TimeUnit.SECONDS);

// Other pool types
ExecutorService cached = Executors.newCachedThreadPool();     // Grows as needed
ExecutorService single = Executors.newSingleThreadExecutor(); // One thread
ScheduledExecutorService scheduled = Executors.newScheduledThreadPool(2);
```

### invokeAll & invokeAny

```java
List<Callable<String>> tasks = List.of(
    () -> { Thread.sleep(100); return "Fast"; },
    () -> { Thread.sleep(500); return "Medium"; },
    () -> { Thread.sleep(1000); return "Slow"; }
);

// Wait for ALL to complete
List<Future<String>> futures = executor.invokeAll(tasks);

// Return FIRST completed result
String fastest = executor.invokeAny(tasks);  // "Fast"
```

---

## 4. Concurrent Collections

```java
// Thread-safe Map — segments-based locking
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
map.put("key", 1);
map.computeIfAbsent("key2", k -> 42);
map.merge("key", 1, Integer::sum);  // Atomic increment

// Thread-safe Queue
BlockingQueue<String> queue = new LinkedBlockingQueue<>(100);
queue.put("item");                    // Blocks if full
String item = queue.take();           // Blocks if empty

// CopyOnWriteArrayList — for read-heavy scenarios
CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();
```

---

## 5. Synchronization Utilities

### CountDownLatch — Wait for N events

```java
CountDownLatch latch = new CountDownLatch(3);

for (int i = 0; i < 3; i++) {
    executor.submit(() -> {
        doWork();
        latch.countDown();  // Signal completion
    });
}

latch.await();  // Block until count reaches 0
System.out.println("All tasks complete!");
```

### CyclicBarrier — Sync N threads at a point

```java
CyclicBarrier barrier = new CyclicBarrier(3, () -> 
    System.out.println("All threads arrived at barrier!"));

for (int i = 0; i < 3; i++) {
    executor.submit(() -> {
        phase1();
        barrier.await();  // Wait for all threads
        phase2();
    });
}
```

### Semaphore — Limit concurrent access

```java
Semaphore semaphore = new Semaphore(3);  // 3 permits

executor.submit(() -> {
    semaphore.acquire();  // Get permit (blocks if none available)
    try {
        accessSharedResource();
    } finally {
        semaphore.release();  // Return permit
    }
});
```

---

## 6. CompletableFuture

```java
CompletableFuture<String> future = CompletableFuture
    .supplyAsync(() -> fetchData("url"))              // Async
    .thenApply(String::toUpperCase)                   // Transform
    .thenApply(s -> "Result: " + s)                   // Chain
    .exceptionally(ex -> "Error: " + ex.getMessage()); // Handle error

String result = future.get();

// Combining futures
CompletableFuture<String> f1 = CompletableFuture.supplyAsync(() -> "Hello");
CompletableFuture<String> f2 = CompletableFuture.supplyAsync(() -> "World");

CompletableFuture<String> combined = f1.thenCombine(f2, (a, b) -> a + " " + b);
// "Hello World"

// Wait for all
CompletableFuture.allOf(f1, f2).join();

// Wait for any
CompletableFuture.anyOf(f1, f2).join();
```

---

## 7. Virtual Threads (Java 21+, Project Loom)

### What Are Virtual Threads?

Virtual threads are **lightweight threads** managed by the JVM rather than the OS. You can create millions of them.

```java
// Creating virtual threads
Thread vThread = Thread.ofVirtual().start(() -> {
    System.out.println("Running on: " + Thread.currentThread());
});

// With name
Thread named = Thread.ofVirtual()
    .name("my-virtual-thread")
    .start(() -> doWork());

// Virtual thread executor — creates a new virtual thread per task
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    for (int i = 0; i < 100_000; i++) {
        executor.submit(() -> {
            Thread.sleep(Duration.ofSeconds(1));
            return "Done";
        });
    }
}  // Waits for all to complete (AutoCloseable)
```

### Platform vs. Virtual Threads

| Feature | Platform Thread | Virtual Thread |
|---------|----------------|----------------|
| Managed by | OS | JVM |
| Memory | ~1 MB stack | ~few KB |
| Max count | ~thousands | ~millions |
| Cost of creation | High | Negligible |
| Best for | CPU-bound | I/O-bound |
| Pooling needed | Yes | No |

### When to Use Virtual Threads

✅ **I/O-bound tasks:** HTTP requests, database calls, file I/O
✅ **High concurrency servers:** Handle millions of connections
✅ **Replace thread pools** for I/O workloads

❌ **Not for CPU-bound work** — they share the same carrier threads
❌ **Avoid `synchronized` blocks** — prefer `ReentrantLock` (prevents pinning)

---

## 8. Structured Concurrency (Preview, Java 21+)

```java
try (var scope = new StructuredTaskScope.ShutdownOnFailure()) {
    Subtask<String> user = scope.fork(() -> fetchUser(userId));
    Subtask<String> order = scope.fork(() -> fetchOrder(orderId));

    scope.join();            // Wait for all
    scope.throwIfFailed();   // Propagate exceptions

    String result = user.get() + " - " + order.get();
}
// If any subtask fails, all others are cancelled automatically
```

### ShutdownOnSuccess — Return first result

```java
try (var scope = new StructuredTaskScope.ShutdownOnSuccess<String>()) {
    scope.fork(() -> fetchFromServerA());
    scope.fork(() -> fetchFromServerB());
    scope.fork(() -> fetchFromServerC());

    scope.join();
    String fastest = scope.result();  // First successful result
}
```

---

## 9. Deadlock Prevention

```java
// DEADLOCK example:
// Thread 1: lock(A) → lock(B)
// Thread 2: lock(B) → lock(A)  ← Deadlock!

// Prevention strategies:
// 1. Lock ordering — always acquire locks in the same order
// 2. Timeout — use tryLock with timeout
// 3. Avoid nested locks when possible

ReentrantLock lock = new ReentrantLock();
if (lock.tryLock(5, TimeUnit.SECONDS)) {
    try {
        // critical section
    } finally {
        lock.unlock();
    }
} else {
    // Handle timeout — couldn't acquire lock
}
```

---

## 10. Best Practices

1. **Prefer `ExecutorService`** over manual `Thread` creation
2. **Use virtual threads** for I/O-bound workloads (Java 21+)
3. **Use `ConcurrentHashMap`** instead of `synchronized HashMap`
4. **Prefer `AtomicInteger`** over `synchronized` for simple counters
5. **Always handle `InterruptedException`** — restore interrupt status
6. **Use `CompletableFuture`** for async pipelines
7. **Avoid shared mutable state** — prefer immutable data
8. **Always unlock in `finally`** when using `ReentrantLock`
9. **Profile before parallelizing** — concurrency adds complexity

---

## 11. Exercises

1. **Producer-Consumer:** Implement using `BlockingQueue` with multiple producers/consumers
2. **Parallel Web Scraper:** Use `CompletableFuture` to fetch multiple URLs concurrently
3. **Thread-Safe Cache:** Implement an LRU cache using `ConcurrentHashMap` and `ReentrantReadWriteLock`
4. **Virtual Thread Benchmark:** Compare throughput of 10,000 I/O tasks with platform vs virtual threads
5. **Structured Concurrency:** Implement a service that fetches user profile + orders + recommendations concurrently

---

## 📖 References

- *Thinking in Java*, Bruce Eckel — Ch. 13 (Concurrency)
- *OCP Java SE 8 Programmer II Study Guide* — Ch. 7 (Concurrency)
- *Java Coding Problems*, Anghel Leonard — Ch. 10–11 (Virtual Threads, Structured Concurrency)
- *Java 8 Lambdas*, Richard Warburton — Ch. 9 (Lambda-Enabled Concurrency)

---

[← Part 7: Streams API](Part-07-Streams-API.md) | [Back to Course Index](../README.md) | [Next: Part 9 — I/O & NIO →](Part-09-IO-And-NIO.md)
