# cursor.md

Repository: `chemacabeza/my-github-projects`

Purpose: portfolio-style monorepo with 6 main areas:
- `test-for-ai-wan/` (AI video generation studio — Spring Boot + React + PostgreSQL + Docker + fal.ai)
- `test-for-audio-generation/` (git submodule — AI Voice Studio: full-stack TTS using OpenAI API — Spring Boot + React + Docker)
- `AI-related/` (Docker-based AI image generation platform / Fooocus deployment)
- `bash/` (Bash In Depth: multi-chapter guide + scripts)
- `JavaSpringBoot/` (enterprise Spring Boot 3.x examples / microservices)
- `neural-network-with-java/` (git submodule — multi-model ML inference pipeline: Python → ONNX → Java)

---

## Repo map (where to look first)

- Root docs:
  - `README.md` (entry point + quick start)
  - `ABOUT-ME.md` / `ABOUT-THIS-REPO.md` (context)
  - `CONTRIBUTING.md` (contribution rules)
  - `DEPENDENCIES.md` (dependency notes)
  - `IMPROVEMENTS.md` (roadmap / ideas)
- Main code/content:
  - `test-for-ai-wan/` ⭐ most full-featured video platform
  - `test-for-audio-generation/` ⭐ newest — AI voice/TTS studio (submodule)
  - `AI-related/`
  - `bash/`
  - `JavaSpringBoot/`
  - `neural-network-with-java/` (submodule)
- Supporting:
  - `examples/`
  - `images/`

---

## Fast ways to run things (prefer these)

### test-for-ai-wan (AI Video Studio)
Full-stack video generation platform. From `test-for-ai-wan/`:
- `./run.sh start` — builds Docker images (Spring Boot backend + React frontend + PostgreSQL) and starts everything
- `./run.sh stop` — stops and removes containers (DB is in-memory / tmpfs — wiped on stop)
- Frontend: http://localhost:3000 | Backend API: http://localhost:8080/api
- 5 fal.ai models: Wan 2.6, Wan 2.2-A14B, Kling v2.5 Turbo Pro, LTX-2 19B, PixVerse v5
- Requires: `FAL_API_KEY` in `test-for-ai-wan/.env` (see `.env.example`)

Notes for agents:
- Endpoint paths for the fal.ai queue API include a `fal-ai/` prefix for all models *except* `wan-2.6`.
- Per-model duration constraints: Kling = 5/10 s, PixVerse = 5/8 s, Wan/LTX = 5/10/15 s.
- Adding a new model: update `T2V_ENDPOINTS`/`I2V_ENDPOINTS` maps in `FalAiService.java`, add to `MODELS` arrays in `TextToVideoForm.jsx` and `ImageToVideoForm.jsx`.

### test-for-audio-generation (AI Voice Studio)
Full-stack TTS platform. From `test-for-audio-generation/`:
- `./start.sh start` — builds Docker images (Spring Boot backend + React/Nginx frontend) and starts everything
- `./start.sh stop` — stops and removes containers
- `./start.sh restart` — stop then start (picks up `.env` changes)
- `./start.sh logs` — tail live logs from all containers
- `./start.sh status` — show running container status
- Frontend: http://localhost | Backend API: http://localhost:8080
- Requires: `OPENAI_API_KEY` in `backend/.env` (copy from `backend/.env.example`)
- Health check: `curl http://localhost:8080/actuator/health` → `{"status":"UP"}`

Notes for agents:
- The API key is injected via `backend/.env` — **never hardcode it** and never commit `.env`.
- `api-key.txt` at repo root should be deleted — it is not used by the app and may contain a stale key.
- Backend port: 8080 (Spring Boot). Frontend port: 80 (Nginx). No database — stateless.
- Available voices: alloy, ash, ballad, coral, echo, fable, nova, onyx, sage, shimmer, verse.
- Available models: `gpt-4o-mini-tts` (default), `tts-1`, `tts-1-hd`.
- Response format: MP3 streamed as `audio/mpeg` binary from backend → browser `<audio>` tag.
- When updating: run `git submodule update --remote test-for-audio-generation` then update this file, `ABOUT-ME.md`, and `ABOUT-THIS-REPO.md`.

### AI-related (Docker / local)
From repo root:
- Docker:
  - `cd AI-related && make run`
- Local:
  - `cd AI-related && make install-local && make run-local` :contentReference[oaicite:1]{index=1}

Notes for agents:
- Expect large model assets and symlink-based model management.
- Be careful with GPU-specific steps (CUDA vs Apple Silicon / MPS).
- The project includes 42 LoRA models (5 standard + 37 custom character LoRAs). The latest addition is **alina** (Moldovan, 26 years old, 1.73m tall, SDXL LoRA, model version ID 2784882).
- When adding a new LoRA: update `AI-related/README.md` (LoRAs list), `AI-related/run_local.sh` (download command), and this file.

### Bash book + scripts
- Chapters live under: `bash/chapters/`
- Prefer making changes chapter-by-chapter (keep examples runnable and minimal). :contentReference[oaicite:2]{index=2}

### Java / Spring Boot
- Each subproject is a Maven app.
- Run inside a chosen subdirectory:
  - `mvn spring-boot:run` :contentReference[oaicite:3]{index=3}

### Neural Network with Java (submodule)
- Git submodule at `neural-network-with-java/` — a production-ready multi-model ML inference pipeline.
- **Models**: Iris MLP (91%), MNIST CNN (99.13%), Glasses ResNet18 (98.12%), Document Reader (PDF/TXT)
- Run locally:
  - `cd neural-network-with-java && ./start-app.sh` (backend + frontend)
  - Backend: http://localhost:8080, Frontend: http://localhost:3000
- Docker:
  - `cd neural-network-with-java && docker-compose up --build`
- Key endpoints: `GET /models`, `POST /models/{name}/predict`, `POST /documents/extract`
- When updating: run `git submodule update --remote neural-network-with-java` then update this file, `ABOUT-ME.md`, and `ABOUT-THIS-REPO.md`.

---

## How to work in this repo (rules for Cursor/agents)

### 1) Don’t assume “one build”
This is a monorepo with independent areas. Always identify the target area first:
- AI change → stay inside `AI-related/`
- Bash content/script change → stay inside `bash/`
- Java change → stay inside `JavaSpringBoot/<project>/`

### 2) Keep changes scoped
Avoid cross-area refactors unless explicitly requested.

### 3) Prefer docs-first navigation
Before editing:
- Read the nearest README in the target folder (if present).
- Check root `DEPENDENCIES.md` if adding libraries/tools.

### 4) Avoid heavy/destructive operations by default
- Don’t download large models, rebuild containers, or run long training jobs unless asked.
- If a command might be slow or destructive, propose it first and clearly label it.

### 5) Security + hygiene
- Never add secrets/tokens to repo or sample configs.
- If you need env vars, document them and use `.env.example` (never `.env`).

---

## Conventions to follow

### Documentation
- Keep Markdown headings consistent.
- Prefer short, copy/pasteable command blocks.
- When adding a new “project”:
  - create a folder under the right domain (`AI-related/`, `bash/`, `JavaSpringBoot/`)
  - add/extend a README in that folder
  - link it from the root README “Contents” section

### Java
- Follow typical Spring layering (controller/service/repository) if applicable.
- Keep examples “teachable” and not overly abstract.

### Bash
- Prefer portable bash (`#!/usr/bin/env bash`) unless chapter explicitly covers bashisms.
- Add comments explaining the “why”, not just “what”.

---

## What to ask the maintainer when unsure
If requirements are ambiguous, ask only what unblocks:
- Which area is the change targeting? (`AI-related` vs `bash` vs `JavaSpringBoot`)
- Should changes be “demo quality” or “production ready”?
- Any constraints (Apple Silicon vs CUDA, Java version, etc.)

---

## Quick sanity checklist before PR
- Targeted the correct subfolder
- Commands in docs are copy/pasteable
- No secrets added
- No unrelated formatting churn
- Root README links updated if new top-level content was introduced

---

## Current state (last updated: 2026-03-18)

### test-for-ai-wan (AI Video Studio)

Live project at `test-for-ai-wan/`. Full-stack status:

| Component | Status |
|---|---|
| Backend (Spring Boot) | ✅ Running on port 8080 |
| Frontend (React/Nginx) | ✅ Running on port 3000 |
| Database (PostgreSQL) | ✅ Flyway V3 applied (`model` column) |
| fal.ai models | ✅ All 5 endpoints verified with curl |

Latest changes (March 2026):
- Added model selection (Wan 2.6, Wan 2.2-A14B, Kling v2.5 Turbo, LTX-2 19B, PixVerse v5)
- Fixed endpoint paths (`fal-ai/` prefix required for all except Wan 2.6)
- Added per-model duration/aspect-ratio constraints in frontend
- Negative prompt raised to 3000 chars

### test-for-audio-generation (AI Voice Studio)

Live project at `test-for-audio-generation/`. Full-stack status:

| Component | Status |
|---|---|
| Backend (Spring Boot 3) | ✅ Running on port 8080 |
| Frontend (React 18 / Nginx) | ✅ Running on port 80 |
| OpenAI TTS integration | ✅ Verified — MP3 streamed successfully |

Latest changes (March 2026):
- Added as git submodule to `my-github-projects`
- Added "🔑 Obtaining Your OpenAI API Key" section to README
- API key configured via `backend/.env` (gitignored)

### AI-related

**Expert Tips & Advanced Workflows courses** (`AI-related/courses/ExpertTips_AdvancedWorkflows/`, 3 guides):

| Guide | Path | Description |
|-------|------|-------------|
| Flux Prompt Crafter | `Flux_Prompt_Crafter/README.md` | Build a Custom GPT for Flux 1.1 Pro Ultra prompts. Covers: Custom GPT setup (women & men system prompts with full physical descriptors), key differences between women/men chest field conventions, ChatGPT templates to generate physical characteristics by country (with Chilean woman & man examples), and a usage example with Rabab. |
| Kling AI Video Prompts | `Kling_AI_Video_Prompts/README.md` | Build a Custom GPT for cinematic video prompts with ambient audio for Kling AI. |
| CivitAI LoRA Training | `CivitAI_LoRA_Training/README.md` | Step-by-step guide to training and publishing LoRAs on civitai.green using Onsite Training (no local GPU needed). Covers: prerequisites (Buzz credits), using ChatGPT to generate optimal hyperparameters (Epochs, LR, Network Dim/Alpha, Optimizer, etc.) for a given image count, dataset preparation (30–40 images, captions, trigger word), the full UI walkthrough (Train a Model → upload ZIP → fill parameters form), launch/monitor, testing (over/under-fit diagnosis), and publishing. |

**Checkpoint models** (`AI-related/models/`, 7 total):
| File | Type | Source |
|---|---|---|
| `juggernautXL_v8Rundiffusion.safetensors` | SDXL 1.0 | Hugging Face |
| `animaPencilXL_v500.safetensors` | SDXL 1.0 | Hugging Face |
| `realisticStockPhoto_v20.safetensors` | SDXL 1.0 | Hugging Face |
| `sdxlYamersRealistic5_v5Rundiffusion.safetensors` | SDXL 1.0 | Civitai #299716 |
| `sdXL_v10VAEFix.safetensors` | SDXL 1.0 | Civitai #128078 |
| `sdxlUnstableDiffusers_nihilmania.safetensors` | SDXL 1.0 | Civitai #395107 |
| `SDXLRonghua_v45.safetensors` | SDXL 1.0 | Civitai #471038 |

**LoRAs** (`AI-related/LoRAs/`, 42 total — 5 standard + 37 custom character LoRAs):

Standard:
- `sd_xl_offset_example-lora_1.0.safetensors` — contrast/dynamic range
- `SDXL_FILM_PHOTOGRAPHY_STYLE_V1.safetensors` — film photography style
- `lingerie_loha.safetensors` ⚠️ — Civitai #362360 (requires API token)
- `retro_neon_illustriouos.safetensors` — Civitai #1082049
- `pumpsheel.safetensors` — Civitai #100982

Character LoRAs (trigger word = filename stem, all SDXL):
| # | File | Character | Nationality | Age | Height | Civitai version ID |
|---|---|---|---|---|---|---|
| 1 | `helga_lora.safetensors` | helga | Swedish | 26 | 1.85m | 2570750 |
| 2 | `anastasia_lora.safetensors` | anastasia | Russian | 25 | 1.75m | 2570343 |
| 3 | `hana_lora.safetensors` | hana | Japanese | 25 | 1.75m | 2570710 |
| 4 | `inga_lora.safetensors` | inga | German | 26 | 1.75m | 2570634 |
| 5 | `mariam_lora.safetensors` | mariam | Guinean | 25 | 1.70m | 2570639 |
| 6 | `chen_lora.safetensors` | chen | Chinese | 25 | 1.70m | 2570349 |
| 7 | `iuliia_lora.safetensors` | iuliia | Ukrainian | 25 | 1.73m | 2570319 |
| 8 | `allison_lora.safetensors` | allison | Australian | 27 | 1.85m | 2570341 |
| 9 | `emma_lora.safetensors` | emma | American | 27 | 1.85m | 2570631 |
| 10 | `rabab_lora.safetensors` | rabab | Moroccan | 25 | 1.72m | 2570327 |
| 11 | `fiona_lora.safetensors` | fiona | Scottish | 28 | 1.85m | 2583873 |
| 12 | `giulia_lora.safetensors` | giulia | Italian | 26 | 1.80m | 2586700 |
| 13 | `juanita_lora.safetensors` | juanita | Cuban | 28 | 1.85m | 2590587 |
| 14 | `sofia_lora.safetensors` | sofia | Finnish | 25 | 1.85m | 2593749 |
| 15 | `svetlana_lora.safetensors` | svetlana | Russian | 28 | 1.85m | 2599427 |
| 16 | `kasia_lora.safetensors` | kasia | Polish | 26 | 1.85m | 2603390 |
| 17 | `lara_lora.safetensors` | lara | Polish | 30 | 1.70m | 2608668 |
| 18 | `stefi_lora.safetensors` | stefi | German | 26 | 1.90m | 2614177 |
| 19 | `sheila_lora.safetensors` | sheila | Peruvian | 26 | 1.70m | 2619966 |
| 20 | `amina_lora.safetensors` | amina | Moroccan | 26 | 1.73m | 2622521 |
| 21 | `milica_lora.safetensors` | milica | Serbian | 27 | 1.75m | 2627557 |
| 22 | `anne_lora.safetensors` | anne | Dutch | 26 | 1.80m | 2665179 |
| 23 | `maria_lora.safetensors` | maria | Portuguese | 28 | 1.80m | 2674074 |
| 24 | `aaju_lora.safetensors` | aaju | Greenlandic | 28 | 1.75m | 2676941 |
| 25 | `tina_lora.safetensors` | tina | Slovenian | 26 | 1.75m | 2694529 |
| 26 | `nora_lora.safetensors` | nora | Estonian | 23 | 1.78m | 2697743 |
| 27 | `anna_lora.safetensors` | anna | Latvian | 24 | 1.75m | 2700775 |
| 28 | `dalia_lora.safetensors` | dalia | Lithuanian | 24 | 1.73m | 2703173 |
| 29 | `olena_lora.safetensors` | olena | Ukrainian | 24 | 1.72m | 2706444 |
| 30 | `zoya_lora.safetensors` | zoya | Belarusian | 26 | 1.75m | 2705922 |
| 31 | `priya_lora.safetensors` | priya | Indian | 26 | 1.75m | 2709407 |
| 32 | `valentina_lora.safetensors` | valentina | Venezuelan | 26 | 1.75m | 2711709 |
| 33 | `carmen_lora.safetensors` | carmen | Chilean | 28 | 1.75m | 2724940 |
| 34 | `naran_lora.safetensors` | naran | Mongolian | 25 | 1.68m | 2727706 |
| 35 | `olga_lora.safetensors` | olga | Belarusian | 25 | 1.70m | 2748594 |
| 36 | `gabriela_lora.safetensors` | gabriela | Brazilian | 26 | 1.72m | 2780416 |
| 37 | `alina_lora.safetensors` | alina | Moldovan | 26 | 1.73m | 2784882 |
