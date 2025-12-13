.PHONY: build up run down install-local run-local

IMAGE_NAME = fooocus-local
CONTAINER_NAME = fooocus-container
VENV_DIR = venv
FOOOCUS_DIR = Fooocus

# Detect operating system
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    OS = macos
    SED_INPLACE = sed -i ''
    TORCH_INSTALL = pip install torch torchvision
    PLATFORM_MSG = "macOS detected - installing PyTorch with MPS (Metal Performance Shaders) support"
else
    OS = linux
    SED_INPLACE = sed -i
    TORCH_INSTALL = pip install "torch==2.4.0" "torchvision==0.19.0"
    PLATFORM_MSG = "Linux detected - installing PyTorch with CUDA support"
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
	@echo "Cloning Fooocus..."
	[ -d $(FOOOCUS_DIR)/.git ] || git clone https://github.com/lllyasviel/Fooocus.git $(FOOOCUS_DIR)
	@echo "Creating virtual environment..."
	[ -d $(VENV_DIR) ] || python3 -m venv $(VENV_DIR)
	@echo "Installing dependencies..."
	. $(VENV_DIR)/bin/activate && \
	pip install --upgrade pip && \
	pip install packaging setuptools wheel "pygit2==1.15.1" && \
	$(TORCH_INSTALL) && \
	$(SED_INPLACE) 's/scipy==1.14.0/scipy>=1.10.0/' $(FOOOCUS_DIR)/requirements_versions.txt && \
	pip install -r $(FOOOCUS_DIR)/requirements_versions.txt

run-local:
	@echo "Starting Fooocus locally..."
	. $(VENV_DIR)/bin/activate && \
	./run_local.sh python entry_with_update.py --listen --port 7860 --always-high-vram
