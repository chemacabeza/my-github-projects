# 02: Databases and Storage

<p align="center">
  <img src="images/sd_databases.png" alt="Databases and Storage" width="800"/>
</p>

> 🧠 **The Feynman Hook:** Imagine organising your life's records. A SQL database is like a perfectly organised filing cabinet — everything in labeled folders, with a master index so you can find any document instantly. A NoSQL database is like a pile of notebooks — each one holds complete information about one topic, so you can grab a notebook and read everything about a person without searching multiple folders. Both work. The question is: *how do you need to look things up?*

## 🎯 What You'll Learn

> **After this chapter, you'll know when to choose SQL vs NoSQL, how to scale databases with replication and sharding, and how indexes make queries fast.**

The database is the heart of every system. Get this choice wrong and you'll spend years fighting your own infrastructure. Get it right and your data layer becomes invisible — fast, reliable, and scalable.

---

## 1. SQL vs NoSQL — The Fundamental Choice

> **Feynman Insight:** SQL is like a spreadsheet where every row has exactly the same columns. If you want to link data from two spreadsheets, you do a JOIN — expensive but precise. NoSQL is like a box of envelopes: each envelope holds everything about one entity. No linking needed, but you can't ask "give me all envelopes from customers in London" without scanning every single one.

| Aspect | SQL (Relational) | NoSQL |
| :--- | :--- | :--- |
| **Data Model** | Tables with rows and columns | Documents, key-value, wide-column, graph |
| **Schema** | Fixed schema (ALTER TABLE to change) | Flexible / schema-less |
| **Relationships** | JOINs across tables | Denormalized, embedded data |
| **Transactions** | Full ACID compliance | Usually eventual consistency |
| **Scaling** | Primarily vertical | Designed for horizontal |
| **Query Language** | SQL (standardized) | Database-specific APIs |
| **Examples** | PostgreSQL, MySQL, Oracle | MongoDB, Cassandra, Redis, DynamoDB |

### When to Use SQL:
- Complex queries with JOINs
- Transactions are critical (banking, e-commerce)
- Data has clear relationships
- Data integrity > flexibility

### When to Use NoSQL:
- Massive write throughput
- Flexible, evolving data models
- Horizontal scaling is essential
- Low-latency reads at scale

---

## 2. NoSQL Database Types

> **Feynman Insight:** NoSQL isn't one thing — it's four very different ideas. A key-value store is like a locker room: each locker has a number, you put whatever you want in it, and retrieval is instant. A document store is like a folder with related papers stuffed inside. A wide-column store is like a giant spreadsheet that can have different columns per row. A graph database is like a social network map — the *connections* between things are first-class data, not the things themselves.

```
┌────────────────┬───────────────────┬──────────────────┬────────────────┐
│  Key-Value     │  Document Store   │  Wide-Column     │  Graph         │
├────────────────┼───────────────────┼──────────────────┼────────────────┤
│ Redis          │ MongoDB           │ Cassandra        │ Neo4j          │
│ DynamoDB       │ CouchDB           │ HBase            │ Amazon Neptune │
│ Memcached      │ Firestore         │ ScyllaDB         │ ArangoDB       │
├────────────────┼───────────────────┼──────────────────┼────────────────┤
│ Session cache  │ Content mgmt      │ Time-series      │ Social graphs  │
│ Shopping cart  │ User profiles     │ IoT data         │ Recommendations│
│ Leaderboards   │ Product catalogs  │ Message logs     │ Fraud detection│
└────────────────┴───────────────────┴──────────────────┴────────────────┘
```

---

## 3. ACID Properties

> **Feynman Insight:** Imagine a bank transfer: you move £500 from savings to checking. That's two operations: subtract from one account, add to another. ACID guarantees these are treated as a single, indivisible act. If the system crashes between the two steps, the bank doesn't pocket your £500 — it either completes both steps or neither. Think of ACID as the promise your bank makes that money doesn't vanish into thin air.

| Property | Meaning | Example |
| :--- | :--- | :--- |
| **Atomicity** | All operations succeed or all fail | Bank transfer: debit AND credit, or neither |
| **Consistency** | Data always moves from one valid state to another | Balance can never go negative |
| **Isolation** | Concurrent transactions don't interfere | Two users buying the last item |
| **Durability** | Once committed, data survives crashes | Write to disk, not just memory |

---

## 4. Database Indexing

> **Feynman Insight:** Searching a database without an index is like looking through a library without a catalogue — you have to check every shelf. An index is like the card catalogue at the front: it knows *exactly* which shelf holds the book you want. The index takes up space and must be updated when books change locations, but for large libraries, it's the only way to find anything quickly.

```
WITHOUT INDEX:       Scan every row → O(n)
WITH B-TREE INDEX:   Binary search → O(log n)

Table: users (10 million rows)
Query: SELECT * FROM users WHERE email = 'alice@example.com'

Without index:  Full table scan → ~5 seconds
With index:     B-Tree lookup → ~5 milliseconds
                                  (1000x faster!)
```

### Index Types:
| Type | Best For | How It Works |
| :--- | :--- | :--- |
| **B-Tree** | Range queries, sorting | Balanced tree with sorted keys |
| **Hash** | Exact matches (=) | Hash function maps key to location |
| **Full-Text** | Text search | Inverted index of words |
| **Composite** | Multi-column queries | Index on (col_a, col_b) |

> ⚠️ **Trade-off:** Every index slows down INSERT/UPDATE/DELETE because the index must also be updated. Don't index everything.

---

## 5. Database Replication

> **Feynman Insight:** Replication is like making photocopies of important documents and distributing them to multiple offices. If the head office burns down, the branches still have copies. Reads can happen at any branch (fast, local) while writes typically go to head office (the leader). The challenge: keeping all copies in sync when the document changes.

<p align="center">
  <img src="images/sd_db_replication.png" alt="Database Replication Strategies" width="700"/>
</p>

| Strategy | Writes | Reads | Consistency |
| :--- | :--- | :--- | :--- |
| **Single-Leader** | One primary | Any replica | Strong (if synchronous) |
| **Multi-Leader** | Multiple primaries | Any node | Eventual |
| **Leaderless** | Any node | Any node | Quorum-based |

---

## 6. Database Sharding

> **Feynman Insight:** When your single filing cabinet is overflowing, you buy more cabinets and split the files alphabetically: Cabinet A holds A–H, Cabinet B holds I–P, Cabinet C holds Q–Z. That's sharding. Nobody's cabinet is overloaded, but the downside is: if you want all files about someone whose name spans two cabinets, you now have to search two places.

<p align="center">
  <img src="images/sd_sharding.png" alt="Database Sharding" width="700"/>
</p>

```
┌────────────────────────────┐
│    SHARD KEY: user_id      │
├────────────┬───────────────┤
│ Shard A    │ user_id 1-1M  │ ──── DB Server 1
│ Shard B    │ user_id 1M-2M │ ──── DB Server 2
│ Shard C    │ user_id 2M-3M │ ──── DB Server 3
└────────────┴───────────────┘
```

### Sharding Strategies:
| Strategy | How | Pro | Con |
| :--- | :--- | :--- | :--- |
| **Range-based** | Shard by ID range | Simple | Hot spots if ranges are uneven |
| **Hash-based** | Hash(key) % N | Even distribution | Hard to do range queries |
| **Directory-based** | Lookup table maps key → shard | Flexible | Lookup table is a bottleneck |

> 💡 **Pro Tip:** Avoid sharding as long as possible. It adds enormous complexity (cross-shard JOINs, rebalancing, transactions). Try read replicas and caching first.

---

## 🤔 Reflection Questions

1. **You're designing a new e-commerce platform.** The product catalog has complex relationships (categories, variants, reviews), but the shopping cart needs blazing-fast reads. Would you use one database or two? What happens when they need to share data?
<details>
<summary>💡 View Answer</summary>

Use **two databases (Polyglot Persistence)** as recommended by Kleppmann in DDIA. A relational database (PostgreSQL) handles the product catalog's complex relationships and ACID transactions. A key-value store (Redis or DynamoDB) serves the shopping cart with sub-millisecond reads. When they need to share data (e.g., cart needs product prices), use asynchronous event propagation via a message broker like Kafka — the product service publishes price-change events that the cart service consumes to update its local cache.
</details>

2. **"Just add an index on every column and queries will be fast."** Why is this advice dangerous? Think about what happens during a Black Friday sale with millions of writes per second.
<details>
<summary>💡 View Answer</summary>

Every index is a separate data structure (typically a B-Tree) that must be updated on every INSERT, UPDATE, or DELETE. With millions of writes per second during Black Friday, each write now triggers multiple index updates — this is called **write amplification**. The disk I/O becomes the bottleneck as the database spends more time maintaining indexes than processing actual transactions. As DDIA explains, indexes always trade write speed for read speed; the correct approach is to index only the columns used in your most critical WHERE clauses and query patterns.
</details>

3. **Your database has 500 million rows and queries are slow.** How would you decide between adding read replicas vs. sharding? What questions would you ask about the workload before choosing?
<details>
<summary>💡 View Answer</summary>

Ask: **Is the problem read-heavy or write-heavy?** If the workload is mostly reads (analytics dashboards, product browsing), add **read replicas** — they clone the full dataset and serve read queries in parallel. If writes are the bottleneck (millions of inserts per second), replicas won't help because all writes still funnel through a single leader. In that case, you need **sharding** to distribute writes across multiple nodes. Also ask: does the data fit in memory? If not, even reads will be slow on replicas, and sharding becomes necessary to reduce dataset size per node.
</details>

4. **A NoSQL database promises infinite scalability and flexible schemas.** But six months later, your team is writing complex application-level JOINs. What went wrong in the original decision, and how would you avoid this trap?
<details>
<summary>💡 View Answer</summary>

The team chose NoSQL without analyzing their **data access patterns**. NoSQL databases are designed for denormalized, single-entity lookups — not for relational queries. If your data has many relationships (users → orders → products → reviews), you need SQL's native JOIN capability. The trap is avoided by modeling your queries first (what data do you read together?) and then choosing the database that matches.
</details>

5. **Single-leader replication means all writes go through one node.** What happens when that node is in Virginia but most of your users are in Tokyo? How does this architectural constraint influence the rest of your system design?
<details>
<summary>💡 View Answer</summary>

Every write from Tokyo must cross the Pacific Ocean to Virginia and back — adding 150–300ms of network latency per write. Reads can be fast if you place read replicas in Tokyo. To solve write latency, you could use **multi-leader replication** (as described in DDIA Chapter 5), placing a leader in each region. However, this introduces **write conflicts** that must be resolved with strategies like Last-Write-Wins or CRDTs.
</details>

---

## 📝 Key Interview Talking Points

- Start with SQL unless you have a specific reason for NoSQL
- Indexes are your first tool for query optimization
- Replication solves read scaling; sharding solves write scaling
- Always mention the CAP theorem trade-offs when discussing distributed databases

---

[<< Previous: Scalability](./01_Scalability_Fundamentals.md) | [Home: Curriculum Map](./README.md) | [Next: Caching Strategies >>](./03_Caching_Strategies.md)
