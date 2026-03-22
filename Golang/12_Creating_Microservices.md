# 12: Capstone: Creating Microservices in Go

This is the absolute capstone of the *Golang Mastery Curriculum*, inspired heavily by **Microservices with Go**. 

We will build a fully operational, multi-container architecture.
1. **The Gateway Service (REST API)**: Exposes a user-facing HTTP endpoint using Go's built-in `net/http` router.
2. **The Core Service (gRPC)**: A backend microservice that processes the data at lightning speed.
3. **The Orchestrator**: A `docker-compose.yml` that networks them together isolated from the host machine.

---

## 1. The Project Structure
Instead of putting everything in one folder, we separate the microservices.

```text
Golang/
├── docker-compose.yml
├── gateway-service/
│   ├── main.go
│   ├── Dockerfile
│   └── go.mod
└── core-service/
    ├── main.go
    ├── Dockerfile
    ├── go.mod
    └── proto/
        └── core.proto
```

For this demonstration, we assume `core.proto` defines a basic `ProcessData` gRPC call (as learned in Module 11).

---

## 2. The Core Service (Backend gRPC)

Because this service is not exposed to the public internet, it runs purely on gRPC.

### `core-service/main.go`
```go
package main

import (
    "context"
    "log"
    "net"
    "google.golang.org/grpc"
    pb "myapp/core/proto" // Pseudo-import of the generated protobuf code
)

type server struct {
    pb.UnimplementedCoreServiceServer
}

func (s *server) ProcessData(ctx context.Context, req *pb.DataRequest) (*pb.DataResponse, error) {
    log.Printf("[CORE] Received request from Gateway for: %s", req.GetPayload())
    
    // Simulate heavy backend database processing...
    return &pb.DataResponse{Result: "PROCESSED: " + req.GetPayload()}, nil
}

func main() {
    // 1. Listen on a TCP socket specifically for gRPC traffic
    lis, err := net.Listen("tcp", ":50051")
    if err != nil {
        log.Fatalf("[CORE] Failed to listen: %v", err)
    }

    // 2. Start the highly concurrent gRPC Server
    grpcServer := grpc.NewServer()
    pb.RegisterCoreServiceServer(grpcServer, &server{})

    log.Println("[CORE] Backend Microservice Booted - Listening on tcp/50051")
    if err := grpcServer.Serve(lis); err != nil {
        log.Fatalf("[CORE] Failed to serve: %v", err)
    }
}
```

---

## 3. The API Gateway (Frontend REST)

This service faces the user. It accepts standard HTTP JSON requests, opens a lightning-fast HTTP/2 gRPC connection to the Core service, gets the result, and returns it to the user.

### `gateway-service/main.go`
```go
package main

import (
    "context"
    "encoding/json"
    "log"
    "net/http"
    "os"
    "time"

    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
    pb "myapp/core/proto" // We share the exact same generated proto definitions!
)

func ProcessHandler(w http.ResponseWriter, r *http.Request) {
    // 1. Retrieve the target value from the URL query (e.g., ?payload=HelloWorld)
    payload := r.URL.Query().Get("payload")

    // 2. Access the Core Service
    // IMPORTANT: It accesses the service by its DOCKER CONTAINER NAME ("core-service"), not localhost!
    backend_addr := os.Getenv("CORE_SERVICE_ADDR")
    if backend_addr == "" {
        backend_addr = "core-service:50051" // Default Docker Compose DNS resolution
    }

    conn, err := grpc.Dial(backend_addr, grpc.WithTransportCredentials(insecure.NewCredentials()))
    if err != nil {
        http.Error(w, "Gateway Failed to connect to Core Backend", http.StatusInternalServerError)
        return
    }
    defer conn.Close()

    // 3. Execute the gRPC Call
    client := pb.NewCoreServiceClient(conn)
    ctx, cancel := context.WithTimeout(context.Background(), 2 * time.Second)
    defer cancel()

    rpcResp, err := client.ProcessData(ctx, &pb.DataRequest{Payload: payload})
    if err != nil {
        http.Error(w, "Core Service Processing Failed", http.StatusInternalServerError)
        return
    }

    // 4. Return to the User as JSON
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]string{
        "status": "success",
        "data":   rpcResp.GetResult(),
    })
}

func main() {
    // Standard Go built-in router
    http.HandleFunc("/api/process", ProcessHandler)
    
    log.Println("[GATEWAY] Booted - Listening for Public HTTP REST traffic on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}
```

---

## 4. The Docker Orchestration

Because we are using Go, both microservices use the exact same highly optimized `FROM scratch` `Dockerfile` template.

### `docker-compose.yml`
This file creates a secure virtual network holding both containers. Only the Gateway is exposed to your laptop's browser.

```yaml
version: '3.8'

services:
  # The Backend gRPC worker
  core-service:
    build: 
      context: ./core-service
    container_name: golang_core
    # Notice we DO NOT expose port 50051 to the public. 
    # It communicates implicitly on the internal Docker network.

  # The Frontend API Gateway
  gateway-service:
    build: 
      context: ./gateway-service
    container_name: golang_gateway
    depends_on:
      - core-service
    ports:
      - "8080:8080"
    environment:
      # Inject the Core Service's internal Docker DNS name into the Gateway
      - CORE_SERVICE_ADDR=core-service:50051 
```

### Starting the System
Run the entire architecture with one command:
```bash
docker compose up --build
```
You can now open your browser or use `curl`:
```bash
curl "http://localhost:8080/api/process?payload=GoIsIncredible"
```

The Gateway interprets the REST call, initiates a gRPC binary procedure against the Core Service, waits for the result, and replies with JSON. 

## Final Conclusion
You have mastered Go. From the absolute basics of variable declaration, through Struct composition, explicit Error Handling, Goroutine multithreading, and System Operations, you have arrived at the pinnacle: A multi-container Dockerized Architecture speaking high-performance RPC protocols. 

The standard library in Go provides all of these capabilities out of the box. There are no heavy frameworks, no massive virtual machines, and no complex inheritance patterns. Just pure, pragmatic software engineering.
