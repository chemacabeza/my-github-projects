# 17: Design a URL Shortener

<p align="center">
  <img src="images/sd_url_shortener.png" alt="URL Shortener Design" width="800"/>
</p>

## 🎯 The Big Goal

> **Design a system like TinyURL or bit.ly that converts long URLs into short, shareable links and redirects users efficiently.**

---

## 1. Requirements

| Functional | Non-Functional |
| :--- | :--- |
| Shorten a long URL → short URL | Highly available (always works) |
| Redirect short URL → original URL | Low latency redirects (< 10ms) |
| Custom short links (optional) | 100M URLs/day write, 10:1 read ratio |
| Link expiration | Scale to billions of URLs |
| Click analytics | Not guessable (no sequential IDs) |

---

## 2. High-Level Architecture

```
Client ──→ [API Gateway] ──→ [URL Service] ──→ [Database]
                                    │
                              [Cache (Redis)]
                                    │
                            [Analytics Service]
```

---

## 3. URL Shortening — The Core Algorithm

### Option A: Base62 Encoding
```
Auto-increment ID: 123456789
Base62 encode: 123456789 → "8M0kX"
Short URL: https://short.url/8M0kX
```

### Option B: MD5/SHA Hash + Truncate
```
hash("https://very-long-url.com/...") → take first 7 chars → "a3bF7kQ"
```

### Option C: Pre-generated Key Service
```
[Key Generation Service] pre-generates millions of unique keys
On request: grab next unused key from pool → assign to URL
```

| Method | Pros | Cons |
| :--- | :--- | :--- |
| **Base62** | Simple, no collisions | Sequential = guessable |
| **Hash + Truncate** | Not guessable | Collisions possible |
| **Pre-generated** | Fast, no collisions | Requires key management |

---

## 4. Database Design

```
┌────────────────────────────────────────────┐
│ url_mappings                               │
├────────────────────────────────────────────┤
│ short_code  VARCHAR(7)  PRIMARY KEY        │
│ long_url    TEXT                            │
│ user_id     VARCHAR(36)                    │
│ created_at  TIMESTAMP                      │
│ expires_at  TIMESTAMP                      │
│ click_count INT DEFAULT 0                  │
└────────────────────────────────────────────┘
```

**Database Choice:** NoSQL (DynamoDB/Cassandra) — simple key-value lookups at massive scale.

---

## 5. Redirect Flow

```
1. Client: GET https://short.url/8M0kX
2. Cache lookup (Redis): found? → return long URL
3. Cache miss → DB lookup → store in cache → return long URL
4. HTTP 301 (permanent) or 302 (temporary) redirect to long URL
```

| Code | When | Effect |
| :--- | :--- | :--- |
| **301** | Permanent redirect | Browser caches (fewer server hits, but no analytics) |
| **302** | Temporary redirect | Browser always hits server (better for analytics) |

---

## 6. Scale Considerations

| Concern | Solution |
| :--- | :--- |
| **Read-heavy** | Cache popular URLs in Redis (90%+ hit rate) |
| **Write scaling** | Pre-generated key pool, partitioned DB |
| **Analytics** | Async write to analytics DB via message queue |
| **Availability** | Multi-region deployment with DNS failover |

---

## 📝 Key Interview Talking Points

- Start with requirements and math (100M writes/day = ~1150 writes/sec)
- Base62 is the simplest approach; pre-generated keys for production scale
- Use 302 redirects if analytics matter; 301 if latency matters
- Cache eliminates 90%+ of DB reads

---

[<< Previous: DevOps](./16_DevOps_and_Deployment.md) | [Home: Curriculum Map](./README.md) | [Next: Design Chat System >>](./18_Design_Chat_System.md)
