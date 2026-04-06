# 29: Design a Metrics Monitoring System

<p align="center">
  <img src="images/sys_metrics_monitoring.png" alt="Metrics Monitoring System Design" width="100%"/>
</p>

> 🧠 **The Feynman Hook:** A metrics monitoring system is an ICU vital signs monitor at scale. One patient's heart rate is trivial to track. Monitoring 50,000 patients simultaneously — all of them generating heartbeats every second — requires specialised hardware and storage that a regular hospital clipboard cannot handle. That's why metrics monitoring systems use Time-Series Databases (TSDBs) instead of regular SQL: just as an EKG machine records time-stamped waveforms on a continuous roll of paper rather than a spreadsheet, TSDBs are purpose-built for append-only, time-indexed data.

## 🎯 What You'll Learn

> **After this chapter, you will know how to design massive systems that monitor system health, like Datadog or Prometheus.**

Every large system generates millions of logs and metrics every second (e.g., CPU load: 85%). Where does that data go? How do you query it without crashing the database?

You need specialized pipelines that handle pure telemetry data at extreme speed.

---

## 1. 🗃️ Time-Series Databases (TSDB)

You cannot use MySQL or PostgreSQL to store billions of CPU readings per minute. It will die.

You must build the system entirely around a **Time-Series Database (TSDB)**, like InfluxDB or Prometheus.

*   🕒 **Time is the Index**: Every single row of data is indexed purely by a timestamp.
*   📉 **Compression**: TSDBs use heavy algorithmic compression uniquely designed for numbers that change slightly over time.
*   🧊 **Downsampling**: Old data is automatically summarized. Last week's minute-by-minute data gets compressed into hourly averages automatically to save space.

---

## 2. 🧲 Push vs Pull Data Models

> **Feynman Insight:** Pull model (Prometheus) is like a nurse doing rounds: every 10 seconds, the nurse walks to each patient's room and records their vitals. If the patient discharged (server died), the nurse's empty clipboard tells you immediately. Push model (Datadog) is like patients pressing a nurse button: they self-report when something changes. Perfect for patients who may be discharged mid-round (ephemeral containers, Lambda functions) — they push their readings before they disappear.

How does the telemetry data actually get completely into your central TSDB? 

There are two massive industry camps:

### 📥 The Pull Model (Direct Fetching)
*   Used by **Prometheus**.
*   The central monitoring server "pulls" or scrapes data actively from your microservices every 10 seconds.
*   ✅ **Pros**: The central server cannot be easily overwhelmed. It controls the tempo securely. Easy to know if a server is entirely dead (it won't respond to the pull).

### 📤 The Push Model (Direct Sending)
*   Used by **Datadog** and **New Relic**.
*   The individual microservices "push" their data into a central log aggregator automatically.
*   ✅ **Pros**: Better for temporary environments completely (like AWS Lambda) where the server spins up, pushes data, and permanently dies before a Pull model could scrape it.

---

## 🤔 Reflection Questions

1. **If a thousand thousands (a million) servers suddenly push metrics to your system at the exact same second, how do you completely prevent your backend from melting?** (Hint: Place a highly scaled Kafka queue directly in front of your TSDB).
<details>
<summary>💡 View Answer</summary>

Place a **Kafka cluster** as a buffer between the metric producers (servers) and the Time-Series Database (TSDB). Kafka absorbs the burst by writing metrics to disk-backed partitions at wire speed (sequential I/O). The TSDB consumers read from Kafka at their own sustainable rate. Even if 1 million servers push simultaneously, Kafka's partitioned log handles millions of writes per second without breaking a sweat. As *Kafka: The Definitive Guide* explains, this is exactly the pattern Kafka was designed for — decoupling producers from consumers so that a burst in production doesn't overwhelm the downstream system. Alex Xu's monitoring system design uses this exact architecture.
</details>

2. **When scaling out a Time-Series Database, what makes more architectural sense: Sharding the database by Server ID or safely sharding it by Timestamp exactly?**
<details>
<summary>💡 View Answer</summary>

**Shard by Timestamp** (time-range partitioning). Metrics are almost always queried by time range ("show me CPU usage for the last 6 hours"), not by server ID. If you shard by server ID, a time-range query must scatter to *every* shard (every server's shard has data for every time range). With time-based sharding, the query targets only the 1-2 shards covering the requested time window. Additionally, old data can be cheaply archived by simply moving the oldest time shard to cold storage. As Alex Xu explains in his TSDB design, InfluxDB and Prometheus both use time-based sharding internally for exactly this reason.
</details>

---

## 📝 Key Interview Talking Points

*   **TSDBs vs Relational DBs**: Prove you distinctly know that Time-Series databases exactly are highly specialized for heavy sequential writes comprehensively and compressed time-range queries cleverly. 
*   **Decoupling Ingestion**: Never write data directly to the database. Always explicitly put an event broker nicely (like Kafka/Kinesis) comfortably between your metric agents and your TSDB efficiently.
*   **The Pull vs Push Argument**: Explain perfectly when to clearly use actively push actively (ephemeral containers, lambda functions) versus elegantly pull purely (long-running servers cleanly).

---

[<< Previous: Proximity Service](./28_Design_Proximity_Service_Maps.md) | [Home: System Design Curriculum](./README.md) | [Next: Distributed Message Queue >>](./30_Design_Distributed_Message_Queue.md)
