# 09: Building Modern CLI Applications

Based on *Building Modern CLI Applications in Go*, this module demonstrates why Go is the reigning champion of terminal applications (Docker, Kubernetes/kubectl, Terraform, and GitHub CLI are all written in Go). 

Instead of manually parsing `os.Args` (as seen in `08_System_Programming.md`), Go provides the built-in `flag` package to automatically parse dashed arguments like `-port 8080`.

---

## 1. The built-in `flag` package

The standard library provides everything you need to build simple configuration flags.

### `main.go`
```go
package main

import (
    "flag"
    "fmt"
    "os"
)

func main() {
    // 1. Define your Flags (Name, Default Value, Help Description)
    // These return POINTERS to the actual variables (e.g., *string)
    hostPtr := flag.String("host", "localhost", "The target host IP or Domain")
    portPtr := flag.Int("port", 8080, "The port to connect to")
    debugPtr := flag.Bool("debug", false, "Enable verbose debug logging")

    // 2. Parse the command-line input!
    // This MUST be called after defining all flags and before accessing them.
    flag.Parse()

    // 3. Application Logic
    if *debugPtr {
        fmt.Println("[DEBUG] Raw command line args:", os.Args)
        fmt.Println("[DEBUG] Number of parsed flags:", flag.NFlag())
    }

    // Notice we must dereference (*) the pointers to get the value
    fmt.Printf("Connecting to %s:%d...\n", *hostPtr, *portPtr)
}
```

### Try it with Docker

**`Dockerfile`**
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
RUN CGO_ENABLED=0 go build -o mycli .

FROM scratch
COPY --from=builder /app/mycli /
# The ENTRYPOINT allows us to pass arguments dynamically at runtime
ENTRYPOINT ["/mycli"]
```

Build the CLI securely inside the container:
```bash
docker build -t go-cli .
```

Run the container, passing arguments directly into it!
```bash
# 1. Defaults
docker run --rm go-cli
# Output: Connecting to localhost:8080...

# 2. Custom Flags
docker run --rm go-cli -host=db.production.local -port=5432 -debug
# Output:
# [DEBUG] Raw command line args: [/mycli -host=db.production.local -port=5432 -debug]
# [DEBUG] Number of parsed flags: 3
# Connecting to db.production.local:5432...

# 3. Auto-Generated Help Menu
docker run --rm go-cli -help
# Output:
# Usage of /mycli:
#   -debug
#         Enable verbose debug logging
#   -host string
#         The target host IP or Domain (default "localhost")
#   -port int
#         The port to connect to (default 8080)
```

---

## 2. Advanced CLI Tools (Cobra / Viper)

While the `flag` package is fantastic for quick scripts, enterprise tools like `kubectl` have deeply nested subcommands:
- `kubectl get pods`
- `kubectl describe node worker-1`
- `kubectl scale deployment web --replicas=3`

If you are building an application of that scale, you do not use `flag`. You use the open-source **[Cobra](https://github.com/spf13/cobra)** framework (which literally powers `kubectl` and `Hugo`).

### Subcommand Example (Conceptual with Cobra)

```go
package main

import (
    "fmt"
    "github.com/spf13/cobra"
)

func main() {
    // 1. The Root Command (e.g. 'mycli')
    var rootCmd = &cobra.Command{
        Use:   "mycli",
        Short: "MyCLI is a lightning fast orchestrator",
        Run: func(cmd *cobra.Command, args []string) {
            fmt.Println("Please provide a subcommand! Try `mycli server start`")
        },
    }

    // 2. The Nested Subcommand (e.g. 'server')
    var serverCmd = &cobra.Command{
        Use:   "server",
        Short: "Manage the application server",
    }

    // 3. The Deep Action (e.g. 'start')
    var startCmd = &cobra.Command{
        Use:   "start",
        Short: "Starts the production server on port 8080",
        Run: func(cmd *cobra.Command, args []string) {
            fmt.Println("Starting REST API on 0.0.0.0:8080...")
        },
    }

    // Connect them together
    rootCmd.AddCommand(serverCmd)
    serverCmd.AddCommand(startCmd)

    // Execute the Root Command (which automatically parses os.Args)
    rootCmd.Execute()
}
```

### Summary
Go produces static binaries natively. You do not require a heavy JVM like Java nor a massive runtime environment like Python. You copy the `<10MB` compiled binary to a server, and it executes instantly without external dependencies. This is why Go rules infrastructure CLI tooling.
