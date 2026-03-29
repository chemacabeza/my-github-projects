# 04: Networking and Protocols

<p align="center">
  <img src="images/sd_networking.png" alt="Networking and Protocols" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand the protocols that power the internet — HTTP, REST, GraphQL, WebSockets, DNS — and when to choose each one.**

Every system design answer involves clients talking to servers. Understanding **how** they communicate is fundamental.

---

## 1. HTTP — The Foundation

HTTP (HyperText Transfer Protocol) is the request/response protocol of the web:

```
Client ─── REQUEST ───> Server
       <── RESPONSE ──
```

### HTTP Methods:
| Method | Purpose | Idempotent? | Example |
| :--- | :--- | :--- | :--- |
| `GET` | Read data | ✅ Yes | `GET /users/123` |
| `POST` | Create new resource | ❌ No | `POST /users` |
| `PUT` | Full update/replace | ✅ Yes | `PUT /users/123` |
| `PATCH` | Partial update | ❌ No | `PATCH /users/123` |
| `DELETE` | Remove resource | ✅ Yes | `DELETE /users/123` |

### HTTP Status Codes:
| Range | Meaning | Common Codes |
| :--- | :--- | :--- |
| **2xx** | Success | 200 OK, 201 Created, 204 No Content |
| **3xx** | Redirect | 301 Moved Permanently, 304 Not Modified |
| **4xx** | Client Error | 400 Bad Request, 401 Unauthorized, 404 Not Found, 429 Too Many Requests |
| **5xx** | Server Error | 500 Internal Error, 502 Bad Gateway, 503 Service Unavailable |

---

## 2. API Styles Compared

```
┌───────────────┬──────────────┬───────────────┬──────────────┐
│    REST       │   GraphQL    │    gRPC       │   SOAP       │
├───────────────┼──────────────┼───────────────┼──────────────┤
│Resource-based │Query language│Binary protocol│XML-based     │
│JSON over HTTP │Single endpt  │Protobuf       │WSDL contract │
│Multiple endpts│Client defines│HTTP/2 streams │Enterprise    │
│               │what it needs │               │              │
├───────────────┼──────────────┼───────────────┼──────────────┤
│Most web APIs  │Mobile apps   │Microservices  │Legacy/Banks  │
│GitHub, Twitter│GitHub, Shopif│Google, Netflix│Payment gatewy│
└───────────────┴──────────────┴───────────────┴──────────────┘
```

| Feature | REST | GraphQL | gRPC |
| :--- | :--- | :--- | :--- |
| **Format** | JSON | JSON | Protobuf (binary) |
| **Transport** | HTTP/1.1 | HTTP/1.1 | HTTP/2 |
| **Over-fetching** | Common problem | No (client picks fields) | No |
| **Under-fetching** | Common problem | No (nested queries) | No |
| **Streaming** | ❌ | ❌ (subscriptions limited) | ✅ Bi-directional |
| **Code Generation** | ❌ Manual | ✅ Schema-first | ✅ Proto-first |
| **Learning Curve** | Low | Medium | High |

---

## 3. Real-Time Communication

| Pattern | How It Works | Latency | Use Case |
| :--- | :--- | :--- | :--- |
| **Short Polling** | Client sends requests every N seconds | High | Simple dashboards |
| **Long Polling** | Server holds request until data is available | Medium | Chat (older systems) |
| **WebSocket** | Full-duplex persistent connection | Low | Real-time chat, gaming |
| **SSE** (Server-Sent Events) | Server pushes updates to client | Low | Live feeds, stock tickers |

```
SHORT POLLING:     Client ──req──> Server    (every 5s, wastes resources)
LONG POLLING:      Client ──req──> Server... ──response when data ready──>
WEBSOCKET:         Client <──────────────────> Server  (always open)
SSE:               Client <──── push ──── Server  (one-way stream)
```

---

## 4. DNS — Domain Name System

DNS translates human-readable domains to IP addresses:

```
Browser                Recursive          Root          .com TLD      Authoritative
  │                    Resolver           Server        Server        Server
  ├── google.com? ────>│                    │              │              │
  │                    ├── google.com? ────>│              │              │
  │                    │<── ask .com TLD ───┘              │              │
  │                    ├── google.com? ───────────────────>│              │
  │                    │<── ask ns1.google.com ────────────┘              │
  │                    ├── google.com? ──────────────────────────────────>│
  │                    │<── 142.250.80.46 ───────────────────────────────┘
  │<── 142.250.80.46 ──┘
```

### DNS Record Types:
| Record | Purpose | Example |
| :--- | :--- | :--- |
| **A** | Domain → IPv4 address | `google.com → 142.250.80.46` |
| **AAAA** | Domain → IPv6 address | `google.com → 2607:f8b0::` |
| **CNAME** | Alias to another domain | `www.example.com → example.com` |
| **MX** | Mail server | `example.com → mail.example.com` |
| **NS** | Name server | `example.com → ns1.google.com` |

---

## 5. TCP vs UDP

| Feature | TCP | UDP |
| :--- | :--- | :--- |
| **Connection** | Connection-oriented (3-way handshake) | Connectionless |
| **Reliability** | Guaranteed delivery, ordering | Best-effort, no guarantees |
| **Speed** | Slower (overhead) | Faster (minimal overhead) |
| **Use Cases** | HTTP, email, file transfer | Video streaming, gaming, DNS |

---

## 6. HTTPS and TLS

TLS encrypts communication between client and server:

```
1. Client Hello     → Supported cipher suites
2. Server Hello     → Chosen cipher, server certificate
3. Key Exchange     → Client verifies certificate, generates session key
4. Encrypted Data   → All data encrypted with session key
```

---

## 🤔 Reflection Questions

1. **A mobile banking app needs to display real-time transaction notifications.** Would you choose WebSockets, SSE, or long polling? How does the fact that mobile connections are unreliable affect your choice?
<details>
<summary>💡 View Answer</summary>

**Server-Sent Events (SSE)** is the best choice for mobile banking notifications. The data flow is strictly unidirectional (server → phone), which matches SSE perfectly. SSE runs over standard HTTP/2, which handles reconnection automatically when a mobile device switches between WiFi and cellular. WebSockets require a full handshake on every reconnect and are overkill for one-way push notifications. Long polling wastes battery life with constant reconnection cycles. SSE also passes through corporate proxies and firewalls more reliably than WebSockets.
</details>

2. **Your API uses REST and mobile clients complain about slow load times** because they need 5 separate API calls to render one screen. Would migrating to GraphQL solve this? What new problems might it introduce?
<details>
<summary>💡 View Answer</summary>

Yes, GraphQL solves the **under-fetching problem** by letting the client request exactly the data it needs in a single query. However, it introduces serious backend challenges: 1) The **N+1 query problem** — a single GraphQL query can trigger hundreds of database calls unless you implement DataLoader batching. 2) **No HTTP caching** — GraphQL uses POST requests, which CDNs cannot cache by default, unlike REST's GET endpoints. 3) **Security complexity** — deeply nested queries can be weaponized for denial-of-service attacks. As *Mastering API Architecture* explains, you need query depth limiting and cost analysis.
</details>

3. **DNS caches entries for hours, but you need to fail over to a backup server within 60 seconds.** How does DNS TTL create a tension between reliability and performance? What strategies can you use to work around this?
<details>
<summary>💡 View Answer</summary>

Low DNS TTL (e.g., 30 seconds) enables fast failover because clients re-resolve the hostname frequently and will discover the backup server quickly. However, low TTL increases DNS query volume, adding latency to every new connection and load on DNS servers. The workaround is to use a **health-check-aware DNS service** (like AWS Route 53) that actively monitors endpoints and removes unhealthy IPs from DNS responses. Alternatively, use an **Anycast IP** where multiple servers share the same IP address and BGP routing handles failover at the network level — no DNS change needed.
</details>

4. **You're choosing between gRPC and REST for internal service-to-service communication.** gRPC is faster, but your team is more experienced with REST. How would you weigh performance gains against operational complexity and team expertise?
<details>
<summary>💡 View Answer</summary>

For internal service-to-service communication, **gRPC** offers significant advantages: binary serialization (Protocol Buffers) is 5–10x faster than JSON, HTTP/2 multiplexing eliminates head-of-line blocking, and strongly typed contracts prevent API drift. However, if your team lacks gRPC experience, the debugging overhead is real — binary payloads are not human-readable, and tooling (interceptors, load balancers) is less mature. A pragmatic middle ground: use REST for external-facing APIs (better browser/tooling support) and adopt gRPC gradually for internal high-throughput paths where the latency savings justify the learning curve.
</details>

5. **HTTPS adds latency due to the TLS handshake.** For a system serving millions of short-lived API calls, how significant is this overhead? What optimizations exist to minimize it, and when might you consider *not* using HTTPS?
<details>
<summary>💡 View Answer</summary>

A full TLS 1.2 handshake adds 2 round-trips (~100ms on a 50ms connection). At millions of short-lived calls, this overhead is significant. Key optimizations: 1) **TLS 1.3** reduces the handshake to 1 round-trip, and supports **0-RTT resumption** for repeat connections. 2) **Connection pooling/keep-alive** amortizes the handshake cost across thousands of requests per connection. 3) **Session tickets** allow clients to skip the full handshake on reconnection. You should *never* skip HTTPS for external traffic. The only case for plain HTTP is internal service-to-service communication within a private VPC with network-level encryption (e.g., AWS VPC encryption or a service mesh like Istio providing mTLS).
</details>

---

## 📝 Key Interview Talking Points

- REST is the default for public APIs; gRPC for internal microservice communication
- WebSockets for real-time features (chat, notifications, live updates)
- Always mention DNS in any "what happens when you type a URL" discussion
- TCP for reliability, UDP for speed — know the trade-off

---

[<< Previous: Caching](./03_Caching_Strategies.md) | [Home: Curriculum Map](./README.md) | [Next: CAP Theorem >>](./05_CAP_Theorem_Consistency.md)
