# 01: Scalability Fundamentals

<p align="center">
  <img src="images/sd_scalability.png" alt="Scalability Fundamentals" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand how systems grow from handling 100 users to 100 million users — and the architectural decisions that make this possible.**

Every application starts small. A single server handles everything: web requests, business logic, and database queries. But what happens when your user base explodes? The answer is **scalability** — the art of growing your system's capacity without redesigning it from scratch.

---

## 1. What Is Scalability?

Scalability is a system's ability to handle **increased load** by adding resources.

| Term | Definition |
| :--- | :--- |
| **Load** | The demand placed on a system (requests/sec, concurrent users, data volume) |
| **Throughput** | How much work the system completes per unit time |
| **Latency** | How long it takes to complete a single request |
| **Capacity** | The maximum load a system can handle before degradation |

> 💡 **Key Insight:** A system is scalable if adding resources increases throughput proportionally without increasing latency.

---

## 2. Vertical vs Horizontal Scaling

These are the two fundamental approaches to scaling:

<p align="center">
  <img src="images/sd_vertical_horizontal.png" alt="Vertical vs Horizontal Scaling" width="700"/>
</p>

| Aspect | Vertical Scaling | Horizontal Scaling |
| :--- | :--- | :--- |
| **How** | Bigger hardware (more CPU, RAM) | More machines |
| **Cost** | Expensive (diminishing returns) | Linear cost growth |
| **Limit** | Hardware ceiling | Virtually unlimited |
| **Complexity** | Simple (single machine) | Complex (distributed system) |
| **Downtime** | Requires restart | Zero-downtime possible |
| **Failure** | Single point of failure | Fault-tolerant |

> 🏢 **Real-World:** Netflix started vertical on a single Oracle database. Today they run on thousands of horizontally scaled microservices across AWS.

---

## 3. Load Balancers

A load balancer distributes incoming traffic across multiple servers:

```
              ┌───────────────┐
  Users ──────┤ LOAD BALANCER ├──────┬──── Server 1
              └───────────────┘      ├──── Server 2
                                     ├──── Server 3
                                     └──── Server N
```

### Load Balancing Algorithms:

| Algorithm | How It Works | Best For |
| :--- | :--- | :--- |
| **Round Robin** | Each request goes to the next server in order | Equal-capacity servers |
| **Weighted Round Robin** | Servers with more capacity get more traffic | Mixed hardware |
| **Least Connections** | Route to the server with fewest active connections | Variable-length requests |
| **IP Hash** | Hash the client IP to assign a fixed server | Session affinity |
| **Random** | Pick a random server | Simple workloads |

### Types of Load Balancers:
- **Layer 4 (Transport):** Routes based on IP + port. Fast, simple. (e.g., HAProxy)
- **Layer 7 (Application):** Routes based on HTTP headers, URL, cookies. Smarter. (e.g., Nginx, AWS ALB)

---

## 4. Content Delivery Networks (CDN)

A CDN caches content at **edge locations** close to users worldwide:

```
Without CDN:  User (Tokyo) ──── 200ms ──── Origin (New York)

With CDN:     User (Tokyo) ──── 10ms ──── Edge (Tokyo) ──── Origin (New York)
                                            └── cached content served instantly
```

| CDN Strategy | When to Use |
| :--- | :--- |
| **Push CDN** | Upload content to CDN proactively (small, rarely changing files) |
| **Pull CDN** | CDN fetches from origin on first request, then caches (dynamic sites) |

> 🌐 **Example:** Netflix uses AWS CloudFront + their own Open Connect CDN to serve 15% of global internet traffic.

---

## 5. Stateless vs Stateful Design

| Aspect | Stateful | Stateless |
| :--- | :--- | :--- |
| **Session storage** | On the server | External (Redis, DB) |
| **Scaling** | Difficult (sticky sessions) | Easy (any server can handle any request) |
| **Failure recovery** | Session lost if server dies | Session survives server failure |

```
STATEFUL (Bad for Scaling):
  User A ──── always ──── Server 1 (holds session)
  User B ──── always ──── Server 2 (holds session)

STATELESS (Good for Scaling):
  User A ──── any ──── Server 1 ┐
  User B ──── any ──── Server 2 ├── All read from shared Session Store (Redis)
  User C ──── any ──── Server 3 ┘
```

---

## 6. Database Scaling

Databases are usually the first bottleneck:

### Read Replicas:
```
  Writes ──── Primary DB ──── Replication ──── Replica 1 (reads)
                                          └── Replica 2 (reads)
                                          └── Replica 3 (reads)
```

### Sharding:
```
  User ID 1-1M    ──── Shard A
  User ID 1M-2M   ──── Shard B
  User ID 2M-3M   ──── Shard C
```

---

## 7. The Scaling Roadmap

| Users | Architecture |
| :--- | :--- |
| **1-100** | Single server (app + DB on one machine) |
| **100-10K** | Separate web server and DB server |
| **10K-100K** | Load balancer + multiple app servers + read replicas |
| **100K-1M** | CDN + caching layer (Redis) + database sharding |
| **1M-10M** | Microservices + message queues + auto-scaling |
| **10M+** | Global CDN + multi-region + event-driven architecture |

---

## 🤔 Reflection Questions

1. **You're building a social media app that just went viral overnight — traffic jumped from 1,000 to 100,000 users.** Which would you scale first: the web servers, the database, or the caching layer? Why does the order matter?

2. **A stateful design stores user sessions on each server.** What happens if a server crashes at 3 AM? How would a stateless design change the recovery story, and what new components would you need to introduce?

3. **Your team argues: "Let's just buy a bigger server."** Under what circumstances is vertical scaling actually the better choice? When does it become a trap, and how would you convince your team to invest in horizontal scaling infrastructure early?

4. **You're asked to design a system that must handle both read-heavy and write-heavy workloads.** Can a single scaling strategy (e.g., replicas or shards) handle both? What happens if you pick the wrong one?

5. **CDNs solve latency for static content, but what about dynamic content** like real-time dashboards or personalized feeds? How would you deliver fast experiences for data that changes every second?

---

## 📝 Key Interview Talking Points

- Always start with a single server and explain *why* you need to scale each component
- Distinguish between **read-heavy** (add replicas + cache) and **write-heavy** (add shards) workloads
- Stateless design is a prerequisite for horizontal scaling
- The load balancer is the entry point for all scaling conversations

---

[Home: Curriculum Map](./README.md) | [Next: Databases and Storage >>](./02_Databases_and_Storage.md)
