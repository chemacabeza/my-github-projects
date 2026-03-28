# 11: Microservices Architecture

<p align="center">
  <img src="images/sd_microservices.png" alt="Microservices Architecture" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand how to decompose a monolith into microservices, the patterns that make them resilient, and the trade-offs involved.**

---

## 1. Monolith vs Microservices

```
MONOLITH:                          MICROSERVICES:
┌──────────────────────┐           ┌──────┐ ┌──────┐ ┌──────┐
│   All code in one    │           │ User │ │Order │ │ Pay  │
│   deployable unit    │    →      │ Svc  │ │ Svc  │ │ Svc  │
│   Single database    │           └──┬───┘ └──┬───┘ └──┬───┘
└──────────────────────┘              │DB1│    │DB2│    │DB3│
```

| Aspect | Monolith | Microservices |
| :--- | :--- | :--- |
| **Deployment** | One unit | Each service independently |
| **Scaling** | Scale everything | Scale individual services |
| **Tech Stack** | One language/framework | Each service chooses its own |
| **Complexity** | Simple initially | Distributed system complexity |
| **Team** | One team | Independent teams per service |
| **Failure** | Single failure = everything down | Isolated failures |

---

## 2. Service Decomposition Strategies

| Strategy | How | Example |
| :--- | :--- | :--- |
| **By Business Domain** | One service per domain | UserService, OrderService, PaymentService |
| **By Subdomain (DDD)** | Bounded contexts | "Shipping" context separate from "Billing" |
| **Strangler Fig** | Gradually replace monolith pieces | Route new features to microservices |

---

## 3. Resilience Patterns

### Circuit Breaker
```
CLOSED → calls pass through normally
  │ (failures exceed threshold)
  ▼
OPEN → all calls fail immediately (fast-fail)
  │ (timeout expires)
  ▼
HALF-OPEN → allow one test call
  │ (success → CLOSED, failure → OPEN)
```

### Other Patterns:
| Pattern | Purpose |
| :--- | :--- |
| **Retry with Backoff** | Retry failed calls with increasing delay |
| **Timeout** | Don't wait forever for a response |
| **Bulkhead** | Isolate failures to one service pool |
| **Fallback** | Return cached/default data on failure |

---

## 4. Service Communication

| Pattern | Type | Use Case |
| :--- | :--- | :--- |
| **REST/HTTP** | Synchronous | Simple request-response |
| **gRPC** | Synchronous | High-performance internal calls |
| **Message Queue** | Asynchronous | Decoupled, event-driven |
| **Event Bus** | Asynchronous | Pub/sub notifications |

---

## 5. Service Discovery

```
SERVICE REGISTRY (Consul, etcd):
  ┌──────────────────────┐
  │ UserService: 10.0.1.5│
  │ OrderService: 10.0.2.3│
  │ PayService: 10.0.3.7  │
  └──────────────────────┘
       ↑ register     ↓ discover
   [Services]      [API Gateway]
```

---

## 📝 Key Interview Talking Points

- Start with a monolith; extract microservices when team/scale demands it
- Each service owns its own database (no shared DB!)
- Circuit breaker prevents cascading failures across services
- Use async messaging for decoupling; sync calls for real-time needs

---

[<< Previous: API Design](./10_API_Design_and_Gateway.md) | [Home: Curriculum Map](./README.md) | [Next: Data Pipelines >>](./12_Data_Processing_Pipelines.md)
