# 04: Networking and Protocols

<p align="center">
  <img src="images/sd_networking.png" alt="Networking and Protocols" width="800"/>
</p>

> 🧠 **The Feynman Hook:** The internet is a global postal system. HTTP is the standard envelope format every post office understands. DNS is the address book converting "google.com" into an IP. TCP is the courier who waits for a signed receipt before leaving. UDP is the one who slips mail through the slot and moves on. Understanding these "postal rules" tells you exactly how clients and servers talk — and why different conversations need different rules.

## 🎯 What You'll Learn

> **After this chapter, you'll understand the protocols that power the internet — HTTP, REST, GraphQL, WebSockets, DNS — and when to choose each one.**

---

## 1. HTTP — The Foundation

> **Feynman Insight:** HTTP is a polite, stateless conversation. The client knocks on the door, delivers a request, the server responds — then both walk away and forget the exchange ever happened. Every new request starts fresh. It's like ordering at a fast-food counter: each transaction is complete and independent.

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

> **Feynman Insight:** REST is a vending machine — each button (endpoint) gives a fixed pre-packaged item. GraphQL is a custom sandwich counter — tell the chef exactly what you want and get precisely that. gRPC is a factory intercom — blazing fast binary signals, designed for machines to talk to machines.

| Feature | REST | GraphQL | gRPC |
| :--- | :--- | :--- | :--- |
| **Format** | JSON | JSON | Protobuf (binary) |
| **Transport** | HTTP/1.1 | HTTP/1.1 | HTTP/2 |
| **Over-fetching** | Common problem | No (client picks fields) | No |
| **Streaming** | ❌ | ❌ | ✅ Bi-directional |
| **Best for** | Public APIs | Mobile/complex clients | Internal microservices |

---

## 3. Real-Time Communication

> **Feynman Insight:** Waiting for a package: short polling is calling the courier every 5 minutes ("Is it here yet?"). Long polling is staying on hold until they answer. WebSockets are giving the courier your number so they call *you* the moment it arrives. SSE is like a live radio broadcast — one-way stream from server to client.

| Pattern | How It Works | Latency | Use Case |
| :--- | :--- | :--- | :--- |
| **Short Polling** | Client sends requests every N seconds | High | Simple dashboards |
| **Long Polling** | Server holds request until data is available | Medium | Chat (older systems) |
| **WebSocket** | Full-duplex persistent connection | Low | Real-time chat, gaming |
| **SSE** (Server-Sent Events) | Server pushes updates to client | Low | Live feeds, stock tickers |

---

## 4. DNS — Domain Name System

> **Feynman Insight:** DNS is the internet's phone book. You know "google.com" but not their phone number (IP). Your local book (cache) checks first. If not found, it calls directory enquiries (root server → TLD → authoritative nameserver) until the number is found. Then it caches it for next time.

```
Browser → Resolver → Root → TLD → Authoritative → IP (142.250.80.46)
```

### DNS Record Types:
| Record | Purpose | Example |
| :--- | :--- | :--- |
| **A** | Domain → IPv4 | `google.com → 142.250.80.46` |
| **CNAME** | Alias to another domain | `www.example.com → example.com` |
| **MX** | Mail server | `example.com → mail.example.com` |
| **NS** | Name server | `example.com → ns1.google.com` |

---

## 5. TCP vs UDP

> **Feynman Insight:** TCP is a registered letter — guaranteed delivery, signed receipt, in order. UDP is a postcard — drop it in the box and hope it arrives. For a video call, losing a UDP packet means a pixel glitch. Waiting for TCP retransmission would cause a 2-second freeze. Different guarantees for different needs.

| Feature | TCP | UDP |
| :--- | :--- | :--- |
| **Reliability** | Guaranteed delivery, ordering | Best-effort, no guarantees |
| **Speed** | Slower (handshake overhead) | Faster (minimal overhead) |
| **Use Cases** | HTTP, email, file transfer | Video streaming, gaming, DNS |

---

## 6. HTTPS and TLS

> **Feynman Insight:** TLS is a locked briefcase for your data. Before sending anything, client and server agree on a secret combination (key exchange) that eavesdroppers can't decode. Once agreed, everything inside the briefcase is unreadable to anyone who intercepts it.

```
1. Client Hello     → Supported cipher suites
2. Server Hello     → Chosen cipher, server certificate
3. Key Exchange     → Client verifies certificate, generates session key
4. Encrypted Data   → All further data encrypted with session key
```

---

## 🤔 Reflection Questions

1. **A mobile banking app needs real-time transaction notifications.** Would you choose WebSockets, SSE, or long polling? How does the unreliability of mobile connections affect your choice?
<details>
<summary>💡 View Answer</summary>

**Server-Sent Events (SSE)** is best. The data flow is strictly unidirectional (server → phone), SSE runs over HTTP/2 with automatic reconnection on mobile network switches, and it passes through corporate proxies more reliably than WebSockets.
</details>

2. **Your REST API requires 5 calls to render one mobile screen.** Would GraphQL solve this? What new problems might it introduce?
<details>
<summary>💡 View Answer</summary>

Yes, GraphQL eliminates under-fetching with a single query. But it introduces the N+1 query problem (requiring DataLoader), no CDN caching (POST requests), and potential DDoS via deeply nested queries.
</details>

3. **DNS caches entries for hours, but you need failover within 60 seconds.** How do you resolve this TTL tension?
<details>
<summary>💡 View Answer</summary>

Use a **health-check-aware DNS service** (Route 53) that removes unhealthy IPs automatically. Or use **Anycast IPs** where BGP routing handles failover at the network layer without any DNS change needed.
</details>

4. **gRPC vs REST for internal microservice communication** — your team knows REST better. How do you decide?
<details>
<summary>💡 View Answer</summary>

Start with REST, then migrate high-throughput internal paths to gRPC as the team gains confidence. gRPC's binary protocol is 5–10x faster, but the debugging overhead (binary payloads, less mature tooling) is real. External APIs stay REST.
</details>

5. **TLS adds latency. For millions of short-lived API calls, how do you minimize the overhead?**
<details>
<summary>💡 View Answer</summary>

Use **TLS 1.3** (1 round-trip handshake), **connection pooling** (amortizes handshake cost), and **session tickets** (skip full handshake on reconnection). Never skip HTTPS for external traffic; only consider plain HTTP inside a private VPC with mTLS via a service mesh.
</details>

---

## 📝 Key Interview Talking Points

- REST for public APIs; gRPC for internal microservice communication
- WebSockets for real-time features (chat, live updates)
- Always mention DNS in any "what happens when you type a URL" discussion
- TCP for reliability, UDP for speed

---

[<< Previous: Caching](./03_Caching_Strategies.md) | [Home: Curriculum Map](./README.md) | [Next: CAP Theorem >>](./05_CAP_Theorem_Consistency.md)
