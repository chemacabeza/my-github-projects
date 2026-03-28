# 09: Message Queues & Streaming

<p align="center">
  <img src="images/sd_message_queues.png" alt="Message Queues and Streaming" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand how services communicate asynchronously using message queues and event streaming — and when to use Kafka vs RabbitMQ.**

---

## 1. Why Message Queues?

Synchronous communication creates tight coupling:
```
SYNCHRONOUS (Fragile):
  Order Service ──HTTP──→ Payment Service ──HTTP──→ Inventory Service
  (If Payment is down, the entire chain breaks!)

ASYNCHRONOUS (Resilient):
  Order Service ──msg──→ [QUEUE] ──msg──→ Payment Service
                                  ──msg──→ Inventory Service
  (If Payment is down, messages wait in the queue)
```

| Benefit | Description |
| :--- | :--- |
| **Decoupling** | Services don't need to know about each other |
| **Resilience** | Messages survive service failures |
| **Buffering** | Absorbs traffic spikes |
| **Scalability** | Add more consumers to process faster |

---

## 2. Messaging Patterns

### Point-to-Point (Queue)
```
Producer ──→ [Queue] ──→ Consumer
                      (one message, one consumer)
```

### Publish-Subscribe (Topic)
```
Publisher ──→ [Topic] ──→ Subscriber A
                     ──→ Subscriber B
                     ──→ Subscriber C
                  (one message, ALL subscribers)
```

---

## 3. Apache Kafka

Kafka is a distributed event streaming platform, not just a message queue:

```
Producers ──→ [Topic: orders] ──→ Consumer Group A (Order Processing)
              Partition 0: ███████
              Partition 1: ███████  ──→ Consumer Group B (Analytics)
              Partition 2: ███████
```

| Feature | Detail |
| :--- | :--- |
| **Durability** | Messages persisted to disk |
| **Ordering** | Guaranteed within a partition |
| **Retention** | Messages kept for days/weeks (not deleted after read) |
| **Throughput** | Millions of messages/sec |
| **Consumer Groups** | Multiple independent consumers read the same data |

### Why is Kafka Fast?
- Sequential disk I/O (faster than random memory access!)
- Zero-copy transfer (kernel sends data directly to network)
- Batching and compression
- Append-only log (no random writes)

---

## 4. RabbitMQ vs Kafka

| Feature | RabbitMQ | Kafka |
| :--- | :--- | :--- |
| **Model** | Message broker (queue) | Event streaming (log) |
| **Delivery** | Push to consumers | Consumers pull |
| **Ordering** | Per-queue | Per-partition |
| **Retention** | Delete after consumption | Retain for configurable time |
| **Replay** | ❌ No | ✅ Yes |
| **Throughput** | ~50K msg/sec | ~1M msg/sec |
| **Best For** | Task distribution, RPC | Event sourcing, analytics |

---

## 5. Event-Driven Architecture

```
  User signs up ──→ [UserCreated Event]
                         │
                    ┌────┴────────┬────────────┐
                    ▼             ▼             ▼
              Email Service  Analytics     Recommendation
              (Send welcome) (Track)       (Initialize)
```

| Pattern | Description |
| :--- | :--- |
| **Event Notification** | Emit events, consumers react |
| **Event-Carried State** | Event includes all data needed |
| **Event Sourcing** | Store events as source of truth, derive state |
| **CQRS** | Separate read and write models |

---

## 📝 Key Interview Talking Points

- Use message queues when services should be **decoupled** and **resilient to failures**
- Kafka for **event streaming** and replay; RabbitMQ for **task queues**
- Event-driven architecture enables loose coupling between microservices
- Always discuss **message ordering guarantees** and **at-least-once vs exactly-once delivery**

---

[<< Previous: Consensus](./08_Consensus_and_Coordination.md) | [Home: Curriculum Map](./README.md) | [Next: API Design >>](./10_API_Design_and_Gateway.md)
