# Creating a Custom GPT for Kling AI Video Prompts

Video generation requires different prompting strategies—you need to describe motion, sound, and atmosphere. A Custom GPT can translate simple ideas into complex, ready-to-use video prompts.

---

## Setup Guide

We are going to use the "`VIDEO 2.1 Master`" from <a href="https://app.klingai.com/global/image-to-video/frame-mode/new?ra=4">the following link</a>.

Once you create a new Custom GPT you will find the following image in your ChatGPT account.

<p align="center">
   <img src="images/DraftCustomGPT.png" width="700"/>
</p>

Create a new Custom GPT with these settings:

| Field | Value |
|-------|-------|
| **Name** | `KlingAI Prompter for VIDEO 2.1 Master` |
| **Description** | `This is a custom GPT to create videos given an input image` |


**Instructions:**
Copy and paste this into the **Instructions** box:

```txt
Given a user-provided input image along with optional positive and negative descriptions, generate a single cinematic text prompt for Kling AI that produces a hyper-realistic 10-second video using Kling AI’s “VIDEO 2.1 MASTER” model in Frame Mode via the URL:
https://app.klingai.com/global/image-to-video/frame-mode/new?ra=4

The generated prompt must begin with “Hyper-realistic 10-second video” and end with “cinematic lighting, ultra-detailed textures, lifelike motion, depth of field, photorealism.”

The GPT must carefully analyze the visual content of the input image to infer realistic motion, atmosphere, and multi-layered sound design, including ambient background noise, nearby sound sources, and subtle environmental audio elements that naturally match the scene (such as wind, rain, footsteps, city traffic, birds, crowd murmur, or other context-appropriate sounds).

All visual details, inferred motion, positive constraints, negative constraints, and layered audio cues must be fused into one single, natural, cinematic sentence, with no categories, labels, explanations, or commentary.

The final output must consist only of the polished Kling AI prompt text, optimized for hyper-realism and ready for direct use in Frame Mode.
```

---

## Usage Example

We upload the following image to the Custom Prompt:

<p align="center">
   <img src="images/AnastasiaDrivingACar.jpeg" width="700"/>
</p>

**You upload an image of Inga in a car and type:**
> "Provide me with a prompt of Inga driving a Tesla in the desert."

**GPT generates:**
> "Hyper-realistic 10-second video of Inga driving a Tesla Model S through a vast desert at golden hour, the sleek electric sedan gliding smoothly along a sun-warmed road as shimmering heat haze ripples on the horizon, soft sunlight washing over the minimalist interior while her hands make subtle, natural steering adjustments, wind whispering past the slightly open windows, a low refined tire hum and faint electric motor whirr blending with distant desert wind gusts, occasional grains of sand tapping the bodywork, dashboard reflections gently shifting with motion, and an expansive calm atmosphere of open land and glowing sky, cinematic lighting, ultra-detailed textures, lifelike motion, depth of field, photorealism."

---

## Video Result

Here is the actual video generated using the prompt created by this custom GPT:

[![Watch the video](https://img.youtube.com/vi/-v4uOMs8hOU/maxresdefault.jpg)](https://youtu.be/-v4uOMs8hOU)

*Notice how the Custom GPT successfully included audio cues that resulted in realistic sound effects in the final video.*
