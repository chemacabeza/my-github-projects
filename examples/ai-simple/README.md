# Simple AI Image Generation Example

Minimal example demonstrating AI image generation using the Fooocus framework.

## Prerequisites

1. **Fooocus installed**: Follow instructions in [AI-related/README.md](../../AI-related/README.md)
2. **Python 3.10+**
3. **Models downloaded**: Checkpoint and LoRA models (happens automatically on first run)

## Quick Start

### Option 1: Use Fooocus Directly

The simplest way to generate images is through the Fooocus web UI:

```bash
cd ../../AI-related
make run-local
# Visit http://localhost:7860 in your browser
```

### Option 2: Command Line Generation (Advanced)

For programmatic generation, you can use Fooocus in headless mode:

```bash
cd ../../AI-related

# Activate Python environment
source venv/bin/activate

# Navigate to Fooocus directory
cd Fooocus

# Generate image via command line
python entry_with_update.py \
    --prompt "A serene mountain landscape at sunset, photorealistic" \
    --preset realistic \
    --output-path ../outputs/my_image.png
```

## Example Prompts

### Realistic Photography
```
A professional portrait of a woman in business attire,
studio lighting, sharp focus, 50mm lens, photorealistic
```

### Anime Style
```
anime style, a young adventurer with blue hair,
fantasy setting, vibrant colors, detailed character design
```

### Artistic Styles
```
oil painting of a medieval castle,
sunset lighting, impressionist style, warm colors
```

## Using LoRA Models

To use character LoRAs (like helga, anastasia, hana):

1. Open Fooocus UI at http://localhost:7860
2. Click on "Advanced" options
3. Select "LoRA" tab
4. Choose a LoRA model (e.g., `helga_lora`)
5. Set weight (typically 0.7-1.0)
6. Include trigger word in prompt (e.g., "helga, portrait photo...")

## Model Selection

Different checkpoint models for different styles:

| Model | Best For | Example Use |
|-------|----------|-------------|
| `juggernautXL_v8Rundiffusion` | General purpose, realistic | Portraits, products |
| `animaPencilXL_v500` | Anime/illustration | Character art, manga |
| `realisticStockPhoto_v20` | Stock photography | Commercial images |
| `SDXLRonghua_v45` | Chinese style | Traditional Chinese art |

## Output Location

Generated images are saved to:
```
AI-related/outputs/
```

## Tips for Better Results

### 1. Use Descriptive Prompts
```
❌ Bad: "a person"
✅ Good: "professional portrait of a 30-year-old woman with brown hair,
         wearing business attire, soft studio lighting, shallow depth of field"
```

### 2. Specify Quality
Add quality keywords:
- `photorealistic`, `highly detailed`
- `8k resolution`, `sharp focus`
- `professional photography`

### 3. Negative Prompts
Specify what to avoid:
- `blurry, low quality, distorted`
- `bad anatomy, extra fingers`
- `cartoon, sketch` (for realistic images)

### 4. Aspect Ratios
- Portrait: 3:4 (768x1024)
- Landscape: 4:3 (1024x768)
- Square: 1:1 (1024x1024)
- Widescreen: 16:9 (1365x768)

## Performance Notes

**First Generation**: Slower (loading models into memory)
**Subsequent Generations**: Faster (models cached)

**Generation Time Estimates:**
- **NVIDIA RTX 3090**: 5-10 seconds per image
- **Apple M1 Max**: 15-25 seconds per image
- **CPU only**: 2-5 minutes per image

## Troubleshooting

### Issue: Models not found
**Solution**: Run `make run-local` first to download models automatically

### Issue: Out of memory error
**Solution**:
- Reduce image resolution
- Close other applications
- Use `--lowvram` flag

### Issue: Slow generation on macOS
**Solution**: Ensure MPS is enabled:
```bash
python -c "import torch; print('MPS available:', torch.backends.mps.is_available())"
```

## Advanced Usage

For production use cases, see:
- [Fooocus Documentation](https://github.com/lllyasviel/Fooocus)
- [AI-related/README.md](../../AI-related/README.md) - Full setup guide
- [AI-related/courses/](../../AI-related/courses/) - Comprehensive courses

## Example Workflow

1. **Start Fooocus**:
   ```bash
   cd AI-related && make run-local
   ```

2. **Open browser**: http://localhost:7860

3. **Select model**: Choose from dropdown (e.g., juggernautXL)

4. **Write prompt**:
   ```
   portrait of a woman, professional photography,
   studio lighting, bokeh background, 50mm lens
   ```

5. **Set parameters**:
   - Steps: 30 (quality vs speed tradeoff)
   - Guidance: 7.0 (prompt adherence)
   - Resolution: 1024x1024

6. **Generate**: Click "Generate" button

7. **Refine**: Adjust prompt and regenerate until satisfied

---

*Start simple, experiment, and gradually explore advanced features!*
