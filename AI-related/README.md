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
    *   **Type**: SDXL LoRA
    *   **Description**: Swedish woman character (26 years old, 1.85m tall)
    *   **Trigger Word**: `helga`
    *   **Model ID**: 2570750
    *   **Source**: [Civitai](https://civitai.green/models/2284175?modelVersionId=2570750)

7.  `anastasia_lora.safetensors`
    *   **Type**: LoRA
    *   **Description**: Russian woman character (25 years old, 1.75m tall)
    *   **Trigger Word**: `anastasia`
    *   **Model ID**: 2570343
    *   **Source**: [Civitai](https://civitai.green/models/2283812?modelVersionId=2570343)

8.  `hana_lora.safetensors`
    *   **Type**: LoRA
    *   **Description**: Japanese woman character (25 years old, 1.75m tall)
    *   **Trigger Word**: `hana`
    *   **Model ID**: 2570710
    *   **Source**: [Civitai](https://civitai.green/models/2284140?modelVersionId=2570710)

9.  `inga_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: German woman character (26 years old, 1.75m tall)
    *   **Trigger Word**: `inga`
    *   **Model ID**: 2570634
    *   **Source**: [Civitai](https://civitai.green/models/2284072?modelVersionId=2570634)

10. `mariam_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Guinean woman character (25 years old, 1.70m tall)
    *   **Trigger Word**: `mariam`
    *   **Model ID**: 2570639
    *   **Source**: [Civitai](https://civitai.green/models/2284076?modelVersionId=2570639)

11. `chen_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Chinese woman character (25 years old, 1.70m tall)
    *   **Trigger Word**: `chen`
    *   **Model ID**: 2570349
    *   **Source**: [Civitai](https://civitai.green/models/2283817?modelVersionId=2570349)

12. `iuliia_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Ukrainian woman character (25 years old, 1.73m tall)
    *   **Trigger Word**: `iuliia`
    *   **Model ID**: 2570319
    *   **Source**: [Civitai](https://civitai.green/models/2283787?modelVersionId=2570319)

13. `allison_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Australian woman character (27 years old,1.85m tall)
    *   **Trigger Word**: `allison`
    *   **Model ID**: 2570341
    *   **Source**: [Civitai](https://civitai.green/models/2283809?modelVersionId=2570341)

14. `emma_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: American woman character (27 years old, 1.85m tall)
    *   **Trigger Word**: `emma`
    *   **Model ID**: 2570631
    *   **Source**: [Civitai](https://civitai.green/models/2284070?modelVersionId=2570631)

15. `rabab_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Moroccan woman character (25 years old, 1.72m tall)
    *   **Trigger Word**: `rabab`
    *   **Model ID**: 2570327
    *   **Source**: [Civitai](https://civitai.green/models/2283796?modelVersionId=2570327)

16. `fiona_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Scottish woman character (28 years old, 1.85m tall)
    *   **Trigger Word**: `fiona`
    *   **Model ID**: 2583873
    *   **Source**: [Civitai](https://civitai.green/models/2296247?modelVersionId=2583873)

17. `giulia_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Italian woman character (26 years old, 1.80m tall)
    *   **Trigger Word**: `giulia`
    *   **Model ID**: 2586700
    *   **Source**: [Civitai](https://civitai.green/models/2298822?modelVersionId=2586700)

18. `juanita_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Cuban woman character (28 years old, 1.85m tall)
    *   **Trigger Word**: `juanita`
    *   **Model ID**: 2590587
    *   **Source**: [Civitai](https://civitai.green/models/2302342?modelVersionId=2590587)

19. `sofia_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Finnish woman character (25 years old, 1.85m tall)
    *   **Trigger Word**: `sofia`
    *   **Model ID**: 2593749
    *   **Source**: [Civitai](https://civitai.green/models/2305233?modelVersionId=2593749)

20. `svetlana_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Russian woman character (28 years old, 1.85m tall)
    *   **Trigger Word**: `svetlana`
    *   **Model ID**: 2599427
    *   **Source**: [Civitai](https://civitai.green/models/2310427?modelVersionId=2599427)

21. `kasia_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Polish woman character (26 years old, 1.85m tall)
    *   **Trigger Word**: `kasia`
    *   **Model ID**: 2603390
    *   **Source**: [Civitai](https://civitai.green/models/2313984?modelVersionId=2603390)

22. `lara_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Polish woman character (30 years old, 1.70m tall)
    *   **Trigger Word**: `lara`
    *   **Model ID**: 2608668
    *   **Source**: [Civitai](https://civitai.green/models/2318797?modelVersionId=2608668)

23. `stefi_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: German woman character (26 years old, 1.90m tall)
    *   **Trigger Word**: `stefi`
    *   **Model ID**: 2614177
    *   **Source**: [Civitai](https://civitai.com/models/2323826?modelVersionId=2614177)

24. `sheila_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Peruvian woman character (26 years old, 1.70m tall)
    *   **Trigger Word**: `sheila`
    *   **Model ID**: 2619966
    *   **Source**: [Civitai](https://civitai.green/models/2329078?modelVersionId=2619966)

25. `amina_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Moroccan woman character (26 years old, 1.73m tall)
    *   **Trigger Word**: `amina`
    *   **Model ID**: 2622521
    *   **Source**: [Civitai](https://civitai.green/models/2331386?modelVersionId=2622521)

26. `milica_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Serbian woman character (27 years old, 1.75m tall)
    *   **Trigger Word**: `milica`
    *   **Model ID**: 2627557
    *   **Source**: [Civitai](https://civitai.green/models/2335896?modelVersionId=2627557)

27. `anne_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Dutch woman character (26 years old, 1.80m tall)
    *   **Trigger Word**: `anne`
    *   **Model ID**: 2665179
    *   **Source**: [Civitai](https://civitai.green/models/2369885?modelVersionId=2665179)

28. `maria_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Portuguese woman character (28 years old, 1.80m tall)
    *   **Trigger Word**: `maria`
    *   **Model ID**: 2674074
    *   **Source**: [Civitai](https://civitai.green/models/2377884?modelVersionId=2674074)

29. `aaju_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Greenlandic woman character (28 years old, 1.75m tall)
    *   **Trigger Word**: `aaju`
    *   **Model ID**: 2676941
    *   **Source**: [Civitai](https://civitai.green/models/2380507?modelVersionId=2676941)

30. `tina_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Slovenian woman character (26 years old, 1.75m tall)
    *   **Trigger Word**: `tina`
    *   **Model ID**: 2694529
    *   **Source**: [Civitai](https://civitai.green/models/2396460?modelVersionId=2694529)

31. `nora_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Estonian woman character (23 years old, 1.78m tall)
    *   **Trigger Word**: `nora`
    *   **Model ID**: 2697743
    *   **Source**: [Civitai](https://civitai.green/models/2399341?modelVersionId=2697743)

32. `anna_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Latvian woman character (24 years old, 1.75m tall)
    *   **Trigger Word**: `anna`
    *   **Model ID**: 2700775
    *   **Source**: [Civitai](https://civitai.green/models/2402032?modelVersionId=2700775)

33. `dalia_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Lithuanian woman character (24 years old, 1.73m tall)
    *   **Trigger Word**: `dalia`
    *   **Model ID**: 2703173
    *   **Source**: [Civitai](https://civitai.green/models/2404165?modelVersionId=2703173)

34. `olena_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Ukrainian woman character (24 years old, 1.72m tall)
    *   **Trigger Word**: `olena`
    *   **Model ID**: 2706444
    *   **Source**: [Civitai](https://civitai.green/models/2407082?modelVersionId=2706444)

35. `zoya_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Belarusian woman character (26 years old, 1.75m tall)
    *   **Trigger Word**: `zoya`
    *   **Model ID**: 2705922
    *   **Source**: [Civitai](https://civitai.green/models/2406617?modelVersionId=2705922)

36. `priya_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Indian woman character (26 years old, 1.75m tall)
    *   **Trigger Word**: `priya`
    *   **Model ID**: 2709407
    *   **Source**: [Civitai](https://civitai.green/models/2409730?modelVersionId=2709407)

37. `valentina_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Venezuelan woman character (26 years old, 1.75m tall)
    *   **Trigger Word**: `valentina`
    *   **Model ID**: 2711709
    *   **Source**: [Civitai](https://civitai.green/models/2411844?modelVersionId=2711709)

38. `carmen_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Chilean woman character (28 years old, 1.75m tall)
    *   **Trigger Word**: `carmen`
    *   **Model ID**: 2724940
    *   **Source**: [Civitai](https://civitai.green/models/2423632?modelVersionId=2724940)

39. `naran_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Mongolian woman character (25 years old, 1.68m tall)
    *   **Trigger Word**: `naran`
    *   **Model ID**: 2727706
    *   **Source**: [Civitai](https://civitai.green/models/2426080?modelVersionId=2727706)

40. `olga_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Belarusian woman character (25 years old, 1.70m tall)
    *   **Trigger Word**: `olga`
    *   **Model ID**: 2748594
    *   **Source**: [Civitai](https://civitai.green/models/2444591?modelVersionId=2748594)

41. `gabriela_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Brazilian woman character (26 years old, 1.72m tall)
    *   **Trigger Word**: `gabriela`
    *   **Model ID**: 2780416
    *   **Source**: [Civitai](https://civitai.green/models/2472971?modelVersionId=2780416)

42. `alina_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: Moldovan woman character (26 years old, 1.73m tall)
    *   **Trigger Word**: `alina`
    *   **Model ID**: 2784882
    *   **Source**: [Civitai](https://civitai.com/models/2476986?modelVersionId=2784882)

43. `charlize_lora.safetensors`
    *   **Type**: SDXL LoRA
    *   **Description**: South African woman character (26 years old, 1.70m tall)
    *   **Trigger Word**: `charlize`
    *   **Model ID**: 2805114
    *   **Source**: [Civitai](https://civitai.green/models/2495366?modelVersionId=2805114)


### 🖼️ LoRA Character Gallery

<p align="center"><em>Click any image to view the model on CivitAI</em></p>

<table align="center">
<tr>
  <td align="center"><a href="https://civitai.com/models/2284175"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/2947e803-e17e-401b-9e98-5f02b76cb9c6/width=450/116522817.jpeg" width="220"/></a><br/><b>Helga</b><br/><em>Swedish · 26y · 1.85m</em></td>
  <td align="center"><a href="https://civitai.com/models/2283812"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/7d0d345c-51fa-4f31-ac18-0f56625fc53d/width=450/116509365.jpeg" width="220"/></a><br/><b>Anastasia</b><br/><em>Russian · 25y · 1.75m</em></td>
  <td align="center"><a href="https://civitai.com/models/2284140"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/04985357-7056-45d9-ad3a-fab7655f9571/width=450/116512221.jpeg" width="220"/></a><br/><b>Hana</b><br/><em>Japanese · 25y · 1.75m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2284072"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/82b7a3af-3bca-4ded-887b-d35c41c99875/width=450/116511750.jpeg" width="220"/></a><br/><b>Inga</b><br/><em>German · 26y · 1.75m</em></td>
  <td align="center"><a href="https://civitai.com/models/2284076"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/207cca0d-3260-4156-aa45-4b0e53b34a0d/width=450/116512422.jpeg" width="220"/></a><br/><b>Mariam</b><br/><em>Guinean · 25y · 1.70m</em></td>
  <td align="center"><a href="https://civitai.com/models/2283817"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/bb6144f1-7e4a-43fe-beb5-7b24210d20fd/width=450/116501408.jpeg" width="220"/></a><br/><b>Chen</b><br/><em>Chinese · 25y · 1.70m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2283787"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/c8d61866-d952-453e-819b-f4deb82acc9f/width=450/116500925.jpeg" width="220"/></a><br/><b>Iuliia</b><br/><em>Ukrainian · 25y · 1.73m</em></td>
  <td align="center"><a href="https://civitai.com/models/2283809"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/23f5df57-ce04-4cbb-9fcd-4cc24b705abd/width=450/116501622.jpeg" width="220"/></a><br/><b>Allison</b><br/><em>Australian · 27y · 1.85m</em></td>
  <td align="center"><a href="https://civitai.com/models/2284070"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/fb29a80e-1651-4436-9b75-8588a6e524b2/width=450/116512774.jpeg" width="220"/></a><br/><b>Emma</b><br/><em>American · 27y · 1.85m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2283796"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/33fb3301-ec2f-4a8f-8915-c198d074efd1/width=450/116499426.jpeg" width="220"/></a><br/><b>Rabab</b><br/><em>Moroccan · 25y · 1.72m</em></td>
  <td align="center"><a href="https://civitai.com/models/2296247"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/1e86c00c-0d9e-4ba3-a433-22dbfcda3c27/width=450/116977697.jpeg" width="220"/></a><br/><b>Fiona</b><br/><em>Scottish · 28y · 1.85m</em></td>
  <td align="center"><a href="https://civitai.com/models/2298822"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/38e333fc-c818-4625-8239-0d1353dd9065/width=450/117088163.jpeg" width="220"/></a><br/><b>Giulia</b><br/><em>Italian · 26y · 1.80m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2302342"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/acfa2396-fea3-4d2f-a518-88695142e05d/width=450/117244562.jpeg" width="220"/></a><br/><b>Juanita</b><br/><em>Cuban · 28y · 1.85m</em></td>
  <td align="center"><a href="https://civitai.com/models/2305233"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/f9c3eb39-62e2-4967-878c-b7dc564aa667/width=450/117349603.jpeg" width="220"/></a><br/><b>Sofia</b><br/><em>Finnish · 25y · 1.85m</em></td>
  <td align="center"><a href="https://civitai.com/models/2310427"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/c060b0ae-6f46-4968-a61a-5565df48d27d/width=450/117559750.jpeg" width="220"/></a><br/><b>Svetlana</b><br/><em>Russian · 28y · 1.85m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2313984"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/e3e8305f-42b0-4fd6-a7c1-c3a3e0cba541/width=450/117742042.jpeg" width="220"/></a><br/><b>Kasia</b><br/><em>Polish · 26y · 1.85m</em></td>
  <td align="center"><a href="https://civitai.com/models/2318797"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/d706b22c-5dcf-49c9-8be2-ed9289dab6df/width=450/117909238.jpeg" width="220"/></a><br/><b>Lara</b><br/><em>Polish · 30y · 1.70m</em></td>
  <td align="center"><a href="https://civitai.com/models/2323826"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/6534e7cd-c4d0-4d09-bfa2-22a83ecb3e1a/width=450/118136063.jpeg" width="220"/></a><br/><b>Stefi</b><br/><em>German · 26y · 1.90m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2329078"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/1e0bc7f9-d9ac-42b5-9a8d-f23ed0264432/width=450/118376129.jpeg" width="220"/></a><br/><b>Sheila</b><br/><em>Peruvian · 26y · 1.70m</em></td>
  <td align="center"><a href="https://civitai.com/models/2331386"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/0d31c367-b752-433c-bf76-72edd4d4135a/width=450/118459690.jpeg" width="220"/></a><br/><b>Amina</b><br/><em>Moroccan · 26y · 1.73m</em></td>
  <td align="center"><a href="https://civitai.com/models/2335896"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/f93a7700-22dc-4689-81b8-3800c7784fd3/width=450/118668328.jpeg" width="220"/></a><br/><b>Milica</b><br/><em>Serbian · 27y · 1.75m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2369885"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/0868a068-67c5-4248-a37a-a93b03412f31/width=450/120144950.jpeg" width="220"/></a><br/><b>Anne</b><br/><em>Dutch · 26y · 1.80m</em></td>
  <td align="center"><a href="https://civitai.com/models/2377884"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/a84e1a9f-18b6-42a1-99bd-3f814190a1e8/width=450/120577362.jpeg" width="220"/></a><br/><b>Maria</b><br/><em>Portuguese · 28y · 1.80m</em></td>
  <td align="center"><a href="https://civitai.com/models/2380507"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/5dcd07e4-f6e0-41c8-86ed-32b9951faa1e/width=450/120605584.jpeg" width="220"/></a><br/><b>Aaju</b><br/><em>Greenlandic · 28y · 1.75m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2396460"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/e7cd9cc3-2bc5-45a8-86f9-203a927b77b7/width=450/121299632.jpeg" width="220"/></a><br/><b>Tina</b><br/><em>Slovenian · 26y · 1.75m</em></td>
  <td align="center"><a href="https://civitai.com/models/2399341"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/00d48c11-ee1b-405f-8fb9-03b996db0cbd/width=450/121442367.jpeg" width="220"/></a><br/><b>Nora</b><br/><em>Estonian · 23y · 1.78m</em></td>
  <td align="center"><a href="https://civitai.com/models/2402032"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/f7a24fac-4cab-4327-8fff-35df4298a1cc/width=450/121616848.jpeg" width="220"/></a><br/><b>Anna</b><br/><em>Latvian · 24y · 1.75m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2404165"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/fff8fdb3-0cbb-466d-81c7-c333830315a2/width=450/121647674.jpeg" width="220"/></a><br/><b>Dalia</b><br/><em>Lithuanian · 24y · 1.73m</em></td>
  <td align="center"><a href="https://civitai.com/models/2406617"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/11a1dc67-005b-44f8-bc5f-29781869c9be/width=450/121754777.jpeg" width="220"/></a><br/><b>Zoya</b><br/><em>Belarusian · 26y · 1.75m</em></td>
  <td align="center"><a href="https://civitai.com/models/2407082"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/9bc01b12-88d9-4c4e-8605-8f3e7d9956f7/width=450/121790959.jpeg" width="220"/></a><br/><b>Olena</b><br/><em>Ukrainian · 24y · 1.72m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2409730"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/ed6d0860-501d-4caf-b01e-6a97aae86d32/width=450/121901125.jpeg" width="220"/></a><br/><b>Priya</b><br/><em>Indian · 26y · 1.75m</em></td>
  <td align="center"><a href="https://civitai.com/models/2423632"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/2c41df75-92c9-4999-8cbc-b11f119a96ce/width=450/122450824.jpeg" width="220"/></a><br/><b>Carmen</b><br/><em>Chilean · 28y · 1.75m</em></td>
  <td align="center"><a href="https://civitai.com/models/2426080"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/4711cbbc-24b7-4d97-8df2-15060958996c/width=450/122579561.jpeg" width="220"/></a><br/><b>Naran</b><br/><em>Mongolian · 25y · 1.68m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2444591"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/5a6c1d27-1589-47a9-b9c3-58d59d0d0e12/width=450/123859534.jpeg" width="220"/></a><br/><b>Olga</b><br/><em>Belarusian · 25y · 1.70m</em></td>
  <td align="center"><a href="https://civitai.com/models/2472971"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/2cc70d69-19f6-4c5b-a81d-c62c2817e559/width=450/124464358.jpeg" width="220"/></a><br/><b>Gabriela</b><br/><em>Brazilian · 26y · 1.72m</em></td>
  <td align="center"><a href="https://civitai.com/models/2476986"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/45f2d6a3-27fc-483a-a94f-93df50851028/width=450/124653293.jpeg" width="220"/></a><br/><b>Alina</b><br/><em>Moldovan · 26y · 1.73m</em></td>
</tr>
<tr>
  <td align="center"><a href="https://civitai.com/models/2495366"><img src="https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/8bb943b3-76d0-427c-9798-5ae55d881ec1/width=450/125437607.jpeg" width="220"/></a><br/><b>Charlize</b><br/><em>South African · 26y · 1.70m</em></td>
  <td></td>
  <td></td>
</tr>
</table>

---

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
