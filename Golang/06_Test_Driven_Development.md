# 06: Test-Driven Development (TDD)

Go completely ignores third-party testing frameworks (like JUnit or pytest). Instead, testing is a first-class citizen embedded directly into the compiler toolchain: `go test`.

Drawing from *Test-Driven Development in Go*, we learn that if your code doesn't have a parallel `_test.go` file right beside it, it shouldn't go to production.

---

## 1. The built-in `testing` package

Test files must end in `_test.go`. Test functions must start with `Test` and take a pointer to `testing.T` as their only parameter.

### `calculator.go` (The implementation)
```go
package mathops

import "errors"

func Add(a, b int) int {
    return a + b
}

func Divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("cannot divide by zero")
    }
    return a / b, nil
}
```

### `calculator_test.go` (The Test file)
```go
package mathops

import "testing"

// 1. The Basic Test
func TestAdd(t *testing.T) {
    result := Add(2, 3)
    expected := 5

    // If it fails, we explicitly call t.Errorf (which fails the test and continues)
    // or t.Fatalf (which explicitly stops execution immediately).
    if result != expected {
        t.Errorf("Expected %d, got %d", expected, result)
    }
}
```

---

## 2. Table-Driven Tests (The Go Idiom)

Writing one function per test case is extremely verbose and discouraged in Go. Instead, the community standard is **Table-Driven Tests**.

We define a massive array of anonymous structs containing all possible testing states, and iterate through them.

```go
package mathops

import "testing"

func TestDivideTableDriven(t *testing.T) {
    // 1. Define the Struct slice describing the inputs and expected outputs
    tests := []struct {
        name        string
        a, b        int
        expected    int
        expectError bool
    }{
        {"Normal Division", 10, 2, 5, false},
        {"Negative Division", -10, 2, -5, false},
        {"Zero Division Error", 10, 0, 0, true},
        {"Large Number Division", 1000, 10, 100, false},
    }

    // 2. Loop through the test structs
    for _, tt := range tests {
        // 3. Run a sub-test block using t.Run (Allows running specific tests by name on the CLI)
        t.Run(tt.name, func(t *testing.T) {
            
            result, err := Divide(tt.a, tt.b)

            if tt.expectError {
                if err == nil {
                    t.Errorf("Expected an error but got none!")
                }
            } else {
                if err != nil {
                    t.Errorf("Received unexpected error: %v", err)
                }
                if result != tt.expected {
                    t.Errorf("Expected %d, got %d", tt.expected, result)
                }
            }
        })
    }
}
```

**Running the tests:**
From your terminal, simply run:
```bash
go test -v ./...
```
The compiler automatically finds all `_test.go` files and recursively runs them, outputting a highly readable passed/failed result block.

---

## 3. Mocking Dependencies via Interfaces

How do you test a function that writes to a real PostgreSQL database or hits the AWS API? You don't. You Mock it.

In Go, we don't need heavyweight mocking frameworks. Because Interfaces are fulfilled implicitly (covered in Module `02`), we simply have our test pass a *fake struct* that has the same methods!

### `database.go` (The Production Interface)
```go
package repository

import "fmt"

// 1. Define the Behavior
type Datastore interface {
    SaveUser(username string) error
}

type PostgresDB struct {}

func (db PostgresDB) SaveUser(username string) error {
    fmt.Println("Connecting to Real Postgres DB -> Network Latency...")
    return nil // Simulates a successful real network call
}

// 2. Dependency Injection
func RegisterNewUser(db Datastore, username string) error {
    // We only care that 'db' can SaveUser(). We don't care IF it's Postgres!
    return db.SaveUser(username) 
}
```

### `database_test.go` (The Mock Injection)
```go
package repository

import "testing"

// 1. Create a Fake/Mock Implementation
type MockDB struct {
    MockError error // We can manipulate this from the test to simulate failures!
    CallCount int
}

// It implicitly fulfills Datastore!
func (m *MockDB) SaveUser(username string) error {
    m.CallCount++
    return m.MockError // Instantly returns whatever we programmed it to return
}

func TestRegisterNewUser(t *testing.T) {
    // Inject the fast, fake database into the Register function!
    mockStore := &MockDB{MockError: nil} 

    err := RegisterNewUser(mockStore, "test_admin")
    
    if err != nil {
        t.Errorf("Expected registration to succeed")
    }

    if mockStore.CallCount != 1 {
        t.Errorf("Expected MockDB to be called exactly 1 time")
    }
}
```

### Dockerizing the Testing execution
To run tests universally via Docker, we don't need a multi-stage `FROM scratch` build because tests only run during the build/CI pipeline.

**`Dockerfile.test`**
```dockerfile
FROM golang:1.22-alpine
WORKDIR /app
COPY . .
# Setting the entrypoint strictly to run the test framework
ENTRYPOINT ["go", "test", "-v", "./..."]
```

Run via `docker build -f Dockerfile.test . && docker run --rm <image_id>`

### Summary
The `_test.go` architecture guarantees that your test code ships alongside your business context. Dependency Injection using Implicit Interfaces allows incredibly lightweight mocking, maintaining Go's ideology of minimal abstraction and profound simplicity.
