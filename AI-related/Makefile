.PHONY: build up run down install-local run-local

IMAGE_NAME = fooocus-local
CONTAINER_NAME = fooocus-container
VENV_DIR = venv
FOOOCUS_DIR = Fooocus

# Detect Python 3 version (prefer 3.13, then 3.12, then 3.11, then 3.10, then generic python3)
PYTHON := $(shell command -v python3.13 2>/dev/null || command -v python3.12 2>/dev/null || command -v python3.11 2>/dev/null || command -v python3.10 2>/dev/null || command -v python3 2>/dev/null)

# Detect operating system
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    OS = macos
    SED_INPLACE = sed -i ''
    TORCH_INSTALL = pip install torch torchvision
    PLATFORM_MSG = "macOS detected - installing PyTorch with MPS (Metal Performance Shaders) support"
    # macOS runtime flags: disable offloading for better MPS performance
    RUNTIME_FLAGS = --disable-offload-from-vram --always-high-vram
    # macOS system dependencies (Homebrew)
    INSTALL_LIBGIT2 = brew install libgit2 || true
    # Detect Homebrew prefix (Apple Silicon: /opt/homebrew, Intel: /usr/local)
    HOMEBREW_PREFIX := $(shell brew --prefix 2>/dev/null || echo "/opt/homebrew")
    # Set environment for pygit2 to find libgit2 headers and libraries
    PYGIT2_ENV = LIBGIT2=$(HOMEBREW_PREFIX) C_INCLUDE_PATH=$(HOMEBREW_PREFIX)/include LIBRARY_PATH=$(HOMEBREW_PREFIX)/lib
else
    OS = linux
    SED_INPLACE = sed -i
    TORCH_INSTALL = pip install "torch==2.4.0" "torchvision==0.19.0"
    PLATFORM_MSG = "Linux detected - installing PyTorch with CUDA support"
    # Linux runtime flags: high VRAM mode for CUDA
    RUNTIME_FLAGS = --always-high-vram
    # Linux system dependencies (apt)
    INSTALL_LIBGIT2 = sudo apt-get update && sudo apt-get install -y libgit2-dev || true
    # No special env needed for Linux (system paths are used)
    PYGIT2_ENV =
endif

# Docker targets
build:
	docker build -t $(IMAGE_NAME) .

up:
	docker run -d --rm \
		--name $(CONTAINER_NAME) \
		--gpus all \
		-p 7860:7860 \
		-v $(PWD)/models:/opt/Fooocus/models/checkpoints \
		-v $(PWD)/LoRAs:/opt/Fooocus/models/loras \
		-v $(PWD)/outputs:/opt/Fooocus/outputs \
		-v $(PWD)/cache/huggingface:/cache/huggingface \
		-e HF_HOME=/cache/huggingface \
		-e NVIDIA_VISIBLE_DEVICES=all \
		-e GRADIO_SERVER_NAME=0.0.0.0 \
		-e GRADIO_SERVER_PORT=7860 \
		$(IMAGE_NAME) \
		python entry_with_update.py \
		--listen --port 7860 \
		--always-high-vram \
		--debug-mode \
		--external-working-path /opt/Fooocus/models/checkpoints /opt/Fooocus/models/loras \
		--rebuild-hash-cache 8

run: build up

down:
	docker stop $(CONTAINER_NAME) || true

# Local targets
install-local:
	@echo $(PLATFORM_MSG)
	@echo "Using Python: $(PYTHON)"
	@echo "Installing system dependencies (libgit2)..."
	$(INSTALL_LIBGIT2)
	@echo "Cloning Fooocus..."
	[ -d $(FOOOCUS_DIR)/.git ] || git clone https://github.com/lllyasviel/Fooocus.git $(FOOOCUS_DIR)
	@echo "Creating virtual environment..."
	[ -d $(VENV_DIR) ] || $(PYTHON) -m venv $(VENV_DIR)
	@echo "Installing dependencies..."
	. $(VENV_DIR)/bin/activate && \
	pip install --upgrade pip && \
	pip install packaging setuptools wheel && \
	$(PYGIT2_ENV) pip install "pygit2>=1.16.0" && \
	$(TORCH_INSTALL) && \
	$(SED_INPLACE) 's/scipy==1.14.0/scipy>=1.10.0/' $(FOOOCUS_DIR)/requirements_versions.txt && \
	$(SED_INPLACE) 's/pygit2==1.15.1/pygit2>=1.16.0/' $(FOOOCUS_DIR)/requirements_versions.txt && \
	$(SED_INPLACE) 's/onnxruntime==1.18.1/onnxruntime>=1.20.0/' $(FOOOCUS_DIR)/requirements_versions.txt && \
	$(SED_INPLACE) 's/rembg==2.0.57/rembg>=2.0.62/' $(FOOOCUS_DIR)/requirements_versions.txt && \
	$(SED_INPLACE) 's/numpy==1.26.4/numpy>=1.26.0/' $(FOOOCUS_DIR)/requirements_versions.txt && \
	$(SED_INPLACE) 's/tokenizers==0.19.1/tokenizers>=0.20.0/' $(FOOOCUS_DIR)/requirements_versions.txt && \
	$(SED_INPLACE) 's/safetensors==0.4.3/safetensors>=0.5.0/' $(FOOOCUS_DIR)/requirements_versions.txt && \
	$(SED_INPLACE) 's/transformers==4.42.4/transformers>=4.45.0/' $(FOOOCUS_DIR)/requirements_versions.txt && \
	pip install -r $(FOOOCUS_DIR)/requirements_versions.txt && \
	pip install audioop-lts

run-local:
	@if [ ! -d $(VENV_DIR) ]; then \
		echo "Virtual environment not found. Running install-local first..."; \
		$(MAKE) install-local; \
	fi
	@echo "Starting Fooocus locally..."
	. $(VENV_DIR)/bin/activate && \
	./run_local.sh python entry_with_update.py --listen --port 7860 $(RUNTIME_FLAGS)

