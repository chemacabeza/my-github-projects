# 08: System Programming in Go

Go sits in the unique territory right above C and C++, providing high-level networking/API design while possessing direct, massive access to low-level POSIX System Calls. 

Based on *Hands-On System Programming with Go*, we explore how Go interacts directly with the Linux kernel seamlessly, managing process signals (`SIGINT`, `SIGTERM`), standard I/O streams, and file descriptors.

---

## 1. Process Signal Handling (Graceful Shutdowns)

When running inside Docker or Kubernetes, your app receives a `SIGTERM` signal when scaling down or deploying. If you instantly kill the program (`exit(status 137)`), you drop active database connections and leave users stranded.

We must build a **Graceful Shutdown** handler.

### `main.go`
```go
package main

import (
    "fmt"
    "os"
    "os/signal"
    "syscall"
    "time"
)

func main() {
    // 1. Create a channel capable of receiving OS Signals
    // It must be a buffered channel to prevent the OS from attempting to write
    // to full memory, which could drop the kill signal.
    sigChan := make(chan os.Signal, 1)

    // 2. Register which signals we want this channel to listen for
    // SIGINT  (Ctrl+C from keyboard)
    // SIGTERM (Docker/Kubernetes termination request)
    signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

    // 3. Fire a background Goroutine to simulate active work running infinitely
    go func() {
        for {
            fmt.Println("[WORKER] Processing background job...")
            time.Sleep(2 * time.Second)
        }
    }()

    fmt.Println("[SYSTEM] Application booted. Waiting to be killed...")

    // 4. BLOCK the main thread on the signal channel!
    // The main process will sleep eternally exactly here until the OS kills us.
    receivedSignal := <-sigChan

    // 5. The Graceful Teardown Phase
    fmt.Printf("\n[SYSTEM] Received (%s) signal! Commencing graceful shutdown.\n", receivedSignal)
    fmt.Println("[SYSTEM] Unlocking Database...")
    time.Sleep(1 * time.Second)
    fmt.Println("[SYSTEM] Flushing remaining streams to disk...")
    time.Sleep(1 * time.Second)

    fmt.Println("[SYSTEM] All jobs gracefully terminated. Halting Process.")
    
    // We exit gracefully (OS exit code 0)
    os.Exit(0)
}
```

### Try it with Docker
If you use `docker compose up`, and then press `CTRL+C`, Docker sends `SIGTERM`. Your app will intercept the signal, announce the shutdown, close the mock database, and cleanly exit!

---

## 2. Reading POSIX Command Line Arguments

Instead of a bulky UI, system programs act as CLI utilities reading `os.Args` (the equivalent of C++'s `int argc, char** argv`).

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    // Retrieve the arguments exactly as the user typed them in the bash terminal
    args := os.Args

    if len(args) < 2 {
        fmt.Println("Usage: ./myapp [username]")
        os.Exit(1) // Exit with a generic error code
    }

    // args[0] is perpetually the name of the executable itself (e.g. "./myapp")
    // The user's input begins at args[1]
    username := args[1] 

    fmt.Printf("Authenticating user POSIX shell context: %s\n", username)
}
```

---

## 3. High-Performance File I/O (`os` and `io` packages)

Go’s standard library provides incredibly fast file interactions. Reading massive log files entirely into RAM causes Out-Of-Memory (OOM) Kubernetes crashes. We must stream files using `bufio` buffers.

### `main.go`
```go
package main

import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    const filename = "/etc/hosts"

    // 1. Open the file 
    // This executes a Linux `open()` syscall behind the scenes yielding a hardware file descriptor
    file, err := os.Open(filename)
    if err != nil {
        fmt.Printf("Fatal: Could not open %s\n", filename)
        os.Exit(1)
    }
    
    // 2. DEFER the close operation!
    // Never forget to close raw OS resources, or you'll run out of file descriptors ('Too many open files').
    // Wrapping it in defer guarantees execution no matter how the function exits!
    defer file.Close()

    // 3. Create a Buffered Scanner
    // The scanner reads chunk by chunk instead of loading gigabytes of data into RAM at once.
    scanner := bufio.NewScanner(file)

    fmt.Println("--- Scanning Host File ---")
    lineCount := 0
    for scanner.Scan() {
        lineCount++
        fmt.Printf("Line %d: %s\n", lineCount, scanner.Text())
    }

    if err := scanner.Err(); err != nil {
        fmt.Println("Error reading OS Stream:", err)
    }
}
```

### Summary of System Programming
Go’s simplicity abstracts away C pointers while leaving direct POSIX capabilities untouched. By using the `os` and `os/signal` packages, you write bulletproof microservices that cooperate natively with modern generic supervisors like Docker and Kubernetes.

---

## 4. Dockerizing System Programs

To safely test POSIX signal handling in an isolated environment without killing your host machine processes, run the code via Docker multi-stage builds.

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
  go-sys:
    build: .
    container_name: golang_system
```

Execute the system daemon:
```bash
docker compose up --build
```
*Note: Press `CTRL+C` while it is running to watch Docker send `SIGTERM` and verify that your Graceful Shutdown handler intercepts it successfully!*
