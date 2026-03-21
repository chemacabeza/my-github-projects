# Section 5: REST API Security

This guide is a complete, copy-pasteable tutorial for securing Spring Boot REST APIs using **Spring Security**. You will learn how to implement Role-Based Access Control (RBAC) using both in-memory users and a JDBC-connected PostgreSQL database.

By following this guide, you will build a runnable application, entirely containerized via Docker.

## 1. Project Setup (Maven `pom.xml`)

Include the Spring Security starter. When this is on the classpath, Spring Boot automatically secures all endpoints and generates a default password.

```xml
    <dependencies>
        <!-- Standard REST Controllers -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- Spring Security core -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>

        <!-- Database access for the JDBC authentication part -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>
    </dependencies>
```

---

## 2. Docker & Environment Setup (Mac & Ubuntu)

To test JDBC authentication, we need a real database. Place these files in your project root.

### `docker-compose.yml`

```yaml
version: '3.8'

services:
  db:
      image: postgres:15-alpine
      container_name: security_db
      environment:
        POSTGRES_USER: springsecurity
        POSTGRES_PASSWORD: springsecurity
        POSTGRES_DB: security_demo
      ports:
        - "5432:5432"
      volumes:
        - pg_security_data:/var/lib/postgresql/data
        # Mount our initialization script to create the Spring Security tables automatically
        - ./init.sql:/docker-entrypoint-initdb.d/init.sql

  app:
    build: .
    container_name: security_app
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/security_demo

volumes:
  pg_security_data:
```

### `Dockerfile`

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

---

## 3. Database Initialization (`init.sql`)

Create a file named `init.sql` in your project root. The `docker-compose.yml` mounts this into PostgreSQL so the tables are created when the database first boots.

This establishes the default Spring Security schema and inserts three users (`john`, `mary`, `susan`) with the encrypted password `test123` (hashed using bcrypt, which is the industry standard).

```sql
-- Create standard Spring Security tables for PostgreSQL

CREATE TABLE users (
  username VARCHAR(50) NOT NULL PRIMARY KEY,
  password VARCHAR(68) NOT NULL,
  enabled BOOLEAN NOT NULL
);

CREATE TABLE authorities (
  username VARCHAR(50) NOT NULL,
  authority VARCHAR(50) NOT NULL,
  CONSTRAINT authorities_idx_1 UNIQUE (username, authority),
  CONSTRAINT authorities_ibfk_1 FOREIGN KEY (username) REFERENCES users (username)
);

-- Insert users (password is "test123" encrypted with bcrypt)
INSERT INTO users (username, password, enabled) VALUES 
('john','{bcrypt}$2a$10$qeS0HEh7urweMojsnwNAR.vcXJeI1OEeUVyX0Uj33I.3wL9z5gGg6',true),
('mary','{bcrypt}$2a$10$qeS0HEh7urweMojsnwNAR.vcXJeI1OEeUVyX0Uj33I.3wL9z5gGg6',true),
('susan','{bcrypt}$2a$10$qeS0HEh7urweMojsnwNAR.vcXJeI1OEeUVyX0Uj33I.3wL9z5gGg6',true);

-- Assign roles (Spring requires the ROLE_ prefix in the database)
INSERT INTO authorities (username, authority) VALUES 
('john','ROLE_EMPLOYEE'),
('mary','ROLE_EMPLOYEE'),
('mary','ROLE_MANAGER'),
('susan','ROLE_EMPLOYEE'),
('susan','ROLE_MANAGER'),
('susan','ROLE_ADMIN');
```

---

## 4. Configuration (`application.properties`)

Provides the database connection details for the app.

```properties
spring.datasource.url=${SPRING_DATASOURCE_URL:jdbc:postgresql://localhost:5432/security_demo}
spring.datasource.username=springsecurity
spring.datasource.password=springsecurity
```

---

## 5. Part 1: Spring Security with In-Memory Users

If you don't want to use a database yet and just want to hardcode users for a prototype, you define an `InMemoryUserDetailsManager`. 

### `src/main/java/com/luv2code/springboot/demo/security/DemoSecurityConfig.java`

```java
package com.luv2code.springboot.demo.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class DemoSecurityConfig {

    // 1. Defining Users in Memory
    @Bean
    public InMemoryUserDetailsManager userDetailsManager() {
        // {noop} tells Spring not to expect an encrypted password (bad for production, okay for demo)
        UserDetails john = User.builder()
                .username("john")
                .password("{noop}test123")
                .roles("EMPLOYEE")
                .build();

        UserDetails mary = User.builder()
                .username("mary")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER")
                .build();

        UserDetails susan = User.builder()
                .username("susan")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER", "ADMIN")
                .build();

        return new InMemoryUserDetailsManager(john, mary, susan);
    }

    // 2. Defining Authorization Rules
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                configurer
                        .requestMatchers(HttpMethod.GET, "/api/employees").hasRole("EMPLOYEE")
                        .requestMatchers(HttpMethod.GET, "/api/employees/**").hasRole("EMPLOYEE")
                        .requestMatchers(HttpMethod.POST, "/api/employees").hasRole("MANAGER")
                        .requestMatchers(HttpMethod.PUT, "/api/employees").hasRole("MANAGER")
                        .requestMatchers(HttpMethod.DELETE, "/api/employees/**").hasRole("ADMIN")
        );

        // use HTTP Basic authentication (browser pop-up or header: Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==)
        http.httpBasic(Customizer.withDefaults());

        // disable Cross Site Request Forgery (CSRF) 
        // This is typically required for stateless APIs where you test with Postman/Curl.
        http.csrf(csrf -> csrf.disable());

        return http.build();
    }
}
```

---

## 6. Part 2: Spring Security with JDBC (Database)

Hardcoding users is bad practice. To switch the app to use the PostgreSQL database (which we initialized in Step 3), delete the `InMemoryUserDetailsManager` bean and replace it with a `JdbcUserDetailsManager`.

Update your `DemoSecurityConfig.java`:

```java
package com.luv2code.springboot.demo.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

import javax.sql.DataSource;

@Configuration
public class DemoSecurityConfig {

    // 1. Ask Spring for the autowired DataSource (connected to Postgres via application.properties)
    @Bean
    public UserDetailsManager userDetailsManager(DataSource dataSource) {
        // Because our init.sql used the standard Spring Security schema (users and authorities tables),
        // Spring literally does all the work for us instantly.
        return new JdbcUserDetailsManager(dataSource);
        
        /* 
        // IF you had custom table names (e.g., 'members' and 'roles'), you would do this instead:
        // JdbcUserDetailsManager jdbcUserDetailsManager = new JdbcUserDetailsManager(dataSource);
        // jdbcUserDetailsManager.setUsersByUsernameQuery("select user_id, pw, active from members where user_id=?");
        // jdbcUserDetailsManager.setAuthoritiesByUsernameQuery("select user_id, role from roles where user_id=?");
        // return jdbcUserDetailsManager;
        */
    }

    // 2. The filterChain stays exactly the same as the in-memory example!
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                configurer
                        .requestMatchers(HttpMethod.GET, "/api/employees").hasRole("EMPLOYEE")
                        .requestMatchers(HttpMethod.GET, "/api/employees/**").hasRole("EMPLOYEE")
                        .requestMatchers(HttpMethod.POST, "/api/employees").hasRole("MANAGER")
                        .requestMatchers(HttpMethod.PUT, "/api/employees").hasRole("MANAGER")
                        .requestMatchers(HttpMethod.DELETE, "/api/employees/**").hasRole("ADMIN")
        );

        http.httpBasic(Customizer.withDefaults());
        http.csrf(csrf -> csrf.disable());
        return http.build();
    }
}
```

---

## 7. Dummy REST Controller for Testing

To prove our security rules work, let's create a dummy controller without a real database behind it.

### `src/main/java/com/luv2code/springboot/demo/rest/EmployeeRestController.java`

```java
package com.luv2code.springboot.demo.rest;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/employees")
public class EmployeeRestController {

    @GetMapping
    public String getAllEmployees() {
        return "List of all employees (Requires EMPLOYEE role)";
    }

    @PostMapping
    public String addEmployee() {
        return "Employee added! (Requires MANAGER role)";
    }

    @DeleteMapping("/{id}")
    public String deleteEmployee(@PathVariable int id) {
        return "Employee " + id + " deleted! (Requires ADMIN role)";
    }
}
```

---

## 8. Running & Testing

1. Start the stack: `docker compose up --build -d`
2. Test the endpoints using `curl` with the `-u username:password` flag (HTTP Basic Auth).

**Test 1: John (EMPLOYEE) trying to read (Should work)**
```bash
curl -u john:test123 http://localhost:8080/api/employees
> List of all employees (Requires EMPLOYEE role)
```

**Test 2: John (EMPLOYEE) trying to add an employee (Should fail - 403 Forbidden)**
```bash
curl -i -X POST -u john:test123 http://localhost:8080/api/employees
> HTTP/1.1 403 Forbidden
```

**Test 3: Mary (MANAGER) trying to add an employee (Should work)**
```bash
curl -X POST -u mary:test123 http://localhost:8080/api/employees
> Employee added! (Requires MANAGER role)
```

**Test 4: Mary (MANAGER) trying to delete an employee (Should fail - 403 Forbidden)**
```bash
curl -i -X DELETE -u mary:test123 http://localhost:8080/api/employees/1
> HTTP/1.1 403 Forbidden
```

**Test 5: Susan (ADMIN) trying to delete an employee (Should work)**
```bash
curl -X DELETE -u susan:test123 http://localhost:8080/api/employees/1
> Employee 1 deleted! (Requires ADMIN role)
```
