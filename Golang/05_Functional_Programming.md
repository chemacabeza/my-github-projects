# 05: Functional Programming and Generics (Go 1.18+)

<p align="center">
  <img src="images/go_ch05_functional.png" alt="Go Functional Programming and Generics" width="100%"/>
</p>

> 🧠 **The Feynman Hook:** Before Go 1.18, if you wanted a `Filter` function that worked on both `[]int` and `[]string`, you had two options: copy-paste the function twice (ugly) or use `interface{}` and cast at runtime (slow and unsafe). Generics solve this with a single elegant concept: **type parameters**. `[T any]` says "T is a placeholder — fill it in at compile time with the actual type." The compiler then generates the specialised version for you. You write the algorithm once. The compiler instantiates it for every type you use it with — and if you try to use it with the wrong type, it fails at compile time, not runtime.

While Go is predominantly imperative, it fully supports first-class functions, closures, and anonymous functions. Furthermore, Go 1.18 introduced **Generics** (Type Parameters), which radically revolutionised how Go handles functions over different data types.

---

## 1. First-Class Functions and Closures

> **Feynman Insight:** When a function is "first-class," it means you can treat it like any other value: store it in a variable, pass it as an argument, return it from a function. A **closure** is a function that "closes over" variables from its surrounding scope — it keeps those variables alive in memory even after the parent function has returned. A `MakeMultiplier(3)` call returns a new function that permanently remembers `factor = 3`. Each call to `MakeMultiplier` creates a completely independent closure with its own private copy of `factor`.

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

## 2. The `map`, `filter`, and `reduce` Concepts with Generics

> **Feynman Insight:** Think of these three operations as a factory assembly line. **Filter** is the quality control station: it checks each item against a criterion and discards the ones that fail (`isEven`). **Map** is the transformation station: it converts every passing item into a new form (integer `4` becomes string `"Num-4"`). **Reduce** is the packing station: it squashes the entire collection into one unit (all strings concatenated into one CSV). Before Go 1.18, you'd need a separate `FilterInts`, `FilterStrings`, `FilterUsers` for each type. With `[T any]`, you write `Filter` once and the compiler specialises it for every type you use.

Before Go 1.18, writing a generic `map` or `filter` function was impossible without resorting to the notoriously slow `interface{}`. Now, we define Type Parameters using `[T any]` or `[T comparable]`.

```go
package main

import "fmt"

// 1. Filter: Applies an anonymous predicate function (T -> bool) to a generic slice of T.
func Filter[T any](input []T, predicate func(T) bool) []T {
    var result []T

    for _, item := range input {
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

> **Feynman Insight:** The `any` type is Go's "universal adapter plug." Just as a universal adapter fits any socket because it makes no assumptions about voltage or prong shape, `any` accepts any value because it requires zero methods. However, once you've plugged something into `any`, you need a **Type Assertion** to extract the original type back — like checking "is this actually a 230V UK plug?" with `value, ok := item.(string)`. The `ok` boolean tells you whether the assertion succeeded without panicking. The **Type Switch** is the cleaner version: try UK, try EU, try US, default to unknown — all in one readable block.

Sometimes, you genuinely don't know what type you will receive. The pre-1.18 solution was `interface{}`, which was explicitly aliased to `any` in Go 1.18.

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

---

## 4. Dockerizing the Environment

To run the functional programming and generics examples, you must use Go 1.18 or higher.

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

```bash
docker compose up --build
```

---

## 🤔 Reflection Questions

1. **What problem do Generics solve that `interface{}` does not?**
<details>
<summary>💡 View Answer</summary>

`interface{}` (now aliased as `any`) loses type information at compile time. You must use `reflect` or type assertions at **runtime** to get the concrete type back — which is slow and can panic if incorrect. Generics (`[T any]`) are resolved entirely at **compile time**: the compiler generates a specialised version of the function for each concrete type used. This gives you both the reusability of `interface{}` AND the performance and type-safety of concrete types. The Go standard library's `slices` and `maps` packages (Go 1.21+) are built with generics.
</details>

2. **What is a closure, and why is it useful?**
<details>
<summary>💡 View Answer</summary>

A **closure** is a function that captures and retains access to variables from the scope where it was created, even after that scope has exited. `MakeMultiplier(3)` returns an anonymous function that permanently holds `factor = 3` in memory — even after `MakeMultiplier` has returned. This is the foundation of: **middlewares** (closures wrapping HTTP handlers with auth logic), **callback factories** (generating event handlers with pre-filled parameters), and **memoisation** (closures that cache previous results in a captured map).
</details>

---

## 📝 Key Interview Talking Points

- **First-class functions** mean Go supports functional patterns: you can pass `func(int) bool` as arguments.
- **Closures capture variables by reference** — if a goroutine captures a loop variable `i`, always pass `i` as a parameter instead of capturing, to avoid the classic concurrent closure bug.
- **`[T any]` vs `[T comparable]`**: `comparable` constrains T to types that support `==` (needed for maps and equality checks). `any` is completely unconstrained.
- **Generics are zero-cost at runtime** — the compiler generates specialised code per type. No boxing, no `reflect`, no runtime overhead.
- **Type Switch** is the idiomatic way to handle `any` values — prefer it over repeated type assertions.
