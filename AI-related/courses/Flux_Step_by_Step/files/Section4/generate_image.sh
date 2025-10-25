#!/usr/bin/env bash
# generate_image.sh

REPLICATE_API_KEY="..."
REPLICATE_LORA="..."
# The prompt needs to include the trigger word for the LoRA
PROMPT=""

curl -X POST "https://api.replicate.com/v1/predictions" \
  -H "Authorization: Bearer YOUR_REPLICATE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "version": "THE_SPECIFIC_NUMBER_OF_YOUR_LORA",
    "input": {
      "model": "dev",
      "prompt": "IMAGE_PROMPT_INCLUDING_THE_LORA_KEY_WORD",
      "megapixels": "1",
      "aspect_ratio": "4:5",
      "output_format": "png",
      "num_inference_steps": 50,
      "disable_safety_checker": true
    }
  }'

