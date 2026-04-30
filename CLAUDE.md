# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal engineering portfolio by José María Cabeza Rodríguez (Engineering Manager @ Klarna). It is a multi-domain monorepo containing production-quality AI platforms, a 35-chapter Bash guide, 70+ Spring Boot projects, ML inference examples, and learning archives. Primary branch is `master`.

Nine git submodules link to external GitHub repositories; most use SSH (`git@github.com:chemacabeza/…`) and require an SSH key for write access.

---

## Directory Map

| Path | Contents |
|------|----------|
| `AI-related/` | Fooocus deployment + 46 GB model library (7 SDXL checkpoints, 41 LoRAs). `models/` and `LoRAs/` are gitignored. |
| `assistant-google/` | Personal AI assistant – Spring Boot 3 + React 18 + WhatsApp + Google OAuth 2.0 (submodule) |
| `test-for-ai-wan/` | AI video generation studio – 5 video models, async job orchestration, PostgreSQL/Flyway (submodule) |
| `test-for-audio-generation/` | OpenAI TTS platform – 11 voices, stateless backend proxy (submodule) |
| `test-audio-listener/` | OpenAI Whisper STT – full-text search, Next.js 15 App Router (submodule) |
| `test-ai-asistant/` | Voice assistant pipeline STT→Chat→TTS, wake-word, 9 languages (submodule) |
| `neural-network-with-java/` | PyTorch→ONNX→Java multi-model inference (Iris, MNIST, ResNet18) (submodule) |
| `ai_and_MachineLearning/` | AI/ML coursework notes (submodule) |
| `CyberSecurity/` | Security learning archive (submodule) |
| `test-with-llms/` | LLM experiments (submodule) |
| `bash/` | 35-chapter Bash guide, 236 executable scripts, 7 parts |
| `JavaSpringBoot/` | 11-part Spring Boot course, 70+ projects, 133+ JUnit 5 test classes |
| `SystemDesign/` | DDD course content |
| `AdvancedAI/` | Advanced AI projects |
| `examples/` | Starter templates: `ai-simple`, `bash-template`, `java-minimal-api` |
| `docs/` | Documentation hub |

---

## Build & Run Commands

### AI-related (Fooocus — Python/Docker)
```bash
cd AI-related
make run          # Docker build + run (auto-detects macOS MPS vs Linux CUDA)
make up           # Start existing container
make down         # Stop container
make install-local  # Local venv install
make run-local    # Run locally (no Docker)
```

### Full-stack AI Platforms (Docker Compose)
```bash
# AI Video Studio
cd test-for-ai-wan && ./run.sh start   # start
cd test-for-ai-wan && ./run.sh stop    # stop

# TTS Platform
cd test-for-audio-generation && ./start.sh

# STT Platform
cd test-audio-listener && ./start.sh

# Voice Assistant
cd test-ai-asistant && ./start.sh

# Personal AI Assistant
cd assistant-google && ./build.sh && ./start.sh
```

### Java / Spring Boot
```bash
# Run a project
./mvnw spring-boot:run

# Run all tests
./mvnw test

# Run a single test class
./mvnw test -Dtest=MyTestClass

# Run a single test method
./mvnw test -Dtest=MyTestClass#myMethod

# Build JAR
./mvnw clean package
```
Each Spring Boot project under `JavaSpringBoot/` has its own `./mvnw` wrapper. Defaults use H2 in-memory DB; override with `spring.datasource.*` for MySQL 8+.

### Bash Guide
Each chapter directory under `bash/` contains an `examples.sh` that exercises all scripts in that chapter. Scripts require Bash 5.0+ and use `set -euo pipefail` throughout.

---

## Architecture Patterns

### Full-stack AI Platforms
- **Backend**: Spring Boot 3 / Java 21, reactive WebClient, `@Scheduled` async jobs
- **Frontend**: React 18 + Vite or Next.js 15 (App Router)
- **DB**: PostgreSQL with Flyway migrations
- **Infra**: Docker Compose, Nginx reverse proxy, multi-stage Docker builds
- **AI APIs**: OpenAI (Whisper, GPT-4o, TTS), fal.ai video models

### ML Inference (neural-network-with-java)
- **Workflow**: Train in PyTorch → export ONNX → serve from Spring Boot via ONNX Runtime
- **Test strategy**: Golden parity tests compare Python vs Java outputs to tolerance 1e-5

### Spring Boot Course (JavaSpringBoot)
- 11 self-contained parts covering Spring MVC, Security, Data JPA, AOP, etc.
- Tests use JUnit 5 + Mockito + Spring Test; some parts use Testcontainers.

### Bash Guide (bash/)
- 35 chapters, strict error handling, platform detection macOS/Linux throughout
- Chapter structure: concept explanation → executable `examples.sh`

---

## Prerequisites

| Domain | Requirement |
|--------|-------------|
| Python (AI) | Python 3.10+ (3.12+ recommended), PyTorch 2.x, CUDA/MPS/CPU auto-detected |
| Java | Java 17+ (21 in use), Maven 3.6+ (or `./mvnw`) |
| Bash | Bash 5.0+, standard Unix utilities |
| Infrastructure | Docker 20.10+, Docker Compose v2; NVIDIA Docker runtime for GPU on Linux |

The 46 GB Fooocus model library is gitignored and auto-downloaded on first run.

---

## Submodules

To clone including all submodules:
```bash
git clone --recurse-submodules git@github.com:chemacabeza/my-github-projects.git
```

To update a specific submodule:
```bash
git submodule update --remote <submodule-path>
```

Private submodules (`assistant-google`, `test-for-ai-wan`, `test-for-audio-generation`, `test-audio-listener`, `test-ai-asistant`, `neural-network-with-java`) require SSH key access. Public submodules (`ai_and_MachineLearning`, `CyberSecurity`, `test-with-llms`) use HTTPS.
