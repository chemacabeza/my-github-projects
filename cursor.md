# cursor.md

Repository: `chemacabeza/my-github-projects`

Purpose: portfolio-style monorepo with 3 main areas:
- `AI-related/` (Docker-based AI image generation platform / Fooocus deployment)
- `bash/` (Bash In Depth: multi-chapter guide + scripts)
- `JavaSpringBoot/` (enterprise Spring Boot 3.x examples / microservices)

---

## Repo map (where to look first)

- Root docs:
  - `README.md` (entry point + quick start)
  - `ABOUT-ME.md` / `ABOUT-THIS-REPO.md` (context)
  - `CONTRIBUTING.md` (contribution rules)
  - `DEPENDENCIES.md` (dependency notes)
  - `IMPROVEMENTS.md` (roadmap / ideas)
- Main code/content:
  - `AI-related/`
  - `bash/`
  - `JavaSpringBoot/`
- Supporting:
  - `examples/`
  - `images/`

---

## Fast ways to run things (prefer these)

### AI-related (Docker / local)
From repo root:
- Docker:
  - `cd AI-related && make run`
- Local:
  - `cd AI-related && make install-local && make run-local` :contentReference[oaicite:1]{index=1}

Notes for agents:
- Expect large model assets and symlink-based model management.
- Be careful with GPU-specific steps (CUDA vs Apple Silicon / MPS).

### Bash book + scripts
- Chapters live under: `bash/chapters/`
- Prefer making changes chapter-by-chapter (keep examples runnable and minimal). :contentReference[oaicite:2]{index=2}

### Java / Spring Boot
- Each subproject is a Maven app.
- Run inside a chosen subdirectory:
  - `mvn spring-boot:run` :contentReference[oaicite:3]{index=3}

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

## Current state (last updated: 2026-02-19)

### AI-related

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

**LoRAs** (`AI-related/LoRAs/`, 32 total — 5 standard + 27 custom character LoRAs):

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
