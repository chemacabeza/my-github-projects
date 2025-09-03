#!/usr/bin/env bash
set -euo pipefail

# Host-mounted folders (relative to where you run docker compose)
CKPT_DIR="/models"
LORA_DIR="/LoRAs"

mkdir -p "$CKPT_DIR" "$LORA_DIR"

echo "=== Checking models ==="

# Models
[ -f "$CKPT_DIR/sdxlYamersRealistic5_v5Rundiffusion.safetensors" ] || \
  curl -L 'https://civitai.com/api/download/models/299716' -o "$CKPT_DIR/sdxlYamersRealistic5_v5Rundiffusion.safetensors"

[ -f "$CKPT_DIR/sdXL_v10VAEFix.safetensors" ] || \
  curl -L 'https://civitai.com/api/download/models/128078' -o "$CKPT_DIR/sdXL_v10VAEFix.safetensors"

[ -f "$CKPT_DIR/sdxlUnstableDiffusers_nihilmania.safetensors" ] || \
  curl -L 'https://civitai.com/api/download/models/395107' -o "$CKPT_DIR/sdxlUnstableDiffusers_nihilmania.safetensors"

[ -f "$CKPT_DIR/SDXLRonghua_v45.safetensors" ] || \
  curl -L 'https://civitai.com/api/download/models/471038' -o "$CKPT_DIR/SDXLRonghua_v45.safetensors"

echo "=== Checking LoRAs ==="

# LoRAs
[ -f "$LORA_DIR/lingerie_loha.safetensors" ] || \
  curl -L 'https://civitai.com/api/download/models/362360' -o "$LORA_DIR/lingerie_loha.safetensors"

[ -f "$LORA_DIR/retro_neon_illustriouos.safetensors" ] || \
  curl -L 'https://civitai.com/api/download/models/1082049' -o "$LORA_DIR/retro_neon_illustriouos.safetensors"

[ -f "$LORA_DIR/pumpsheel.safetensors" ] || \
  curl -L 'https://civitai.com/api/download/models/100982' -o "$LORA_DIR/pumpsheel.safetensors"

echo "=== Starting Fooocus ==="
exec "$@"

