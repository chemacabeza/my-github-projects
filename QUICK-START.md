# Quick Start Guide

> Get any project running in under 5 minutes

---

## 🎯 Try It Now

### AI Image Generation (60 seconds)

**Using Docker** (recommended):
```bash
cd AI-related
make run
```

**Using Local Installation**:
```bash
cd AI-related
make install-local
make run-local
```

**Access:** http://localhost:7860

**What you'll see:** Fooocus web UI for AI image generation

**Try it:** Enter a prompt like:
- "a professional headshot, business attire, studio lighting, high quality"
- "a serene landscape with mountains and lake, sunset, photorealistic"
- "anime character, colorful hair, detailed eyes, by studio ghibli"

**Tips:**
- Choose different models from the dropdown for various styles
- Use LoRAs for character-specific or style variations
- Adjust quality settings for faster/better generation

---

### Bash Learning Path (30 seconds)

```bash
cd bash/chapters/01-Introduction/04-Basics
./examples.sh
```

**What you'll see:** Interactive Bash examples demonstrating fundamentals

**Next steps:**
```bash
# Explore variables
cd bash/chapters/02-Variables-And-Types/05-variables
./examples.sh

# Learn control flow
cd bash/chapters/03-Control-Flow/11-if-statement
./examples.sh

# Try process management
cd bash/chapters/06-Process-Management/25-processes
./examples.sh
```

**Browse all chapters:**
```bash
ls bash/chapters/
# Navigate through 35 chapters organized in 7 parts
```

---

### Java REST API (2 minutes)

**Simplest Example - Hello World**:
```bash
cd JavaSpringBoot/spring-boot-3-spring-6-hibernate-for-beginners-main/04-spring-boot-rest-crud/01-spring-boot-rest-crud-hello-world
./mvnw spring-boot:run
```

**Access:** http://localhost:8080/hello

**Test with curl:**
```bash
curl http://localhost:8080/hello
# Output: "Hello World!"
```

**Press Ctrl+C to stop**

---

### Java REST CRUD with Database (5 minutes)

**Full CRUD Example**:
```bash
cd JavaSpringBoot/spring-boot-3-spring-6-hibernate-for-beginners-main/04-spring-boot-rest-crud/07-spring-boot-rest-crud-employee-list-employees
```

**Run without database** (uses in-memory H2):
```bash
./mvnw spring-boot:run
```

**Test the endpoints:**
```bash
# Get all employees
curl http://localhost:8080/api/employees

# Get employee by ID
curl http://localhost:8080/api/employees/1

# Create new employee
curl -X POST http://localhost:8080/api/employees \
  -H "Content-Type: application/json" \
  -d '{"firstName":"John","lastName":"Doe","email":"john@example.com"}'

# Update employee
curl -X PUT http://localhost:8080/api/employees \
  -H "Content-Type: application/json" \
  -d '{"id":1,"firstName":"Jane","lastName":"Doe","email":"jane@example.com"}'

# Delete employee
curl -X DELETE http://localhost:8080/api/employees/1
```

**What you'll see:** Complete REST CRUD API with:
- Layered architecture (Controller → Service → Repository)
- Spring Data JPA
- Exception handling
- Proper HTTP status codes

---

## Prerequisites by Section

| Section | Requirements | Installation | Verification |
|---------|-------------|--------------|--------------|
| **AI** | Python 3.12+, 8GB RAM, Docker (optional) | See [AI Dependencies](AI-related/README.md#installation) | `python --version` |
| **Bash** | Bash 4.0+ (5.0+ recommended) | Pre-installed on macOS/Linux | `bash --version` |
| **Java** | Java 17+, Maven 3.6+ | See [Java Dependencies](DEPENDENCIES.md#java--spring-boot) | `java --version` |

### Detailed Prerequisites

**For AI Projects:**
- Python 3.12 or higher
- 8GB+ RAM (16GB recommended)
- GPU optional but recommended:
  - macOS: Apple Silicon (M1/M2) with MPS support
  - Linux: NVIDIA GPU with CUDA
  - Windows: NVIDIA GPU or CPU fallback
- Docker (optional, for containerized deployment)

**For Bash Projects:**
- Bash 4.0+ (included in macOS/Linux)
- Standard Unix utilities (sed, awk, grep)
- Text editor for viewing examples

**For Java Projects:**
- Java JDK 17 or higher
- Maven 3.6+ (or use included Maven Wrapper `./mvnw`)
- MySQL 8+ (optional, H2 in-memory database included for quick tests)
- IDE recommended: IntelliJ IDEA, VS Code with Java extensions

**Full prerequisites and installation guides:** [DEPENDENCIES.md](DEPENDENCIES.md)

---

## Recommended Starting Points

### For Recruiters 🔍
Want to quickly assess capabilities?

1. **Start here**: [Skills Matrix](SKILLS-MATRIX.md) - 2-minute skills overview
2. **Then read**: [Project Highlights](PROJECT-HIGHLIGHTS.md) - Impact statements
3. **Explore code**: Pick a quick-start above and run it locally
4. **Quality check**: [Testing Practices](TESTING.md) - Quality approach

**Total time**: 10-15 minutes to fully evaluate this portfolio

---

### For Backend Engineers ☕
Interested in Spring Boot expertise?

1. **Quick demo**: Run the Java REST API examples above (2 minutes)
2. **Browse projects**: [Java Project Catalog](JavaSpringBoot/PROJECT-CATALOG.md) - 70+ projects
3. **Deep dive**: [Architecture Overview](JavaSpringBoot/docs/architecture-overview.md) - Patterns and design
4. **Learn more**: [REST CRUD Quick Start](JavaSpringBoot/docs/quickstart-rest-crud.md) - Detailed guide

**Highlights:**
- Layered architecture (Controller → Service → Repository)
- Spring Security implementations
- Advanced JPA mappings
- AOP for cross-cutting concerns

---

### For AI/ML Enthusiasts 🎨
Curious about generative AI deployment?

1. **Run Fooocus**: Use the Docker command above (1 minute to start)
2. **Explore models**: [AI Documentation](AI-related/README.md) - 7 checkpoints + 26 LoRAs
3. **Try generation**: Create images with different models and styles
4. **Learn setup**: [Installation guide](AI-related/README.md#installation) - Local and Docker

**Highlights:**
- Production deployment with Docker
- Multi-platform GPU optimization (MPS, CUDA)
- 46GB model library management
- Symbolic link architecture

---

### For DevOps/SRE ⚡
Need automation and scripting skills?

1. **Try examples**: Run Bash examples above (30 seconds)
2. **Browse chapters**: [Bash Guide](bash/README.md) - 35-chapter curriculum
3. **Learn patterns**: Start with [Introduction](bash/chapters/01-Introduction/)
4. **Advanced topics**: [Process Management](bash/chapters/06-Process-Management/)

**Highlights:**
- 236 production-ready scripts
- Error handling patterns (`set -euo pipefail`)
- Process management and coprocesses
- Advanced I/O and text processing

---

### For Hiring Managers 💼
Evaluating for engineering leadership?

1. **Background**: [About Me](ABOUT-ME.md) - Career journey and experience
2. **Skills**: [Skills Matrix](SKILLS-MATRIX.md) - Technical expertise
3. **Projects**: [Project Highlights](PROJECT-HIGHLIGHTS.md) - Impact and achievements
4. **Growth**: [Learning Roadmap](ROADMAP.md) - Continuous learning mindset
5. **Quality**: [Testing Practices](TESTING.md) - Quality-first approach

**Key indicators:**
- 15+ years experience (Klarna, Amadeus, NCR)
- Engineering Manager at Klarna (2020-present)
- Hands-on technical depth + leadership
- Continuous learning (1000+ hours in 2024-2025)

---

## Troubleshooting

### AI Issues

**Problem:** GPU not detected on macOS
```bash
# Check Python version (need 3.12+ for MPS support)
python --version

# If older, install Python 3.12+
brew install python@3.12
```

**Problem:** Out of memory error
```bash
# Use CPU mode (slower but works on any machine)
cd AI-related
make run-local-cpu
```

**Problem:** Model download fails
```bash
# Check internet connection
# Models are large (1-8GB each)
# Download may take 10-30 minutes depending on speed
```

---

### Java Issues

**Problem:** Port 8080 already in use
```bash
# Option 1: Stop the process using port 8080
lsof -ti:8080 | xargs kill

# Option 2: Change port in application.properties
echo "server.port=8081" >> src/main/resources/application.properties
```

**Problem:** Java version mismatch
```bash
# Check Java version
java --version

# Should be Java 17+
# Install if needed:
# macOS: brew install openjdk@17
# Linux: sudo apt install openjdk-17-jdk
```

**Problem:** Maven build fails
```bash
# Use Maven Wrapper (included in projects)
./mvnw clean package

# Or install Maven:
# macOS: brew install maven
# Linux: sudo apt install maven
```

**Problem:** Database connection error
```bash
# Most examples work with H2 in-memory database (no setup needed)
# For MySQL projects, ensure MySQL is running:
# macOS: brew services start mysql
# Linux: sudo systemctl start mysql
```

---

### Bash Issues

**Problem:** Permission denied
```bash
# Make script executable
chmod +x script.sh
./script.sh
```

**Problem:** Command not found
```bash
# Ensure Bash 4.0+
bash --version

# macOS may have older Bash 3.x by default
# Install newer Bash:
brew install bash
```

**Problem:** Script fails immediately
```bash
# Run with error reporting to see details
bash -x script.sh

# Or check syntax without running
bash -n script.sh
```

---

## Next Steps

### After Quick Start

**If you ran AI:**
- Explore different models in [AI README](AI-related/README.md#model-library)
- Try character LoRAs for personalized images
- Read about [model pipeline architecture](AI-related/README.md)

**If you ran Java:**
- Browse [Java Project Catalog](JavaSpringBoot/PROJECT-CATALOG.md) for more examples
- Follow [Quick Start Guides](JavaSpringBoot/docs/) for detailed tutorials
- Study [Architecture Patterns](JavaSpringBoot/docs/architecture-overview.md)

**If you ran Bash:**
- Follow the 35-chapter progression in [bash/chapters/](bash/chapters/)
- Start with [Variables](bash/chapters/02-Variables-And-Types/)
- Progress to [Advanced Topics](bash/chapters/07-Advanced/)

---

## Getting Help

### Documentation
- **Main README**: [README.md](README.md) - Repository overview
- **Dependencies**: [DEPENDENCIES.md](DEPENDENCIES.md) - Complete setup guide
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute

### Contact
- **GitHub Issues**: [Open an issue](https://github.com/chemacabeza/my-github-projects/issues) for bugs or questions
- **LinkedIn**: [Add your LinkedIn URL] - Professional inquiries
- **Email**: Via GitHub Issues or LinkedIn

---

## Quick Reference

### Common Commands

**AI:**
```bash
cd AI-related && make run              # Start with Docker
cd AI-related && make run-local        # Start locally
cd AI-related && make stop             # Stop Docker
```

**Java:**
```bash
./mvnw spring-boot:run                 # Run Spring Boot app
./mvnw test                            # Run tests
./mvnw clean package                   # Build JAR
```

**Bash:**
```bash
cd bash/chapters/[section]/[chapter]   # Navigate to chapter
./examples.sh                          # Run examples
bash -x script.sh                      # Debug script
```

### Project Structure
```
my-github-projects/
├── AI-related/          # Generative AI, Fooocus, models (46GB)
├── bash/                # 35-chapter Bash guide (236 scripts)
├── JavaSpringBoot/      # 70+ Spring Boot projects (10 sections)
├── examples/            # Template starter projects
├── Golang/              # Future Go projects (planned)
├── docs/                # Comprehensive documentation
└── images/              # Visual assets and banners
```

---

**Last Updated:** 2026-02-06

**Happy exploring!** 🚀
