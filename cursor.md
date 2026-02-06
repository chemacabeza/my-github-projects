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

