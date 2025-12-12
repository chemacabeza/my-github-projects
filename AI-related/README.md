# AI Related

<p align="center">
 <img src="images/AI-Related3.jpg" width="900"/>
</p>

## INTRODUCTION

Welcome to **AI Related** — the experimental zone where creativity meets computation. This section of my public GitHub repository is all about **pushing the limits of what’s possible with AI** — a playground for experiments, ideas, and breakthroughs at the intersection of technology and imagination.

Inside, you’ll discover:

* 🧠 **Hands-on experiments** with tools like Stable Diffusion and beyond — transforming lines of code into vibrant, intelligent art.
* 📘 **Learning notes and insights** from courses, research, and tinkering — distilled into practical workflows that make AI creation both approachable and powerful.
* 🚀 **Custom projects and prototypes** where theory becomes reality — unique explorations that showcase how AI can amplify human creativity.

Whether you’re here to **learn**, **explore**, **or be inspired**, _AI Related_ is your launchpad into the evolving world of artificial intelligence.
Dive in, experiment boldly, and see how far your curiosity can take you.

## CONTENTS

* [Running Fooocus on your local computer](Local-Fooocus/README.md)
* [Running Fooocus on Google Colab](Google-Colab/README.md)

## QUICK START

To build and run the local Fooocus environment (using Docker):

1.  **Navigate to the directory**:
    ```bash
    cd AI-related
    ```

2.  **Run with Docker**:
    ```bash
    make run
    ```

To stop:

```bash
make down
```

### Running Locally (No Docker)

If you prefer to run the application directly on your machine (without Docker), follow these steps.

**Prerequisites**:
*   Linux or macOS (Windows support may require manual adjustments)
*   Python 3.10 or higher (Python 3.12 is supported)
*   `git`, `make`, and `python3` installed

1.  **Navigate to the directory**:
    ```bash
    cd AI-related
    ```

2.  **Install dependencies**:
    ```bash
    make install-local
    ```
    *   This command performs the following:*
        *   Clones the Fooocus repository.
        *   Creates a local virtual environment (`venv`).
        *   Installs optimized PyTorch versions (compatible with Python 3.12).
        *   Installs all required dependencies.

3.  **Run the application**:
    ```bash
    make run-local
    ```
    *   *First run:* This will automatically download necessary checkpoint and LoRA models (several GBs).
    *   **Note on Civitai Models**: Some models may require a Civitai API token (e.g., age-restricted content).
        *   If the download fails with a 401 error, you can provide your token:
            ```bash
            export CIVITAI_API_TOKEN=your_token_here
            make run-local
            ```
        *   If you don't have a token, the script will skip those restricted models and continue.
    *   *Subsequent runs:* Starts the Fooocus server immediately.
    *   Access the UI at [http://localhost:7860](http://localhost:7860).
## COURSES

* [Flux Step by Step - AI Influencers & Fanvue Models FAST](courses/Flux_Step_by_Step/README.md)
* [Realistic AI Images with Stable Diffusion & Fooocus](courses/Realistic_AI_Images_with_Stable_Diffusion_and_Fooocus/README.md)
