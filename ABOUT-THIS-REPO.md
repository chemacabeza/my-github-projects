# 🚀 About This Repository

<p align="center">
    <img src="images/MyRepo1.jpg" width="700" alt="Repo Banner"/>
</p>

Welcome to my **Engineering Playground**—the digital lab where I turn coffee into code and wild ideas into working software. 🧪✨

This isn't just a code dump; it's a curated collection of **experiments, tools, and production-ready architectures**. Whether it's forging intelligent art with AI, automating the boring stuff with shell scripts, or architecting robust backends, this repo is where I **build, break, and optimize**.

---

## 🧠 AI-Related: The Creative Engine
*Where algorithms dream.*

This folder is the bleeding edge of my generative AI explorations. It's a mix of rigorous study and wild experimentation.
- **Flux Step-by-Step**: A masterclass in AI media workflows. Theory meets practice in a structured roadmap.
- **Stable Diffusion & Fooocus**: Pure creative fire. Sculpting pixels into breathtaking reality. 🎨
- **Coursework & Labs**: My personal notes and hands-on labs from top-tier AI courses.

**Current model library (as of 2026-02-21):**
- 🏛️ **7 SDXL checkpoint models** — general-purpose, anime, stock photography, Chinese style, and more
- 🎭 **36 LoRAs** — 5 standard style/utility LoRAs + **31 custom character LoRAs** representing women from 30 different nationalities (Sweden, Russia, Japan, Germany, Guinea, China, Ukraine, Australia, USA, Morocco, Scotland, Italy, Cuba, Finland, Poland, Serbia, the Netherlands, Portugal, Greenland, Slovenia, Estonia, Latvia, Lithuania, Belarus, India, and more)

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
- **👓 Glasses Detection (ResNet18)**: Binary image classification — 128×128 grayscale face images, transfer learning on CelebA dataset

**Architecture & Pipeline:**
- **PyTorch Training**: Deterministic training with fixed seeds for MLP, CNN, and ResNet architectures
- **ONNX Export**: Dynamic batch axis, embedded preprocessing (StandardScaler/normalization), float32 enforcement
- **ModelRegistry**: Centralized registry pattern serving multiple models simultaneously (`/models/{name}/predict`)
- **Spring Boot Service**: Multi-model REST API with health checks, CORS, and per-model endpoints
- **React Frontend**: Interactive UI with Iris prediction forms, digit canvas drawing, glasses detection, image upload, and webcam capture

**Quality & Testing:**
- **Golden Parity Tests**: Per-model golden tests ensuring identical outputs between Python and Java ONNX Runtime (tolerance: 1e-5)
- **Comprehensive Test Suite**: Unit tests, integration tests, 4D tensor handling, image processing validation
- **CI/CD Ready**: Docker multi-stage builds, Docker Compose, Makefile automation, `start-app.sh` for macOS/Ubuntu

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
