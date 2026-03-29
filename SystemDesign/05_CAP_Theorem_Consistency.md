# 05: CAP Theorem & Consistency Models

<p align="center">
  <img src="images/sd_cap_theorem.png" alt="CAP Theorem" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand why distributed systems must make trade-offs between consistency, availability, and partition tolerance — and how to choose the right balance for your use case.**

---

## 1. The CAP Theorem

In any distributed system, you can only guarantee **two out of three** properties:

<p align="center">
  <img src="images/sd_cap_triangle.png" alt="CAP Theorem Triangle" width="700"/>
</p>

| Property | Definition | Example |
| :--- | :--- | :--- |
| **Consistency (C)** | Every read receives the most recent write | All nodes see the same data simultaneously |
| **Availability (A)** | Every request receives a response (even if stale) | System never refuses to answer |
| **Partition Tolerance (P)** | System works despite network failures between nodes | Messages between nodes can be lost/delayed |

> ⚠️ **Critical Point:** Network partitions are **inevitable** in distributed systems. So you're really choosing between **CP** (consistency) and **AP** (availability).

---

## 2. CP vs AP Systems

| System Type | Guarantees | Sacrifices | Examples |
| :--- | :--- | :--- | :--- |
| **CP** | Consistency + Partition Tolerance | Availability (rejects requests during partition) | PostgreSQL, MongoDB, HBase, ZooKeeper |
| **AP** | Availability + Partition Tolerance | Consistency (may serve stale data) | Cassandra, DynamoDB, CouchDB |

### When to Choose CP:
- Financial transactions (bank transfers)
- Inventory management (don't oversell)
- User credentials (authentication must be correct)

### When to Choose AP:
- Social media feeds (slight delay is OK)
- Shopping cart (merge conflicts later)
- Analytics dashboards (stale data is acceptable)

---

## 3. Consistency Models — The Spectrum

```
STRONGEST ◄──────────────────────────────────────► WEAKEST

Linearizable → Sequential → Causal → Eventual
   │                                      │
   │ All see same data                    │ Data converges
   │ at the same time                     │ eventually
   │                                      │
   └── Bank account balance               └── DNS propagation
       Ticket booking                         Social media likes
```

| Model | Guarantee | Latency | Example |
| :--- | :--- | :--- | :--- |
| **Linearizability** | Reads always return the latest write | High | Distributed locks, leader election |
| **Sequential** | All see operations in same order | Medium | Multi-player games |
| **Causal** | Cause-effect ordering preserved | Low-Medium | Chat messages (reply after original) |
| **Eventual** | All replicas converge given enough time | Low | DNS updates, shopping cart |

---

## 4. ACID vs BASE

| ACID (SQL) | BASE (NoSQL) |
| :--- | :--- |
| **A**tomicity | **B**asically **A**vailable |
| **C**onsistency | **S**oft state |
| **I**solation | **E**ventual consistency |
| **D**urability | |
| Strong guarantees, slower | Weak guarantees, faster |
| PostgreSQL, MySQL | Cassandra, DynamoDB |

---

## 5. Conflict Resolution Strategies

When eventual consistency leads to conflicts:

| Strategy | How | Used By |
| :--- | :--- | :--- |
| **Last Write Wins (LWW)** | Most recent timestamp wins | Cassandra |
| **Version Vectors** | Track causal history, merge | DynamoDB |
| **CRDTs** | Conflict-free data structures | Riak, Redis |
| **Application-level** | App decides how to merge | Shopping carts |

---

## 🤔 Reflection Questions

1. **Your banking app uses a CP database, but during a network partition, users can't check their balance.** Angry customers flood support. Was CP the right choice? How would you explain the trade-off to a non-technical product manager?
<details>
<summary>💡 View Answer</summary>

Yes, CP was the correct choice. In banking, showing a user an incorrect balance (AP) could allow them to overdraw their account — a real financial loss. Explain to the PM: "During a network issue, we have two options: show potentially wrong numbers or temporarily show a 'service unavailable' message. Showing wrong financial data is illegal and costly; a brief outage is recoverable." As Kleppmann explains in DDIA, CP systems sacrifice availability during partitions to guarantee every read returns the most recent write.
</details>

2. **An e-commerce site uses eventual consistency for its product catalog.** A customer sees an item in stock, adds it to their cart, but at checkout the item is gone. How would you minimize this kind of user frustration while keeping the benefits of AP design?
<details>
<summary>💡 View Answer</summary>

Use **inventory reservations** with short TTLs. When a user adds an item to their cart, immediately place a temporary hold (reservation) on that item in a strongly-consistent cache (Redis with distributed locks). The reservation expires after 10 minutes if checkout doesn't complete. This provides a brief window of strong consistency for the critical checkout flow while the broader catalog remains eventually consistent and highly available. Alex Xu's system design approach recommends this hybrid pattern for e-commerce specifically.
</details>

3. **"We'll use strong consistency everywhere to be safe."** What would this decision cost in terms of latency, availability, and infrastructure? Can you think of a scenario where strong consistency actually makes the user experience *worse*?
<details>
<summary>💡 View Answer</summary>

Strong consistency requires synchronous replication — every write must be confirmed by a quorum of nodes before responding. This adds latency (waiting for the slowest replica) and reduces availability (if quorum is lost, the system rejects writes). A scenario where it makes UX *worse*: a social media "Like" button. If you enforce strong consistency, the user clicks "Like" and waits 200ms for a quorum acknowledgment. With eventual consistency, the UI instantly shows the like locally, and the backend propagates it asynchronously — a much snappier experience for a non-critical action.
</details>

4. **Two users in different countries edit the same document simultaneously** in a collaborative editor. How do CRDTs solve this differently than a locking mechanism? Why is the CRDT approach more appropriate for global-scale systems?
<details>
<summary>💡 View Answer</summary>

A lock mechanism requires one user to wait while the other finishes — at global scale, the lock acquisition round-trip across continents adds unacceptable latency. **CRDTs (Conflict-free Replicated Data Types)** allow both users to edit simultaneously on their local replicas with zero coordination. CRDTs are mathematically designed so that all replicas converge to the same state regardless of the order operations are received. As DDIA explains, CRDTs achieve this by encoding operations as commutative, associative, and idempotent transformations — making distributed merge conflicts impossible by design.
</details>

5. **Your system uses ACID transactions for payments but BASE for the social feed.** Where do you draw the boundary between the two? What happens at the seam — when a payment triggers a feed notification?
<details>
<summary>💡 View Answer</summary>

The boundary is drawn at the **domain level**: any operation involving money, inventory, or legal obligations uses ACID. Social features (feeds, likes, notifications) use BASE. At the seam, you use the **Transactional Outbox Pattern**: the payment service commits the payment AND writes a "PaymentCompleted" event to an outbox table in the same ACID transaction. A separate process polls the outbox and publishes the event to Kafka, which the feed service consumes asynchronously. This guarantees the event is never lost without coupling the payment's ACID transaction to the feed's BASE system.
</details>

---

## 📝 Key Interview Talking Points

- Network partitions are unavoidable — the real choice is CP vs AP
- **Default to eventual consistency** unless you have a strong reason for linearizability
- Banking = CP (correctness is critical). Social media = AP (availability is king)
- Know the consistency spectrum and be able to pick the right model for each component

---

[<< Previous: Networking](./04_Networking_and_Protocols.md) | [Home: Curriculum Map](./README.md) | [Next: Replication & Partitioning >>](./06_Replication_and_Partitioning.md)
