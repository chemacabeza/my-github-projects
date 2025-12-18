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

# Function to download file with optional token
download_model() {
    local url="$1"
    local output="$2"
    
    if [ -f "$output" ]; then
        return 0
    fi

    # Try downloading without token first (use || true to prevent set -e from exiting)
    local exit_code=0
    curl -fL "$url" -o "$output" || exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        return 0
    fi
    
    # If 401 Unauthorized (curl exit code 22 for HTTP errors, or 56 for 401 during transfer)
    if [ $exit_code -eq 22 ] || [ $exit_code -eq 56 ]; then
        echo "Download failed: Unauthorized (401)."
        if [ -n "${CIVITAI_API_TOKEN:-}" ]; then
            echo "Retrying with CIVITAI_API_TOKEN..."
            # Append token to URL
            if [[ "$url" == *"?"* ]]; then
                url="${url}&token=${CIVITAI_API_TOKEN}"
            else
                url="${url}?token=${CIVITAI_API_TOKEN}"
            fi
            if curl -fL "$url" -o "$output"; then
                return 0
            fi
        else
            echo "WARNING: restricted model requires CIVITAI_API_TOKEN environment variable."
            echo "Export it before running: export CIVITAI_API_TOKEN=your_token_here"
            echo "Skipping download for $output"
            # Clean up partial download
            rm -f "$output"
            return 0 # Don't fail the build, just skip
        fi
    fi
    return $exit_code
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
download_model 'https://civitai.com/api/download/models/2498388' "$LORA_DIR/helga_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2502002' "$LORA_DIR/anastasia_lora.safetensors"
download_model 'https://civitai.com/api/download/models/2514908' "$LORA_DIR/hana_lora.safetensors"

echo "=== Starting Fooocus ==="
echo "All models and LoRAs are accessible via symbolic links"
echo "Navigate to Fooocus directory and launch..."
# Navigate to Fooocus directory before launching
cd Fooocus
exec "$@"
