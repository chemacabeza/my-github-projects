# AI Related

<p align="center">
 <img src="images/AI-Related3.jpg" width="900"/>
</p>

## INTRODUCTION

Welcome to **AI Related** — the experimental zone where creativity meets computation. This section of my public GitHub repository is all about **pushing the limits of what’s possible with AI** — a playground for experiments, ideas, and breakthroughs at the intersection of technology and imagination.

Inside, you’ll discover:

* 🧠 **Hands-on experiments** with tools like Stable Diffusion and beyond — transforming lines of code into vibrant, intelligent art.
* 📘 **Learning notes and insights** from courses, research, and tinkering — distilled into practical workflows that make AI creation both approachable and powerful.
* 🚀 **Custom projects and prototypes** where theory becomes reality — unique explorations that showcase how AI can amplify human creativity.

Whether you’re here to **learn**, **explore**, **or be inspired**, _AI Related_ is your launchpad into the evolving world of artificial intelligence.
Dive in, experiment boldly, and see how far your curiosity can take you.

## CONTENTS

* [Running Fooocus on your local computer](Local-Fooocus/README.md)
* [Running Fooocus on Google Colab](Google-Colab/README.md)

## QUICK START

To build and run the local Fooocus environment (using Docker):

1.  **Navigate to the directory**:
    ```bash
    cd AI-related
    ```

2.  **Run with Docker**:
    ```bash
    make run
    ```

To stop:

```bash
make down
```

### Running Locally (No Docker)

If you prefer to run the application directly on your machine (without Docker), follow these steps.

**Prerequisites**:
*   **Linux** or **macOS** (Windows support may require manual adjustments)
*   **Python 3.10 or higher** (Python 3.12+ recommended)
*   **`git`**, **`make`**, and **`python3`** installed
*   **macOS only**: Xcode Command Line Tools (`xcode-select --install`)
*   **macOS only**: macOS 12.3 (Monterey) or later for MPS support

1.  **Navigate to the directory**:
    ```bash
    cd AI-related
    ```

2.  **Install dependencies**:
    ```bash
    make install-local
    ```
    *   This command performs the following:*
        *   Clones the Fooocus repository.
        *   Creates a local virtual environment (`venv`).
        *   Installs optimized PyTorch versions (compatible with Python 3.12).
        *   Installs all required dependencies.

3.  **Run the application**:
    ```bash
    make run-local
    ```
    *   **First run**: This will:
        *   Create symbolic links from `Fooocus/models/checkpoints` → `models/` and `Fooocus/models/loras` → `LoRAs/`
        *   Automatically download necessary checkpoint and LoRA models to centralized directories (several GBs)
    *   **Note on Civitai Models**: Some models may require a Civitai API token (e.g., age-restricted content).
        *   If the download fails with a 401 error, you can provide your token:
            ```bash
            export CIVITAI_API_TOKEN=your_token_here
            make run-local
            ```
        *   If you don't have a token, the script will skip those restricted models and continue.
    *   **Subsequent runs**: Starts the Fooocus server immediately using the existing models.
    *   Access the UI at [http://localhost:7860](http://localhost:7860).

### Model Management

**Storage Architecture**:

This installation uses a **centralized storage approach** with symbolic links:

*   📁 **Checkpoint models**: Stored in `AI-related/models/`
*   📁 **LoRAs**: Stored in `AI-related/LoRAs/`
*   🔗 **Symbolic links**: Fooocus accesses models via symlinks:
    *   `Fooocus/models/checkpoints` → `../../models`
    *   `Fooocus/models/loras` → `../../LoRAs`

**Adding New Models**:

1. Download your `.safetensors` model file
2. Place it in the appropriate directory:
   - Checkpoint models → `AI-related/models/`
   - LoRAs → `AI-related/LoRAs/`
3. Restart Fooocus (or it will auto-detect on next run)
4. The new model will appear in the Fooocus UI

**Verifying Symbolic Links**:

To check if symbolic links are properly set up:
```bash
ls -la Fooocus/models/checkpoints
ls -la Fooocus/models/loras
```

You should see symlinks pointing to `../../models` and `../../LoRAs`.

### macOS-Specific Information

**GPU Acceleration on macOS**:

This installation automatically detects macOS and installs PyTorch with **Metal Performance Shaders (MPS)** support for GPU acceleration on Apple Silicon chips:

*   ✅ **Apple Silicon (M1/M2/M3/M4)**: Full MPS GPU acceleration
*   ✅ **Intel Macs with AMD GPU**: MPS support available
*   ℹ️ **Older Intel Macs**: CPU-only mode (slower but functional)

**Installation automatically configures**:
*   Latest PyTorch with MPS backend
*   Platform-specific dependencies
*   Optimized settings for macOS

**Verifying MPS Support**:

After installation, you can verify MPS is available:
```bash
. venv/bin/activate
python -c "import torch; print('MPS available:', torch.backends.mps.is_available())"
```

Expected output on Apple Silicon: `MPS available: True`

**Performance Notes**:
*   First image generation may be slower (model caching)
*   Subsequent generations significantly faster with GPU
*   Apple Silicon provides excellent performance for AI image generation

**Advanced Performance Tuning**:

For power users on Apple Silicon, you can experiment with additional flags by modifying the `Makefile` `RUNTIME_FLAGS`:

```makefile
# Example: Aggressive optimization for M1/M2/M3/M4 with 16GB+ RAM
RUNTIME_FLAGS = --all-in-fp16 --disable-offload-from-vram --always-high-vram --unet-in-fp16 --vae-in-fp16 --clip-in-fp16
```

> [!WARNING]
> These flags may cause instability on systems with less than 16GB unified memory. Test carefully.

### Included Models

The local installation includes the following models by default. Some are standard Fooocus models, while others are custom additions.

---

#### Checkpoint Models

1.  **Standard**: `juggernautXL_v8Rundiffusion.safetensors`
    *   **Type**: SDXL 1.0 Checkpoint
    *   **Description**: General purpose, high quality realistic model
    *   **Source**: [Hugging Face](https://huggingface.co/lllyasviel/fav_models)

2.  **Standard**: `animaPencilXL_v500.safetensors`
    *   **Type**: SDXL 1.0 Checkpoint
    *   **Description**: Anime and illustration style
    *   **Source**: [Hugging Face](https://huggingface.co/mashb1t/fav_models)

3.  **Standard**: `realisticStockPhoto_v20.safetensors`
    *   **Type**: SDXL 1.0 Checkpoint
    *   **Description**: Realistic stock photography style
    *   **Source**: [Hugging Face](https://huggingface.co/lllyasviel/fav_models)

4.  `sdxlYamersRealistic5_v5Rundiffusion.safetensors`
    *   **Type**: SDXL 1.0 Checkpoint
    *   **Description**: Realistic photography with RunDiffusion partnership, merged with Realistic 5
    *   **Model ID**: 299716
    *   **Source**: [Civitai](https://civitai.com/models/84576)

5.  `sdXL_v10VAEFix.safetensors`
    *   **Type**: SDXL 1.0 Checkpoint (VAE Fix)
    *   **Description**: Official SDXL 1.0 base model with VAE fix
    *   **Model ID**: 128078
    *   **Downloads**: 303K+
    *   **Source**: [Civitai](https://civitai.com/models/101055)

6.  `sdxlUnstableDiffusers_nihilmania.safetensors`
    *   **Type**: SDXL 1.0 Checkpoint  
    *   **Description**: Enhanced with new CLIP and Pony Diffusion trigger words
    *   **Model ID**: 395107
    *   **Source**: [Civitai](https://civitai.com/models/84040)

7.  `SDXLRonghua_v45.safetensors`
    *   **Type**: SDXL 1.0 Checkpoint
    *   **Description**: Chinese style (国风) model - RongHua v4.5
    *   **Model ID**: 471038
    *   **Downloads**: 10K+
    *   **Source**: [Civitai](https://civitai.com/models/125634)

---

#### LoRAs

1.  **Standard**: `sd_xl_offset_example-lora_1.0.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Improves contrast and dynamic range
    *   **Trigger Word**: `contrasts` (Optional, often works without)
    *   **Source**: [Hugging Face](https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0)

2.  **Standard**: `SDXL_FILM_PHOTOGRAPHY_STYLE_V1.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Film photography aesthetic
    *   **Trigger Word**: `film photography style`
    *   **Source**: [Hugging Face](https://huggingface.co/mashb1t/fav_models)

3.  `lingerie_loha.safetensors` ⚠️
    *   **Type**: SDXL LyCORIS (LoHa)
    *   **Description**: Smokin' Lingerie style
    *   **Trigger Words**: `lingeriegw`, `l1ng3rie`
    *   **Model ID**: 362360
    *   **⚠️ Requires**: Civitai API Token (age-restricted content)
    *   **Note**: Set `CIVITAI_API_TOKEN` environment variable before running
    *   **Source**: [Civitai](https://civitai.com/models/323202)

4.  `retro_neon_illustriouos.safetensors`
    *   **Type**: Illustrious-XL LoRA
    *   **Description**: Retro neon synthwave style
    *   **Trigger Word**: `retro_neon`
    *   **Model ID**: 1082049
    *   **Base Model**: Illustrious-XL (also works with FLUX, SD, XL, Pony)
    *   **Downloads**: 1.2K+
    *   **Source**: [Civitai](https://civitai.com/models/569937)

5.  `pumpsheel.safetensors`
    *   **Type**: SD 1.5 LoRA
    *   **Description**: Red Bottoms high heels / stiletto pumps
    *   **Trigger Words**: `high heels`, `pumps`, `stiletto heels`
    *   **Model ID**: 100982
    *   **Downloads**: 2K+
    *   **Source**: [Civitai](https://civitai.com/models/94667)

6.  `helga_lora.safetensors`
    *   **Type**: LoRA
    *   **Description**: Swedish woman character
    *   **Trigger Word**: `helga`
    *   **Model ID**: 2219193
    *   **Source**: [Civitai](https://civitai.com/models/999999)

7.  `anastasia_lora.safetensors`
    *   **Type**: LoRA
    *   **Description**: Russian woman character
    *   **Trigger Word**: `anastasia`
    *   **Model ID**: 2502002
    *   **Source**: [Civitai](https://civitai.com/models/999999)

8.  `hana_lora.safetensors`
    *   **Type**: LoRA
    *   **Description**: Japanese woman character
    *   **Trigger Word**: `hana`
    *   **Model ID**: 2514908
    *   **Source**: [Civitai](https://civitai.green/models/2234019/hana)

9.  `inga_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: German woman character (26 years old)
    *   **Trigger Word**: `inga`
    *   **Model ID**: 2567306
    *   **Source**: [Civitai](https://civitai.green/models/2281071?modelVersionId=2567306)

10. `mariam_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Guinean woman character (25 years old)
    *   **Trigger Word**: `mariam`
    *   **Model ID**: 2526076
    *   **Source**: [Civitai](https://civitai.green/models/2243911/mariam)

11. `chen_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Chinese woman character (25 years old)
    *   **Trigger Word**: `chen`
    *   **Model ID**: 2570349
    *   **Source**: [Civitai](https://civitai.green/models/2283817?modelVersionId=2570349)

12. `iuliia_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Ukrainian woman character (25 years old)
    *   **Trigger Word**: `iuliia`
    *   **Model ID**: 2570319
    *   **Source**: [Civitai](https://civitai.green/models/2283787?modelVersionId=2570319)

13. `allison_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Australian woman character (1.85m tall)
    *   **Trigger Word**: `allison`
    *   **Model ID**: 2570341
    *   **Source**: [Civitai](https://civitai.green/models/2283809?modelVersionId=2570341)

14. `emma_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: American woman character (27 years old, 1.85m tall)
    *   **Trigger Word**: `emma`
    *   **Model ID**: 2554575
    *   **Source**: [Civitai](https://civitai.green/models/2269530/emma)

15. `rabab_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Moroccan woman character (25 years old, 1.72m tall)
    *   **Trigger Word**: `rabab`
    *   **Model ID**: 2570327
    *   **Source**: [Civitai](https://civitai.green/models/2283796?modelVersionId=2570327)

### Troubleshooting

**Models not appearing in Fooocus UI:**

1. Verify symbolic links exist:
   ```bash
   ls -la Fooocus/models/checkpoints
   ls -la Fooocus/models/loras
   ```

2. If symlinks are missing, re-run:
   ```bash
   make run-local
   ```
   The script will automatically create them.

3. Ensure model files are in the correct directories:
   ```bash
   ls -lh models/*.safetensors
   ls -lh LoRAs/*.safetensors
   ```

**Download failures:**

- For Civitai 401 errors, set your API token:
  ```bash
  export CIVITAI_API_TOKEN=your_token_here
  make run-local
  ```

**Port already in use:**

- If port 7860 is occupied, you can modify the port in the `Makefile` (`run-local` target)

**macOS-Specific Issues**:

- **MPS not available**: Ensure you have:
  - macOS 12.3 or later
  - Apple Silicon or AMD GPU
  - Latest PyTorch installed (`pip install --upgrade torch`)

- **"xcode-select" errors**: Install Command Line Tools:
  ```bash
  xcode-select --install
  ```

- **Slow performance on Intel Mac**: Intel Macs without AMD GPU use CPU mode. Consider:
  - Using smaller batch sizes
  - Reducing image resolution
  - Being patient with generation times

---
## COURSES

* [Flux Step by Step - AI Influencers & Fanvue Models FAST](courses/Flux_Step_by_Step/README.md)
* [Realistic AI Images with Stable Diffusion & Fooocus](courses/Realistic_AI_Images_with_Stable_Diffusion_and_Fooocus/README.md)
* [Expert Tips & Advanced Workflows](courses/ExpertTips_AdvancedWorkflows/README.md)
