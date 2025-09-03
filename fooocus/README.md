# Fooocus with Docker + SDXL Models & LoRAs

This folder provides a **Dockerized setup of Fooocus** for generating images with **Stable Diffusion XL (SDXL)**.
The goal is to make it easy to replicate Fooocus on your computer or laptop without worrying about environment setup.

I’ve preconfigured this project with a curated collection of **SDXL models** and **LoRAs**, so you can start experimenting right away.

---

## 📦 Included Models

The following **SDXL models** are available inside the container:

- `juggernautXL_v8Rundiffusion.safetensors`
- `sdXL_v10VAEFix.safetensors`
- `SDXLRonghua_v45.safetensors`
- `sdxlYamersRealistic5_v5Rundiffusion.safetensors`
- `sdxlUnstableDiffusers_nihilmania.safetensors`

And the following **LoRAs** are included:

- `lingerie_loha.safetensors`
- `pumpsheel.safetensors`
- `retro_neon_illustriouos.safetensors`
- `sd_xl_offset_example-lora_1.0.safetensors`

---

## 🚀 Getting Started

### 1. Clone the repo

```bash
git clone git@github.com:chemacabeza/my-github-projects.git my-github-projects.git
cd my-github-projects.git/fooocus
```

### 2. Build the Docker image

```bash
docker compose build --no-cache
```

### 3. Run Fooocus

```bash
docker compose up
```

This will start Fooocus and expose the web interface on:
👉 [http://localhost:7860](http://localhost:7860)


### 🗂️ Project Structure

```bash
├── cache
│   └── huggingface
│       └── hub
│           └── version.txt
├── docker-compose.yml # A Docker Compose configuration that builds and runs Fooocus with GPU support, mounted model/LoRA folders, and a web UI exposed on port 7860.
├── Dockerfile # Fooocus container setup
├── entrypoint.sh # A Bash script that prepares Fooocus by ensuring required SDXL models and LoRAs are downloaded into host-mounted folders before starting the container.
├── LoRAs
│   ├── lingerie_loha.safetensors
│   ├── pumpsheel.safetensors
│   ├── retro_neon_illustriouos.safetensors
│   └── sd_xl_offset_example-lora_1.0.safetensors
├── models
│   ├── juggernautXL_v8Rundiffusion.safetensors
│   ├── SDXLRonghua_v45.safetensors
│   ├── sdxlUnstableDiffusers_nihilmania.safetensors
│   ├── sdXL_v10VAEFix.safetensors
│   └── sdxlYamersRealistic5_v5Rundiffusion.safetensors
├── outputs
└── run.sh # A Bash script that rebuilds Docker containers without cache and then starts them using Docker Compose.
```
