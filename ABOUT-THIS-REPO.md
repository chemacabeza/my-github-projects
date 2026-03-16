# 🚀 About This Repository

<p align="center">
    <img src="images/MyRepo1.jpg" width="700" alt="Repo Banner"/>
</p>

Welcome to my **Engineering Playground**—the digital lab where I turn coffee into code and wild ideas into working software. 🧪✨

This isn't just a code dump; it's a curated collection of **experiments, tools, and production-ready architectures**. Whether it's spinning up an AI video generation studio, forging intelligent art with diffusion models, automating the boring stuff with shell scripts, or architecting robust backends—this repo is where I **build, break, and ship**.  

---

## 🎬 test-for-ai-wan: AI Video Generation Studio
*Full-stack generative video platform. Built like a SaaS product.*

> "I wanted to explore fal.ai's video models. Four days later I had a production-ready platform."

This is the project that showcases everything in one place — **Spring Boot, React, PostgreSQL, Docker, async job orchestration, and 5 state-of-the-art AI video models** all wired together:

**What it does:**
- 📝 **Text → Video**: Describe a scene in words. The app submits the job to fal.ai, polls the status asynchronously, and presents the finished video in a live-updating gallery.
- 🖼️ **Image → Video**: Upload any photo and a motion prompt. Watch it come to life.

**AI models supported** (each with its own constraints enforced in the UI):

| Model | Duration | Notes |
|---|---|---|
| **Wan 2.6** | 5 / 10 / 15 s | Default. Versatile, cinematic quality. |
| **Wan 2.2-A14B** | 5 / 10 / 15 s | Higher-fidelity variant. |
| **Kling v2.5 Turbo Pro** | 5 / 10 s | Kuaishou's flagship. Unparalleled motion fluidity. |
| **LTX-2 19B** | Frame-count | Open-source giant from Lightricks — generates audio too. |
| **PixVerse v5** | 5 / 8 s | Creative and stylistic generations. |

**Stack (end-to-end, all Dockerised):**

| Layer | Tech |
|---|---|
| Frontend | React + Vite, live job cards, per-model form validation, drag-and-drop image upload |
| Backend | Spring Boot 3, REST API, reactive `WebClient`, scheduled async polling |
| Database | PostgreSQL + Flyway migrations (`model` column added live, zero downtime) |
| Infra | Docker Compose, Nginx reverse proxy, multi-stage Docker builds |
| AI Layer | fal.ai queue API — 5 endpoints, dynamic routing, per-model parameter enforcement |

**Engineering highlights:**
- 🔁 **Async job lifecycle** — job submitted, polled every 15 s by a Spring `@Scheduled` task, marked `COMPLETED`/`FAILED` automatically, surfaced in the UI without a page refresh
- ✅ **Per-model validation** — discovered at runtime that Kling only accepts 5 s/10 s durations; curl-tested every endpoint, then enforced constraints in frontend dropdowns *and* backend `@Pattern` validators — invalid payloads are impossible to submit
- 🧩 **Clean extensibility** — adding a new model is one map entry in `FalAiService` + one item in the frontend `MODELS` array
- 🗄️ **Live DB migration** — V3 Flyway migration adds the `model` column with a default, leaving existing rows fully intact

→ **Source**: [`test-for-ai-wan/`](test-for-ai-wan/)

---

## 🧠 AI-Related: The Creative Engine
*Where algorithms dream.*

This folder is the bleeding edge of my generative AI explorations. It's a mix of rigorous study and wild experimentation.
- **Flux Step-by-Step**: A masterclass in AI media workflows. Theory meets practice in a structured roadmap.
- **Stable Diffusion & Fooocus**: Pure creative fire. Sculpting pixels into breathtaking reality. 🎨
- **Coursework & Labs**: My personal notes and hands-on labs from top-tier AI courses.

**Current model library (as of 2026-03-16):**
- 🏛️ **7 SDXL checkpoint models** — general-purpose, anime, stock photography, Chinese style, and more
- 🎭 **40 LoRAs** — 5 standard style/utility LoRAs + **35 custom character LoRAs** representing women from 34 different nationalities (Sweden, Russia, Japan, Germany, Guinea, China, Ukraine, Australia, USA, Morocco, Scotland, Italy, Cuba, Finland, Poland, Serbia, the Netherlands, Portugal, Greenland, Slovenia, Estonia, Latvia, Lithuania, Belarus, India, Venezuela, Chile, Mongolia, Peru, and more)

## ⚡ Bash: Automate Everything
*Why click when you can script?*

This is the turbo-charged automation hub. A Swiss-army knife of shell scripts designed to:
- 🚀 **Deploy** environments in seconds.
- 🔧 **Fix** complex issues with a single command.
- ⏱️ **Save** hours of repetitive work.

It's pure command-line adrenaline for the efficiency-obsessed.

## ☕ Java + Spring Boot: The Heavy Lifters
*Enterprise-grade power.*

The engine room of the repository. Here, I craft scalable backends using **Java** and **Spring Boot**.
- **Microservices**: Built for scale and resilience.
- **REST APIs**: Clean, documented, and production-ready.
- **Architecture**: Where solid design patterns meet real-world application.

## 🧮 Neural Network with Java: Multi-Model ML Platform
*Where AI training meets enterprise deployment.*

A production-ready **multi-model ML inference platform** that bridges Python and Java, demonstrating end-to-end ML deployment with guaranteed cross-runtime parity:

**Supported Models:**
- **🌸 Iris Classification (MLP)**: Tabular data — 4 features → 3 classes, PyTorch MLP, 91%+ accuracy
- **🔢 MNIST Digit Recognition (CNN)**: Image data — 28×28 grayscale → 10 digits, PyTorch CNN, 99.13% accuracy
- **👓 Glasses Detection (ResNet18)**: Binary image classification — 128×128 grayscale face images, transfer learning on CelebA dataset, 98.12% accuracy, realtime webcam detection
- **📄 Document Reader**: Text extraction from PDF and TXT files via drag-and-drop upload

**Architecture & Pipeline:**
- **PyTorch Training**: Deterministic training with fixed seeds for MLP, CNN, and ResNet architectures
- **ONNX Export**: Dynamic batch axis, embedded preprocessing (StandardScaler/normalization), float32 enforcement
- **ModelRegistry**: Centralized registry pattern serving multiple models simultaneously (`/models/{name}/predict`)
- **Spring Boot Service**: Multi-model REST API with health checks, CORS, per-model endpoints, and document processing
- **React Frontend**: Interactive UI with Iris prediction forms, digit canvas drawing, glasses detection (webcam), document reader (drag-and-drop), and image upload

**Quality & Testing:**
- **Golden Parity Tests**: Per-model golden tests ensuring identical outputs between Python and Java ONNX Runtime (tolerance: 1e-5)
- **Comprehensive Test Suite**: Unit tests, integration tests, 4D tensor handling, image processing validation
- **CI/CD Ready**: Docker multi-stage builds, Docker Compose with nginx reverse proxy, Makefile automation, `start-app.sh` for macOS/Ubuntu

**Key Features:**
- Multi-model serving with isolated artifacts (`artifact/iris/`, `artifact/mnist/`, `artifact/glasses/`)
- Embedded preprocessing in ONNX (eliminates Python↔Java drift)
- Image processing pipelines: base64 → grayscale → resize → normalized pixels
- 4D tensor support for CNN/ResNet models (NCHW format)
- Docker Compose orchestration and multi-platform support (macOS/Ubuntu)
- Full documentation with troubleshooting guides

This project showcases the complete lifecycle of deploying ML models in Java environments, from training to production serving with multiple model architectures.

---

> "Talk is cheap. Show me the code." - Linus Torvalds
