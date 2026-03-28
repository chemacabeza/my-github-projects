# 12: Data Processing Pipelines

<p align="center">
  <img src="images/sd_data_pipelines.png" alt="Data Processing Pipelines" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand how to process massive datasets using batch and stream processing — MapReduce, Spark, Kafka Streams, and the Lambda Architecture.**

---

## 1. Batch vs Stream Processing

| Aspect | Batch Processing | Stream Processing |
| :--- | :--- | :--- |
| **Input** | Bounded dataset (finite) | Unbounded stream (infinite) |
| **Latency** | Minutes to hours | Milliseconds to seconds |
| **Examples** | Daily reports, ETL jobs | Real-time alerts, live dashboards |
| **Tools** | Hadoop, Spark, Hive | Kafka Streams, Flink, Spark Streaming |

```
BATCH:    [Data Lake] ──→ Process ALL data ──→ [Result]  (run nightly)
STREAM:   [Events] ──→ Process EACH event ──→ [Result]   (real-time)
```

---

## 2. MapReduce

The foundational batch processing model:

<p align="center">
  <img src="images/sd_mapreduce.png" alt="MapReduce Processing Model" width="700"/>
</p>

---

## 3. ETL (Extract-Transform-Load)

<p align="center">
  <img src="images/sd_etl_pipeline.png" alt="ETL Pipeline" width="700"/>
</p>

---

## 4. Stream Processing Concepts

| Concept | Description |
| :--- | :--- |
| **Event** | An immutable fact that happened (e.g., "user clicked button") |
| **Window** | Group events by time (tumbling, sliding, session) |
| **Watermark** | Track event-time progress to handle late arrivals |
| **State** | Maintain running counts, averages, etc. |

### Windowing Types:
```
TUMBLING (Fixed):     [0-5min][5-10min][10-15min]  (no overlap)
SLIDING:              [0-5min]
                       [2-7min]
                        [4-9min]                   (overlap)
SESSION:              [───user active───][gap][───active───]
```

---

## 5. Lambda Architecture

Combines batch and stream for completeness AND speed:

```
                    ┌─── BATCH LAYER ──── [Master Dataset] ──→ Batch Views
RAW DATA ───────────┤
                    └─── SPEED LAYER ──── [Real-time] ──→ Real-time Views
                                                              │
                    SERVING LAYER ←── Query: Merge(Batch + Real-time)
```

| Layer | Purpose | Tool |
| :--- | :--- | :--- |
| **Batch** | Complete, accurate results (slow) | Hadoop, Spark |
| **Speed** | Approximate, real-time results (fast) | Kafka Streams, Flink |
| **Serving** | Merge both for queries | Druid, Elasticsearch |

---

## 🤔 Reflection Questions

1. **Your batch ETL pipeline runs nightly, but the business now wants "near-real-time" dashboards updated every 5 minutes.** Can you just run the batch job more frequently, or do you need a fundamentally different architecture? What are the costs of each approach?

2. **MapReduce is conceptually elegant, but Spark has largely replaced it.** What specific limitations of MapReduce made Spark necessary? Think about iterative algorithms like machine learning — why does writing intermediate results to disk kill performance?

3. **Your streaming pipeline processes credit card transactions in real-time, but an event arrives 30 seconds late** due to mobile network delays. The 1-minute window already closed. How do watermarks and late-arrival policies handle this? Is it acceptable to miss some events?

4. **Lambda Architecture maintains two separate pipelines (batch + speed) that must produce the same results.** Why is this operationally painful? How does Kappa Architecture (stream-only) simplify things, and what does it sacrifice?

5. **Your ETL pipeline silently corrupts data** — a transformation step trims leading zeros from ZIP codes, turning "01234" into "1234". The bug isn't caught for 3 months. How would you design data validation and quality checks to catch such issues early?

---

## 📝 Key Interview Talking Points

- Batch for daily analytics; stream for real-time monitoring
- MapReduce is conceptually important but Spark has largely replaced it
- Lambda architecture is complex — consider **Kappa** (stream-only) as an alternative
- ETL pipelines are the backbone of data warehousing

---

[<< Previous: Microservices](./11_Microservices_Architecture.md) | [Home: Curriculum Map](./README.md) | [Next: Architectural Patterns >>](./13_Architectural_Patterns.md)
