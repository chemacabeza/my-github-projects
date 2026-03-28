# The System Design Mastery Curriculum

<p align="center">
  <img src="images/sd_cover.png" alt="System Design Mastery" width="800"/>
</p>

Welcome to the **System Design Mastery Guide**. This repository contains a complete, **20-chapter curriculum** spanning 5 phases, designed to take you from fundamental concepts to designing real-world systems at scale.

This curriculum was synthesized from **9 professional-grade textbooks**: *Designing Data-Intensive Applications* (Kleppmann), *System Design Interview Volumes 1 & 2* (Alex Xu), *ByteByteGo Big Archive 2023*, *AlgoMaster System Design Handbook*, *The C4 Model* (Simon Brown), *CQRS Journey Guide*, *Microservices for Java Developers*, and *The Clean Coder*.

---

## 📖 Curriculum Map

### Phase 1: Foundations
*The building blocks every system architect must know.*

* [**01: Scalability Fundamentals**](./01_Scalability_Fundamentals.md) - Vertical vs horizontal scaling, load balancers, CDN, stateless design, and the scaling roadmap from 100 to 100M users.
* [**02: Databases & Storage**](./02_Databases_and_Storage.md) - SQL vs NoSQL, ACID properties, indexing (B-Tree, hash), replication, and sharding strategies.
* [**03: Caching Strategies**](./03_Caching_Strategies.md) - Cache-aside, write-through, write-back, eviction policies (LRU, LFU), Redis, and cache invalidation.
* [**04: Networking & Protocols**](./04_Networking_and_Protocols.md) - HTTP, REST vs GraphQL vs gRPC, WebSockets, DNS resolution, TCP vs UDP, and TLS encryption.

### Phase 2: Distributed Systems
*The theory that powers every large-scale system.*

* [**05: CAP Theorem & Consistency**](./05_CAP_Theorem_Consistency.md) - CAP triangle, CP vs AP systems, consistency spectrum, ACID vs BASE, and conflict resolution.
* [**06: Replication & Partitioning**](./06_Replication_and_Partitioning.md) - Leader-follower, multi-leader, leaderless replication, sharding, consistent hashing, and rebalancing.
* [**07: Transactions & Concurrency**](./07_Transactions_and_Concurrency.md) - Isolation levels, two-phase commit, Saga pattern, optimistic vs pessimistic locking.
* [**08: Consensus & Coordination**](./08_Consensus_and_Coordination.md) - Raft consensus, quorum, ZooKeeper/etcd, distributed locks, and heartbeat failure detection.

### Phase 3: Building Blocks
*The components that connect modern systems together.*

* [**09: Message Queues & Streaming**](./09_Message_Queues_and_Streaming.md) - Kafka vs RabbitMQ, pub/sub, event-driven architecture, and event sourcing.
* [**10: API Design & Gateway**](./10_API_Design_and_Gateway.md) - API gateway, rate limiting (token bucket), pagination, versioning, and idempotency.
* [**11: Microservices Architecture**](./11_Microservices_Architecture.md) - Service decomposition, circuit breaker, service discovery, and communication patterns.
* [**12: Data Processing Pipelines**](./12_Data_Processing_Pipelines.md) - Batch (MapReduce) vs stream processing, ETL, Lambda architecture, and windowing.

### Phase 4: Architecture & Patterns
*Design patterns and operational practices for production systems.*

* [**13: Architectural Patterns**](./13_Architectural_Patterns.md) - Monolith, microservices, serverless, event-driven, CQRS, event sourcing, and the C4 model.
* [**14: Security & Authentication**](./14_Security_and_Authentication.md) - OAuth 2.0, JWT, symmetric vs asymmetric encryption, and API security best practices.
* [**15: Observability & Reliability**](./15_Observability_and_Reliability.md) - Logs, metrics, traces, SLI/SLO/SLA, error budgets, and the RED method.
* [**16: DevOps & Deployment**](./16_DevOps_and_Deployment.md) - CI/CD pipelines, Docker, Kubernetes, blue-green, and canary deployments.

### Phase 5: Real-World System Designs
*End-to-end system design exercises modeled on interview-style problems.*

* [**17: Design a URL Shortener**](./17_Design_URL_Shortener.md) - Base62 encoding, pre-generated keys, 301 vs 302 redirects, caching, and analytics.
* [**18: Design a Chat System**](./18_Design_Chat_System.md) - WebSocket, message delivery, group chat fan-out, presence (heartbeats), and message storage.
* [**19: Design a News Feed**](./19_Design_News_Feed.md) - Fan-out on write vs read, hybrid approach, ranking algorithms, and feed cache (Redis sorted sets).
* [**20: Design a Video Platform**](./20_Design_Video_Platform.md) - Upload pipeline, transcoding, adaptive bitrate (HLS/DASH), CDN, and recommendation engine.

---

## 🚀 How to Use This Curriculum

1. **Beginners:** Start with Phase 1 and work through sequentially
2. **Interview Prep:** Focus on Phases 3-5 for the most common interview topics
3. **Deep Dive:** Phase 2 covers the distributed systems theory behind everything
4. **Quick Reference:** Each chapter includes a 📝 Key Talking Points section
