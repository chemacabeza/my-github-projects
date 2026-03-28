# 06: Replication & Partitioning

<p align="center">
  <img src="images/sd_replication.png" alt="Replication and Partitioning" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand how distributed databases replicate data for fault tolerance and partition data for scalability — and the trade-offs in each approach.**

---

## 1. Why Replicate?

| Goal | How Replication Helps |
| :--- | :--- |
| **High Availability** | If one node fails, replicas continue serving |
| **Read Scalability** | Distribute reads across replicas |
| **Geographic Proximity** | Replicas near users reduce latency |

---

## 2. Replication Strategies

### Single-Leader (Master-Slave)

```
  ALL WRITES ──→ [LEADER] ──replication──→ [FOLLOWER 1] ← reads
                                       └→ [FOLLOWER 2] ← reads
                                       └→ [FOLLOWER 3] ← reads
```

| Aspect | Detail |
| :--- | :--- |
| **Writes** | Only to leader |
| **Reads** | From any follower |
| **Consistency** | Synchronous = strong, Async = eventual |
| **Failover** | Promote a follower to leader |
| **Used by** | PostgreSQL, MySQL, MongoDB |

### Multi-Leader

```
  [LEADER A] ←──writes/reads──→ [LEADER B]
      │                             │
      └── replication ──────────────┘
```

| Pros | Cons |
| :--- | :--- |
| Write to any leader (lower latency) | Write conflicts are complex |
| Better for multi-datacenter | Conflict resolution needed |

### Leaderless (Dynamo-style)

```
  Client writes to N nodes simultaneously
  Read from R nodes, take the most recent
  W + R > N ensures overlap (quorum)
```

| Parameter | Meaning |
| :--- | :--- |
| **N** | Number of replicas |
| **W** | Write quorum (nodes that must confirm) |
| **R** | Read quorum (nodes to read from) |

> 💡 **Example:** N=3, W=2, R=2 → At least 1 node has latest data in every read.

---

## 3. Synchronous vs Asynchronous Replication

| Type | Behavior | Trade-off |
| :--- | :--- | :--- |
| **Synchronous** | Leader waits for follower confirmation | Strong consistency, higher latency |
| **Asynchronous** | Leader confirms immediately, replicates later | Low latency, risk of data loss |
| **Semi-synchronous** | 1 follower sync, rest async | Balance of both |

---

## 4. Partitioning (Sharding)

When data is too large for one server, split it across multiple:

```
┌──────────────────────────────────┐
│         ALL USER DATA            │
├──────────┬──────────┬────────────┤
│ Shard 1  │ Shard 2  │ Shard 3   │
│ A-H      │ I-P      │ Q-Z       │
│ Server 1 │ Server 2 │ Server 3  │
└──────────┴──────────┴────────────┘
```

### Partitioning Strategies:

| Strategy | How | Pros | Cons |
| :--- | :--- | :--- | :--- |
| **Range** | By key range (A-H, I-P) | Range queries work | Hot spots possible |
| **Hash** | hash(key) % N | Even distribution | No range queries |
| **Directory** | Lookup table | Flexible | Lookup = bottleneck |
| **Consistent Hashing** | Hash ring | Minimal redistribution | Complex implementation |

### Consistent Hashing

```
        Node A
         ╱╲
    ────╱  ╲────
   │  ╱    ╲  │
   │╱   Ring  ╲│
   ╱     ○     ╲
  ╱    keys     ╲
 Node D ──────── Node B
        ╲      ╱
         ╲    ╱
          ╲  ╱
         Node C
```

When a node is added/removed, only **K/N keys** need to move (K = total keys, N = nodes).

---

## 5. Rebalancing

When adding/removing nodes, data must be redistributed:

| Strategy | Disruption | Used By |
| :--- | :--- | :--- |
| **Fixed partitions** | Reassign whole partitions to new node | Riak, Elasticsearch |
| **Dynamic partitions** | Split/merge as data grows | HBase, MongoDB |
| **Consistent hashing** | Minimal key movement | DynamoDB, Cassandra |

---

## 📝 Key Interview Talking Points

- Replication = copies of same data → fault tolerance and read scaling
- Partitioning = different data on different nodes → write scaling
- Single-leader is the default; multi-leader only for multi-datacenter
- Consistent hashing minimizes data movement when the cluster changes

---

[<< Previous: CAP Theorem](./05_CAP_Theorem_Consistency.md) | [Home: Curriculum Map](./README.md) | [Next: Transactions & Concurrency >>](./07_Transactions_and_Concurrency.md)
