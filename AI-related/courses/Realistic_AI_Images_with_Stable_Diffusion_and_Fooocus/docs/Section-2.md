# Section 2: Introduction to Fooocus and Google Colab

## What is Fooocus?

**Fooocus** is a powerful, open-source image generation software based on **Stable Diffusion**.

*   **Stable Diffusion**: The underlying engine that generates images from noise.
*   **Fooocus**: The user-friendly interface that makes it easy to control Stable Diffusion.

### How It Works (Simplified)

Stable Diffusion works by reversing the process of adding noise to an image. It starts with random "static" (noise) and gradually refines it into a clear image based on your text prompt.

<p align="center">
    <img src="images/section2/002-TrainingLearning.png" width="800"/>
</p>

You don't need to be a technical expert. You just need to provide an "idea" (prompt), and the software handles the complex generation process.

### Why Choose Fooocus?

*   ✅ **Free/Low Cost**: Runs on Google Colab (free tier available).
*   ✅ **User-Friendly**: Intuitive interface with "advanced" features hidden but accessible.
*   ✅ **High Quality**: Optimized for photorealism out of the box.
*   ✅ **Extensible**: Supports custom checkpoints (models) and LoRAs.

---

## Getting Started with Google Colab

We will use Google Colab to run Fooocus in the cloud. This avoids the need for a powerful local computer.

1.  **Open the Notebook**: Go to the [Fooocus Colab Notebook](https://colab.research.google.com/github/lllyasviel/Fooocus/blob/main/fooocus_colab.ipynb).
2.  **Run the Cell**: Click the "Play" button (▶️) next to the code block.
3.  **Wait for Initialization**: It may take a few minutes to install dependencies.
4.  **Access the Interface**: Look for a link ending in `gradio.live` (e.g., `https://9b701c85cd07.gradio.live`). Click it to open Fooocus.

### First Test Run

Try a simple prompt like:
> `a cute little animal`

<p align="center">
    <img src="images/section2/CuteLittleAnimal1.png" width="400"/>
    <img src="images/section2/CuteLittleAnimal2.png" width="400"/>
</p>

---

## Installing Custom Base Models (Checkpoints)

A **Base Model** (or Checkpoint) determines the overall style and capability of the image generator. For example, "Realism Engine SDXL" is tuned for realistic photos.

We can download models from [CivitAI](https://civitai.com/).

### How to Install a Model in Colab

To install a specific model (e.g., Realism Engine SDXL) automatically when you start Colab, you need to modify the code cell **before** running it.

#### 1. Get the Download Link
On CivitAI:
1.  Find the model (e.g., Realism Engine SDXL).
2.  Right-click the "Download" button and copy the link address.
    *   *Note: Ensure the link contains the model ID (e.g., `293240`).*

#### 2. Modified Colab Code
Replace the default code in the Colab cell with this script to download the model and launch Fooocus:

```python
!pip install pygit2==1.15.1
%cd /content
!git clone https://github.com/lllyasviel/Fooocus.git
%cd /content/Fooocus

# Download the Model (Realism Engine SDXL)
!wget -O /content/Fooocus/models/checkpoints/realismEngineSDXL_v30VAE.safetensors https://civitai.com/api/download/models/293240

# Launch Fooocus
!python entry_with_update.py --share --always-high-vram
```

**Key Steps:**
1.  `!wget ...`: Downloads the model file to the correct folder (`models/checkpoints`).
2.  `entry_with_update.py`: Starts the application.

Once running, select your new model from the "Base Model" dropdown in the Fooocus "Advanced" settings.

---
[Previous Section](Section-1.md) | [Next Section](Section-3.md)
