<!--
<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
-->
# How to run Fooocus on Google Colab

<p align="center">
    <img src="images/GoogleColab2.jpg" width="600"/>
</p>

A typical notebook in Google Colab looks like the following.

```bash
!pip install pygit2==1.15.1
%cd /content
!git clone https://github.com/lllyasviel/Fooocus.git
%cd /content/Fooocus
!mkdir -p /content/Fooocus/models/checkpoints
!curl -L 'https://civitai.com/api/download/models/299716' -o /content/Fooocus/models/checkpoints/sdxlYamersRealistic5_v5Rundiffusion.safetensors
!python entry_with_update.py --share --always-high-vram
```

**What is happening in this notebook in Google Colab?**

1. **Install a Python library**

```bash
!pip install pygit2==1.15.1
```
* Installs the `pygit2` package (version 1.15.1).
* This library lets Python code work with Git repositories.

2. **Go to the Colab “home” folder**

```bash
%cd /content
```
* Changes the current working directory to `/content`, which is the default place where files live in Google Colab.

3. **Download some code from GitHub**

```bash
!git clone https://github.com/lllyasviel/Fooocus.git
```
* Makes a local copy of the `Fooocus` project from GitHub into `/content/Fooocus`.

4. **Enter that project folder**

```bash
%cd /content/Fooocus
```
* Moves into the newly cloned `Fooocus` folder.

5. **Create a folder for model files**

```bash
!mkdir -p /content/Fooocus/models/checkpoints
```
* Creates a `models/checkpoints` directory inside Fooocus.
* The `-p` flag means “make parent folders if they don’t exist and don’t complain if they already do.”

6. **Download a big AI model file**

```bash
!curl -L 'https://civitai.com/api/download/models/299716' -o /content/Fooocus/models/checkpoints/sdxlYamersRealistic5_v5Rundiffusion.safetensors
```
* Downloads a model (a `.safetensors` file) from Civitai and saves it in the checkpoints folder.
* `-L` tells `curl` to follow any redirects until it gets the file.
* You can include several models in the same Google Colab notebook. 
    * More information about creating the `curl` commands later in this page

7. **Run the program**

```bash
!python entry_with_update.py --share --always-high-vram
```
* Starts the Fooocus application.
* `--share` usually means “create a public link so others can connect to the running app.”
* `--always-high-vram` probably tells it to use more GPU memory for better performance.


## Building curl command for SDXL models

The purpose of this section is to be able to build the following command:

```bash
!curl -L 'https://civitai.com/api/download/models/<number>' -o /content/Fooocus/models/checkpoints/<model>
```

Where:
* "`<model>`" = filename you want to give the model
* "`<number>`" = the model version ID from Civitai

1. Go to <a href="https://civitai.com/">Civitai</a>.
2. Search for a model:
    * For example: "`realistic vision`", "`deliberate`", "`dreamshaper`", etc.
    * Fooocus only allows working with SDXL models. You need to search for "`SDXL`" in the search bar.
3. Go to the Model’s Page
    * Model page for <a href="https://civitai.com/models/127923/sdxl-yamers-realistic-5">SDXL Yamer's Realistic 5</a>: 
         * This page shows:
             * Model description
             * Previews
             * Versions (very important)
4. Scroll to the "Versions" Section
    * Each model may have multiple versions (e.g., v1.0, v2.0, v5.1, etc.).
    * Pick the version you want to download.
5. Right-click the "Download" button
    * Under the version you chose, you'll see a "Download" button.
    * Right-click the button and choose "Copy link address"
         * Our copied link address is as follows: "`https://civitai.com/api/download/models/299716`"
6. Extract the Model Version ID
    * The copied URL will look like: `https://civitai.com/api/download/models/299716`
    * The number at the end ("`299716`") is the model version ID -> this goes into your "`<number>`".
7. Name the file "`<model>.safetensors`"
    * Choose a name for your model file. You can:
        * Use the model name (e.g., "`sdxlYamersRealistic5_v5Rundiffusion.safetensors`")
    * This becomes your "`<model>`" in the command.
8. Put it all together
    * Let’s say:
        * You want to download _SDXL Yamer's Realistic 5_
        * You copied the link: `https://civitai.com/api/download/models/299716`
        * You want to name it `sdxlYamersRealistic5_v5Rundiffusion`
    * Then, your Colab line becomes:

```bash
!curl -L 'https://civitai.com/api/download/models/299716' -o /content/Fooocus/models/checkpoints/sdxlYamersRealistic5_v5Rundiffusion.safetensors
```

### Different SDXL models

#### <a href="https://civitai.com/models/127923/sdxl-yamers-realistic-5">SDXL Yamer's Realistic 5</a>

```bash
!curl -L 'https://civitai.com/api/download/models/299716' -o /content/Fooocus/models/checkpoints/sdxlYamersRealistic5_v5Rundiffusion.safetensors
```

#### <a href="https://civitai.com/models/101055/sd-xl">SD XL</a>

```bash
!curl -L 'https://civitai.com/api/download/models/128078' -o /content/Fooocus/models/checkpoints/sdXL_v10VAEFix.safetensors
```

#### <a href="https://civitai.com/models/84040/sdxl-unstable-diffusers-yamermix">SDXL Unstable Diffusers ☛ YamerMIX</a>

```bash
!curl -L 'https://civitai.com/api/download/models/395107' -o /content/Fooocus/models/checkpoints/sdxlUnstableDiffusers_nihilmania.safetensors
```

This model is very slow to download in Google Colab


## Template Prompt for Fooocus

**Prompt Template**

```txt
A hyper-realistic portrait of a [character type or role], [gender], [age], 
with [detailed physical traits: skin tone, eye color, hairstyle, facial features], 
wearing [specific outfit/clothing details], posed in a [describe pose: e.g., confident stance, 
seated with crossed arms, walking mid-stride], set against a [background: location, lighting, atmosphere], 
in the style of [style: e.g., cinematic realism, Vogue photography, Rembrandt lighting, etc.], 
ultra-detailed, 8K resolution, shallow depth of field, photorealistic, perfect lighting, 
realistic skin texture, detailed fabric, bokeh effect.
```

**Prompt Template in one line**

```txt
A hyper-realistic portrait of a [character type or role], [gender], [age], with [detailed physical traits: skin tone, eye color, hairstyle, facial features], wearing [specific outfit/clothing details], posed in a [describe pose: e.g., confident stance, seated with crossed arms, walking mid-stride], set against a [background: location, lighting, atmosphere], in the style of [style: e.g., cinematic realism, Vogue photography, Rembrandt lighting, etc.], ultra-detailed, 8K resolution, shallow depth of field, photorealistic, perfect lighting, realistic skin texture, detailed fabric, bokeh effect.
```

**Negative Prompt**

```txt
blurry, low resolution, low quality, pixelated, overexposed, underexposed, poorly drawn hands, 
extra fingers, missing fingers, deformed face, mutated hands, malformed limbs, distorted body, 
bad anatomy, unrealistic proportions, bad eyes, lazy eye, cross-eye, asymmetrical face, messy hair, 
ugly, bad lighting, over-saturated, low contrast, watermarks, text, logo, frame, border, jpeg artifacts, 
cartoon, anime, painting, illustration, sketch, 3D render, CGI, doll-like, waxy skin, unnatural skin texture, 
uncanny valley, flat shading
```

**Negative Prompt in one line**

```txt
blurry, low resolution, low quality, pixelated, overexposed, underexposed, poorly drawn hands, extra fingers, missing fingers, deformed face, mutated hands, malformed limbs, distorted body, bad anatomy, unrealistic proportions, bad eyes, lazy eye, cross-eye, asymmetrical face, messy hair, ugly, bad lighting, over-saturated, low contrast, watermarks, text, logo, frame, border, jpeg artifacts, cartoon, anime, painting, illustration, sketch, 3D render, CGI, doll-like, waxy skin, unnatural skin texture, uncanny valley, flat shading
```


**Example Prompt (based on the template)**

```txt
A hyper-realistic portrait of a futuristic warrior, female, mid-30s, 
with deep bronze skin, glowing green eyes, braided silver hair, 
a scar across her left cheek, wearing an armored exosuit with neon-blue accents, 
posed standing confidently with one hand on her hip and the other holding a plasma blade, 
set against a rainy cyberpunk city at night with neon lights reflecting on the wet street, 
in the style of cinematic realism, ultra-detailed, 8K resolution, shallow depth of field, 
photorealistic, perfect lighting, realistic skin texture, detailed fabric and armor, 
subtle bokeh effect.
```

The following image is an example created with the example prompt and the negative prompt.

<p align="center">
    <img src="./images/ImageFromTemplate.jpeg" width="550"/>
</p>

## LoRA (Low-Rank Adaptation)

LoRA stands for **Low-Rank Adaptation**. It’s a **parameter-efficient fine-tuning** technique, designed to adapt large pre-trained neural networks (like GPT, BERT, or Stable Diffusion) to new tasks or datasets **without updating most of the model’s parameters**.

Instead of modifying the entire weight matrices in the model, LoRA introduces **small trainable low-rank matrices** that get injected into specific layers (often attention layers) and are the **only parts trained** during fine-tuning.

This approach dramatically reduces:
* Memory usage
* Training time
* Compute requirements

### Building curl command for LoRAs

At the end we need to build a command like the following one.

```bash
!curl -L 'https://civitai.com/api/download/models/<number>' -o /content/Fooocus/models/loras/<lora-name>.safetensors
```

Where:
* "`<number`": The LoRA version ID from Civitai
* "`<lora-name>`": The name of the LoRA 


1. Go to <a href="https://civitai.com/">Civitai</a>.
2. Search for a LoRA:
    * You need to search for "`LORA`" in the search bar.
3. Once you find LoRA to your liking go to the website of that LoRA
4. Click on the Download button of the LoRA and select "`Copy Link Address`"
    * In our case we are using the LoRA <a href="https://civitai.com/models/6433/loraflatcolor">[LORA]Flat_Color</a>
    * The link copied is "`https://civitai.com/api/download/models/7555`"
5. Then you actually start dowloading the LoRA just to get the filename in our case the filename is "`flat_color.safetensors`"
6. Bear in mind that some LoRAs have trigger words in this LoRA the trigger words are "`flat_color,ligne_claire`"
    * So this is something you need to include in your prompt to trigger the LoRA
7. At the end the "`curl`" command line is as follows:

```bash
!curl -L 'https://civitai.com/api/download/models/7555' -o /content/Fooocus/models/loras/flat_color.safetensors
```

### 💡 Motivation Behind LoRA

Training or fine-tuning large models (e.g., GPT-3 or BERT-large) is computationally expensive and memory-intensive. Most organizations or individuals don’t have the resources to do this efficiently.

LoRA was designed to:
1. Reduce the number of trainable parameters.
2. Allow **multiple tasks or domains** to be trained **without retraining the full model**.
3. Be modular — you can train **different adapters** and **swap them in** without affecting the base model.

### ⚙️  How LoRA Works: The Technical Explanation

Let’s take a simple example from a Transformer model: the **self-attention layer**.

**Original setup**

In a typical Transformer, we have a weight matrix $W \in \mathbb{R}^{ d \times k}$ (say in a query or value projection).

When fine-tuning, traditional approaches **update $W$** directly.

**LoRA modification**

Instead of updating $W$, LoRA **freezes** it and **adds a trainable delta** using **two low-rank** matrices:

$\nabla W = AB$

Where:
* $A \in \mathbb{R}^{ d \times r}$
* $B \in \mathbb{R}^{ r \times k}$
* $r \ll d, k$ (typically $r = 4$ or $r = 8$)

### 🧠 In Simple Terms:

Instead of updating the **entire huge model**, LoRA adds **small adapter layers** that learn task-specific behavior while keeping the original model mostly frozen. This saves **time**, **memory**, and **compute**.

### 🔧 How It Works

1. **Start with a pre-trained model** (e.g., GPT-2 or Stable Diffusion).
2. Freeze the weights of this base model.
3. Add **low-rank matrices** (the “LoRA layers”) into specific layers of the model (like attention layers).
4. Train **only** the small LoRA layers, not the whole model.

These low-rank matrices are much smaller than the full weight matrices, so training is fast and resource-efficient.

### 🏆 Benefits

* **Efficient**: Uses much less memory and compute.
* **Modular**: You can train many LoRA adapters for different tasks and swap them in/out.
* **Open-source friendly**: Common in community fine-tuned models (e.g., huggingface or Civitai).

### 📦 Use Cases

* Fine-tuning a large language model on your own data.
* Creating custom personas or styles in image generators like Stable Diffusion.
* Training models with limited GPU resources.

