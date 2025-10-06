FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git curl python3 python3-venv python3-pip python3-dev build-essential \
    libffi-dev libssl-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Clone Fooocus (optionally pin a known-good commit to avoid breaking changes)
RUN git clone https://github.com/lllyasviel/Fooocus.git
WORKDIR /opt/Fooocus
# Example to pin (uncomment and replace with a commit you trust):
# RUN git checkout <commit-sha>

# Python venv
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Preinstall essentials so runtime setup is smoother
RUN pip install --upgrade pip \
 && pip install packaging setuptools wheel "pygit2==1.15.1" \
 && pip install --index-url https://download.pytorch.org/whl/cu121 \
        "torch==2.1.0+cu121" "torchvision==0.16.0+cu121"

# Entrypoint (downloads your models/LoRAs to the mounted host dirs if missing)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Optional: symlink Fooocus’ default paths to your mounted host folders
# (this keeps Fooocus happy if it expects models/checkpoints and models/loras)
RUN mkdir -p /opt/Fooocus/models \
 && ln -s /models /opt/Fooocus/models/checkpoints \
 && ln -s /LoRAs  /opt/Fooocus/models/loras

ENV HF_HOME=/cache/huggingface
EXPOSE 7860

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python", "entry_with_update.py", "--listen", "--always-high-vram"]
