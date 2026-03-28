# 16: DevOps & Deployment

<p align="center">
  <img src="images/sd_devops.png" alt="DevOps and Deployment" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you'll understand CI/CD pipelines, containerization with Docker, orchestration with Kubernetes, and deployment strategies like blue-green and canary.**

---

## 1. CI/CD Pipeline

```
CODE ──→ BUILD ──→ TEST ──→ RELEASE ──→ DEPLOY ──→ MONITOR
  │        │        │         │          │           │
  │ Git    │ Compile │ Unit   │ Artifact │ Canary   │ Alerts
  │ push   │ Docker  │ Integr │ Registry │ Rolling  │ Metrics
  │        │ build   │ E2E    │          │ Blue-Grn │
```

| Stage | Purpose | Tools |
| :--- | :--- | :--- |
| **Source** | Code changes trigger pipeline | GitHub, GitLab |
| **Build** | Compile code, create artifacts | Maven, npm, Docker |
| **Test** | Automated tests | JUnit, pytest, Cypress |
| **Release** | Store built artifacts | Docker Registry, Nexus |
| **Deploy** | Push to production | ArgoCD, Spinnaker |
| **Monitor** | Verify health post-deploy | Prometheus, Grafana |

---

## 2. Docker

```
Dockerfile ──build──→ Image ──run──→ Container
                        │
                        └── Push to Registry (Docker Hub, ECR)
```

| Concept | Description |
| :--- | :--- |
| **Image** | Read-only template (OS + app + dependencies) |
| **Container** | Running instance of an image |
| **Dockerfile** | Recipe to build an image |
| **Registry** | Storage for images (Docker Hub, ECR, GCR) |
| **Volume** | Persistent data storage |
| **Network** | Communication between containers |

---

## 3. Kubernetes

<p align="center">
  <img src="images/sd_kubernetes.png" alt="Kubernetes Cluster Architecture" width="700"/>
</p>

| K8s Object | Purpose |
| :--- | :--- |
| **Pod** | Smallest unit (1+ containers) |
| **Deployment** | Manages Pod replicas + rolling updates |
| **Service** | Stable endpoint to access Pods |
| **Ingress** | HTTP routing from outside the cluster |
| **HPA** | Horizontal Pod Autoscaler |

---

## 4. Deployment Strategies

| Strategy | How | Risk | Rollback |
| :--- | :--- | :--- | :--- |
| **Rolling** | Replace instances one by one | Low | Slow |
| **Blue-Green** | Run old + new, switch traffic | Medium | Instant (switch back) |
| **Canary** | Send 5% traffic to new, then increase | Low | Instant |
| **A/B Testing** | Route by user segment | Low | Instant |

```
BLUE-GREEN:
  [Blue v1.0] ← 100% traffic
  [Green v2.0] ← 0% traffic (testing)
  ── switch ──
  [Blue v1.0] ← 0% (standby)
  [Green v2.0] ← 100% traffic ✅

CANARY:
  [v1.0] ← 95% traffic
  [v2.0] ← 5% traffic (canary)
  ── if healthy ──
  [v1.0] ← 0%
  [v2.0] ← 100% traffic ✅
```

---

## 🤔 Reflection Questions

1. **Your canary deployment sends 5% of traffic to the new version, and metrics look good.** But the 5% were all from the same region, and a bug only affects users in Europe. How would you design a canary that catches region-specific or user-segment-specific bugs?

2. **Docker "works on my machine" is the slogan, but your container runs fine locally and crashes in production.** What differences between local and production environments (OS, network, memory limits, secrets) could cause this? How does your Dockerfile design prevent it?

3. **Kubernetes HPA auto-scales your pods based on CPU usage.** But your app is I/O-bound, not CPU-bound — CPU stays at 10% while users experience timeouts. What custom metrics would you use for scaling, and how does this change your monitoring strategy?

4. **Blue-green deployment gives instant rollback, but it requires running two full copies of your infrastructure.** For a system with 200 pods, that's 400 pods during deployment. How would you justify this cost, or what alternative strategy would you use?

5. **Your CI pipeline takes 45 minutes to run all tests.** Developers start skipping the pipeline and pushing directly. How would you balance test coverage with developer velocity? What techniques (parallelization, test selection, caching) would you apply?

---

## 📝 Key Interview Talking Points

- CI/CD automates the path from code commit to production
- Docker provides consistent environments; K8s provides orchestration
- Canary deployments minimize risk by testing with real traffic
- Blue-green allows instant rollback by switching traffic

---

[<< Previous: Observability](./15_Observability_and_Reliability.md) | [Home: Curriculum Map](./README.md) | [Next: Design URL Shortener >>](./17_Design_URL_Shortener.md)
