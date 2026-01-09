# Minimal Spring Boot REST API

A minimal Spring Boot 3 REST API example demonstrating core concepts.

## What's Included

- ✅ Spring Boot 3.2.1
- ✅ Spring Web (REST endpoints)
- ✅ Maven build configuration
- ✅ 4 REST endpoints (GET and POST)
- ✅ JSON request/response
- ✅ Path variables and request bodies
- ✅ Zero configuration database
- ✅ Ready to run in < 30 seconds

## Prerequisites

- **Java 17** or higher
- **Maven 3.6+** (or use included Maven Wrapper)

## Quick Start

### Option 1: Using Maven Wrapper (Recommended)

```bash
# Navigate to project directory
cd examples/java-minimal-api

# Run the application (downloads dependencies automatically)
./mvnw spring-boot:run
```

### Option 2: Using System Maven

```bash
cd examples/java-minimal-api
mvn spring-boot:run
```

The application starts on **http://localhost:8080**

## API Endpoints

### 1. Simple Hello
```bash
curl http://localhost:8080/api/hello
```

**Response:**
```json
{
  "message": "Hello from Spring Boot!",
  "timestamp": "2026-01-09T10:30:00",
  "version": "1.0.0"
}
```

### 2. Personalized Greeting
```bash
curl http://localhost:8080/api/hello/John
```

**Response:**
```json
{
  "message": "Hello, John!",
  "timestamp": "2026-01-09T10:30:00"
}
```

### 3. POST with Request Body
```bash
curl -X POST http://localhost:8080/api/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "John", "message": "Hi there"}'
```

**Response:**
```json
{
  "received": {
    "name": "John",
    "message": "Hi there"
  },
  "echo": "Received: Hi there",
  "timestamp": "2026-01-09T10:30:00"
}
```

### 4. Application Status
```bash
curl http://localhost:8080/api/status
```

**Response:**
```json
{
  "status": "UP",
  "application": "Minimal Spring Boot API",
  "timestamp": "2026-01-09T10:30:00",
  "javaVersion": "17.0.9",
  "springBootVersion": "3.2.1"
}
```

## Project Structure

```
java-minimal-api/
├── pom.xml                                    # Maven configuration
├── src/
│   └── main/
│       ├── java/com/example/demo/
│       │   ├── MinimalApiApplication.java    # Main application class
│       │   └── HelloController.java          # REST controller
│       └── resources/
│           └── application.properties         # Configuration
└── README.md
```

## Key Concepts Demonstrated

### 1. Spring Boot Application
```java
@SpringBootApplication
public class MinimalApiApplication {
    public static void main(String[] args) {
        SpringApplication.run(MinimalApiApplication.java, args);
    }
}
```

### 2. REST Controller
```java
@RestController              // Combines @Controller + @ResponseBody
@RequestMapping("/api")      // Base path for all endpoints
public class HelloController {
    // Endpoint methods
}
```

### 3. GET Mapping
```java
@GetMapping("/hello")
public Map<String, Object> hello() {
    // Returns JSON automatically
}
```

### 4. Path Variables
```java
@GetMapping("/hello/{name}")
public Map<String, Object> helloName(@PathVariable String name) {
    // Extract 'name' from URL path
}
```

### 5. POST with Request Body
```java
@PostMapping("/hello")
public Map<String, Object> helloPost(@RequestBody Map<String, String> request) {
    // Deserialize JSON body automatically
}
```

## Building & Running

### Build JAR
```bash
./mvnw clean package
```

Produces: `target/minimal-api-1.0.0.jar`

### Run JAR
```bash
java -jar target/minimal-api-1.0.0.jar
```

### Build without Tests
```bash
./mvnw clean package -DskipTests
```

## Configuration

Edit `src/main/resources/application.properties`:

```properties
# Change server port
server.port=9090

# Change log level
logging.level.com.example.demo=TRACE
```

## Testing with curl

### Test all endpoints
```bash
# Hello endpoint
curl http://localhost:8080/api/hello

# Personalized greeting
curl http://localhost:8080/api/hello/Alice

# POST request
curl -X POST http://localhost:8080/api/hello \
  -H "Content-Type: application/json" \
  -d '{"name":"Bob","message":"Testing"}'

# Status endpoint
curl http://localhost:8080/api/status
```

### Test with HTTPie (prettier)
```bash
# Install: pip install httpie

http GET :8080/api/hello
http GET :8080/api/hello/Alice
http POST :8080/api/hello name=Bob message=Testing
http GET :8080/api/status
```

## Next Steps

### Add More Features

**1. Add Request Parameters:**
```java
@GetMapping("/search")
public String search(@RequestParam String query) {
    return "Searching for: " + query;
}
// Usage: /api/search?query=spring
```

**2. Add a Service Layer:**
```java
@Service
public class GreetingService {
    public String greet(String name) {
        return "Hello, " + name + "!";
    }
}
```

**3. Add Exception Handling:**
```java
@ExceptionHandler(Exception.class)
public ResponseEntity<String> handleException(Exception e) {
    return ResponseEntity.status(500).body("Error: " + e.getMessage());
}
```

**4. Add Database (JPA):**
- Add `spring-boot-starter-data-jpa` dependency
- Add H2 or MySQL dependency
- Create entity classes
- Create repository interfaces

## Troubleshooting

### Port Already in Use
```bash
# Change port in application.properties
server.port=9090

# Or set via command line
./mvnw spring-boot:run -Dspring-boot.run.arguments=--server.port=9090
```

### Java Version Error
```bash
# Check Java version
java -version

# Should be 17 or higher
# Install Java 17: https://adoptium.net/
```

### Maven Build Fails
```bash
# Clean and rebuild
./mvnw clean install

# Use system Maven if wrapper has issues
mvn clean install
```

## Related Resources

From this repository:
- [JavaSpringBoot/](../../JavaSpringBoot/) - Full Spring Boot examples
- [Section 4: REST CRUD APIs](../../JavaSpringBoot/docs/Section-4.md)
- [Section 6: Spring MVC](../../JavaSpringBoot/docs/Section-6.md)

External resources:
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Guides](https://spring.io/guides)
- [Baeldung Spring Tutorials](https://www.baeldung.com/spring-tutorial)

## Extending This Example

This minimal example is perfect for:
- ✅ Learning Spring Boot basics
- ✅ Testing REST endpoint concepts
- ✅ Starting a new microservice
- ✅ API prototyping

For production applications, add:
- 🔐 Spring Security (authentication/authorization)
- 💾 Database integration (JPA/Hibernate)
- ✅ Validation (@Valid, @NotNull, etc.)
- 📝 API documentation (Swagger/OpenAPI)
- 🧪 Unit and integration tests
- 🔍 Logging and monitoring
- 🐳 Docker containerization

---

*Start simple, then grow your application as needed!*
