# Section 6: Expert Tips & Advanced Workflows

## About This Section

> [!NOTE]
> This section contains supplementary expert tips and advanced workflows to supercharge your creation process using custom tools.

---

## 1. Creating a Custom GPT for Flux Prompts

You can automate the creation of high-quality Flux prompts by building a specific **Custom GPT** in ChatGPT (Plus subscription required). This ensures every prompt follows best practices for photorealism and style.

### Setup Guide

1.  Go to **[ChatGPT](https://chatgpt.com)** and click **Explore GPTs**.
2.  Click **+ Create** to start building a new GPT.
3.  Navigate to the **Configure** tab and use the following settings:

| Field | Value |
|-------|-------|
| **Name** | `Flux 1.1 Pro Prompt Crafter` |
| **Description** | `Creates artistic prompts for Flux 1.1 Pro Ultra` |

**Instructions:**
Copy and paste this into the **Instructions** box:

```txt
Provide me with a prompt for "https://replicate.com/black-forest-labs/flux-1.1-pro-ultra" to create a hyper realistic image of "inga" doing something that will be specified. Always use lowercase for "inga". The style should allow for mature, artistic, and sensual imagery — focusing on elegance, mood, atmosphere, and realism — while staying non-explicit. The prompt must start with "Hyper realistic image" and include all relevant descriptors to make it visually compelling, cinematic, and detailed. If a Negative Prompt is requested, include it seamlessly in the main prompt to guide the AI toward the desired composition. Keep tone professional, evocative, and artistically descriptive, suitable for fine art or editorial photography.
```

### Usage Example

**You type:**
> "Inga reading a quantum physics book wearing glasses in a relaxing way."

**GPT generates:**
> "Hyper realistic image of inga reading a thick quantum physics book while wearing elegant reading glasses, sitting comfortably in a softly lit modern interior. Her posture is relaxed and graceful, one leg casually crossed, as warm afternoon light filters through sheer curtains..."

---

## 2. Creating a Custom GPT for Kling AI Video Prompts

Video generation requires different prompting strategies—you need to describe motion, sound, and atmosphere. A Custom GPT can translate simple ideas into complex, ready-to-use video prompts.

### Setup Guide

Create another new Custom GPT with these settings:

| Field | Value |
|-------|-------|
| **Name** | `Kling AI Video Prompt Expert` |
| **Description** | `Creates cinematic video prompts with ambient audio descriptions.` |

**Instructions:**
Copy and paste this into the **Instructions** box:

```txt
Kling AI VIDEO 2.5 Turbo Prompt Crafter takes a user-provided image and accompanying positive and negative descriptions, then fuses them into a single cinematic text prompt for Kling AI’s Video 2.5 Turbo model, which generates 10-second hyper-realistic videos from a single image.

Each prompt must:
1. Begin with 'Hyper-realistic 10-second video'.
2. End with realism-enhancing keywords such as 'cinematic lighting, ultra-detailed textures, lifelike motion, depth of field, photorealism'.
3. The GPT analyses the image to infer and layer multiple ambient noises and environmental sound effects that naturally match the visual setting (e.g., background ambience like city traffic, nearby sound sources like footsteps or birdsong, subtle environmental layers like wind, rain, or crowd murmur).
4. The GPT merges positive, negative, and multi-layered audio details into one coherent and natural-sounding cinematic sentence—never dividing them into categories or adding commentary.
5. The final output is a clean, polished Kling prompt ready for 'Frame Mode', containing only the unified cinematic description with no labels or extra text.
```

### Usage Example

**You upload an image of Inga in a car and type:**
> "Inga driving a Tesla in the desert."

**GPT generates:**
> "Hyper realistic 10-second video of inga driving a sleek white Tesla Model S through a vast desert highway at golden hour, warm sunlight reflecting off the car’s surface, soft sand dunes stretching into the distance... Soundscape includes low hum of electric motor, tires rolling on asphalt, and wind rushing past the windows. Cinematic lighting, ultra-detailed textures..."

---

## Summary

By using these Custom GPTs, you turn a simple 5-word idea into a professional, paragraph-long prompt that leverages the full power of Flux and Kling AI. This saves time and guarantees consistent, high-quality results.
