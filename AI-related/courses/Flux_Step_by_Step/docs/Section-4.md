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

It's recommended to use **between 30 to 40 images** to train your LoRA.

When you have this folder with the images within you just need to create a ZIP file.

What you need to have is:
* An account on <a href="https://replicate.com/">Replicate</a>
* An account on <a href="https://huggingface.co/">Hugging Face</a>

Inside <a href="https://replicate.com/">Replicate</a> you will find the <a href="https://replicate.com/ostris/flux-dev-lora-trainer/train">Flux Dev LoRA Trainer</a>

Once you are in that trainer you need to:
1. Assing the name for your AI Influencer, it could be anything.
2. Then provide your dataset in the field "`input_images`" of the Flux Dev LoRA Trainer
3. Then you need to select the "`trigger_word`" this is a very important because it will be the word that will trigger the LoRA. The recommendation is to use the name of the AI Influencer
4. On the "`steps`" you need to select between "`2000`" and "`3000`". The more steps you take the more time you will get to train the LoRA and the more expensive it is. The cost to train a LoRA could be between 3$ or 4$.
5. Then you need go back to <a href="https://huggingface.co/">Hugging Face</a> to create a new Access Token
6. Then with Access Token you created in Hugging Face you back to the Flux Dev LoRA Trainer and paste Access Token in the field that says "`hf_token`"
7. Then you go back to <a href="https://huggingface.co/">Hugging Face</a> to create a new model with the name of your AI Influencer, do not forget to copy the name of your model.
8. Then you go back to the Flux Dev LoRA Trainer and paste the name of the model of Hugging Face inside the field "`hf_repo_id`"
