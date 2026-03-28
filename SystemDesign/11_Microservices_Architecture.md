# 11: Microservices Architecture

<p align="center">
  <img src="images/sd_microservices.png" alt="Microservices Architecture" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand how to decompose a monolith into microservices, the patterns that make them resilient, and the trade-offs involved.**

---

## 1. Monolith vs Microservices

<p align="center">
  <img src="images/sd_monolith_micro.png" alt="Monolith vs Microservices" width="700"/>
</p>

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

## 🤔 Reflection Questions

1. **"We should rewrite our monolith as microservices."** Your startup has a team of 5 engineers and 10,000 users. Is this the right move right now? What would you need to see in terms of team size, traffic, and pain points before recommending the migration?

2. **The circuit breaker for your payment service is OPEN, and all payment calls fail-fast.** But some payment providers are still healthy — only one is down. How would you make the circuit breaker more fine-grained without adding unmanageable complexity?

3. **Each microservice owns its own database, but you need to join data from Users, Orders, and Products for a report.** How do you generate this report without violating the "no shared database" rule? What patterns help solve cross-service data queries?

4. **Your microservices use synchronous REST calls in a chain: A→B→C→D.** If D is slow, the latency cascades back through all services. How does this "distributed monolith" problem negate the benefits of microservices? What communication pattern would you recommend instead?

5. **Service discovery shows 20 instances of OrderService, but 3 are unhealthy and returning errors.** How does the service registry detect and remove unhealthy instances? What happens to in-flight requests during deregistration?

---

## 📝 Key Interview Talking Points

- Start with a monolith; extract microservices when team/scale demands it
- Each service owns its own database (no shared DB!)
- Circuit breaker prevents cascading failures across services
- Use async messaging for decoupling; sync calls for real-time needs

---

[<< Previous: API Design](./10_API_Design_and_Gateway.md) | [Home: Curriculum Map](./README.md) | [Next: Data Pipelines >>](./12_Data_Processing_Pipelines.md)
