# 01: Go Basics and Environment

Welcome to **Phase 1** of your Golang journey. Go (or Golang) is an open-source, statically typed, compiled language developed by Google. It is designed for absolute simplicity, blazing-fast compilation, and massive concurrency. 

This guide pulls core concepts from *Go Programming: From Beginner to Professional*.

---

## 1. The Simplest Program

Unlike C++ or Java, Go prefers ultra-lightweight syntax. It strips away classes, inheritance, and exception throwing, replacing them with a highly opinionated standard formatter (`gofmt`).

### `main.go`
```go
// Every Go program must start with a package declaration.
// The 'main' package tells the compiler this is an executable, not a library.
package main

// Import the formatting library for fast I/O
import "fmt"

func main() {
    fmt.Println("Welcome to Modern Golang!")
}
```

---

## 2. Dockerizing Go (The Zero-Overhead Container)

Go is a compiled language that can target specific OS architectures. If we compile statically, we don't even need an underlying Linux distribution (like Ubuntu or Alpine) to run the binary inside Docker. We can use `scratch` (a literally empty container) to create production images smaller than 5 Megabytes!

### `Dockerfile`
This is a **Multi-Stage Build**. It compiles the code in Stage 1, and only copies the lightweight binary into Stage 2.

```dockerfile
# Stage 1: Build the binary using the heavy official Go image
FROM golang:1.22-alpine AS builder

# Set working directory
WORKDIR /app

# Copy source code
COPY main.go .

# Compile the binary.
# CGO_ENABLED=0 disables C-bindings, creating a 100% pure static Go binary.
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Stage 2: Create the minimal execution container
FROM scratch

# Copy the static binary from the builder stage
COPY --from=builder /app/main /main

# Execute
ENTRYPOINT ["/main"]
```

### `docker-compose.yml`
```yaml
version: '3.8'

services:
  go-basics:
    build: .
    container_name: golang_basics
```

### Running the Environment
Run this command in the directory holding these three files:
```bash
docker compose up --build
```
You will immediately see the container boot up, print "Welcome to Modern Golang!", and gracefully exit.

---

## 3. Variables, Types, and Short Declaration

Go has standard data types but offers a very unique initialization syntax called **Short Variable Declaration**.

### `main.go` (Variables Example)

```go
package main

import "fmt"

// Package-level variables MUST use the 'var' keyword
var globalServer string = "AWS_EU_WEST"

func main() {
    // 1. Explicit Declaration (Verbose)
    var age int = 30
    var price float64 = 19.99

    // 2. Type Inference
    var isVerified = true

    // 3. Short Variable Declaration (Idomatic Go)
    // The ':=' operator declares AND initializes a new variable.
    // It is exclusively used inside functions.
    name := "Bjarne"   // Deduced to string
    userId := 4022     // Deduced to int

    // If you declare a variable in Go and DO NOT use it, 
    // the compiler will throw a hard error and refuse to build!
    fmt.Printf("User %s (ID: %d) is verified: %t\n", name, userId, isVerified)
    fmt.Println("Server:", globalServer, "| Age:", age, "| Price:", price)
}
```

---

## 4. Control Flow (If, For, Switch)

Go is incredibly minimalist. There is no `while` loop or `do-while` loop. The `for` loop serves every repetitive purpose.

### `main.go` (Control Flow Example)

```go
package main

import "fmt"

func main() {
    // 1. The Standard For Loop
    fmt.Print("Standard Loop: ")
    for i := 0; i < 3; i++ {
        fmt.Print(i, " ")
    }
    fmt.Println()

    // 2. The "While" Loop (Just 'for' without semicolons)
    fmt.Print("While Loop: ")
    count := 2
    for count > 0 {
        fmt.Print(count, " ")
        count--
    }
    fmt.Println()

    // 3. If Initialization Statement
    // You can initialize a variable right inside the 'if' condition!
    // Its scope is strictly limited to the if/else block.
    if statusCode := 200; statusCode == 200 {
        fmt.Println("Success! Status:", statusCode)
    } // statusCode ceases to exist here.

    // 4. Switch statements
    // Go automatically breaks after every case! No need for explicit 'break'.
    osType := "darwin"
    switch osType {
    case "darwin":
        fmt.Println("Running on macOS")
    case "linux":
        fmt.Println("Running on Linux")
    default:
        fmt.Println("Unknown OS")
    }
}
```

### Summary
Go removes cognitive overhead by providing one way to declare variables locally (`:=`) and one way to loop (`for`). Combined with zero-overhead Docker compilation using `FROM scratch`, you have the foundation of cloud-native development. 

In the next guide (`02_Structs_and_Interfaces.md`), we look into how Go completely reinvented Object-Oriented Programming without using Classes.
