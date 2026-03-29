# 25: Software Architecture: The Hard Parts

<p align="center">
  <img src="images/sys_distributed_transactions.png" alt="Distributed Transactions and Sagas" width="100%"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you will understand how to safely handle failures across multiple databases. You will learn the complex world of Distributed Transactions.**

In a monolith, updating two tables safely is easy using a classic ACID database transaction. It either fully works, or fully rolls back.

But what if you split those tables into two different microservices? Transactions become the hardest problem in software architecture.

---

## 1. 🪤 The Fallacy of Two-Phase Commits (2PC)

A **Two-Phase Commit (2PC)** is a traditional way to coordinate multiple databases.

A "Coordinator" node tells all databases what to do in two steps:

1.  **Phase 1 (Prepare)**: Coordinator asks Database A and Database B: "Are you ready to commit this data?" Both lock their rows and say "Yes."
2.  **Phase 2 (Commit)**: Coordinator says: "Okay, go ahead and commit!" Both finalize the writes.

### Why is 2PC bad?
It is extremely slow and fragile.
If Database B goes offline during Phase 1, Database A keeps its rows locked indefinitely waiting for a response! The whole system freezes.

---

## 2. 🔄 The Saga Pattern

Modern microservices abandon 2PC and use **Sagas**. A Saga is a sequence of local transactions. Each microservice updates its own database and publishes an event to trigger the next step.

### What if it fails?
Since there is no "global rollback," Sagas use **Compensating Transactions**. 

If Step 3 fails, the system triggers compensating actions to manually "undo" Step 2 and Step 1.

**Example Scenario:**
1. ✅ **Order Service**: Creates an order.
2. ✅ **Payment Service**: Charges credit card.
3. ❌ **Inventory Service**: Fails! Out of stock.
4. ⏪ **Payment Service (Compensating)**: Refunds credit card.
5. ⏪ **Order Service (Compensating)**: Cancels order.

### How are Sagas coordinated?

There are two primary ways:

1.  **Choreography**: No central manager. Services just listen to each other's events. Faster, but harder to track.
2.  **Orchestration**: A central "Saga Manager" service explicitly tells each service what to do. Easier to track complex flows, but adds a single point of failure.

---

## 🤔 Reflection Questions

1. **Why do we never use Two-Phase Commits (2PC) in highly scalable cloud architectures?**
2. **Writing a compensating transaction sounds scary.** What happens if the refund fails while trying to undo the payment? How do you prevent endless loops?

---

## 📝 Key Interview Talking Points

*   **ACID vs BASE**: Sagas sacrifice strict ACID consistency for BASE (Basically Available, Soft state, Eventual consistency) availability.
*   **Compensating Transactions**: Always mention these. Sagas are useless without a rock-solid plan to securely "undo" previous steps.
*   **Orchestration vs Choreography**: Know which one to use. Use Orchestration for complex workflows (like e-commerce checkout). Use Choreography for simple, linear flows.

---

[<< Previous: Micro-Frontends Web Architecture](./24_Micro_Frontends_Web_Architecture.md) | [Home: System Design Curriculum](./README.md) | [Next: Evolutionary Architectures >>](./26_Evolutionary_Architectures_Metrics.md)
