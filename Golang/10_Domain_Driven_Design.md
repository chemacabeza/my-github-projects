# 10: Domain-Driven Design (Hexagonal Architecture)

As we enter Phase 4, we examine how to structure enterprise Go applications based on **Hands-On Software Architecture with Golang** and **Domain-Driven Design with Golang**.

For scripts, putting everything in `main.go` is fine. For Microservices, it guarantees chaos. Go developers heavily favor **Hexagonal Architecture** (also known as Ports & Adapters) or clean layered architecture.

---

## 1. The Problem with Tight Coupling

If your REST Controller directly imports an Amazon S3 SDK to upload an image, you are doomed. If you decide to switch to Google Cloud or a local disk, you must rewrite the entire REST API layer. 

Worse: You cannot write Unit Tests without charging your credit card!

---

## 2. Hexagonal Architecture (Ports and Adapters)

In Hexagonal Architecture, the Application **Core (Domain)** has absolutely zero dependencies. It does not know what HTTP is. It does not know what PostgreSQL is.

It communicates with the outside world purely through **Interfaces (Ports)**.
The outside world plugs into these Ports using **Implementations (Adapters)**.

### The Domain (Core Logic)
This is pure Go code. No frameworks.

**`domain/user.go`**
```go
package domain

// The Core Business Entity
type User struct {
    ID    string
    Email string
}

// THE PORT (Interface): This defines what the Domain NEEDS from the outside world.
// It doesn't care if it's MySQL, MongoDB, or a dummy map!
type UserRepository interface {
    Save(u User) error
    FindByID(id string) (User, error)
}

// The Core Service
type UserService struct {
    // The Service holds the Port Interface, never a concrete database struct!
    repo UserRepository 
}

// Dependency Injection Factory
func NewUserService(repo UserRepository) UserService {
    return UserService{repo: repo}
}

// Business Logic
func (s UserService) RegisterUser(email string) error {
    if email == "" {
        return fmt.Errorf("email cannot be empty")
    }
    newUser := User{ID: "USR-001", Email: email}
    
    // Calls the interface, completely unaware of WHERE it's saving.
    return s.repo.Save(newUser) 
}
```

---

## 3. The Adapters (Plugging into the Ports)

Now, we write concrete implementations for the outside layers.

### The Database Adapter (Driven Adapter)
This plugs into the outgoing `UserRepository` Port.

**`adapters/postgres_repo.go`**
```go
package adapters

import (
    "fmt"
    // import "database/sql"
    // import _ "github.com/lib/pq"
)

type PostgresUserRepository struct {
    ConnectionString string
}

// Implicitly fulfills domain.UserRepository!
func (db PostgresUserRepository) Save(u domain.User) error {
    fmt.Printf("[POSTGRES] Opening transaction... Executing INSERT for %s\n", u.Email)
    return nil // Simulates success
}

func (db PostgresUserRepository) FindByID(id string) (domain.User, error) {
    return domain.User{ID: id, Email: "found@db.local"}, nil
}
```

### The REST API Adapter (Driving Adapter)
This triggers the Application Core from an HTTP request.

**`adapters/http_handler.go`**
```go
package adapters

import (
    "fmt"
    "net/http"
    "myapp/domain"
)

type UserHandler struct {
    service domain.UserService
}

func NewUserHandler(service domain.UserService) UserHandler {
    return UserHandler{service: service}
}

// A standard Go net/http handler
func (h UserHandler) RegisterEndpoint(w http.ResponseWriter, r *http.Request) {
    email := r.URL.Query().Get("email")
    
    // Call the Domain Core
    err := h.service.RegisterUser(email)
    
    if err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    w.WriteHeader(http.StatusCreated)
    w.Write([]byte("User formally registered!"))
}
```

---

## 4. The `main.go` Wiring (Dependency Injection)

The `main` package acts uniquely as the glue. It imports the Core, imports the Adapters, wires them together, and starts the server.

**`main.go`**
```go
package main

import (
    "log"
    "net/http"
    "myapp/domain"
    "myapp/adapters"
)

func main() {
    // 1. Instantiate the Database Adapter
    db := adapters.PostgresUserRepository{ConnectionString: "postgres://admin:pass@db:5432/core"}

    // 2. Inject the Database into the Core Domain Service
    userService := domain.NewUserService(db)

    // 3. Inject the Core Service into the HTTP REST Handler
    userHandler := adapters.NewUserHandler(userService)

    // 4. Start the Web Server
    http.HandleFunc("/register", userHandler.RegisterEndpoint)
    
    log.Println("Domain-Driven Microservice Booting on :8080...")
    log.Fatal(http.ListenAndServe(":8080", nil))
}
```

### Testing is Trivial
To write tests for `domain/user.go`, we NEVER invoke Docker or PostgreSQL. We pass a `MockUserRepository` (as learned in Module `06`) directly into `NewUserService` and execute the unit tests instantly.

### Summary
Clean Architecture guarantees that business logic controls the infrastructure, not the other way around. By isolating frameworks inside Adapters, transferring from an HTTP REST endpoint to a high-speed gRPC interface requires touching exclusively the Adapter layer. The core remains untouched. 

We explore that extreme performance gRPC transition in the next guide: `11_gRPC_and_Protobufs.md`.

---

## 5. Dockerizing the Hexagonal Architecture

Even with a massive amount of internal folders (`domain`, `adapters`), compiling a multi-package Go project results in one single static binary file.

**`Dockerfile`**
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
# We copy everything, so the Go compiler can find all adapter/domain packages
COPY . .
RUN CGO_ENABLED=0 go build -o my_microservice .

FROM scratch
COPY --from=builder /app/my_microservice /
EXPOSE 8080
ENTRYPOINT ["/my_microservice"]
```

**`docker-compose.yml`**
```yaml
version: '3.8'
services:
  go-ddd:
    build: .
    container_name: golang_hexagonal
    ports:
      - "8080:8080"
```

Boot the API locally:
```bash
docker compose up --build
```
