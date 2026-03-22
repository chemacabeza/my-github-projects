# 07: Data Structures and Algorithms in Go

Go does not hide memory operations behind massive object hierarchies. Inspired by *Learn Data Structures and Algorithms with Golang*, we must understand Go's three primary built-in data types: Arrays, Slices, and Maps.

---

## 1. Arrays vs Slices (The Slice Header)

In Go, an **Array** has a fixed length defined at compile time. It is passed by value (copied entirely). 
A **Slice** is dynamic. It is essentially a 24-byte header (Pointer, Length, Capacity) pointing to an underlying hidden Array.

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
}
```

### Understanding Capacity Growth
When a slice exceeds its `Capacity` (not Length), Go allocates a brand-new contiguous block of memory in the background (typically double the previous size), copies the old array into the new array, and updates the Slice Header pointer. This is an $O(n)$ operation! Pre-allocate using `make` when building heavily populated algorithms.

---

## 2. Maps (Hash Tables)

Go provides a built-in highly optimized Hash Table called a `map`. Maps provide $O(1)$ average time complexity for inserts, updates, and lookups.

**CRITICAL RULE:** A Map points to memory. If you declare a map without initializing it via `make()`, it is a `nil map` and writing to it will instantly instantly crash (`panic`) the program.

### `main.go`
```go
package main

import "fmt"

func main() {
    // 1. DANGER: Declaring a nil map
    var brokenMap map[string]int
    // brokenMap["apple"] = 5 // PANIC! Attempted to write to a nil map.

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

## 3. Implementing a Basic Queue (FIFO Structure)

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
Add your standard multi-stage `Dockerfile`:
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o app main.go

FROM scratch
COPY --from=builder /app/app /
ENTRYPOINT ["/app"]
```
Run `docker build -t go-data . && docker run --rm go-data`
