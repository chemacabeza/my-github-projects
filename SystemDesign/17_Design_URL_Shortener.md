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

## 🤔 Reflection Questions

1. **Your URL shortener generates Base62 sequential IDs, and a competitor notices the pattern** — they can guess all recently created short URLs and access potentially private links. How would you make short URLs unpredictable without sacrificing the simplicity of sequential generation?
<details>
<summary>💡 View Answer</summary>

Generate sequential IDs internally for database efficiency, but apply a **bijective obfuscation function** (like Hashids or a simple XOR cipher with a secret key) before encoding to Base62. Sequential ID 1000 might become `x7Kp2`, and 1001 becomes `mR9qA` — completely unpredictable externally but trivially reversible internally for lookups. Alternatively, use a **pre-generated random ID pool**: batch-generate random Base62 codes, store them, and assign them sequentially. As Alex Xu's URL shortener design recommends, the internal ID and the external short code should be decoupled to prevent enumeration attacks.
</details>

2. **Two users submit the same long URL at the same millisecond.** Should they get the same short URL or different ones? What are the implications of each approach for caching, analytics, and link ownership?
<details>
<summary>💡 View Answer</summary>

**Same short URL**: saves storage, improves cache hit rate (one cache entry instead of two), but breaks per-user analytics (you can't tell which user's clicks are which) and creates ownership ambiguity (who can delete or modify the link?). **Different short URLs**: each user gets their own link, enabling per-user click tracking, custom expiry, and clear ownership. This costs slightly more storage but is the correct design for a production system. As Alex Xu's design shows, use a hash of the long URL to detect duplicates, but always generate a unique short URL per user to maintain ownership semantics.
</details>

3. **Your URL shortener handles 1 billion redirects per day, and your database can't keep up.** Which requests should go to cache vs. database? How do you decide the TTL for cached entries when some URLs are accessed once and others millions of times?
<details>
<summary>💡 View Answer</summary>

Redirects (reads) are the overwhelmingly dominant operation — cache these aggressively. The write path (creating short URLs) is infrequent and always hits the database. For TTL: use an **adaptive TTL** based on popularity. Hot URLs (>100 hits/hour) get a long TTL (24 hours). Unpopular URLs get a short TTL (1 hour) or are evicted via LRU. The Pareto principle applies: ~20% of URLs generate ~80% of traffic. Cache those 20% and you absorb 80% of database load. As Alex Xu calculates, with a cache hit rate of 80%, your database only handles 200M requests/day instead of 1 billion — well within capacity.
</details>

4. **A short URL links to a phishing site.** Users blame your platform. How would you design a safety layer that scans destination URLs without adding latency to the redirect? What happens if a legitimate URL gets flagged?
<details>
<summary>💡 View Answer</summary>

Scan URLs **asynchronously at creation time**, not at redirect time. When a new short URL is created, submit the destination URL to a background safety scanner (Google Safe Browsing API, VirusTotal) before marking it as "active." Redirects only work for active URLs, so there's zero added latency. For URLs flagged after creation (retroactive scanning): show an **interstitial warning page** ("This link may be unsafe. Proceed?") instead of immediately redirecting. For false positives: implement a **manual appeal process** and monitor false-positive rates. Store safety scan results with a TTL and re-scan periodically.
</details>

5. **Custom aliases like `short.url/my-brand` are popular, but they introduce a new collision space** with auto-generated codes. How do you prevent a user's custom alias from conflicting with a future auto-generated one? What reservation strategies would you use?
<details>
<summary>💡 View Answer</summary>

Maintain **two separate namespaces**: auto-generated codes use a fixed length (e.g., exactly 7 characters) while custom aliases allow variable lengths or include a prefix distinguisher. Alternatively, reserve a character range: auto-generated codes only use lowercase (a-z, 0-9), while custom aliases must start with an uppercase letter. The simplest approach: when a custom alias is requested, check it against the auto-generation algorithm's possible outputs and reject collisions. As a safeguard, auto-generated codes can skip any codes that already exist as custom aliases by checking a Bloom filter, which provides O(1) collision detection with negligible memory overhead.
</details>

---

## 📝 Key Interview Talking Points

- Start with requirements and math (100M writes/day = ~1150 writes/sec)
- Base62 is the simplest approach; pre-generated keys for production scale
- Use 302 redirects if analytics matter; 301 if latency matters
- Cache eliminates 90%+ of DB reads

---

[<< Previous: DevOps](./16_DevOps_and_Deployment.md) | [Home: Curriculum Map](./README.md) | [Next: Design Chat System >>](./18_Design_Chat_System.md)
