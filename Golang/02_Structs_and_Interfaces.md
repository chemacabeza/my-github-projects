# 02: Structs and Interfaces (Go's OOP)

If you have a background in Java, Python, or C++, learning Go requires unlearning traditional Object-Oriented Programming (OOP). 

Go has **no classes**, **no inheritance (`extends`)**, and **no constructors**. Instead, it utilizes **Composition** via `Structs` and **Implicit Behavior** via `Interfaces`.

---

## 1. Structs (Data Aggregation)

A `struct` is simply a blueprint that groups together variables (fields).

### `main.go`
```go
package main

import "fmt"

// Define a struct
type User struct {
    ID       int
    Username string
    Email    string
    IsActive bool
}

func main() {
    // 1. Instantiation (Zero Value)
    // If you don't assign values, Go assigns "Zero Values" (0, "", false).
    var u1 User 

    // 2. Instantiation (Struct Literal)
    u2 := User{
        ID:       101,
        Username: "gopher",
        Email:    "gopher@golang.org",
        IsActive: true,
    }

    // 3. Pointers to Structs (Fast references)
    // The built-in 'new' keyword allocates memory and returns a pointer (*User)
    u3 := new(User)
    u3.Username = "admin" // Notice we don't need '->' like C++. Go auto-dereferences!

    fmt.Printf("User 1: %+v\n", u1) // %+v prints the field names!
    fmt.Printf("User 2: %+v\n", u2)
    fmt.Printf("User 3 (Pointer): %+v\n", *u3)
}
```

---

## 2. Methods (Behavior)

Instead of placing functions *inside* a class, Go attaches functions to structs using a **Receiver Argument**.

```go
package main

import "fmt"

type Rectangle struct {
    Width  float64
    Height float64
}

// VALUE RECEIVER: Operates on a *copy* of the struct.
// Use this if you don't need to modify the data.
func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

// POINTER RECEIVER: Operates on the *original* memory address.
// Use this if you need to mutate the struct!
func (r *Rectangle) Scale(multiplier float64) {
    r.Width *= multiplier
    r.Height *= multiplier
}

func main() {
    rect := Rectangle{Width: 10, Height: 5}
    
    fmt.Println("Original Area:", rect.Area()) // Output: 50

    rect.Scale(2) // Mutates the original struct
    
    fmt.Println("Scaled Area:", rect.Area())   // Output: 200
}
```

---

## 3. Composition (Instead of Inheritance)

Go intentionally omits `extends`. If a `Car` needs the features of an `Engine`, you embed an engine inside it. This is called **Struct Embedding** or **Composition over Inheritance**.

```go
package main

import "fmt"

type Engine struct {
    Horsepower int
}

func (e Engine) Start() {
    fmt.Printf("Engine starting with %d HP!\n", e.Horsepower)
}

// Car "embeds" Engine. 
// It does not inherit from it, it holds it.
type Car struct {
    Make  string
    Model string
    Engine // Anonymous embedded field
}

func main() {
    myCar := Car{
        Make:  "Tesla",
        Model: "Model S",
        Engine: Engine{
            Horsepower: 1020,
        },
    }

    // Because Engine is embedded anonymously, we can call Start() directly on Car!
    // We don't have to write myCar.Engine.Start() (though that works too).
    myCar.Start() 
}
```

---

## 4. Interfaces (Implicit Fulfillment)

This is Go's most powerful feature. In Java, a class must explicitly declare it implements an interface: `class User implements Notifier`.

In Go, **Interfaces are fulfilled implicitly**. If a Struct has the exact methods described by an Interface, it automatically fulfills that Interface. No `implements` keyword required!

```go
package main

import "fmt"

// 1. The Interface
// Describes BEHAVIOR, not data.
type Speaker interface {
    Speak() string
}

// 2. Struct A
type Dog struct {
    Name string
}

// Dog implicitly implements Speaker just by having this method!
func (d Dog) Speak() string {
    return "Woof! My name is " + d.Name
}

// 3. Struct B
type Robot struct {
    ModelID int
}

// Robot implicitly implements Speaker too!
func (r Robot) Speak() string {
    return fmt.Sprintf("Beep. I am unit %d", r.ModelID)
}

// 4. Polymorphic Function
// Accepts ANYTHING that fulfills the Speaker interface.
func Announce(s Speaker) {
    fmt.Println("Announcement:", s.Speak())
}

func main() {
    d := Dog{Name: "Rex"}
    r := Robot{ModelID: 9000}

    // Both can be passed into Announce because they both have a Speak() string method.
    Announce(d)
    Announce(r)
}
```

---

## 5. Dockerizing the Examples

To run any of the code snippets above locally, you can use the exact same multi-stage Docker setup from `01_Basics_and_Environment.md`.

### `Dockerfile`
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM scratch
COPY --from=builder /app/app /app
ENTRYPOINT ["/app"]
```

### `docker-compose.yml`
```yaml
version: '3.8'
services:
  go-oop:
    build: .
    container_name: golang_oop
```
```bash
docker compose up --build
```
