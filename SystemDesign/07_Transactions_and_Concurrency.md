# 07: Transactions & Concurrency

<p align="center">
  <img src="images/sd_transactions.png" alt="Transactions and Concurrency" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand how databases ensure correctness when multiple operations happen simultaneously — isolation levels, distributed transactions, and the Saga pattern.**

---

## 1. Why Transactions Matter

Without transactions, concurrent operations can corrupt data:

```
PROBLEM: Two users buy the last item simultaneously

Thread A: reads stock = 1     ──→ stock > 0? YES ──→ stock = stock - 1 = 0 ✅
Thread B: reads stock = 1     ──→ stock > 0? YES ──→ stock = stock - 1 = 0 ⛔ OVERSOLD!
```

A transaction wraps multiple operations into an atomic unit: **all succeed or all fail.**

---

## 2. Isolation Levels

| Level | Dirty Read | Non-Repeatable Read | Phantom Read | Performance |
| :--- | :--- | :--- | :--- | :--- |
| **Read Uncommitted** | ⛔ Possible | ⛔ Possible | ⛔ Possible | Fastest |
| **Read Committed** | ✅ Prevented | ⛔ Possible | ⛔ Possible | Fast |
| **Repeatable Read** | ✅ Prevented | ✅ Prevented | ⛔ Possible | Medium |
| **Serializable** | ✅ Prevented | ✅ Prevented | ✅ Prevented | Slowest |

### Anomalies Explained:
- **Dirty Read:** Reading data written by an uncommitted transaction
- **Non-Repeatable Read:** Same query returns different results within one transaction
- **Phantom Read:** New rows appear between two identical queries

> 🏢 **PostgreSQL default:** Read Committed. **MySQL InnoDB default:** Repeatable Read.

---

## 3. Distributed Transactions: Two-Phase Commit (2PC)

```
                    COORDINATOR
                    ┌────────┐
         Phase 1:   │PREPARE?│
         ┌──────────┤        ├──────────┐
         │          └────────┘          │
         ▼                              ▼
    ┌─────────┐                   ┌─────────┐
    │ Node A  │                   │ Node B  │
    │ "YES"   │                   │ "YES"   │
    └────┬────┘                   └────┬────┘
         │          ┌────────┐          │
         └──────────┤COMMIT! ├──────────┘
         Phase 2:   └────────┘
```

| Pros | Cons |
| :--- | :--- |
| Guarantees atomicity across nodes | Blocking (all nodes wait) |
| Consistent outcome | Coordinator is single point of failure |
| | High latency (2 round trips) |

---

## 4. The Saga Pattern

For long-running transactions across microservices, use **Sagas** instead of 2PC:

```
Order     →    Payment    →    Inventory    →    Shipping
Service        Service         Service           Service
  │               │                │                │
  │  Create       │  Charge        │  Reserve       │  Ship
  │  Order        │  Card          │  Stock         │  Item
  │               │                │                │
  │  ◄── If any step fails, run COMPENSATING transactions ──►
  │               │                │                │
  │  Cancel       │  Refund        │  Release       │  Cancel
  │  Order        │  Card          │  Stock         │  Shipment
```

### Saga Types:

| Type | Coordination | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **Choreography** | Each service triggers the next via events | Simple, decoupled | Hard to track |
| **Orchestration** | Central orchestrator directs steps | Clear flow, easy to debug | Orchestrator = bottleneck |

---

## 5. Optimistic vs Pessimistic Locking

| Strategy | How | Best For |
| :--- | :--- | :--- |
| **Pessimistic** | Lock the data before modifying | High-contention (many writers) |
| **Optimistic** | Check for conflicts at commit time | Low-contention (mostly reads) |

```
PESSIMISTIC:  Lock row → Read → Modify → Commit → Unlock
              (Others wait during entire operation)

OPTIMISTIC:   Read (version=1) → Modify → Commit IF version still = 1
              (If version changed → retry)
```

---

## 📝 Key Interview Talking Points

- Use **2PC** only within a single database cluster; use **Sagas** across microservices
- **Choreography** Sagas for simple flows; **Orchestration** for complex multi-step processes
- **Optimistic locking** for read-heavy systems; **Pessimistic** for write-heavy
- Always ask: "What happens if this step fails?" — that's where compensating transactions come in

---

[<< Previous: Replication](./06_Replication_and_Partitioning.md) | [Home: Curriculum Map](./README.md) | [Next: Consensus & Coordination >>](./08_Consensus_and_Coordination.md)
