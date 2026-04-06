# 07: Data Structures and Algorithms in Go

<p align="center">
  <img src="images/go_ch07_data_structures.png" alt="Go Data Structures and Algorithms" width="100%"/>
</p>

> 🧠 **The Feynman Hook:** In most high-level languages, data structures are hidden behind abstractions. In Go, they're transparent. A **Slice** is not magic — it's a 24-byte struct containing three fields: a pointer to an underlying array, a length, and a capacity. When you understand this, everything about slices suddenly makes sense: why passing a slice to a function doesn't copy all the data (only those 24 bytes are copied), why `append` can sometimes mutate the original (if the underlying array is shared), and why pre-allocating with `make` is faster (no hidden reallocations needed).

Go does not hide memory operations behind massive object hierarchies. Understanding Go's three primary built-in data types — Arrays, Slices, and Maps — is essential for writing efficient code.

---

## 1. Arrays vs Slices (The Slice Header)

> **Feynman Insight:** An **Array** is a fixed-length metal bar: you specify the length when you forge it, it never bends or grows. A **Slice** is a rubber band: it starts small and stretches. But crucially — the rubber band doesn't store the rubber itself; it's a *handle* with three controls: "point to this block of rubber", "this many links are active (Length)", "this block can hold this many before needing to expand (Capacity)". When you `append` past the Capacity, Go secretly creates a **new, larger block** and copies everything over. This O(n) reallocation is why pre-allocating via `make([]int, 0, 100)` matters: no secret copies.

In Go, an **Array** has a fixed length defined at compile time. It is passed by value (copied entirely).
A **Slice** is dynamic — a 24-byte header (Pointer, Length, Capacity) pointing to an underlying hidden Array.

### `main.go`
```go
package main

import "fmt"

func main() {
    // 1. ARRAY: Fixed length, passed by value
    var scores [3]int = [3]int{10, 20, 30}
    // scores[3] = 40 // HARD COMPILER ERROR: Out of bounds!

    // 2. SLICE: The default Go data structure
    // Notice the lack of a size inside the brackets []
    points := []int{10, 20, 30, 40}

    // You can dynamically append to a slice
    points = append(points, 50, 60)

    // The 'len' and 'cap' functions
    fmt.Printf("Length: %d, Capacity: %d\n", len(points), cap(points))

    // 3. Pre-allocating Capacity for Performance using 'make'
    // This creates a slice of length 0, but pre-allocates contiguous memory for *100* integers.
    // This avoids slow reallocation when appending!
    fastSlice := make([]int, 0, 100)
    for i := 0; i < 50; i++ {
        fastSlice = append(fastSlice, i) // Never reaches capacity limit, zero reallocation overhead.
    }
    fmt.Println("Fast slice length:", len(fastSlice))
}
```

### Understanding Capacity Growth

> **Feynman Insight:** When a slice's Length hits its Capacity, Go secretly does three things: (1) creates a new array in memory, typically 2x the old size, (2) copies all existing elements across, (3) updates the slice header pointer. This is an **O(n)** copy — the entire slice is copied. If you're appending 10,000 items in a loop without pre-allocating, Go does this copy roughly log₂(10,000) ≈ 13 times. Pre-allocating with `make([]int, 0, 10000)` reduces this to exactly zero copies.

---

## 2. Maps (Hash Tables)

> **Feynman Insight:** A Map is a dictionary. The dictionary *index* (key) gives you instant access to any entry (O(1) average lookup). The critical bug trap: if you declare a map variable without `make()` — `var m map[string]int` — the variable is `nil`, pointing to nothing. Writing to it (`m["x"] = 5`) causes a panic: "assignment to entry in nil map." You must always initialise a map with `make(map[string]int)` before writing. The **comma-ok** lookup pattern — `value, ok := m["key"]` — is how you distinguish between "this key has a value of 0" and "this key does not exist" (both would return `0` with a plain lookup).

Maps provide $O(1)$ average time complexity for inserts, updates, and lookups.

**CRITICAL RULE:** A Map points to memory. If you declare a map without initialising it via `make()`, it is a `nil map` and writing to it will instantly crash (`panic`).

### `main.go`
```go
package main

import "fmt"

func main() {
    // 1. DANGER: Declaring a nil map
    var brokenMap map[string]int
    // brokenMap["apple"] = 5 // PANIC! Attempted to write to a nil map.
    _ = brokenMap // Suppress unused variable error

    // 2. Safe Initialization
    inventory := make(map[string]int)

    // Insertion
    inventory["health_potion"] = 5
    inventory["mana_potion"] = 2

    // 3. Safe Lookup (The comma-ok idiom)
    // Looking up "gold" returns 0 instead of crashing.
    // Is it 0 because we possess 0 gold, or 0 because the key doesn't exist?
    // We use the second return boolean, classically named 'ok'.
    value, ok := inventory["gold"]
    if !ok {
        fmt.Println("Item does not exist in the hash table.")
    } else {
        fmt.Printf("We have %d gold.\n", value)
    }

    // 4. Deleting a key-value pair
    delete(inventory, "mana_potion")

    // 5. Iteration over a Map
    // Hash maps are completely unordered! Run this multiple times and the output order will change.
    for key, count := range inventory {
        fmt.Printf("Key: %s | Value: %d\n", key, count)
    }
}
```

---

## 3. Implementing a Generic Queue (FIFO Structure)

> **Feynman Insight:** A Queue is a supermarket checkout queue: the first person in line is the first served (First-In, First-Out). Go has no built-in Queue object — you build one from a Slice. The trick: `Enqueue` (push) appends to the end of the slice. `Dequeue` (pop) removes from the front by re-slicing: `q.elements = q.elements[1:]`. Warning: this slicing doesn't actually free the old element's memory — the underlying array still holds it. For a high-throughput production queue, use a linked list or a ring buffer instead to avoid this memory leak pattern.

Since Go doesn't provide standard Stack/Queue objects, we build them manually using Slices.

### `queue.go`
```go
package main

import "fmt"

// A generic Queue supporting any type T
type Queue[T any] struct {
    elements []T
}

// 1. Generic Push (Add to the end)
// We must use a pointer receiver (*Queue) to actually mutate the original slice!
func (q *Queue[T]) Enqueue(item T) {
    q.elements = append(q.elements, item)
}

// 2. Generic Pop (Remove from the front)
func (q *Queue[T]) Dequeue() (T, bool) {
    if len(q.elements) == 0 {
        var zero T // Retrieves the zero-value of whatever T is
        return zero, false
    }

    // Extract the FIRST element [0]
    head := q.elements[0]

    // Slice syntax: Reassign the list holding everything FROM index 1 up to the end
    // Warning: This can cause memory leaks in massive long-running queues.
    q.elements = q.elements[1:]

    return head, true
}

func main() {
    q := Queue[string]{}
    q.Enqueue("Job A")
    q.Enqueue("Job B")

    fmt.Println(q.elements) // Output: [Job A Job B]

    completed, ok := q.Dequeue()
    if ok {
        fmt.Println("Processed:", completed) // Processed Job A
    }

    fmt.Println(q.elements) // Output: [Job B]
}
```

### Docker Execution
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o app main.go

FROM scratch
COPY --from=builder /app/app /
ENTRYPOINT ["/app"]
```
```bash
docker build -t go-data . && docker run --rm go-data
```

---

## 🤔 Reflection Questions

1. **Why is writing to a nil map a runtime panic, not a compile error?**
<details>
<summary>💡 View Answer</summary>

The Go compiler cannot know at compile time whether a map variable will be nil at the moment of writing — the map could be conditionally initialised based on runtime logic. The compiler can only enforce things knowable at compile time (like "you haven't used this variable" or "this type doesn't match"). Nil map panics are runtime errors because the nil state is a runtime condition. The solution is always `make(map[K]V)` for any map you intend to write to — use `var m map[K]V` only for maps you'll receive from other functions.
</details>

2. **Why does map iteration order change between runs?**
<details>
<summary>💡 View Answer</summary>

Go intentionally **randomises** map iteration order. This was a deliberate design decision (introduced in Go 1.1) to prevent developers from accidentally depending on map order — which is not guaranteed by any hash table implementation and would break catastrophically if the internal implementation changed. If you need ordered map output, collect the keys into a slice, `sort.Strings(keys)`, and iterate the slice. The `golang.org/x/exp/maps` package provides sorted key utilities.
</details>

---

## 📝 Key Interview Talking Points

- **Slice = (Pointer, Length, Capacity)** — the 24-byte header. Passing a slice to a function copies these 24 bytes, NOT the underlying data.
- **`append` may or may not mutate the original** — if capacity is not exceeded, it writes in place; if exceeded, it creates a new backing array.
- **Pre-allocate with `make([]T, 0, n)`** when building slices in performance-critical loops to avoid O(n log n) reallocation.
- **The comma-ok idiom for maps** — `v, ok := m[k]`. Always use `ok` when the zero value for the value type is a valid map entry.
- **`delete(m, key)` is safe on nil maps** — it does nothing, unlike writing to a nil map which panics.
