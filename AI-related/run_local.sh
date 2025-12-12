#!/usr/bin/env bash
set -euo pipefail

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

    # Try downloading without token first
    if curl -fL "$url" -o "$output"; then
        return 0
    else
        local exit_code=$?
        # If 401 Unauthorized (curl exit code 22)
        if [ $exit_code -eq 22 ]; then
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
                return 0 # Don't fail the build, just skip
            fi
        fi
        return $exit_code
    fi
}

mkdir -p "$CKPT_DIR" "$LORA_DIR"

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

echo "=== Starting Fooocus ==="
# We assume we are in the AI-related directory and Fooocus is cloned in ./Fooocus
cd Fooocus
exec "$@"
