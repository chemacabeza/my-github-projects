# 05: Functional Programming and Generics (Go 1.18+)

While Go is predominantly imperative, it fully supports first-class functions, closures, and anonymous functions, drawing heavily from the principles found in *Functional Programming in Go*. Furthermore, Go 1.18 introduced **Generics** (Type Parameters), which radically revolutionized how Go handles functions over different data types.

---

## 1. First-Class Functions and Closures

Functions in Go are first-class citizens. You can assign them to variables, pass them as arguments to other functions, and return them from functions.

```go
package main

import "fmt"

// 1. A Higher-Order Function (A function that returns a function)
func MakeMultiplier(factor int) func(int) int {
    // 2. Closure
    // This inner, anonymous function "closes over" the `factor` variable, 
    // keeping it alive in memory even after MakeMultiplier exits!
    return func(value int) int {
        return value * factor
    }
}

func main() {
    // 3. Assigning the returned function to a variable
    double := MakeMultiplier(2)
    triple := MakeMultiplier(3)

    fmt.Println(double(10)) // Output: 20
    fmt.Println(triple(10)) // Output: 30
}
```

---

## 2. The `map`, `filter`, and `reduce` concepts

Before Go 1.18 (Generics), writing a generic `map` or `filter` function was impossible without resorting to the notoriously slow `interface{}` and runtime type-reflection (`reflect` package).

Now, we define Type Parameters using `[T any]` or `[T comparable]`.

### Implementing standard FP utilities using Generics (Go 1.18+)

```go
package main

import "fmt"

// 1. Filter: Applies an anonymous predicate function (T -> bool) to a generic slice of T.
func Filter[T any](input []T, predicate func(T) bool) []T {
    var result []T // Will implicitly be the slice of T's
    
    for _, item := range input {
        // Did the user's predicate pass for this specific item?
        if predicate(item) { 
            result = append(result, item)
        }
    }
    return result
}

// 2. Map: Transforms a generic slice of T into a generic slice of R using a transform function.
func Map[T any, R any](input []T, transform func(T) R) []R {
    result := make([]R, len(input)) // Pre-allocate for performance
    
    for i, item := range input {
        result[i] = transform(item)
    }
    return result
}

// 3. Reduce: Squashes a slice of T into a single R using an accumulator function.
func Reduce[T any, R any](input []T, initial R, accumulator func(R, T) R) R {
    result := initial
    
    for _, item := range input {
        result = accumulator(result, item)
    }
    return result
}

func main() {
    numbers := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    // Pipeline: Filter evens -> Map to String with prefix -> Reduce to a single CSV string!
    
    // Step 1: Filter
    evens := Filter(numbers, func(n int) bool { return n%2 == 0 })
    fmt.Println("Evens:", evens) // Output: [2 4 6 8 10]

    // Step 2: Map
    strs := Map(evens, func(n int) string { return fmt.Sprintf("Num-%d", n) })
    fmt.Println("Strings:", strs) // Output: [Num-2 Num-4 Num-6 Num-8 Num-10]

    // Step 3: Reduce
    csv := Reduce(strs, "START: ", func(acc string, val string) string {
        return acc + val + ", "
    })
    
    // Output: START: Num-2, Num-4, Num-6, Num-8, Num-10, 
    fmt.Println("Result:", csv) 
}
```

---

## 3. Empty Interfaces (`any`)

Sometimes, you genuinely don't know what type you will receive. The pre-1.18 solution was `interface{}`, which was explicitly aliased to `any` in Go 1.18.

An empty interface specifies zero methods. Because every type in Go implements at least zero methods, `any` can hold *anything*.

```go
package main

import "fmt"

func PrintAnything(item any) {
    // 1. Type Assertion
    // We attempt to safely pull the underlying "concrete" type out of the empty interface.
    if value, ok := item.(string); ok {
        fmt.Println("It's a string! Length:", len(value))
    }

    // 2. Type Switch (The preferred method)
    switch v := item.(type) {
    case int:
        fmt.Println("Integer:", v)
    case float64:
        fmt.Println("Float64:", v)
    default:
        fmt.Println("Unknown type!")
    }
}

func main() {
    PrintAnything("Hello")  // Matches string
    PrintAnything(3.14)     // Matches float64
    PrintAnything(true)     // Matches default
}
```

### Summary of Generics
Generics allow functional programming patterns to exist in Go without sacrificing type safety and compile-time verification. Use `[T any]` when building reusable library containers and algorithms. Use explicit structs and interfaces for typical business logic.

---

## 4. Dockerizing the Environment

To run the functional programming and generics examples, you must use Go 1.18 or higher. Our automated multi-stage `Dockerfile` handles this perfectly.

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
  go-fp:
    build: .
    container_name: golang_functional
```

Execute the build and run the logic isolated in the container:
```bash
docker compose up --build
```
