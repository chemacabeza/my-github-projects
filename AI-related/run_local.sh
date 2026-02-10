#!/usr/bin/env bash
set -euo pipefail

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macOS"
    GPU_INFO="Metal Performance Shaders (MPS)"
    echo "=== Platform: $PLATFORM ==="
    echo "GPU Acceleration: $GPU_INFO"
    echo "Tip: Verify MPS with: python -c \"import torch; print('MPS:', torch.backends.mps.is_available())\""
else
    PLATFORM="Linux"
    GPU_INFO="CUDA"
    echo "=== Platform: $PLATFORM ==="
    echo "GPU Acceleration: $GPU_INFO"
fi
echo ""

# Local folders (relative to where you run make)
CKPT_DIR="./models"
LORA_DIR="./LoRAs"

# Function to download file with optional token and retry logic
download_model() {
    local url="$1"
    local output="$2"
    local max_retries=3
    local retry_delay=5
    
    if [ -f "$output" ]; then
        return 0
    fi

    # Prepare URL with token if available (for Civitai models)
    local download_url="$url"
    if [[ "$url" == *"civitai.com"* ]] && [ -n "${CIVITAI_API_TOKEN:-}" ]; then
        if [[ "$url" == *"?"* ]]; then
            download_url="${url}&token=${CIVITAI_API_TOKEN}"
        else
            download_url="${url}?token=${CIVITAI_API_TOKEN}"
        fi
    fi

    # Try downloading with retries for transient errors
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        local exit_code=0
        curl --http1.1 --connect-timeout 30 --max-time 600 -fL "$download_url" -o "$output" || exit_code=$?
        
        if [ $exit_code -eq 0 ]; then
            return 0
        fi
        
        # Handle transient errors (52=empty reply, 28=timeout, 56=network failure)
        if [ $exit_code -eq 52 ] || [ $exit_code -eq 28 ] || [ $exit_code -eq 56 ]; then
            if [ $attempt -lt $max_retries ]; then
                echo "Download attempt $attempt failed (curl error $exit_code). Retrying in ${retry_delay}s..."
                rm -f "$output"
                sleep $retry_delay
                attempt=$((attempt + 1))
                continue
            else
                echo "WARNING: Download failed after $max_retries attempts (curl error $exit_code)."
                echo "Skipping download for $output"
                rm -f "$output"
                return 0 # Don't fail the build, just skip
            fi
        fi
        
        # Handle 401 Unauthorized - try with token if not already using one
        if [ $exit_code -eq 22 ]; then
            if [[ "$download_url" != *"token="* ]] && [ -n "${CIVITAI_API_TOKEN:-}" ]; then
                echo "Download failed: Unauthorized (401). Retrying with CIVITAI_API_TOKEN..."
                if [[ "$url" == *"?"* ]]; then
                    download_url="${url}&token=${CIVITAI_API_TOKEN}"
                else
                    download_url="${url}?token=${CIVITAI_API_TOKEN}"
                fi
                attempt=$((attempt + 1))
                continue
            else
                echo "WARNING: restricted model requires CIVITAI_API_TOKEN environment variable."
                echo "Export it before running: export CIVITAI_API_TOKEN=your_token_here"
                echo "Skipping download for $output"
                rm -f "$output"
                return 0 # Don't fail the build, just skip
            fi
        fi
        
        # For other errors, fail immediately
        rm -f "$output"
        return $exit_code
    done
    
    return 0
}

mkdir -p "$CKPT_DIR" "$LORA_DIR"

# Setup symbolic links for Fooocus to use centralized model storage
echo "=== Setting up symbolic links ==="
FOOOCUS_CKPT_DIR="./Fooocus/models/checkpoints"
FOOOCUS_LORA_DIR="./Fooocus/models/loras"

# Check if checkpoints directory is a symlink or regular directory
if [ -L "$FOOOCUS_CKPT_DIR" ]; then
    echo "Checkpoint symlink already exists"
elif [ -d "$FOOOCUS_CKPT_DIR" ]; then
    echo "Converting checkpoints directory to symlink..."
    rm -rf "$FOOOCUS_CKPT_DIR"
    ln -s "../../models" "$FOOOCUS_CKPT_DIR"
    echo "Created symlink: $FOOOCUS_CKPT_DIR -> ../../models"
else
    ln -s "../../models" "$FOOOCUS_CKPT_DIR"
    echo "Created symlink: $FOOOCUS_CKPT_DIR -> ../../models"
fi

# Check if loras directory is a symlink or regular directory
if [ -L "$FOOOCUS_LORA_DIR" ]; then
    echo "LoRA symlink already exists"
elif [ -d "$FOOOCUS_LORA_DIR" ]; then
    echo "Converting loras directory to symlink..."
    rm -rf "$FOOOCUS_LORA_DIR"
    ln -s "../../LoRAs" "$FOOOCUS_LORA_DIR"
    echo "Created symlink: $FOOOCUS_LORA_DIR -> ../../LoRAs"
else
    ln -s "../../LoRAs" "$FOOOCUS_LORA_DIR"
    echo "Created symlink: $FOOOCUS_LORA_DIR -> ../../LoRAs"
fi

echo "=== Checking models ==="

# Standard Fooocus Models
download_model 'https://huggingface.co/lllyasviel/fav_models/resolve/main/fav/juggernautXL_v8Rundiffusion.safetensors' "$CKPT_DIR/juggernautXL_v8Rundiffusion.safetensors"
download_model 'https://huggingface.co/mashb1t/fav_models/resolve/main/fav/animaPencilXL_v500.safetensors' "$CKPT_DIR/animaPencilXL_v500.safetensors"
download_model 'https://huggingface.co/lllyasviel/fav_models/resolve/main/fav/realisticStockPhoto_v20.safetensors' "$CKPT_DIR/realisticStockPhoto_v20.safetensors"

# Custom Models
download_model 'https://civitai.com/api/download/models/299716' "$CKPT_DIR/sdxlYamersRealistic5_v5Rundiffusion.safetensors"
download_model 'https://civitai.com/api/download/models/128078' "$CKPT_DIR/sdXL_v10VAEFix.safetensors"
download_model 'https://civitai.com/api/download/models/395107' "$CKPT_DIR/sdxlUnstableDiffusers_nihilmania.safetensors"
download_model 'https://civitai.com/api/download/models/471038' "$CKPT_DIR/SDXLRonghua_v45.safetensors"

echo "=== Checking LoRAs ==="

# Standard Fooocus LoRAs
download_model 'https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_offset_example-lora_1.0.safetensors' "$LORA_DIR/sd_xl_offset_example-lora_1.0.safetensors"
download_model 'https://huggingface.co/mashb1t/fav_models/resolve/main/fav/SDXL_FILM_PHOTOGRAPHY_STYLE_V1.safetensors' "$LORA_DIR/SDXL_FILM_PHOTOGRAPHY_STYLE_V1.safetensors"

# Custom LoRAs
download_model 'https://civitai.com/api/download/models/362360' "$LORA_DIR/lingerie_loha.safetensors"
download_model 'https://civitai.com/api/download/models/1082049' "$LORA_DIR/retro_neon_illustriouos.safetensors"
download_model 'https://civitai.com/api/download/models/100982' "$LORA_DIR/pumpsheel.safetensors"
download_model 'https://civitai.com/api/download/models/2570750' "$LORA_DIR/helga_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2570343' "$LORA_DIR/anastasia_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2570710' "$LORA_DIR/hana_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2570634' "$LORA_DIR/inga_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2570639' "$LORA_DIR/mariam_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2570349' "$LORA_DIR/chen_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2570319' "$LORA_DIR/iuliia_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2570341' "$LORA_DIR/allison_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2570631' "$LORA_DIR/emma_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2570327' "$LORA_DIR/rabab_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2583873' "$LORA_DIR/fiona_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2586700' "$LORA_DIR/giulia_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2590587' "$LORA_DIR/juanita_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2593749' "$LORA_DIR/sofia_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2599427' "$LORA_DIR/svetlana_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2603390' "$LORA_DIR/kasia_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2608668' "$LORA_DIR/lara_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2614177' "$LORA_DIR/stefi_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2619966' "$LORA_DIR/sheila_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2622521' "$LORA_DIR/amina_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2627557' "$LORA_DIR/milica_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2665179' "$LORA_DIR/anne_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2674074' "$LORA_DIR/maria_lora.safetensors"

echo "=== Starting Fooocus ==="
echo "All models and LoRAs are accessible via symbolic links"
echo "Navigate to Fooocus directory and launch..."
# Navigate to Fooocus directory before launching
cd Fooocus
exec "$@"
