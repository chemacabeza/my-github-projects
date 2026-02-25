# Creating LoRAs on CivitAI

You can train and publish your own custom **LoRA** (Low-Rank Adaptation) models directly inside [CivitAI](https://civitai.green/) using their built-in **Onsite Training** feature — no local GPU required.

---

## What Is a LoRA?

A LoRA is a lightweight fine-tuning of an existing AI image model (such as Flux or SDXL). Instead of retraining the full model, a LoRA learns a small set of adjustments that teach the model to recognise a specific subject, style, or concept. The result is a small file (typically 50–300 MB) that you combine with the base model at inference time.

---

## Prerequisites

| Requirement | Details |
|-------------|---------|
| **CivitAI account** | Free account at [civitai.green](https://civitai.green/) |
| **Buzz credits** | CivitAI's internal currency used to pay for GPU compute time |
| **Training images** | A curated dataset of images of your subject (see below) |

> [!TIP]
> You can earn free Buzz credits by engaging with the community (posting, reviewing models, etc.) or by purchasing them directly from your account settings.

---

## Using ChatGPT to Create the Training Parameters

Once you have your images ready, you can ask ChatGPT to recommend optimal training parameters for your specific dataset. Use the following template — replacing `<number_of_images>` with your actual image count:

```txt
I am providing <number_of_images> high-quality images to CivitAI's Onsite Trainer using "Custom: Juggernaut XL" as the base model. Provide me with values for the following parameters to create a LoRA with the best image quality possible:
- Epochs
- Num Repeats
- Train Batch Size
- Resolution
- Enable Bucket
- Shuffle Tags
- Keep Tokens
- Clip Skip
- Flip Augmentation
- Unet LR (with all the decimals)
- Text Encoder LR (with all the decimals)
- LR Scheduler
- LR Scheduler Cycles
- Min SNR Gamma
- Network Dim
- Network Alpha
- Noise Offset (with all the decimals)
- Optimizer
- High Priority
```

As an example, we sent the prompt above to ChatGPT with **40 images**, and the answer was the following:

```txt
Here’s a strong “best quality” preset for training a SDXL LoRA on 40 high-quality images with Custom: Juggernaut XL (aiming for high fidelity without overtraining):
- Epochs: 10
- Num Repeats: 10 (40 images × 10 repeats × 10 epochs = ~4000 steps @ batch 1 — a solid rule-of-thumb range)
- Train Batch Size: 1 (keeps steps high without hitting platform limits; better for fidelity on smaller sets)
- Resolution: 1024
- Enable Bucket: ON
- Shuffle Tags: ON
- Keep Tokens: 1 (assumes your trigger token is first; helps consistency)
- Clip Skip: 1 (SDXL generally uses 1; CLIP skip is mostly an SD1.5 thing)
- Flip Augmentation: ON (turn OFF only if left/right accuracy matters: tattoos, text, asymmetrical face marks, etc.)
- Unet LR (all decimals): 0.00010000
- Text Encoder LR (all decimals): 0.00005000
- LR Scheduler: cosine
- LR Scheduler Cycles: 1
- Min SNR Gamma: 5.0
- Network Dim: 64
- Network Alpha: 32
- Noise Offset (all decimals): 0.030000
- Optimizer: AdamW8bit (if available; otherwise AdamW)
- High Priority: ON
```

---

## Step 1 — Prepare Your Dataset

The quality of your LoRA depends almost entirely on the quality of your training images.

### Image guidelines

- **Quantity:** Aim for **30–40 images** for a subject LoRA. More is not always better — diversity matters more than raw count.
- **Resolution:** At least **512 × 512 px**; ideally **1024 × 1024 px** or higher.
- **Variety:** Include different angles, lighting conditions, expressions, and backgrounds. Avoid using the same photo twice.
- **Crop:** Center the subject tightly. Remove busy or distracting backgrounds where possible.
- **Format:** JPG or PNG are both accepted.

### Captions (trigger words)

Each image needs an associated text caption that describes it. CivitAI's trainer supports:

- **Auto-captioning** — CivitAI can generate captions automatically using an integrated tagger (recommended for beginners).
- **Manual captions** — Provide a `.txt` file alongside each image with the same filename, containing a comma-separated list of tags.

> [!IMPORTANT]
> Choose a unique **trigger word** (e.g. `myperson`, `mycharacter`) and include it in every caption. This is the word you will use at inference time to activate your LoRA.

---

## Step 2 — Start a New Training Job

1. Log in to [civitai.green](https://civitai.green/).
2. Click your profile avatar → **Train a Model**.
3. Select **Create** and choose the training type:
   - **Character / Subject** — for a specific person or object.
   - **Style** — for an artistic look or colour palette.
   - **Concept** — for abstract ideas or recurring scene elements.
4. Upload your prepared images. You can drag-and-drop a ZIP archive or upload files individually.
5. Let the auto-captioner run (or upload your own captions).

---

## Step 3 — Configure Training Parameters

CivitAI exposes the most important hyperparameters through a simple form. The recommended starting values are listed below.

| Parameter | Recommended Value | Notes |
|-----------|-------------------|-------|
| **Base model** | Flux Dev / SDXL | Match the model family you intend to use |
| **Training steps** | 1 000 – 2 000 | Lower for style LoRAs; higher for subject LoRAs |
| **Learning rate** | `1e-4` | Decrease if the output is over-fitted |
| **Network dimension (rank)** | 32 – 64 | Higher = more expressive but larger file |
| **Network alpha** | Half of the rank | E.g. 16 if rank is 32 |
| **Batch size** | 1 – 2 | Increase if you have many images |

> [!NOTE]
> CivitAI will estimate the **Buzz cost** of your training job before you confirm. Typical jobs cost between 500 and 2 000 Buzz.

---

## Step 4 — Launch and Monitor

1. Click **Start Training**. Your job is queued on CivitAI's GPU cluster.
2. You will receive an email notification when training completes (usually within 10–30 minutes).
3. From your **Profile → Models**, open the training job to download the resulting `.safetensors` file or use it directly inside CivitAI's **Image Generator**.

---

## Step 5 — Test Your LoRA

Before publishing, evaluate the output quality:

1. Open the **CivitAI Image Generator**.
2. Select the same base model you trained on.
3. Add your LoRA and set its **weight** to `0.7 – 1.0`.
4. Write a prompt that includes your trigger word. For example:

```txt
Hyper realistic portrait of myperson, natural light, editorial photography, shallow depth of field
```

5. Generate several images at different seeds. Check for:
   - Consistent likeness to the training images.
   - Absence of anatomical distortions.
   - Good generalisation (the subject looks natural in new scenarios).

> [!TIP]
> If the LoRA is **over-fitted** (the output looks too similar to your training images, or lacks variety), lower the training steps or learning rate and retrain.
> If the LoRA is **under-fitted** (the trigger word has little effect), increase training steps or add more varied images.

---

## Step 6 — Publish Your LoRA

1. From the completed training job, click **Publish Model**.
2. Fill in:
   - **Name** — clear, descriptive title.
   - **Description** — explain what the LoRA does, the trigger word, and recommended settings.
   - **Tags** — add relevant tags (`flux`, `portrait`, `style`, etc.) to make your model discoverable.
   - **Preview images** — upload at least one generated image to showcase the LoRA.
3. Set visibility (**Public** or **Unlisted**) and click **Publish**.

---

## Tips & Best Practices

- **Start small.** Train a quick 500-step job first to validate your dataset before committing Buzz to a full run.
- **Use consistent lighting.** Training images shot under similar lighting conditions produce more coherent results.
- **Avoid watermarks and text overlays.** These confuse the captioner and introduce artifacts.
- **Version your LoRAs.** CivitAI supports multiple versions per model — use this to iterate without losing previous checkpoints.
- **Check the community.** Browse [civitai.green](https://civitai.green/) for similar LoRAs to understand what training approaches others have used.
