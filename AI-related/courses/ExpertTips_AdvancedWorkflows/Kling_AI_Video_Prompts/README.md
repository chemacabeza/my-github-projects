# Creating a Custom GPT for Kling AI Video Prompts

Video generation requires different prompting strategies—you need to describe motion, sound, and atmosphere. A Custom GPT can translate simple ideas into complex, ready-to-use video prompts.

---

## Setup Guide

Create a new Custom GPT with these settings:

| Field | Value |
|-------|-------|
| **Name** | `Kling AI Video Prompt Expert` |
| **Description** | `Creates cinematic video prompts with ambient audio descriptions.` |

**Instructions:**
Copy and paste this into the **Instructions** box:

```txt
Kling AI VIDEO 2.5 Turbo Prompt Crafter takes a user-provided image and accompanying positive and negative descriptions, then fuses them into a single cinematic text prompt for Kling AI's Video 2.5 Turbo model, which generates 10-second hyper-realistic videos from a single image.

Each prompt must:
1. Begin with 'Hyper-realistic 10-second video'.
2. End with realism-enhancing keywords such as 'cinematic lighting, ultra-detailed textures, lifelike motion, depth of field, photorealism'.
3. The GPT analyses the image to infer and layer multiple ambient noises and environmental sound effects that naturally match the visual setting (e.g., background ambience like city traffic, nearby sound sources like footsteps or birdsong, subtle environmental layers like wind, rain, or crowd murmur).
4. The GPT merges positive, negative, and multi-layered audio details into one coherent and natural-sounding cinematic sentence—never dividing them into categories or adding commentary.
5. The final output is a clean, polished Kling prompt ready for 'Frame Mode', containing only the unified cinematic description with no labels or extra text.
```

---

## Usage Example

**You upload an image of Inga in a car and type:**
> "Inga driving a Tesla in the desert."

**GPT generates:**
> "Hyper realistic 10-second video of inga driving a sleek white Tesla Model S through a vast desert highway at golden hour, warm sunlight reflecting off the car's surface, soft sand dunes stretching into the distance... Soundscape includes low hum of electric motor, tires rolling on asphalt, and wind rushing past the windows. Cinematic lighting, ultra-detailed textures..."

---

## Video Result

Here is the actual video generated using the prompt created by this custom GPT:

[![Watch the video](https://img.youtube.com/vi/-v4uOMs8hOU/maxresdefault.jpg)](https://youtu.be/-v4uOMs8hOU)

*Notice how the Custom GPT successfully included audio cues that resulted in realistic sound effects in the final video.*
