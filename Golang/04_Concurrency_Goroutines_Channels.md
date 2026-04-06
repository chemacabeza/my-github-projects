# 04: Concurrency (Goroutines and Channels)

<p align="center">
  <img src="images/go_ch04_concurrency.png" alt="Go Goroutines and Channels" width="100%"/>
</p>

> 🧠 **The Feynman Hook:** An OS Thread is a full-time employee: they have their own office (2MB stack), their own payroll, and take a long time to hire and fire. A Goroutine is a freelancer on a shared desk: they need only a single business card's worth of memory (2KB starting stack), and you can employ a million of them simultaneously. Go's scheduler invisibly moves freelancers between desks (CPU cores) so that no desk ever sits idle. Channels are the inter-desk messaging system: instead of shouting across the office (shared memory), you drop a note in someone's in-tray (channel), and they pick it up when ready.

Go was built for the modern multi-core era. Its defining feature is its approach to concurrency, inspired by the **Communicating Sequential Processes (CSP)** paper by Tony Hoare.

Instead of heavy OS Threads and Mutex locks (like Java or C++), Go uses lightweight **Goroutines** communicating via **Channels**.

> *"Do not communicate by sharing memory; instead, share memory by communicating."* — Effective Go

---

## 1. Goroutines (Lightweight Threads)

> **Feynman Insight:** The `go` keyword is the most powerful two-letter word in Go. Writing `go HeavyCalculation(i)` doesn't run the function — it schedules it. The Go runtime's scheduler picks it up and runs it on whatever CPU core is available, completely independently of your main function. The main goroutine keeps executing immediately. This is exactly how a restaurant works: a waiter (main goroutine) takes three orders (launches three goroutines) and doesn't stand watching the kitchen (blocking) — they go take more orders. The kitchen (goroutines) works in parallel.

An OS Thread requires roughly 1-2 Megabytes of RAM. A Goroutine requires **2 Kilobytes**. You can comfortably run 1,000,000 Goroutines on a standard laptop.

```go
package main

import (
    "fmt"
    "time"
)

func HeavyCalculation(id int) {
    fmt.Printf("Task %d starting...\n", id)
    time.Sleep(1 * time.Second) // Simulate 1 second of heavy computing
    fmt.Printf("Task %d finished!\n", id)
}

func main() {
    start := time.Now()

    // 1. Spawning Concurrent Tasks
    // Without the 'go' keyword, this loop would take 3 seconds (Sequential).
    // With the 'go' keyword, the main function instantly fires off 3 background tasks.
    for i := 1; i <= 3; i++ {
        go HeavyCalculation(i)
    }

    fmt.Println("All tasks scheduled.")

    // 2. The Main Goroutine
    // If 'main' exits, all background Goroutines are instantly terminated!
    // We sleep the main routine for 2 seconds to give the background tasks time to finish.
    time.Sleep(2 * time.Second)

    fmt.Printf("Program took %v\n", time.Since(start)) // Output: ~2 seconds!
}
```

---

## 2. Sync.WaitGroup (Waiting Properly)

> **Feynman Insight:** `time.Sleep(2 * time.Second)` to wait for goroutines is like a manager saying "the contractors will probably be done in 2 hours, so I'll check back then." What if they finish in 90 minutes? Wasted time. What if they need 2.5 hours? You leave too early. A `WaitGroup` is the proper sign-out sheet: every goroutine signs in (`wg.Add(1)`) when hired, signs out (`wg.Done()`) when finished, and the manager waits (`wg.Wait()`) until the last signature appears. Zero timeouts, zero guessing.

Sleeping the main function is a terrible idea in production. We need a way to track when worker Goroutines finish. We use a `WaitGroup`.

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

func Worker(id int, wg *sync.WaitGroup) {
    defer wg.Done() // Decrements the WaitGroup counter when the function exits!

    fmt.Printf("Worker %d starting...\n", id)
    time.Sleep(time.Millisecond * 500)
    fmt.Printf("Worker %d Done.\n", id)
}

func main() {
    var wg sync.WaitGroup // Create a WaitGroup

    for i := 1; i <= 3; i++ {
        wg.Add(1) // Increment the counter explicitly BEFORE launching the goroutine
        go Worker(i, &wg) // Pass the memory address of the WaitGroup!
    }

    // This completely blocks the main thread here until the counter hits Zero.
    wg.Wait()

    fmt.Println("All workers finished flawlessly. Main thread exiting.")
}
```

---

## 3. Channels (Communicating Between Goroutines)

> **Feynman Insight:** A Channel is a typed, thread-safe in-tray. One goroutine drops a string into the in-tray (`pipe <- processed`). Another goroutine blocks at the in-tray until something arrives (`result := <-pipe`). This completely eliminates the classic concurrency bug: two goroutines reading and writing a shared variable simultaneously (a **race condition**). There's no shared variable — data ownership transfers through the channel. As soon as data enters the channel, the sender no longer owns it.

Channels are typed, thread-safe pipes that connect concurrent goroutines.

```go
package main

import "fmt"

func ProcessData(data string, pipe chan string) {
    processed := data + " [PROCESSED]"

    // Send the data INTO the channel using the '<-' operator
    pipe <- processed
}

func main() {
    // 1. Create a Channel of Strings using the built-in 'make' function
    messages := make(chan string)

    // 2. Launch a background task, giving it the channel to write to
    go ProcessData("Raw User Input", messages)

    // 3. Receive the data FROM the channel!
    // This action entirely BLOCKS the main thread until data arrives in the pipe!
    result := <-messages

    fmt.Println("Received:", result)
}
```

---

## 4. Buffered Channels and Select

> **Feynman Insight:** An unbuffered channel is two people handshaking: the sender can't let go until the receiver grabs it. A **buffered channel** is an in-tray with a stack limit: "I'll accept up to 2 items before you need to wait." The `select` statement is the "whoever calls first" mechanism: multiple goroutines race to deliver data through different channels, and `select` picks up whichever arrives first — with a built-in `time.After()` timeout channel for "if nobody responds within 2 seconds, give up." This pattern replaces callback hell with clean, readable code.

By default, an unbuffered channel synchronizes immediately: the sender blocks until the receiver pulls the data out.
A **Buffered Channel** has a queue limit. It only blocks the sender if the queue is full.

```go
package main

import (
    "fmt"
    "time"
)

func slowWorker(ch chan string) {
    time.Sleep(time.Second * 1)
    ch <- "Worker finished Job A"
}

func fastWorker(ch chan string) {
    time.Sleep(time.Millisecond * 200)
    ch <- "Worker finished Job B"
}

func main() {
    // A channel that can hold 2 strings before blocking the sender
    c1 := make(chan string, 2)
    c2 := make(chan string, 2)

    go slowWorker(c1)
    go fastWorker(c2)

    // The 'select' statement looks exactly like a switch statement,
    // but it is exclusively used for Channels. It blocks until ONE of its cases is ready.
    fmt.Println("Waiting for the fastest worker...")

    select {
    case res1 := <-c1: // This won't trigger for 1 second
        fmt.Println("Received from Slow:", res1)
    case res2 := <-c2: // This will trigger in 200ms!
        fmt.Println("FASTEST RECEIVE:", res2)
    case <-time.After(time.Second * 2): // Built-in timeout mechanism!
        fmt.Println("Timeout!")
    }

    fmt.Println("Application shutdown.")
}
```

### Dockerizing the Execution

**`Dockerfile`**
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
RUN CGO_ENABLED=0 go build -o app .

FROM scratch
COPY --from=builder /app/app /
ENTRYPOINT ["/app"]
```

**`docker-compose.yml`**
```yaml
version: '3.8'
services:
  go-concurrency:
    build: .
    container_name: golang_concurrency
```

```bash
docker compose up --build
```

---

## 🤔 Reflection Questions

1. **What is a race condition and how do channels prevent it?**
<details>
<summary>💡 View Answer</summary>

A **race condition** occurs when two or more goroutines read and write a shared variable simultaneously. The result depends on unpredictable CPU scheduling — your code may work 99% of the time and fail catastrophically 1% of the time. Channels prevent this by enforcing **ownership transfer**: data flows *through* the channel from one goroutine to another. Only one goroutine holds the data at any moment. Go's built-in race detector (`go test -race`) automatically detects race conditions in tests.
</details>

2. **When should you use a WaitGroup vs a Channel?**
<details>
<summary>💡 View Answer</summary>

Use a **WaitGroup** when you simply want to wait for a group of goroutines to *finish* (fire-and-forget fan-out pattern). Use a **Channel** when goroutines need to *return data* back to the caller or communicate with each other. A common pattern: use goroutines + channels for worker pools that stream results back, and WaitGroup for parallel side-effect operations (e.g., 10 goroutines writing to 10 different files).
</details>

---

## 📝 Key Interview Talking Points

- **Goroutine vs OS Thread**: 2KB vs 1-2MB starting stack. The Go runtime multiplexes N goroutines onto M OS threads (M:N threading model).
- **`go` keyword** immediately returns — the scheduled goroutine runs independently.
- **Unbuffered channels synchronise** — both sender and receiver must be ready simultaneously (like a handshake).
- **`select` is the non-blocking multiplexer** for channels — always include a `time.After` case for production timeout handling.
- **`defer wg.Done()`** inside the goroutine function ensures the counter decrements even if the goroutine panics.
