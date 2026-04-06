# 05: CAP Theorem & Consistency Models

<p align="center">
  <img src="images/sd_cap_theorem.png" alt="CAP Theorem" width="800"/>
</p>

> 🧠 **The Feynman Hook:** Imagine a bank with two branches — one in London, one in Tokyo. A cable connecting them snaps (network partition). You have two choices: (A) lock both branches until the cable is fixed so they always agree on your balance (Consistency, but Availability suffers), or (B) keep both branches open even if they temporarily disagree about your balance (Availability, but Consistency suffers). There is no third option. This is the CAP theorem — distributed systems are always forced to pick a side when the network misbehaves.

## 🎯 What You'll Learn

> **After this chapter, you'll understand why distributed systems must make trade-offs between consistency, availability, and partition tolerance — and how to choose the right balance for your use case.**

---

## 1. The CAP Theorem

> **Feynman Insight:** CAP says: in any distributed system connected over a network, you get to pick two out of three guarantees. But here's the trick — network partitions are *inevitable*. Cables break. Switches fail. Cloud zones go down. So Partition Tolerance (P) is not optional. The real choice is always: **C or A** when things go wrong.

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

> **Feynman Insight:** A CP system is like a bank that closes its doors during a network outage rather than risk giving you wrong information about your balance. An AP system is like a convenience store that stays open during a power cut using emergency lighting — you can still buy things, but the inventory might be slightly off.

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

> **Feynman Insight:** Consistency isn't binary — it's a dial. At one extreme: every read always returns the absolute latest write, no matter what (linearizability). At the other: data will *eventually* agree across all nodes, but right now it might differ (eventual consistency). Most real systems dial somewhere in between — strong where it matters (payments), relaxed where speed is paramount (likes, views).

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

> **Feynman Insight:** ACID is the promise of a traditional bank: your money is always exactly right, transactions are perfectly isolated, and nothing is ever lost. BASE is the promise of a trendy digital wallet: it's basically always available, the state is soft (momentarily inconsistent), and it eventually sorts itself out. Neither is wrong — they reflect different priorities.

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

> **Feynman Insight:** When two nodes in an AP system both accept a write during a partition, they have conflicting versions. How do you reconcile them? You need a rule — like how courts settle property disputes: "Most recent document wins" (LWW), or "let both parties negotiate" (application-level merge), or "use a data structure that makes conflicts mathematically impossible" (CRDTs).

| Strategy | How | Used By |
| :--- | :--- | :--- |
| **Last Write Wins (LWW)** | Most recent timestamp wins | Cassandra |
| **Version Vectors** | Track causal history, merge | DynamoDB |
| **CRDTs** | Conflict-free data structures | Riak, Redis |
| **Application-level** | App decides how to merge | Shopping carts |

---

## 🤔 Reflection Questions

1. **Your banking app uses CP, but during a network partition users can't check their balance.** Was CP the right choice? How do you explain this to the product manager?
<details>
<summary>💡 View Answer</summary>

Yes, CP was correct. In banking, showing a wrong balance (AP) could enable overdrafts — a real financial and legal risk. Explain to the PM: "During a network issue, we can show potentially wrong numbers or a brief 'unavailable' message. Wrong financial data is illegal and costly; a brief outage is recoverable." A CP system sacrifices availability during partitions to ensure correctness.
</details>

2. **An e-commerce site uses eventual consistency for its catalog.** A customer sees an item in stock, adds it to the cart, but at checkout it's gone. How do you minimize this frustration while keeping AP benefits?
<details>
<summary>💡 View Answer</summary>

Use **inventory reservations** with short TTLs. When a user adds an item to their cart, place a temporary hold (reservation) on that item in a strongly-consistent cache (Redis with distributed locks). The reservation expires after 10 minutes if checkout doesn't complete. This gives brief strong consistency for the critical checkout flow while the broader catalog stays eventually consistent.
</details>

3. **"We'll use strong consistency everywhere to be safe."** What would this cost in latency and availability? Can it actually make the UX *worse*?
<details>
<summary>💡 View Answer</summary>

Strong consistency requires synchronous replication — every write must be confirmed by a quorum before responding. This adds latency and reduces availability. Example of worse UX: a "Like" button. With strong consistency, the user clicks and waits 200ms for quorum acknowledgment. With eventual consistency, the UI instantly shows the like locally while the backend propagates asynchronously — far snappier for a non-critical action.
</details>

4. **Two users in different countries edit the same document simultaneously.** How do CRDTs solve this differently than locks?
<details>
<summary>💡 View Answer</summary>

Locks require one user to wait — adding unacceptable round-trip latency across continents. **CRDTs** allow both users to edit simultaneously on local replicas with zero coordination. CRDTs are mathematically designed so all replicas converge to the same state regardless of operation order — making conflicts impossible by design.
</details>

5. **Your system uses ACID for payments but BASE for social feeds.** Where do you draw the boundary? What happens when a payment must trigger a feed notification?
<details>
<summary>💡 View Answer</summary>

Use the **Transactional Outbox Pattern** at the seam: the payment service commits the payment AND writes a "PaymentCompleted" event to an outbox table in the **same ACID transaction**. A separate process polls the outbox and publishes to Kafka, which the feed service consumes asynchronously. This guarantees the event is never lost without coupling the ACID transaction to the BASE system.
</details>

---

## 📝 Key Interview Talking Points

- Network partitions are unavoidable — the real choice is CP vs AP
- **Default to eventual consistency** unless you have a strong reason for linearizability
- Banking = CP (correctness is critical). Social media = AP (availability is king)
- Know the consistency spectrum and be able to pick the right model for each component

---

[<< Previous: Networking](./04_Networking_and_Protocols.md) | [Home: Curriculum Map](./README.md) | [Next: Replication & Partitioning >>](./06_Replication_and_Partitioning.md)
