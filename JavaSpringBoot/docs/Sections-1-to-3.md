# Sections 1–3: Spring Core & Hibernate/JPA CRUD

This guide is a complete, copy-pasteable tutorial covering the fundamentals of Spring Boot, Spring Core (Inversion of Control, Dependency Injection, Scopes, Lifecycle), and database access using Hibernate/JPA via `EntityManager`.

By following this guide, you will build a runnable application with a PostgreSQL database, entirely containerized via Docker.

## 1. Project Setup (Maven `pom.xml`)

Initialize a standard Spring Boot project (Java 17+, Maven). Your `pom.xml` should include the following essential dependencies:

```xml
    <dependencies>
        <!-- Spring Boot Web for REST Controllers -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- Spring Data JPA for Hibernate features -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
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

To ensure this project runs identically on macOS and Ubuntu Linux without installing a local database, we use Docker. 

Create these two files in the root of your project:

### `docker-compose.yml`

This spins up a local PostgreSQL database automatically initialized with the correct credentials.

```yaml
version: '3.8'

services:
  db:
      image: postgres:15-alpine
      container_name: spring_db
      environment:
        POSTGRES_USER: springstudent
        POSTGRES_PASSWORD: springstudent
        POSTGRES_DB: student_tracker
      ports:
        - "5432:5432"
      volumes:
        - postgres_data:/var/lib/postgresql/data

  app:
    build: .
    container_name: spring_app
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/student_tracker

volumes:
  postgres_data:
```

### `Dockerfile`

A multi-stage build that compiles the application using Maven and then packages it into a lightweight JDK container.

```dockerfile
# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
# Build the application skipping tests for speed in this demo
RUN mvn clean package -DskipTests

# Stage 2: Create the final lightweight image
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

> **To run the full stack:** Open a terminal in the project root and run `docker compose up --build`.

---

## 3. Configuration (`application.properties`)

Create or replace `src/main/resources/application.properties`. This configuration demonstrates three key Spring Boot features: database connectivity, logging levels, and global lazy initialization.

```properties
# 1. Database Connection (Standard setup)
spring.datasource.url=${SPRING_DATASOURCE_URL:jdbc:postgresql://localhost:5432/student_tracker}
spring.datasource.username=springstudent
spring.datasource.password=springstudent

# Auto-create tables based on JPA entities
spring.jpa.hibernate.ddl-auto=update
# Show the SQL Hibernate generates in the console
spring.jpa.show-sql=true

# 2. Logging Levels
# Levels: TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF
logging.level.root=INFO
logging.level.com.luv2code.springboot.demo=DEBUG
logging.level.org.hibernate.SQL=DEBUG

# 3. Global Lazy Initialization
# Set to 'true' to dramatically speed up startup time. Beans are only created when requested.
# Disadvantage: You won't catch configuration errors until the bean is actually used.
spring.main.lazy-initialization=true
```

---

## 4. Spring Core (Scopes and Lifecycle)

By default, Spring creates a **Singleton** (one single shared instance) for every bean. Sometimes you need a new instance every time, which is called a **Prototype**. We can also tie custom logic to when the bean is created (`@PostConstruct`) and destroyed (`@PreDestroy`).

Here is a complete, copy-pasteable example of these concepts:

### `src/main/java/com/luv2code/springboot/demo/core/Coach.java`
```java
package com.luv2code.springboot.demo.core;

public interface Coach {
    String getDailyWorkout();
}
```

### `src/main/java/com/luv2code/springboot/demo/core/CricketCoach.java`
```java
package com.luv2code.springboot.demo.core;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
// PROTOTYPE scope creates a new instance every time this bean is requested via Dependency Injection
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class CricketCoach implements Coach {

    public CricketCoach() {
        System.out.println("In constructor: " + getClass().getSimpleName());
    }

    // Executed immediately after dependency injection is done
    @PostConstruct
    public void doMyStartupStuff() {
        System.out.println("In doMyStartupStuff(): " + getClass().getSimpleName());
    }

    // Executed right before the bean is destroyed / application shuts down
    // Note: Prototype beans DO NOT automatically call @PreDestroy. 
    // Spring hands over the prototype to the client and forgets about it!
    @PreDestroy
    public void doMyCleanupStuff() {
        System.out.println("In doMyCleanupStuff(): " + getClass().getSimpleName());
    }

    @Override
    public String getDailyWorkout() {
        return "Practice fast bowling for 15 minutes";
    }
}
```

---

## 5. Hibernate/JPA CRUD & JPQL

When managing database entities, you have two choices in Spring Boot:
1. **`EntityManager`**: Lower-level, high control. Necessary for highly custom JPQL (Java Persistence Query Language) or complex native queries.
2. **`JpaRepository`**: High-level, magical CRUD out-of-the-box. (We will cover this in Section 4).

Here is an example using `EntityManager` completely manually.

### `src/main/java/com/luv2code/springboot/demo/entity/Student.java`
```java
package com.luv2code.springboot.demo.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "student")
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "first_name")
    private String firstName;    

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "email")
    private String email;

    // JPA requires an empty constructor
    public Student() {}

    public Student(String firstName, String lastName, String email) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
    }

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

### `src/main/java/com/luv2code/springboot/demo/dao/StudentDAO.java`
```java
package com.luv2code.springboot.demo.dao;

import com.luv2code.springboot.demo.entity.Student;
import java.util.List;

public interface StudentDAO {
    void save(Student theStudent);
    Student findById(Integer id);
    List<Student> findByLastName(String theLastName);
    void update(Student theStudent);
    int updateAllLastNames(String newLastName);
}
```

### `src/main/java/com/luv2code/springboot/demo/dao/StudentDAOImpl.java`

Notice how JPQL query strings use **Java class and field names**, not database table and column names `FROM Student WHERE lastName=:theData`. Note how `:theData` is prefixed but the parameter mapping `setParameter("theData", ...)` drops the colon.

Modifying operations (`save`, `update`, `executeUpdate`) **require** `@Transactional`. Read operations (`find`) do not.

```java
package com.luv2code.springboot.demo.dao;

import com.luv2code.springboot.demo.entity.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public class StudentDAOImpl implements StudentDAO {

    private final EntityManager entityManager;

    public StudentDAOImpl(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    @Override
    @Transactional
    public void save(Student theStudent) {
        entityManager.persist(theStudent);
    }

    @Override
    public Student findById(Integer id) {
        return entityManager.find(Student.class, id);
    }

    @Override
    // Reads do not need @Transactional
    public List<Student> findByLastName(String theLastName) {
        // JPQL uses Java Entity names (Student) and variable names (lastName), NOT DB tables/columns
        TypedQuery<Student> theQuery = entityManager.createQuery(
                "FROM Student WHERE lastName=:theData", Student.class);
        
        // Setting the parameter (no colon here!)
        theQuery.setParameter("theData", theLastName);
        
        return theQuery.getResultList();
    }

    @Override
    @Transactional
    public void update(Student theStudent) {
        // .merge() takes the Java object and updates the database row matching its ID
        entityManager.merge(theStudent);
    }

    @Override
    @Transactional
    public int updateAllLastNames(String newLastName) {
        // Bulk update using JPQL
        int numRowsUpdated = entityManager.createQuery("UPDATE Student SET lastName=:newName")
                .setParameter("newName", newLastName)
                .executeUpdate();
                
        return numRowsUpdated;
    }
}
```

---

## 6. Binding it Together (REST Controller)

To prove all this code works, here is a quick REST Controller you can hit from your browser once Docker is running.

### `src/main/java/com/luv2code/springboot/demo/rest/DemoController.java`
```java
package com.luv2code.springboot.demo.rest;

import com.luv2code.springboot.demo.core.Coach;
import com.luv2code.springboot.demo.dao.StudentDAO;
import com.luv2code.springboot.demo.entity.Student;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class DemoController {

    private final Coach myCoach;
    private final StudentDAO studentDAO;

    public DemoController(Coach myCoach, StudentDAO studentDAO) {
        this.myCoach = myCoach;
        this.studentDAO = studentDAO;
    }

    // Proves the CricketCoach is working
    @GetMapping("/workout")
    public String getDailyWorkout() {
        return myCoach.getDailyWorkout();
    }

    // Creates a new student in the PostgreSQL DB
    @PostMapping("/students")
    public String createStudent(@RequestParam String firstName, @RequestParam String lastName, @RequestParam String email) {
        Student tempStudent = new Student(firstName, lastName, email);
        studentDAO.save(tempStudent);
        return "Saved student. Generated id: " + tempStudent.getId();
    }

    // Finds all students with a specific last name
    @GetMapping("/students/search")
    public List<Student> searchStudents(@RequestParam String lastName) {
        return studentDAO.findByLastName(lastName);
    }
}
```

### Try it out!

If you used the `docker-compose.yml` and `Dockerfile` above:
1. `docker compose up -d`
2. Look at the logs: `docker logs -f spring_app`. You will see Hibernate automatically creating the `student` table.
3. Call the API (using curl or your browser):
   * Get a workout: `curl http://localhost:8080/api/workout`
   * Create a student: `curl -X POST "http://localhost:8080/api/students?firstName=Paul&lastName=Doe&email=paul@luv2code.com"`
   * Search for the student: `curl http://localhost:8080/api/students/search?lastName=Doe`
