# Section 4: LoRAs (Low-Rank Adaptation)

## What is a LoRA?

**LoRA (Low-Rank Adaptation)** is like a "plugin" for your AI model.

*   **Base Model (e.g., SDXL)**: Knows how to draw *everything* generally.
*   **LoRA**: A small file that teaches the model *one specific thing* very well (e.g., a specific celebrity, a cartoon style, a type of clothing).

**Why use them?**
*   ✅ **Efficient**: You don't need to retrain the massive base model.
*   ✅ **Mixable**: You can combine multiple LoRAs (e.g., one for a character + one for a clothing style).

---

## Installing LoRAs in Google Colab

To use a LoRA, you must download it into the `models/loras` folder. We do this by adding `wget` commands to our Colab startup script.

### Example: Installing Multiple LoRAs

Here is a full startup script that installs:
1.  **Base Model**: Realism Engine SDXL.
2.  **LoRA 1**: Lingerie LoHA.
3.  **LoRA 2**: Pumps/Heels.
4.  **LoRA 3**: Retro Neon Style.

```python
!pip install pygit2==1.15.1
%cd /content
!git clone https://github.com/lllyasviel/Fooocus.git
%cd /content/Fooocus

# 1. Base Model
!wget -O /content/Fooocus/models/checkpoints/realismEngineSDXL_v30VAE.safetensors https://civitai.com/api/download/models/293240

# 2. LoRA: Lingerie
!wget -O /content/Fooocus/models/loras/lingerie_loha.safetensors https://civitai.com/api/download/models/362360

# 3. LoRA: High Heels
!wget -O /content/Fooocus/models/loras/pumpsheel.safetensors https://civitai.com/api/download/models/100982

# 4. LoRA: Retro Neon
!wget -O /content/Fooocus/models/loras/retro_neon_illustriouos.safetensors https://civitai.com/api/download/models/1082049

# Launch App
!python entry_with_update.py --share --always-high-vram
```

---

## How to Use a LoRA

### Scenario 1: Adding Details with Inpainting (High Heels)

We want to change the shoes in an existing photo to specific high heels using the `pumpsheel` LoRA.

1.  **Input Image**: Upload photo to **Inpaint or Outpaint**.
2.  **Mask**: Paint over the shoes.
3.  **Prompt**: `black high heels, black stiletto heels`.
4.  **Model Settings**:
    *   Base Model: `realismEngineSDXL`.
    *   LoRA 1: `pumpsheel.safetensors` (Weight `0.8`).
5.  **Advanced Setting**: Check **Development Debug Mode** -> **Inpaint** -> Adjust **Inpaint Denoising Strength** (start at `1.0`, lower if needed).
6.  **Generate**.

<p align="center">
    <img src="../images/section4/Woman-with-red-high-heels.jpeg" width="350"/>
</p>

### Scenario 2: Creating a Stylized Image (Retro Neon)

We want to generate a new image from scratch using the `retro_neon` LoRA.

**Important**: Check the LoRA's page on CivitAI for a **Trigger Word**.
*   *Retro Neon Trigger Word*: `retro_neon`

1.  **Model Settings**:
    *   Base Model: `realismEngineSDXL`.
    *   LoRA 1: `retro_neon...` (Weight `0.8`).
2.  **Prompt**: `RETRO_NEON a cool guy with sunglasses`.
3.  **Generate**.

<p align="center">
    <img src="../images/section4/Retro-Neon-Cool-Guy-With-Sunglasses.jpeg" width="350"/>
</p>

### Adjusting LoRA Weight

The **Weight** determines how strong the effect is.
*   **0.8**: Strong influence (standard).
*   **0.5**: Subtler influence, blends more with the base model.

<p align="center">
    <img src="../images/section4/Retro-Neon-With-05-Weight.jpeg" width="350"/>
    <br>
    <em>Same prompt with LoRA weight reduced to 0.5</em>
</p>
