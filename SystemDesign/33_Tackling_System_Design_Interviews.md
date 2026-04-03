# 33: Tackling System Design Interviews

<p align="center">
  <img src="images/sys_interview_framework.jpg" alt="System Design Interview Framework" width="100%"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you will understand the exact step-by-step framework to confidently tackle any system design interview, using the "4-Step Framework" popularized by Alex Xu.**

A System Design interview is not about finding the "perfect" architecture. It is an open-ended conversation designed to evaluate your ability to navigate ambiguity, ask the right questions, estimate constraints, and systematically construct a scalable solution while discussing trade-offs.

---

## 1. 🗺️ The 4-Step Interview Framework

The key to success is structure. Never jump straight into drawing boxes. Follow this proven 4-step framework based on *System Design Interview – An Insider's Guide* (Alex Xu).

<p align="center">
  <img src="images/sd_interview_4steps.jpg" alt="4-Step Interview Framework" width="80%"/>
</p>

### Step 1: Understand the Problem and Establish Design Scope (3-10 minutes)
Start by clarifying exactly what you are building. Do not make assumptions.
*   **Identify core features:** "Is this API for internal users or public?" "Do we need an activity feed or just direct messaging?"
*   **Identify non-functional requirements:** "Does the system need to be highly available (Netflix) or strongly consistent (Banking)?"
*   **Establish boundaries:** "Are we designing the mobile client logic or just the backend architecture?"

### Step 2: Propose High-Level Design and Get Buy-In (10-15 minutes)
Present a macroscopic view of the system before diving into deep technical weeds.
*   **Draw the core components:** Clients, Load Balancer, API Gateway, Web Servers, and Databases.
*   **Walk through a core flow:** Trace a request from the user to the database and back.
*   **Seek agreement:** "Does this high-level architecture align with your expectations before we scale it?"

### Step 3: Design Deep Dive (10-25 minutes)
Once the interviewer agrees with the high-level design, focus on the most difficult scaling challenges.
*   **Identify bottlenecks:** "Our database will choke on 10,000 writes per second."
*   **Solve the bottlenecks:** "Let's introduce Redis for caching reads, and Kafka to asynchronously buffer our writes."
*   **Discuss specific technologies:** Why Cassandra over MySQL? Why gRPC over REST?

### Step 4: Wrap Up (3-5 minutes)
Summarize your architecture and proactively discuss its limitations.
*   **Acknowledge flaws:** "This system handles our current scale, but if traffic spikes 10x, our single-region database will become a bottleneck."
*   **Discuss future scaling:** "In the future, we could implement multi-region active-active replication."

---

## 2. 🧮 Back-of-the-Envelope Estimation

Interviewers often ask for quick math to justify your design decisions. You must know these baseline numbers by heart.

<p align="center">
  <img src="images/sd_interview_estimation.jpg" alt="Estimation Cheat Sheet" width="70%"/>
</p>

### The Golden Numbers to Memorize
*   **Memory (RAM) is fast but limited:** ~100ns to read. Servers typically have 64GB - 256GB.
*   **SSD Storage is cheap but slower than RAM:** ~150us to read. Servers can easily hold terabytes.
*   **Network is the slowest:** Reading 1MB sequentially from memory takes ~250us, from network takes ~10ms.

### Quick Traffic Math
Always assume a **10:1 Read-to-Write ratio** for most consumer applications unless told otherwise.
*   If you have **1 Million Daily Active Users (DAU)** making 10 requests a day:
    `10,000,000 requests / 86,400 seconds in a day ≈ 115 Queries Per Second (QPS)`
*   **Peak QPS** is usually double or triple the average QPS.

---

## 3. ⚖️ Navigating Architecture Trade-Offs

The most important part of the interview is acknowledging that every choice has a cost. There is no right answer, only appropriate compromises.

<p align="center">
  <img src="images/sd_interview_tradeoffs.jpg" alt="Architecture Trade-Offs" width="80%"/>
</p>

When discussing your design, proactively bring up these exact trade-offs:

1.  **Consistency vs. Availability (CAP Theorem):** Are you building a bank (Consistency: No double spending, but the ATM might go offline) or Instagram (Availability: The feed always loads, even if a new photo is delayed by 5 seconds)?
2.  **Latency vs. Throughout:** Are you optimizing for the fastest single response time (Caching, avoiding full table scans) or the massive processing of big data (Kafka, MapReduce)?
3.  **SQL vs. NoSQL:** Structured tabular data with strict ACID guarantees (MySQL/Postgres) versus massive scale unstructured flexible data models (Cassandra/DynamoDB).

---

## 4. 🏋️ Practice Exercises

To master the System Design Interview, you must practice applying the 4-step framework to real-world problems. Try to design the following systems on a whiteboard before checking the solutions.

### Exercise 1: Design a Global Chat System (WhatsApp/Messenger)
**The Scenario:** You need to design a 1-on-1 and group chat system for 50 million daily active users. 
**Practice Focus:** Step 3 (Deep Dive). How do you handle maintaining millions of persistent open connections? How do you ensure messages are sent reliably when users go offline?
<details>
<summary>💡 View Answer</summary>

See Chapter [18: Design a Chat System](./18_Design_Chat_System.md). You should have proposed **WebSockets** for persistent bi-directional connections, a **Presence Service** relying on periodic heartbeats to track online status, and a **Key-Value Store** (like HBase or Cassandra) to store the massive volume of small, sequential message data.
</details>

### Exercise 2: Design a News Feed (Twitter/Facebook)
**The Scenario:** Design a system that displays a continuously updating feed of posts from the people a user follows. You have 300 million DAU.
**Practice Focus:** Step 4 (Deep Dive & Trade-offs). A celebrity with 10 million followers makes a post. How do you prevent your system from crashing when trying to push that post to 10 million individual feeds simultaneously?
<details>
<summary>💡 View Answer</summary>

See Chapter [19: Design a News Feed](./19_Design_News_Feed.md). This focuses purely on the **Fan-out on Write vs Fan-out on Read** problem. You should propose a **Hybrid Approach**: Pre-compute feeds (push model) for regular users, but use an on-demand pull model for celebrities with massive follower counts to prevent the "thundering herd" problem and massive unnecessary compute overhead.
</details>

### Exercise 3: Design an API Rate Limiter
**The Scenario:** Your company exposes an API, and you need to prevent single users from abusing it and bringing down the servers. Limit requests to X per second per user.
**Practice Focus:** Step 1 (Scope) and Step 3 (Deep Dive). Which algorithm should you use? Where should the rate limiter live in the architecture?
<details>
<summary>💡 View Answer</summary>

See Chapter [10: API Design & Gateway](./10_API_Design_and_Gateway.md). You should place the rate limiter at the **API Gateway** level (before requests hit internal services). You should discuss algorithms like **Token Bucket** (for bursty traffic) or **Sliding Window Log** (for high accuracy). You would use an in-memory cache like **Redis** to keep track of request counters due to its extreme speed and built-in atomic operations.
</details>

### Exercise 4: Design a Load Balancer Strategy for a Stateful Application
**The Scenario:** You have a multiplayer gaming service where users connect via WebSockets to a specific game server. You need to distribute incoming game connections.
**Practice Focus:** Step 3 (Deep Dive). Do you use Layer 4 or Layer 7 load balancing? How does the load balancer know which backend server to send a reconnecting player to?
<details>
<summary>💡 View Answer</summary>

See Chapter [32: Load Balancers Deep Dive](./32_Load_Balancers.md). You should propose a **Layer 4 Load Balancer** since game traffic often uses raw TCP or UDP, which Layer 7 (HTTP) balancers don't handle natively. To ensure returning players connect to the specific server running their game match, you must avoid Round Robin and instead implement an **IP Hash** or rely on a centralized session manager (like Redis) while maintaining sticky sessions so the TCP connection is pinned to the correct backend node.
</details>

---

## 🤔 Reflection Questions

1. **You are asked to design a globally distributed highly available system. The interviewer asks: If a network partition occurs between your US and EU data centers, how do you handle incoming user writes?**
<details>
<summary>💡 View Answer</summary>

This is a direct application of the **CAP Theorem** (Consistency, Availability, Partition Tolerance) (See Chapter [05: CAP Theorem & Consistency](./05_CAP_Theorem_Consistency.md)). Because you asserted the system must be "globally distributed" and "highly available" (AP), you must sacrifice immediate Strong Consistency during a split. You would continue to accept writes in both the US and EU data centers to maintain Availability. When the network partition resolves, the system must perform **Conflict Resolution** (e.g., using Last-Write-Wins timestamps, or Vector Clocks, or letting the client resolve the merge as DynamoDB does). 
</details>

2. **Your high-level design shows an API generating short URLs and storing them in a database. The interviewer asks: As traffic hits 100,000 requests per second, your database CPU hits 100% utilization. How do you scale this specifically?**
<details>
<summary>💡 View Answer</summary>

This requires breaking down the bottleneck into Read vs Write paths (See Chapter [17: Design a URL Shortener](./17_Design_URL_Shortener.md)).
First, identify the read/write ratio. URL shorteners are incredibly heavily read-biased (e.g., 100:1). 
**To scale reads:** Introduce a **Cache layer (Redis)** in front of the database to absorb 90%+ of the traffic, completely relieving database CPU.
**To scale writes:** Shard the database horizontally by the URL short-code to distribute the write load across multiple hardware instances.
</details>

3. **You are designing a system like Netflix. You calculate that you need to store 10 Petabytes of video data. The interviewer asks: Should we use an RDBMS (Like MySQL) or a NoSQL database (Like Cassandra) to store these video files?**
<details>
<summary>💡 View Answer</summary>

**Neither.** This is a trick question regarding object storage. Databases (whether SQL or NoSQL) are built for structured data and high-speed queries, not for hosting massive binary blobs. Large video files should be stored in an **Object Storage system (like Amazon S3 or Google Cloud Storage)**, which is designed explicitly for infinite scaling of flat binary files. The database (SQL or NoSQL) should merely store the *metadata* (Video Name, Description, and the URL pointing to the S3 bucket) (See Chapter [20: Design a Video Platform](./20_Design_Video_Platform.md)).
</details>

---

## 📝 Key Interview Talking Points

*   **Structure:** "Before diving into the architecture, I'd like to spend a few minutes clarifying the functional constraints and scale."
*   **Bottlenecks:** "Looking at this high-level design, the clear bottleneck at 10M DAU will be database I/O on the write path."
*   **Mitigation:** "To mitigate this, I propose introducing a message queue (Kafka) to decouple the ingestion from the slow database writes."

---

[<< Previous: Load Balancers Deep Dive](./32_Load_Balancers.md) | [Home: System Design Curriculum](./README.md)
