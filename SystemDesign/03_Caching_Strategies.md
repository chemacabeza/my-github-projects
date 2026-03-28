# 03: Caching Strategies

<p align="center">
  <img src="images/sd_caching.png" alt="Caching Strategies" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand the five major caching strategies, when to use each one, and how caching reduces latency from hundreds of milliseconds to under a millisecond.**

Caching is the single most impactful performance optimization in system design. It stores frequently accessed data in fast, temporary storage — trading a small amount of memory for massive speed gains.

---

## 1. Why Cache?

```
Database query:     100-500ms
Redis cache hit:    1-5ms
Local memory:       <0.1ms
                    ─────────────────
                    100x to 1000x faster!
```

---

## 2. The Cache Hierarchy

```
┌──────────────────────────────────────────┐
│ L1: Browser Cache        (< 1ms)         │  ← Closest to user
├──────────────────────────────────────────┤
│ L2: CDN Cache            (10-50ms)       │
├──────────────────────────────────────────┤
│ L3: Application Cache    (1-5ms)         │  ← Redis, Memcached
├──────────────────────────────────────────┤
│ L4: Database Cache       (10-50ms)       │  ← Query cache
├──────────────────────────────────────────┤
│ L5: Database (Disk)      (100-500ms)     │  ← Slowest
└──────────────────────────────────────────┘
```

---

## 3. The Five Caching Strategies

### Strategy 1: Cache-Aside (Lazy Loading)

```
Read:   App checks cache → Miss? → Query DB → Store in cache → Return
Write:  App writes to DB → Invalidate cache
```

| Pros | Cons |
| :--- | :--- |
| Only requested data is cached | First request is always slow (cache miss) |
| Cache failure doesn't break the system | Data can become stale |

> 🏢 **Used by:** Most web applications, social media feeds

### Strategy 2: Read-Through Cache

```
Read:   App checks cache → Miss? → Cache queries DB itself → Returns data
```

| Pros | Cons |
| :--- | :--- |
| Simpler app code (cache handles DB reads) | Cache library must support DB integration |
| Consistent read path | Same staleness issue |

### Strategy 3: Write-Through Cache

```
Write:  App writes to cache → Cache writes to DB → Confirm
Read:   Always served from cache (always fresh)
```

| Pros | Cons |
| :--- | :--- |
| Cache is always consistent | Higher write latency (2 writes) |
| No stale data | Caches data that may never be read |

### Strategy 4: Write-Back (Write-Behind)

```
Write:  App writes to cache → Acknowledge immediately → Cache writes to DB later (async)
```

| Pros | Cons |
| :--- | :--- |
| Fastest writes (async) | Risk of data loss if cache crashes |
| Batches DB writes | Complexity of async write handling |

### Strategy 5: Write-Around

```
Write:  App writes to DB directly → Cache is NOT updated
Read:   Cache-aside pattern (DB on miss)
```

| Pros | Cons |
| :--- | :--- |
| Good for infrequently read data | First read after write is slow |
| Avoids filling cache with write-heavy data | |

---

## 4. Cache Eviction Policies

When the cache is full, which item gets removed?

| Policy | How It Works | Best For |
| :--- | :--- | :--- |
| **LRU** (Least Recently Used) | Evict the item accessed longest ago | General purpose (most common) |
| **LFU** (Least Frequently Used) | Evict the item accessed fewest times | Stable popularity patterns |
| **FIFO** (First In, First Out) | Evict the oldest item | Simple, time-based expiry |
| **TTL** (Time-to-Live) | Evict after a fixed time | Data with known freshness |
| **Random** | Evict a random item | Surprisingly effective! |

---

## 5. Cache Invalidation — The Hardest Problem

> *"There are only two hard things in Computer Science: cache invalidation and naming things."* — Phil Karlton

| Approach | How | Trade-off |
| :--- | :--- | :--- |
| **TTL-based** | Data expires after N seconds | Simple, but stale for up to TTL |
| **Event-driven** | DB change triggers cache invalidation | Fresh, but complex |
| **Write-through** | Every write updates cache | No stale data, but slower writes |
| **Manual** | Application explicitly deletes cache keys | Maximum control, error-prone |

---

## 6. Redis — The Universal Cache

Redis is an in-memory data structure store used as cache, message broker, and more:

| Feature | Description |
| :--- | :--- |
| **Data Structures** | Strings, hashes, lists, sets, sorted sets, streams |
| **Persistence** | RDB snapshots + AOF (append-only file) |
| **Replication** | Master-replica architecture |
| **Cluster Mode** | Automatic sharding across nodes |
| **TTL** | Built-in key expiration |
| **Pub/Sub** | Real-time messaging |

---

## 📝 Key Interview Talking Points

- Always mention **cache-aside** as the default strategy
- Discuss **cache invalidation** — interviewers love this topic
- Choose eviction policy based on access pattern: LRU for general, LFU for stable popularity
- Redis vs Memcached: Redis has more data structures; Memcached is simpler and faster for pure key-value

---

[<< Previous: Databases](./02_Databases_and_Storage.md) | [Home: Curriculum Map](./README.md) | [Next: Networking & Protocols >>](./04_Networking_and_Protocols.md)
