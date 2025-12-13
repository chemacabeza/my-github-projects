# Section 3: Creating a Consistent AI Influencer with Flux

## Introduction

Creating a consistent AI influencer means generating a character with the same facial features and body type across different settings, outfits, and poses. This consistency is key to building a brand and audience.

**What is an AI Influencer?**
A digital persona, often indistinguishable from a real person on social media (e.g., [Aitana Lopez](https://www.instagram.com/fit_aitana/?hl=en)).

**Business Potential**:
*   💰 **Sponsorships & Brand Deals**
*   🔗 **Affiliate Marketing**
*   💎 **Exclusive Content Subscriptions** (Fanvue, Patreon)
*   🛍️ **Merchandise**

---

## Step 1: Define Your Character

Before generating images, define your influencer's attributes clearly. The more detailed your definition, the more consistent your results.

### Character Profile Checklist
*   **Demographics**: Age, Gender, Nationality
*   **Physical Traits**: Hair color/style, Eye color, Body type (e.g., athletic, curvy)
*   **Style**: Clothing preference, Makeup style
*   **Background**: Hobbies, Lifestyle, Social status
*   **Backstory**: Use ChatGPT to create a compelling bio and personality to help guide your content creation.

---

## Step 2: The Creation Workflow

Until you train a specific LoRA (covered in Section 4), reliable consistency requires a **Face Swap workflow**.

1.  **Generate the Base Image (Body + Scene)**: Create high-quality photos with the desired pose, outfit, and lighting using Flux.
2.  **Generate the Reference Face**: Create a dedicated high-quality portrait of your character's face.
3.  **Swap the Face**: Replace the base image's face with your reference face using specialized tools.

---

## Step 3: Generating the Base Images (Body)

We use **Flux 1.1 Pro Ultra** for high-quality base images. Focus on the scene, outfit, and pose in these prompts.

### Prompt Templates

#### Scenario 1: Elegant Event
**Prompt:**
```txt
A hyper-realistic knee-length portrait of a beautiful busty 24-year-old Italian girl, beautiful full lips, round face, sensual face, (very realistic skin structure) flawless skin, stunning brown eyes, vibrant look, small waist, athletic figure, wearing (an elegant beige party dress) (posed in a modern luxurious hotel lobby), perfect lighting
```

<p align="center">
    <img src="../images/Section3/ItalianInfluencerInABeigeDress.jpg" width="500"/>
</p>

[📄 Download Body Prompts PDF](../files/Section3/Body+Prompts.pdf)

#### Scenario 2: Casual Kitchen
**Prompt:**
```txt
A hyper-realistic knee-length portrait of a beautiful busty 24-year-old Italian girl, beautiful full lips, round face, sensual face, (very realistic skin structure) flawless skin, stunning brown eyes, vibrant look, small waist, athletic figure, wearing (a white spaghetti top and black jeans, standing in modern designer kitchen), perfect lighting
```

<p align="center">
    <img src="../images/Section3/ItalianInfluencerInTheKitchen2.jpg" width="500"/>
</p>

#### Scenario 3: Swimwear/Pool
**Prompt:**
```txt
A hyper-realistic knee-length portrait of a beautiful busty 24-year-old Italian girl, beautiful full lips, round face, sensual face, (very realistic skin structure) flawless skin, stunning brown eyes, vibrant look, small waist, athletic figure, wearing (an olive-green swimsuit with cutouts posing at a beautiful rooftop infinity pool), perfect lighting
```

<p align="center">
    <img src="../images/Section3/ItalianInfluencerAtThePool2.jpg" width="500"/>
</p>

---

## Step 4: Generating the Reference Face

You need a perfect close-up portrait to serve as your "Source Face" for swapping.

**Combined Face Prompt:**
```txt
A hyper-realistic portrait of a beautiful 24-year-old Italian model, beautiful full lips, round face, sensual face, (very realistic skin structure) flawless skin, stunning brown eyes, professional camera, high resolution, perfect saturation, 4k
```

<p align="center">
    <img src="../images/Section3/ItalianInfluencerFace2.jpg" width="500"/>
</p>

💡 **Tip**: Ensure the face is facing forward, well-lit, and completely visible.

---

## Step 5: Face Swapping

We will look at two methods: **Quick (Discord)** and **High Quality (Fooocus)**.

### Method 1: Discord (InsightFace)

Best for speed and ease of use.

**Prerequisites:**
1.  **Discord Account** & Server
2.  **InsightFace Bot**: Add the bot to your server.

**Setup Process:**
1.  In your Discord server, type `/saveid`.
2.  Upload your **Reference Face** image.
3.  Give it a short ID name (e.g., `italiana`).
4.  Press Enter to save the identity.

**Swapping Process:**
1.  Upload your **Base Image (Body)** to the chat.
2.  Right-click the uploaded image.
3.  Select **Apps > INSwapper**.
4.  The bot will process the image and return it with the face swapped.

<table>
    <tr>
        <td align="center"><b>Before</b></td>
        <td align="center"><b>After</b></td>
    </tr>
    <tr>
        <td><img src="../images/Section3/ItalianInfluencerAtThePool2.jpg" width="400"/></td>
        <td><img src="../images/Section3/ItalianInfluencerAtThePool2_ins.webp" width="400"/></td>
    </tr>
</table>

💡 **NSFW Trick**: If Discord blocks an image due to safety filters:
1. Crop just the face area of your base image.
2. Upload and swap the face on that cropped image.
3. Paste the swapped face back over the original image using an editor like Paint or Photoshop.

---

### Method 2: Fooocus (Advanced Refinement)

Best for quality and high-detail fixes. Use the [Fooocus Colab Notebook](https://colab.research.google.com/drive/1-XWG91YqADQna0uXEVL5C4TlN2IPGw18).

**Configuration:**

1.  **Enable Advanced Mode**: Check the "Advanced" box at the bottom.
2.  **Input Image Settings**:
    *   Go to **Image Prompt** tab.
    *   Select **Advanced** checkboxes.
    *   **Bottom slot**: Select `FaceSwap`.
    *   Upload **Reference Face**.
    *   Set `Stop At` to `1` and `Weight` to `1.19`.
3.  **Inpaint Settings**:
    *   Go to **Inpaint or Outpaint** tab.
    *   Upload **Base Image (Body)**.
    *   Use the brush to mask (color over) the face area.
    *   **Method**: Select `Improve Detail (face, hand, eyes, etc.)`.
    *   **Inpaint Additional Prompt**: Add details like `beautiful brown eyes, detailed face`.
4.  **Mixing Controls** (Developer Debug Mode):
    *   Go to **Developer Debug Mode** -> **Control** tab.
    *   Check `Mixing Image Prompt and Inpaint`.
    *   Go to **Inpaint** tab within Debug Mode.
    *   Set `Inpaint Denoising Strength` to `0.38`.
5.  **Generate**: Click the "Generate" button.

---

## Summary

You now have a complete workflow to create consistent characters:
1.  **Design** the character profile.
2.  **Generate** varied scenarios setting the scene and pose with Flux.
3.  **Standardize** the face using simple (Discord) or advanced (Fooocus) swapping.

In the next section, we will automate this further by **Training a LoRA** (Section 4), which allows generating your character directly without the swapping step.
