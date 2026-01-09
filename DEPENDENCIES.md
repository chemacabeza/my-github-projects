# Dependencies Overview

This document outlines the dependencies and requirements for each section of the repository.

---

## 🎨 AI-Related

### Core Requirements

**Python Environment:**
- Python: `3.10+` (Recommended: `3.12+`)
- pip: Latest version
- Virtual environment support (venv)

**PyTorch:**
- PyTorch: `2.x` with GPU support
  - **CUDA**: For NVIDIA GPUs (Linux/Windows)
  - **MPS (Metal Performance Shaders)**: For Apple Silicon (M1/M2/M3/M4)
  - **CPU**: Fallback for systems without GPU

**Fooocus Framework:**
- Fooocus: Latest (cloned via git)
- Location: `AI-related/Fooocus/`

**AI Models (46GB total):**
- Checkpoint models: 7 SDXL models (~6.5GB each)
- LoRA models: 15 fine-tuning models (~200MB each)
- Automatically downloaded on first run
- Stored in: `AI-related/models/` and `AI-related/LoRAs/`

### System Requirements

**For Docker Deployment:**
- Docker: `20.10+`
- Docker Compose: `2.x`
- NVIDIA Docker runtime (for GPU support on Linux)

**For Local Deployment:**
- **Linux**:
  - Ubuntu 20.04+ or equivalent
  - CUDA Toolkit 11.8+ (for NVIDIA GPUs)
- **macOS**:
  - macOS 12.3 (Monterey) or later
  - Xcode Command Line Tools
  - Apple Silicon recommended for MPS support
- **Windows**:
  - Windows 10/11
  - CUDA Toolkit 11.8+ (for NVIDIA GPUs)

**Hardware:**
- **Minimum**: 16GB RAM, 50GB free disk space
- **Recommended**: 32GB+ RAM, NVIDIA GPU with 8GB+ VRAM (or Apple Silicon)
- **Optimal**: 64GB RAM, NVIDIA RTX 3090/4090 or Apple M1 Max/Ultra

### Python Dependencies

Key packages (installed via requirements.txt):
```
torch>=2.0.0
torchvision
gradio
pillow
opencv-python
numpy
scipy
einops
transformers
safetensors
accelerate
```

---

## ⚡ Bash

### Core Requirements

**Bash Shell:**
- Bash: `4.0+` (Recommended: `5.0+`)
- Most modern Linux distributions and macOS include suitable versions

**Standard Unix Utilities:**
Required command-line tools (typically pre-installed):
- `sed` - Stream editor
- `awk` - Text processing
- `grep` - Pattern matching
- `find` - File search
- `cut`, `sort`, `uniq`, `tr` - Text manipulation
- `cat`, `head`, `tail` - File viewing
- `ps`, `top`, `kill` - Process management

### System Requirements

**Operating Systems:**
- ✅ Linux (any modern distribution)
- ✅ macOS (10.x+)
- ✅ WSL (Windows Subsystem for Linux)
- ⚠️  Windows (Git Bash or Cygwin - limited compatibility)

**Disk Space:**
- Minimal: ~50MB for scripts and documentation

### Optional Tools

For enhanced functionality:
- `shellcheck` - Static analysis for shell scripts
- `bash-completion` - Programmable completion support
- `parallel` - Parallel command execution

---

## ☕ Java + Spring Boot

### Core Requirements

**Java Development Kit (JDK):**
- Java: `17+` (LTS version recommended)
- OpenJDK or Oracle JDK

**Build Tool:**
- Maven: `3.6+` (Recommended: `3.8+`)
- Included in projects via Maven Wrapper (`mvnw`)

**Database:**
- MySQL: `8.0+`
- PostgreSQL: `12+` (alternative)
- H2: Embedded (for testing/development)

### Framework Versions

**Spring Framework:**
- Spring Boot: `3.x`
- Spring Framework: `6.x`
- Spring Data JPA: `3.x`
- Spring Security: `6.x`

**ORM:**
- Hibernate: `6.x`
- JPA: `3.1`

### System Requirements

**Operating Systems:**
- ✅ Linux (any distribution)
- ✅ macOS (10.x+)
- ✅ Windows (10/11)

**Hardware:**
- **Minimum**: 4GB RAM, 2GB free disk space
- **Recommended**: 8GB+ RAM, 5GB free disk space

**IDE (Optional but Recommended):**
- IntelliJ IDEA (Community or Ultimate)
- Eclipse with Spring Tools
- VS Code with Java extensions

### Maven Dependencies

Key Spring Boot starters used across projects:
```xml
spring-boot-starter-web
spring-boot-starter-data-jpa
spring-boot-starter-security
spring-boot-starter-thymeleaf
spring-boot-starter-validation
spring-boot-starter-actuator
spring-boot-starter-aop
spring-boot-devtools (development)
mysql-connector-j
```

---

## 🛠️ Development Tools

### Recommended Across All Sections

**Version Control:**
- Git: `2.30+`
- Git LFS (for large files - planned)

**Text Editors/IDEs:**
- VS Code with extensions
- IntelliJ IDEA (for Java)
- PyCharm (for Python)
- Vim/Emacs (for Bash)

**Terminal:**
- Modern terminal emulator (iTerm2, Alacritty, Windows Terminal)
- Shell: Bash 5.0+ or Zsh

---

## 📦 Installation Quick Reference

### AI-Related
```bash
cd AI-related
make install-local  # Install dependencies
make run-local      # Run Fooocus locally
# OR
make run            # Run with Docker
```

### Bash
```bash
cd bash/chapters/
# Navigate to any chapter and run scripts
bash script-name.sh
```

### Java + Spring Boot
```bash
cd JavaSpringBoot/spring-boot-3-spring-6-hibernate-for-beginners-main
cd <project-directory>
./mvnw spring-boot:run
```

---

## 🔍 Verification Commands

Check if you have the required tools installed:

```bash
# Check versions
python --version      # Should be 3.10+
java --version        # Should be 17+
mvn --version         # Should be 3.6+
bash --version        # Should be 4.0+
docker --version      # For Docker deployments
git --version         # For version control

# Check GPU support (for AI)
nvidia-smi            # NVIDIA GPU info (Linux/Windows)
system_profiler SPDisplaysDataType | grep Metal  # macOS Metal support
```

---

## 📚 Additional Resources

### Official Documentation

- **Python**: https://docs.python.org/3/
- **PyTorch**: https://pytorch.org/docs/
- **Bash**: https://www.gnu.org/software/bash/manual/
- **Spring Boot**: https://spring.io/projects/spring-boot
- **Maven**: https://maven.apache.org/guides/

### Community Resources

- **Fooocus**: https://github.com/lllyasviel/Fooocus
- **Spring Guides**: https://spring.io/guides
- **Advanced Bash Scripting**: https://tldp.org/LDP/abs/html/

---

## ⚠️ Notes

- **AI Models**: The first run will download 46GB of models. Ensure you have sufficient disk space and bandwidth.
- **Docker**: GPU support in Docker requires additional setup (NVIDIA Docker runtime on Linux).
- **macOS**: MPS support is only available on macOS 12.3+ with Apple Silicon or AMD GPUs.
- **Java Memory**: Some Spring Boot projects may require increasing heap size: `export MAVEN_OPTS="-Xmx2g"`

---

**Last Updated**: 2026-01-09
