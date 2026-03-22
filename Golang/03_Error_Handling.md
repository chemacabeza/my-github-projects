# 03: Error Handling

In almost every other language (Java, C++, Python, C#), errors are handled via "Exceptions" (`try/catch`). 

Go famously abandons this model. In Go, **errors are just values**. They are returned alongside the normal data. This makes error handling explicit, preventing hidden crashes and forcing the developer to deal with failure states actively.

---

## 1. The `error` Interface

An error in Go is simply anything that implements the built-in `error` interface.

```go
// The built-in error interface
type error interface {
    Error() string
}
// Anything that has an Error() string method is essentially an error!
```

### Returning and Checking Errors

Functions in Go can return multiple values. It is a universal Go idiom that the *last* value returned is of type `error`. If it's successful, the `error` is `nil`.

```go
package main

import (
    "errors"
    "fmt"
)

// A function returning an int AND an error
func Divide(a, b int) (int, error) {
    if b == 0 {
        // We use the errors package to generate a simple standard error
        return 0, errors.New("cannot divide by zero")
    }
    // Execution succeeded. Return the result, and nil for the error.
    return a / b, nil
}

func main() {
    // We catch BOTH values returned by the function using the := operator
    result, err := Divide(10, 2)

    // ALWAYS CHECK IF err IS NOT NIL!
    if err != nil {
        fmt.Println("Math failed:", err)
        return // End execution gracefully
    }

    fmt.Println("Result is:", result)

    // Triggering the error
    brokenResult, err := Divide(10, 0)
    if err != nil {
        fmt.Println("Math failed:", err) // Output: Math failed: cannot divide by zero
    } else {
        fmt.Println("Result is:", brokenResult)
    }
}
```

---

## 2. Advanced Error Handling formatting

You can use the `fmt` package to create dynamic, formatted errors.

```go
package main

import "fmt"

func ProcessOrder(orderID int) error {
    if orderID < 0 {
        // fmt.Errorf allows us to inject variables into the error string
        return fmt.Errorf("invalid order ID: %d. Order IDs must be positive", orderID)
    }
    return nil // Success
}

func main() {
    err := ProcessOrder(-5)
    if err != nil {
        // Logging the error to the console
        fmt.Println("FATAL:", err)
    }
}
```

---

## 3. Panic and Recover (The "Break Glass" option)

Go *does* have something resembling an exception: it's called a `panic`. 

However, **you should almost never use it in library code**. A `panic` is reserved exclusively for unrecoverable state errors (e.g., the application cannot connect to the database on startup, so it must die).

### `main.go`
```go
package main

import "fmt"

func RiskCrash() {
    // 1. Defer: A function call preceded by 'defer' runs immediately BEFORE the surrounding function returns.
    // It is primarily used to close files or network connections reliably.
    defer fmt.Println("1. This runs right before RiskCrash exits.")

    // 2. Recover: The recover() function stops the program from crashing and captures the panic value.
    // IT ONLY WORKS INSIDE A DEFERRED FUNCTION!
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("3. Recovered from major panic! Error was:", r)
        }
    }()

    fmt.Println("2. About to panic...")
    
    // 3. Panic: Instantly halts normal execution and begins unwinding the stack.
    panic("CRITICAL MEMORY FAILURE")

    fmt.Println("This line will never execute.")
}

func main() {
    fmt.Println("--- Starting ---")
    
    RiskCrash()
    
    // Because we 'recovered', the application keeps running!
    fmt.Println("--- Application Survived ---")
}
```

### Dockerizing the Environment
Using the standard template from `01_Basics_and_Environment.md`:

```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
RUN CGO_ENABLED=0 go build -o app .

FROM scratch
COPY --from=builder /app/app /
ENTRYPOINT ["/app"]
```

```yaml
version: '3.8'
services:
  go-errors:
    build: .
    container_name: golang_error_handling
```

### Summary
The Go error paradigm forces you to write reliable code. By making errors explicit values that must be checked via `if err != nil`, Go eliminates massive swathes of "uncaught exception" bugs that plague other languages. You must acknowledge the failure path as eagerly as the success path.
