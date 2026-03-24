# My Github Projects

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/chemacabeza/my-github-projects)](https://github.com/chemacabeza/my-github-projects/commits/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

<p align="center">
    <img src="images/MainImage2.jpg" width="700"/>
</p>

> **A comprehensive portfolio showcasing expertise in AI, Bash scripting, and Enterprise Java development**

* [ABOUT ME](ABOUT-ME.md)
* [ABOUT THIS REPOSITORY](ABOUT-THIS-REPO.md)

---

## 🎯 Start Here

**New to this repository?** Choose your path:

| Audience | Recommended Starting Point |
|----------|---------------------------|
| 🔍 **Recruiters** | ⚡ [AI Video Studio →](https://github.com/chemacabeza/test-for-ai-wan) · 🔊 [AI Voice Studio →](https://github.com/chemacabeza/test-for-audio-generation) · 🎧 [AI Audio Listener →](https://github.com/chemacabeza/test-for-audio-listener) · 🎙️ [AI Voice Assistant →](https://github.com/chemacabeza/test-ai-asistant) · [Skills Matrix](SKILLS-MATRIX.md) |
| 💼 **Hiring Managers** | [About Me](ABOUT-ME.md) → [Project Highlights](PROJECT-HIGHLIGHTS.md) → Live demos below |
| 💻 **Developers** | [Quick Start](QUICK-START.md) → [Examples](examples/) → Section-specific docs |
| 🎨 **AI Enthusiasts** | [AI Video Studio](https://github.com/chemacabeza/test-for-ai-wan) · [AI Voice Studio](https://github.com/chemacabeza/test-for-audio-generation) · [AI Audio Listener](https://github.com/chemacabeza/test-for-audio-listener) · [AI Voice Assistant](https://github.com/chemacabeza/test-ai-asistant) |
| ☕ **Backend Engineers** | [Java Projects](JavaSpringBoot/PROJECT-CATALOG.md) → [Architecture Docs](JavaSpringBoot/docs/) |
| ⚡ **DevOps/SRE** | [Bash Guide](bash/README.md) → [Docker configs](AI-related/Dockerfile) |

---

## 📊 Portfolio Overview

- 🎬 **AI Video Studio** — full-stack generative video platform (Spring Boot · React · PostgreSQL · 5 fal.ai models · Docker)
- 🔊 **AI Voice Studio** — full-stack TTS platform (Spring Boot · React · OpenAI TTS API · 11 voices · Docker)
- 🎧 **AI Audio Listener** — full-stack STT platform (Spring Boot · Next.js · OpenAI Whisper API · PostgreSQL · Docker)
- 🎙️ **AI Voice Assistant** — full-stack conversational AI (Spring Boot · React · OpenAI GPT-4o + Whisper + TTS · 9 languages · Docker)
- 🚀 **70+ Spring Boot Projects** across 10 enterprise patterns (REST, Security, MVC, JPA, AOP)
- 🎨 **46GB AI Model Library** with 7 SDXL checkpoints + 41 LoRA fine-tuning models
- 📖 **35-Chapter Bash Guide** with 236 executable scripts and hands-on examples
- ✅ **133+ Test Classes** demonstrating quality-first development
- 🏗️ **Production-Ready Deployments** via Docker Compose, Nginx, Maven, multi-stage builds

---

## 🌟 Featured Projects

> 🔍 **Recruiters:** jump straight to the three AI studios below — they showcase the most breadth and depth in the shortest time.

---

### ⚡ AI Video Generation Studio — `test-for-ai-wan`
*From zero to production-ready SaaS platform in days. Not weeks. Days.*

A **full-stack AI video platform** that lets you type a prompt (or upload an image) and watch state-of-the-art generative models turn it into a video — right in your browser. Built from scratch with the same rigour you'd apply to a commercial product.

- **Tech Stack**: Spring Boot 3 · React 18 + Vite · PostgreSQL · Flyway · Docker Compose · Nginx · fal.ai queue API
- **AI Models**: 5 state-of-the-art models — Wan 2.6, Wan 2.2-A14B, Kling v2.5 Turbo Pro, LTX-2 19B, PixVerse v5
- **Architecture**: Async job lifecycle (submit → scheduled polling → live UI update), per-model parameter enforcement, reactive `WebClient`, multi-stage Docker builds
- **Highlights**: Zero-downtime live DB migrations via Flyway, curl-validated endpoints, clean extensibility — adding a new model is one config entry
- **[Explore AI Video Studio →](https://github.com/chemacabeza/test-for-ai-wan)**

---

### 🔊 AI Voice Studio — `test-for-audio-generation`
*Because audio generation is fascinating — and a great test of secure full-stack design.*

A **full-stack Text-to-Speech application** that converts any text into natural, expressive speech via the OpenAI TTS API — played back instantly in the browser as a streamed MP3. The API key lives exclusively on the backend; the React frontend never sees it.

- **Tech Stack**: Spring Boot 3 · React 18 + Vite 5 · OpenAI TTS API · Docker Compose · Nginx
- **Voices**: 11 OpenAI voices (alloy, nova, onyx, shimmer, ash, ballad, coral, echo, fable, sage, verse)
- **Architecture**: Binary MP3 streamed as `audio/mpeg`; key isolation via environment variables only; one-command Docker startup with health checks
- **Highlights**: Clean security model (key never in browser), custom speaking instructions, stateless backend — scales horizontally with zero changes
- **[Explore AI Voice Studio →](https://github.com/chemacabeza/test-for-audio-generation)**
 
---
 
### 🎧 AI Audio Listener — `test-for-audio-listener`
*Because transcribing audio is as useful as it is complex — and a great test of high-performance Java.*
 
A **full-stack Audio Intelligence platform** that turns any speech (live mic or file upload) into accurate text using the OpenAI Whisper API. Features persistent transcription history, full-text search, and a refined Next.js interface.
 
- **Tech Stack**: Spring Boot 3 · Next.js 15 · PostgreSQL · Flyway · Docker Compose · OpenAI Whisper API
- **Features**: Live microphone recording, multi-format file uploads, searchable transcription archive, persistent storage
- **Architecture**: Modular Spring Boot service for transcription orchestration; Next.js 15 frontend for a lightning-fast UI; Dockerized for instant local setup
- **Highlights**: Production-grade error handling, containerized PostgreSQL with Flyway migrations, clean separation of concerns between audio processing and UI
- **[Explore AI Audio Listener →](https://github.com/chemacabeza/test-for-audio-listener)**
 
---

### 🎙️ AI Voice Assistant — `test-ai-asistant`
*"Hey Nova, tell me a joke." — Your own AI assistant, built from scratch.*

A **full-stack conversational AI voice assistant** that listens, thinks, and speaks back — just like Alexa or Google Assistant, but fully customizable. Speak naturally, and the system transcribes your voice (Whisper), generates an intelligent response (GPT-4o), and speaks it back in a natural voice (TTS) — all in real time. Features wake word detection, 9 languages, custom AI names, and both online and offline modes.

- **Tech Stack**: Spring Boot 3 · React + Vite · OpenAI (Whisper + GPT-4o + TTS) · Docker Compose · Nginx
- **Features**: Wake word detection, 9 languages, 6 voice personas, push-to-talk & continuous listening, online/offline dual backends
- **Architecture**: Three-stage pipeline (STT → Chat → TTS), secure API key isolation, health-checked Docker orchestration
- **Highlights**: Fully conversational loop in the browser, custom AI naming, offline fallback backend, one-command Docker startup
- **[Explore AI Voice Assistant →](https://github.com/chemacabeza/test-ai-asistant)**

---

### 🧠 ML Inference Pipeline (PyTorch → ONNX → Java)
Multi-model serving on a single Spring Boot REST API — Iris MLP, MNIST CNN (99.13%), Glasses ResNet18 (98.12%), Document Reader — trained in Python, exported to ONNX, and deployed in Java with golden parity tests guaranteeing identical outputs across runtimes.

- **Tech Stack**: PyTorch, ONNX Runtime, Spring Boot 3, React, WebSocket, Docker
- **[Explore ML Pipeline →](https://github.com/chemacabeza/neural-network-with-java)**

---

### 🎨 AI Image Generation Platform
Production-ready **Fooocus** deployment with a 46 GB model library: 7 SDXL checkpoints, 41 LoRAs (including 35 custom character LoRAs spanning 34 nationalities), Apple Silicon optimisation, and Docker containerisation.

- **Tech Stack**: Python 3.12, PyTorch, Docker, CUDA/MPS GPU acceleration
- **[Explore AI Projects →](AI-related/README.md)**

---

### ⚡ Bash In Depth: The Complete Guide
Comprehensive **35-chapter guide** to advanced Bash scripting — from fundamentals to production patterns.

- **Tech Stack**: 236 shell scripts, 35 structured chapters across 7 parts
- **[Learn Bash →](bash/README.md)**

---

### ☕ Enterprise Java Microservices
Full-stack **Spring Boot 3.x** applications demonstrating enterprise patterns and best practices.

- **Tech Stack**: Spring Boot 3, Spring Framework 6, Hibernate/JPA, Spring Security, MySQL
- **[View Java Projects →](JavaSpringBoot/README.md)**

**Want more details?** → [View all project highlights with impact statements](PROJECT-HIGHLIGHTS.md)

---

## 📚 CONTENTS

* [🎬 AI VIDEO STUDIO](https://github.com/chemacabeza/test-for-ai-wan) ← **Start here**
* [🔊 AI VOICE STUDIO](https://github.com/chemacabeza/test-for-audio-generation) ← **Start here**
* [🎧 AI AUDIO LISTENER](https://github.com/chemacabeza/test-for-audio-listener) ← **Start here**
* [🎙️ AI VOICE ASSISTANT](https://github.com/chemacabeza/test-ai-asistant) ← **Start here**
* [AI RELATED](AI-related/README.md)
* [BASH](bash/README.md)
* [JAVA + SPRING BOOT](JavaSpringBoot/README.md)
* [ML INFERENCE PIPELINE](neural-network-with-java/README.md)

---

## 🚀 Quick Start

Each section contains its own detailed setup instructions:

- **AI Video Studio**: `cd test-for-ai-wan && ./run.sh start` → Frontend: http://localhost:3000 | API: http://localhost:8080
- **AI Voice Studio**: `cd test-for-audio-generation && ./start.sh start` → http://localhost
- **AI Audio Listener**: `cd test-for-audio-listener && ./start.sh start` → http://localhost:3000 (React) | http://localhost:8080 (API)
- **AI Voice Assistant**: `cd test-ai-asistant && ./start.sh start` → http://localhost:3000 (UI) | http://localhost:8080 (API)
- **AI Image Gen**: `cd AI-related && make run` (Docker) or `make install-local && make run-local`
- **Bash**: Navigate to `bash/chapters/` and explore the structured learning path
- **Java**: Individual Maven projects with `mvn spring-boot:run` in each subdirectory

---

## 🤝 Contributing

This is primarily a personal portfolio and learning archive, but contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📜 License

This repository is licensed under the **[Apache License 2.0](LICENSE)**.

### Third-Party Components

- **Fooocus**: [Apache 2.0 License](https://github.com/lllyasviel/Fooocus)
- **AI Models**: Various licenses (CreativeML, Apache, etc.) - see [AI-related/README.md](AI-related/README.md) for details
- **Course Materials**: Personal notes and interpretations from educational courses
- **Spring Boot Examples**: Apache 2.0 License

---

## 📫 Connect

Interested in collaboration or discussing opportunities?

- 💼 **LinkedIn**: [Add your LinkedIn profile URL here]
- 📂 **GitHub**: You're already here! Explore the projects above
- 📧 **Professional**: See [ABOUT-ME.md](ABOUT-ME.md) for my background and experience

---

**Engineering Manager @ Klarna | Former Amadeus, NCR | Based in Berlin**

*Building scalable systems, exploring AI frontiers, and sharing knowledge through code.*
