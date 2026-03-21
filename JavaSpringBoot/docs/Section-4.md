# Section 4: REST CRUD APIs & Spring Data REST

This guide is a complete, copy-pasteable tutorial covering the creation of REST APIs in Spring Boot. It starts with manual controller creation, explores global exception handling, introduces the Service layer, and finally demonstrates how to replace it all with zero-code **Spring Data REST**.

By following this guide, you will build a runnable application with a PostgreSQL database, entirely containerized via Docker.

## 1. Project Setup (Maven `pom.xml`)

Initialize a standard Spring Boot project. To follow the first half of this guide (manual controllers), you need `spring-boot-starter-web` and `spring-boot-starter-data-jpa`. To follow the second half (Spring Data REST), you add `spring-boot-starter-data-rest`.

```xml
    <dependencies>
        <!-- Standard REST Controllers -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- Spring Data JPA -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <!-- Spring Data REST (for the MAGIC zero-code APIs) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-rest</artifactId>
        </dependency>

        <!-- PostgreSQL driver -->
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>
    </dependencies>
```

---

## 2. Docker & Environment Setup (Mac & Ubuntu)

To ensure this project runs identically on macOS and Ubuntu Linux, place these files in your project root.

### `docker-compose.yml`

Spins up a local PostgreSQL database gracefully.

```yaml
version: '3.8'

services:
  db:
      image: postgres:15-alpine
      container_name: employee_db
      environment:
        POSTGRES_USER: springuser
        POSTGRES_PASSWORD: springuser
        POSTGRES_DB: employee_directory
      ports:
        - "5432:5432"
      volumes:
        - pg_data:/var/lib/postgresql/data

  app:
    build: .
    container_name: employee_app
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/employee_directory

volumes:
  pg_data:
```

### `Dockerfile`

Compiles the application and packages it.

```dockerfile
# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the final lightweight image
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

> **Run it:** Execute `docker compose up --build` in your terminal.

---

## 3. Configuration (`application.properties`)

Create this in `src/main/resources/application.properties`. It configures the DB and tweaks Spring Data REST behavior.

```properties
# Database Connection
spring.datasource.url=${SPRING_DATASOURCE_URL:jdbc:postgresql://localhost:5432/employee_directory}
spring.datasource.username=springuser
spring.datasource.password=springuser
spring.jpa.hibernate.ddl-auto=update

# Spring Data REST Configuration
# Change the base endpoint path (default is /)
spring.data.rest.base-path=/api
# Number of elements returned per page (default is 20)
spring.data.rest.default-page-size=5
# Max elements per page allowed
spring.data.rest.max-page-size=100
```

---

## 4. Part 1: Manual REST APIs and Exception Handling

Before using the "Magic" Spring Data REST, you should understand how to build controllers, services, and handle exceptions manually.

### The Entity: `com.luv2code.springboot.demo.entity.Student.java`

```java
package com.luv2code.springboot.demo.entity;

import jakarta.persistence.*;

@Entity
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String firstName;
    private String lastName;

    public Student() {}
    public Student(String firstName, String lastName) { 
        this.firstName = firstName; 
        this.lastName = lastName; 
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
}
```

### Custom Exceptions & Error Responses

When an API fails (e.g., student not found), you should return a clean JSON error response, not a giant Java stack trace.

**1. The Error Payload Class:** `StudentErrorResponse.java`
```java
package com.luv2code.springboot.demo.exception;

public class StudentErrorResponse {
    private int status;
    private String message;
    private long timeStamp;

    public StudentErrorResponse() {}

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public long getTimeStamp() { return timeStamp; }
    public void setTimeStamp(long timeStamp) { this.timeStamp = timeStamp; }
}
```

**2. The Custom Exception:** `StudentNotFoundException.java`
```java
package com.luv2code.springboot.demo.exception;

public class StudentNotFoundException extends RuntimeException {
    public StudentNotFoundException(String message) {
        super(message);
    }
}
```

**3. Global Exception Handler (`@ControllerAdvice`):** `StudentRestExceptionHandler.java`
This intercepts exceptions thrown by *any* controller in your application.

```java
package com.luv2code.springboot.demo.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class StudentRestExceptionHandler {

    // Catch specific StudentNotFoundException
    @ExceptionHandler
    public ResponseEntity<StudentErrorResponse> handleException(StudentNotFoundException exc) {
        StudentErrorResponse error = new StudentErrorResponse();
        error.setStatus(HttpStatus.NOT_FOUND.value());
        error.setMessage(exc.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }

    // Catch ALL other unexpected exceptions (e.g. user sends text instead of int for ID)
    @ExceptionHandler
    public ResponseEntity<StudentErrorResponse> handleException(Exception exc) {
        StudentErrorResponse error = new StudentErrorResponse();
        error.setStatus(HttpStatus.BAD_REQUEST.value());
        error.setMessage("Malformed request or unexpected error: " + exc.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }
}
```

### The Manual REST Controller: `StudentRestController.java`

```java
package com.luv2code.springboot.demo.rest;

import com.luv2code.springboot.demo.entity.Student;
import com.luv2code.springboot.demo.exception.StudentNotFoundException;
import jakarta.annotation.PostConstruct;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
public class StudentRestController {

    private List<Student> theStudents;

    @PostConstruct
    public void loadData() {
        // Mock DB for demo
        theStudents = new ArrayList<>();
        theStudents.add(new Student("Poornima", "Patel")); // Index 0
        theStudents.add(new Student("Mario", "Rossi"));    // Index 1
        theStudents.add(new Student("Mary", "Smith"));     // Index 2
    }

    // e.g. /api/students/1
    @GetMapping("/students/{studentId}")
    public Student getStudent(@PathVariable int studentId) {
        
        // Let's trigger our custom exception if out of bounds
        if ((studentId >= theStudents.size()) || (studentId < 0)) {
            throw new StudentNotFoundException("Student id not found - " + studentId);
        }

        return theStudents.get(studentId);
    }
}
```

---

## 5. Part 2: The Magic of Spring Data REST

Writing DaoImpls, Services, and Controllers for every entity is tedious. **Spring Data REST** completely eliminates boilerplate. By extending `JpaRepository` and including the starter dependency, Spring generates a full HATEOAS-compliant REST API automatically.

### The Entity: `com.luv2code.springboot.demo.entity.Employee.java`
```java
package com.luv2code.springboot.demo.entity;

import jakarta.persistence.*;

@Entity
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String firstName;
    private String lastName;
    private String email;

    public Employee() {}

    // Getters and Setters...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
```

### The Repository (THAT'S IT. NO CONTROLLER. NO SERVICE.)
```java
package com.luv2code.springboot.demo.dao;

import com.luv2code.springboot.demo.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

// @RepositoryRestResource is optional. It overrides the default pluralization (employees).
@RepositoryRestResource(path="members")
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {
    
    // Spring Data REST instantly provides:
    // GET /api/members (List all, paginated and sorted)
    // GET /api/members/{id} (Get one)
    // POST /api/members (Create one)
    // PUT /api/members/{id} (Update one)
    // DELETE /api/members/{id} (Delete one)

    // And you can add custom queries that automatically become REST endpoints like:
    // GET /api/members/search/findByLastName?lastName=Smith
    // List<Employee> findByLastName(String lastName);
}
```

### Testing the HATEOAS Response

When you create an employee via POST `/api/members`, and then curl `/api/members`, Spring Data REST gives you a **HATEOAS** (Hypertext Application Language) JSON response containing navigation links.

```json
{
  "_embedded": {
    "members": [
      {
        "firstName": "Leslie",
        "lastName": "Knope",
        "email": "leslie@pawnee.gov",
        "_links": {
          "self": {
            "href": "http://localhost:8080/api/members/1"
          },
          "employee": {
            "href": "http://localhost:8080/api/members/1"
          }
        }
      }
    ]
  },
  "_links": {
    "self": {
      "href": "http://localhost:8080/api/members"
    },
    "profile": {
      "href": "http://localhost:8080/api/profile/members"
    }
  },
  "page": {
    "size": 5,
    "totalElements": 1,
    "totalPages": 1,
    "number": 0
  }
}
```
*(Notice how the pagination config we set in `application.properties` to `size=5` applies automatically.)*
