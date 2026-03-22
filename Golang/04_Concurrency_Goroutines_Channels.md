# 04: Concurrency (Goroutines and Channels)

Go was built for the modern multi-core era. Its absolute defining feature is its approach to concurrency, inspired by the **Communicating Sequential Processes (CSP)** paper by Tony Hoare.

Instead of heavy OS Threads and Mutex locks (like Java or C++), Go uses lightweight **Goroutines** communicating via **Channels**.

"Do not communicate by sharing memory; instead, share memory by communicating." - Effective Go

---

## 1. Goroutines (Lightweight Threads)

An OS Thread requires roughly 1-2 Megabytes of RAM. A Goroutine requires **2 Kilobytes**. You can comfortably run 1,000,000 Goroutines on a standard laptop.

The `go` keyword instantly schedules a function to run concurrently in the background managed by the Go Scheduler.

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

## 2. Sync.WaitGroup (Waiting for Goroutines)

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

## 3. Channels (Communicating between Goroutines)

Channels are typed, thread-safe pipes that connect concurrent goroutines. You can send values into a channel from one goroutine and receive those values in another.

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

    // Since select only grabbed the first one that fired, main exits here!
    fmt.Println("Application shutdown.")
}
```

### Dockerizing the Execution

To see the massive performance of Go's concurrency running isolated, use this multi-stage setup.

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

Run it via:
```bash
docker compose up --build
```
You will notice the `docker-compose` logs instantly print out the fastest process, showcasing true multi-core capabilities managed through incredibly simple syntax.
