# Section 4: Training a Flux LoRA of your AI Influencer

## ALL YOU NEED TO KNOW ABOUT LORAS

<p align="center">
    <img src="../images/Section4/LoRARepresentation.png" width="800"/>
</p>

The grey box is the full model and the yellow box represent our LoRA.

The LoRA is a tiny part of the whole model that is retrained.


**How do LoRAs work?**

LoRAs work by adding small, extra layers to an AI model. These layers are **trained** to handle a **specific task** or style, like drawing in a particular art style or generating images with certain look.

We can train our LoRA to do:
* A certain style
* To create images of our AI influencer
* To generate images with a specific style


**Why Should You Use LoRAs?**

LoRAs empowers creators, even those with limited resources, to **personalize AI models** for unique outputs in a time-efficient way.


## Training a Flux LoRA with images of your own AI Influencer

The advantange of training our own LoRA with images of our own AI Influencer is that you can recreate the AI Influencer again and again with a just a prompt and a click.

First of all you need to have your **DATA SET** which is a list of images to train your LoRA.

The **DATA SET** needs to contemplate:
* Different backgrounds
* Different dresses for the AI Influencer
* Different poses for the AI Influencer

It's important to train the LoRA with different:
* Angles
* Lightings
* Backgrounds

Give each image a very descriptive name of what is in the image itself.

It's recommended to use **between 25 to 35 images** to train your LoRA.

When you have this folder with the images within you just need to create a ZIP file.

Then you need an account in <a href="https://huggingface.co/">Hugging Face</a> and another account in <a href="https://replicate.com/">Replicate</a>.

Inside <a href="https://replicate.com/">Replicate</a> you will find the <a href="https://replicate.com/ostris/flux-dev-lora-trainer/train">Flux Dev LoRA Trainer</a>


