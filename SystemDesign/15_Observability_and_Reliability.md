# 15: Observability & Reliability

<p align="center">
  <img src="images/sd_observability.png" alt="Observability and Reliability" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand the three pillars of observability — logs, metrics, and traces — and how to measure and improve system reliability.**

---

## 1. The Three Pillars of Observability

```
       LOGS                METRICS              TRACES
  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
  │ Discrete     │   │ Aggregated   │   │ Request flow │
  │ events       │   │ numbers      │   │ across       │
  │              │   │ over time    │   │ services     │
  │ "What        │   │ "How much?   │   │ "Where is    │
  │  happened?"  │   │  How fast?"  │   │  the delay?" │
  └──────────────┘   └──────────────┘   └──────────────┘
  ELK Stack          Prometheus          Jaeger
  Splunk             Grafana             Zipkin
  CloudWatch         Datadog             OpenTelemetry
```

---

## 2. Logs

| Level | When | Example |
| :--- | :--- | :--- |
| **DEBUG** | Development details | "Parsing response from API" |
| **INFO** | Normal operations | "User login successful" |
| **WARN** | Something unexpected | "Cache miss, falling back to DB" |
| **ERROR** | Something failed | "Payment processing failed" |
| **FATAL** | System is crashing | "Database connection pool exhausted" |

### Structured Logging:
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "ERROR",
  "service": "payment-service",
  "message": "Payment failed",
  "user_id": "u123",
  "order_id": "o456",
  "error": "Insufficient funds",
  "trace_id": "abc-def-123"
}
```

---

## 3. Metrics

| Type | Description | Example |
| :--- | :--- | :--- |
| **Counter** | Only goes up | Total requests, errors |
| **Gauge** | Goes up and down | Current CPU %, active connections |
| **Histogram** | Distribution of values | Request latency distribution |
| **Summary** | Percentiles (p50, p95, p99) | Response time percentiles |

### Key Metrics (RED Method):
| Metric | Measures |
| :--- | :--- |
| **R**ate | Requests per second |
| **E**rrors | Error rate (% of failed requests) |
| **D**uration | Latency (how long requests take) |

---

## 4. Distributed Tracing

```
Request: GET /checkout

API Gateway [2ms] ──→ Order Service [15ms] ──→ Payment Service [200ms] ──→ DB [50ms]
                                             ──→ Inventory Service [30ms]

Total: 297ms  │  Bottleneck: Payment Service (200ms = 67% of total time!)
```

Each service adds a **span** with timing. The entire request path = a **trace** (identified by a **trace ID**).

---

## 5. Reliability: SLI, SLO, SLA

| Term | Definition | Example |
| :--- | :--- | :--- |
| **SLI** (Service Level Indicator) | A measurable metric | "99.2% of requests < 200ms" |
| **SLO** (Service Level Objective) | Internal target for SLI | "99.9% availability each month" |
| **SLA** (Service Level Agreement) | Legal contract with customers | "99.95% uptime or credits issued" |

```
SLA (External Promise) ≤ SLO (Internal Target) ≤ SLI (Actual Measurement)
         99.95%                99.99%                 99.998%
```

### Error Budget:
```
SLO: 99.9% availability = 0.1% allowed downtime
Month: 30 days × 24h × 60min = 43,200 minutes
Error Budget: 43,200 × 0.001 = 43.2 minutes of downtime allowed
```

---

## 📝 Key Interview Talking Points

- Use **structured logging** (JSON) for searchability
- RED metrics (Rate, Errors, Duration) are the baseline for any service
- Distributed tracing is essential in microservices to find bottlenecks
- Error budgets balance the tension between reliability and feature velocity

---

[<< Previous: Security](./14_Security_and_Authentication.md) | [Home: Curriculum Map](./README.md) | [Next: DevOps >>](./16_DevOps_and_Deployment.md)
