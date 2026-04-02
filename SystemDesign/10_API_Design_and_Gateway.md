# 10: API Design & Gateway

<p align="center">
  <img src="images/sd_api_design.png" alt="API Design and Gateway" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll know how to design clean, scalable APIs and how an API gateway centralizes cross-cutting concerns like authentication, rate limiting, and routing.**

---

## 1. API Gateway

An API gateway is the **single entry point** for all client requests:

<p align="center">
  <img src="images/sd_api_gateway.png" alt="API Gateway Architecture" width="700"/>
</p>

| Responsibility | Description |
| :--- | :--- |
| **Routing** | Forward requests to the right service |
| **Authentication** | Verify JWT/OAuth tokens |
| **Rate Limiting** | Prevent abuse (100 req/min per user) |
| **Load Balancing** | Distribute among service instances |
| **Caching** | Cache frequent responses |
| **Request/Response Transformation** | Format conversion |
| **Logging & Monitoring** | Centralized observability |

### 🔧 Deep Dive: Stateless Auth at the Gateway (JWT)
If your API Gateway has to check the database for a session token on *every single request*, the database becomes a massive bottleneck.
**The Solution:** Use **JSON Web Tokens (JWT)**. The client logs in once, and the Auth Service returns a JWT signed with a private cryptographic key. For all subsequent requests, the API Gateway uses the corresponding public key to verify the token's cryptographic signature *in-memory*. It securely verifies identity and permissions immediately, completely eliminating the database from the validation path.

### 🔧 Deep Dive: Edge Gateway vs. Service Mesh
It is crucial to distinguish between an **API Gateway** and a **Service Mesh** (like Istio or Envoy). 
*   **API Gateway (North-South Traffic):** Handles traffic entering the cluster from the outside world. It focuses on coarse-grained auth, public rate limiting, and routing external requests.
*   **Service Mesh (East-West Traffic):** Handles internal traffic *between* microservices. It runs as a sidecar proxy alongside each service, managing fine-grained mutual TLS (mTLS), internal retries, and distributed tracing. Don't use a gateway to manage internal service-to-service calls!

---

## 2. Rate Limiting Algorithms

| Algorithm | How | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **Token Bucket** | Tokens added at fixed rate; each request costs 1 token | Allows bursts | Slightly complex |
| **Leaky Bucket** | Requests processed at fixed rate; excess queued | Smooth output | No burst capability |
| **Fixed Window** | Count requests in fixed time windows | Simple | Edge burst problem |
| **Sliding Window Log** | Track timestamp of each request | Accurate | Memory-heavy |
| **Sliding Window Counter** | Combine fixed window + previous window ratio | Balanced | Slightly approximate |

```
TOKEN BUCKET:
  Bucket: [🪙🪙🪙🪙🪙] (capacity: 5, refill: 1/sec)
  Request arrives → take 1 token → [🪙🪙🪙🪙]
  Request arrives → take 1 token → [🪙🪙🪙]
  5 requests arrive → bucket empty → RATE LIMITED (429)
  Wait 1 second → refill 1 token → [🪙]
```

### 🔧 Deep Dive: Distributed Rate Limiting Challenges
Running a rate limiter on a single server is trivial. Running it across a distributed cluster causes **Race Conditions**.
If User A has 1 token left, and two requests hit Server 1 and Server 2 at the exact same millisecond, both servers read `tokens=1`, both allow the request, and both write back `tokens=0`. The user just bypassed the limit!
**The Solution:** Use an in-memory datastore like **Redis**. To prevent the race condition without using slow database locks, execute the rate-limit logic inside a **Redis Lua Script**. Lua scripts run atomically in Redis—while the script executes, no other operations can run, guaranteeing exact counters even at 100,000 QPS.

---

## 3. API Versioning

| Strategy | URL Example | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **URL Path** | `/api/v1/users` | Simple, visible | URL changes |
| **Query Param** | `/api/users?version=1` | Flexible | Easy to miss |
| **Header** | `Accept: application/vnd.api.v1+json` | Clean URLs | Hidden |

---

## 4. Pagination

| Strategy | How | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **Offset** | `?page=3&limit=20` | Simple | Slow for large offsets |
| **Cursor** | `?cursor=abc123&limit=20` | Consistent, fast | Can't jump to page N |
| **Keyset** | `?after_id=500&limit=20` | Very fast | Requires sortable key |

---

## 5. Idempotency

An operation is idempotent if calling it multiple times has the same effect:

```
GET  /users/123       → Always returns same user   ✅ Idempotent
PUT  /users/123       → Replaces user completely    ✅ Idempotent
DELETE /users/123     → User is deleted (stays del) ✅ Idempotent
POST /users           → Creates NEW user each time  ❌ NOT Idempotent
```

> 💡 **Solution for POST:** Use an **idempotency key** header. Same key = same result, no duplicate creation.

---

## 🤔 Reflection Questions

1. **Your API gateway handles authentication, rate limiting, routing, and logging — all in a single component.** What happens when this gateway crashes? How is it different from the monolith you were trying to escape? What strategies keep the gateway from becoming a single point of failure?
<details>
<summary>💡 View Answer</summary>

If the gateway crashes, the entire platform goes dark — it *becomes* the monolith's single point of failure. The difference is that a gateway should be **stateless**: it holds no business data, just routing rules and auth tokens in memory. This means you can run multiple identical gateway instances behind a Layer 4 load balancer (HAProxy/NLB) across multiple Availability Zones. If one instance dies, the load balancer routes traffic to survivors with zero data loss. As *Mastering API Architecture* emphasizes, the gateway must be the thinnest possible layer — push business logic into the services, not the gateway.
</details>

2. **A mobile client hits your rate limiter at 100 requests per minute.** But the user is making legitimate requests across 3 features simultaneously. How would you design more granular rate limiting that doesn't punish power users while still protecting against abuse?
<details>
<summary>💡 View Answer</summary>

Implement **per-endpoint rate limiting** using the Token Bucket algorithm. Instead of a single global limit per user, assign separate buckets: `/api/search` gets 60 req/min, `/api/feed` gets 30 req/min, `/api/profile` gets 20 req/min. A power user can max out all three features simultaneously without hitting a global cap. For abuse protection, layer a secondary **sliding window** rate limit at a higher global threshold (e.g., 500 req/min total). As *Continuous API Management* recommends, rate limits should align with business use cases, not arbitrary technical thresholds.
</details>

3. **Your team chose URL-based versioning (`/api/v1/users`), and now v1 has 200 endpoints.** Marketing wants v2 for new clients while keeping v1 alive for existing ones. How do you maintain two versions without doubling your codebase? Would a different versioning strategy have been better?
<details>
<summary>💡 View Answer</summary>

Use the **Backend for Frontend (BFF)** or **adapter pattern**: v1 and v2 routes in the API gateway map to the same underlying service code, but v1 responses pass through a transformation layer that reshapes the output to the old schema. This way you maintain one codebase with versioned response adapters. Header-based versioning (`Accept: application/vnd.api+json;v=2`) would have been cleaner — it keeps URLs stable and allows gradual client migration. As *Mastering API Architecture* explains, URL versioning creates permanent forking pressure while header versioning treats versions as content negotiation.
</details>

4. **Cursor-based pagination is fast, but a product manager says "users need to jump to page 50."** How would you handle this requirement? Is there a hybrid approach that gives both page-jumping and the consistency of cursors?
<details>
<summary>💡 View Answer</summary>

Pure cursor pagination cannot support random page access because the cursor encodes position relative to the last item seen, not an absolute page number. A **hybrid approach**: use offset-based pagination for the first N pages (where N is small enough that performance is acceptable), and switch to cursor-based for "Load More" / infinite scroll beyond that. Alternatively, pre-compute page boundaries as cursors: a background job calculates the cursor for page 10, 20, 30, etc., storing them in a cache. The client requests "page 50" and gets the nearest pre-computed cursor. This limits random access to pre-computed checkpoints while maintaining cursor consistency.
</details>

5. **A POST request creates an order, but the network times out before the response reaches the client.** The client retries, and now there are two identical orders. How does an idempotency key solve this, and where should it be generated — client or server? What are the edge cases?
<details>
<summary>💡 View Answer</summary>

An **idempotency key** is a unique identifier (UUID) generated by the **client** and sent as a header (`Idempotency-Key: abc-123`). The server checks: has this key been processed before? If yes, return the cached response without re-executing the operation. The key *must* be client-generated because only the client knows when it's retrying the same logical operation. Edge cases: 1) The key must be stored durably (database, not just cache) to survive server restarts. 2) Keys should expire after a window (e.g., 24 hours) to prevent unbounded storage growth. 3) Concurrent retries of the same key must be serialized (use a database unique constraint on the key). As Alex Xu's design emphasizes, idempotency keys are essential for any payment or order API.
</details>

---

## 📝 Key Interview Talking Points

- API gateway is the front door — handles auth, rate limiting, routing
- **Token bucket** is the most common rate limiting algorithm
- Cursor-based pagination for infinite scroll; offset for page-based UIs
- Idempotency keys prevent duplicate operations in unreliable networks

---

[<< Previous: Message Queues](./09_Message_Queues_and_Streaming.md) | [Home: Curriculum Map](./README.md) | [Next: Microservices >>](./11_Microservices_Architecture.md)
