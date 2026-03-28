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

2. **A mobile client hits your rate limiter at 100 requests per minute.** But the user is making legitimate requests across 3 features simultaneously. How would you design more granular rate limiting that doesn't punish power users while still protecting against abuse?

3. **Your team chose URL-based versioning (`/api/v1/users`), and now v1 has 200 endpoints.** Marketing wants v2 for new clients while keeping v1 alive for existing ones. How do you maintain two versions without doubling your codebase? Would a different versioning strategy have been better?

4. **Cursor-based pagination is fast, but a product manager says "users need to jump to page 50."** How would you handle this requirement? Is there a hybrid approach that gives both page-jumping and the consistency of cursors?

5. **A POST request creates an order, but the network times out before the response reaches the client.** The client retries, and now there are two identical orders. How does an idempotency key solve this, and where should it be generated — client or server? What are the edge cases?

---

## 📝 Key Interview Talking Points

- API gateway is the front door — handles auth, rate limiting, routing
- **Token bucket** is the most common rate limiting algorithm
- Cursor-based pagination for infinite scroll; offset for page-based UIs
- Idempotency keys prevent duplicate operations in unreliable networks

---

[<< Previous: Message Queues](./09_Message_Queues_and_Streaming.md) | [Home: Curriculum Map](./README.md) | [Next: Microservices >>](./11_Microservices_Architecture.md)
