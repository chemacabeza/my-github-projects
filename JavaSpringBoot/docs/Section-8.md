# Section 8: Spring MVC Security (Thymeleaf)

This guide is a complete, copy-pasteable tutorial for securing Spring MVC Web Applications (rendering HTML via **Thymeleaf**) using **Spring Security**. 

Unlike Section 5 (REST APIs), securing an MVC app requires dealing with login forms, user sessions, CSRF protection, and manipulating the HTML UI based on user roles.

By following this guide, you will build a runnable application, fully containerized via Docker.

## 1. Project Setup (Maven `pom.xml`)

You need the Spring Web and Security starters, plus Thymeleaf and its special Security dialect plugin (to allow role-checking inside HTML).

```xml
    <dependencies>
        <!-- Spring MVC -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- Spring Security -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>

        <!-- Thymeleaf Templating -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>

        <!-- Use Spring Security tags inside Thymeleaf (sec:authorize) -->
        <dependency>
            <groupId>org.thymeleaf.extras</groupId>
            <artifactId>thymeleaf-extras-springsecurity6</artifactId>
        </dependency>

        <!-- JDBC backend for Users/Roles -->
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

We will use the exact same Docker setup as the REST API security example to provide our PostgreSQL database.

### `docker-compose.yml`

```yaml
version: '3.8'

services:
  db:
      image: postgres:15-alpine
      container_name: mvc_security_db
      environment:
        POSTGRES_USER: springsecurity
        POSTGRES_PASSWORD: springsecurity
        POSTGRES_DB: security_demo
      ports:
        - "5432:5432"
      volumes:
        - pg_mvc_data:/var/lib/postgresql/data
        - ./init.sql:/docker-entrypoint-initdb.d/init.sql

  app:
    build: .
    container_name: mvc_security_app
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/security_demo

volumes:
  pg_mvc_data:
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

Create `init.sql` in your project root. The passwords are "test123" encrypted with bcrypt.

```sql
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

INSERT INTO users (username, password, enabled) VALUES 
('john','{bcrypt}$2a$10$qeS0HEh7urweMojsnwNAR.vcXJeI1OEeUVyX0Uj33I.3wL9z5gGg6',true),
('mary','{bcrypt}$2a$10$qeS0HEh7urweMojsnwNAR.vcXJeI1OEeUVyX0Uj33I.3wL9z5gGg6',true),
('susan','{bcrypt}$2a$10$qeS0HEh7urweMojsnwNAR.vcXJeI1OEeUVyX0Uj33I.3wL9z5gGg6',true);

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

```properties
spring.datasource.url=${SPRING_DATASOURCE_URL:jdbc:postgresql://localhost:5432/security_demo}
spring.datasource.username=springsecurity
spring.datasource.password=springsecurity
```

---

## 5. Security Configuration (Forms & Sessions)

Unlike REST APIs, an MVC application relies on **Form Login**, **Session Cookies**, and requires **CSRF protection**.

### `src/main/java/com/luv2code/springboot/demo/security/DemoSecurityConfig.java`

```java
package com.luv2code.springboot.demo.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

import javax.sql.DataSource;

@Configuration
public class DemoSecurityConfig {

    // 1. Database Authentication
    @Bean
    public UserDetailsManager userDetailsManager(DataSource dataSource) {
        return new JdbcUserDetailsManager(dataSource);
    }

    // 2. HTTP Authorization & Login Form Routing
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                configurer
                        .requestMatchers("/").hasRole("EMPLOYEE")
                        .requestMatchers("/leaders/**").hasRole("MANAGER")
                        .requestMatchers("/systems/**").hasRole("ADMIN")
                        .anyRequest().authenticated()
                )
            .formLogin(form ->
                    form
                        .loginPage("/showMyLoginPage")          // Custom login URL mapped in our controller
                        .loginProcessingUrl("/authenticateTheUser") // Spring handles this POST automatically
                        .permitAll()                            // Everyone can see the login page
                )
            .logout(logout -> 
                    logout.permitAll()
                          .logoutSuccessUrl("/showMyLoginPage?logout") // Redirect after logout
                )
            .exceptionHandling(configurer ->
                    configurer.accessDeniedPage("/access-denied")      // Custom 403 page
                );

        // DO NOT disable CSRF for MVC apps. Forms need protection. 
        // Thymeleaf injects the CSRF token into our forms automatically.
        return http.build();
    }
}
```

---

## 6. The Controllers

You need standard `@Controller` classes to serve the HTML templates.

### `src/main/java/com/luv2code/springboot/demo/controller/LoginController.java`

Handles displaying the login page and the "Access Denied" page.

```java
package com.luv2code.springboot.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

    @GetMapping("/showMyLoginPage")
    public String showMyLoginPage() {
        return "fancy-login"; // Refers to src/main/resources/templates/fancy-login.html
    }

    @GetMapping("/access-denied")
    public String showAccessDenied() {
        return "access-denied"; // Refers to src/main/resources/templates/access-denied.html
    }
}
```

### `src/main/java/com/luv2code/springboot/demo/controller/DemoController.java`

Handles the actual content pages.

```java
package com.luv2code.springboot.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DemoController {

    @GetMapping("/")
    public String showHome() { return "home"; }

    @GetMapping("/leaders")
    public String showLeaders() { return "leaders"; }

    @GetMapping("/systems")
    public String showSystems() { return "systems"; }
}
```

---

## 7. Thymeleaf HTML Templates

All files go in `src/main/resources/templates/`.

### 1. `fancy-login.html` (The Login Form)

Notice the form POSTs to `@{/authenticateTheUser}`. Spring Security intercepts this URL. Thymeleaf automatically injects a hidden CSRF token into the form.

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <title>Login Page</title>
    <meta charset="utf-8" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <div class="container mt-5">
        <div class="col-md-4 offset-md-4">
            <div class="card border-info">
                <div class="card-header bg-info text-white">Sign In</div>
                <div class="card-body">

                    <!-- Login Form -->
                    <form action="#" th:action="@{/authenticateTheUser}" method="POST">

                        <!-- Show Error Message -->
                        <div th:if="${param.error}" class="alert alert-danger">
                            Invalid username or password.
                        </div>
                        
                        <!-- Show Logout Success Message -->
                        <div th:if="${param.logout}" class="alert alert-success">
                            You have been logged out.
                        </div>

                        <!-- User name (must be named "username") -->
                        <div class="mb-3">
                            <input type="text" name="username" placeholder="username" class="form-control" />
                        </div>

                        <!-- Password (must be named "password") -->
                        <div class="mb-3">
                            <input type="password" name="password" placeholder="password" class="form-control" />
                        </div>

                        <button type="submit" class="btn btn-success w-100">Login</button>
                    </form>

                </div>
            </div>
        </div>
    </div>
</body>
</html>
```

### 2. `home.html` (Dynamic Navigation Based on Roles)

We use the `sec:authorize` tag (from the `thymeleaf-extras-springsecurity6` dependency) to conditionally render HTML sections only if the logged-in user possesses the required role.

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/extras/spring-security">
<head>
    <title>luv2code Company Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="container mt-5">

    <h2>luv2code Company Dashboard</h2>
    <hr>
    
    <!-- Display Authentication Info -->
    <div class="alert alert-info">
        <p class="mb-0">Logged in as User: <strong><span sec:authentication="principal.username"></span></strong></p>
        <p class="mb-0">Your Roles: <strong><span sec:authentication="principal.authorities"></span></strong></p>
    </div>

    <!-- Managers Only Content -->
    <div sec:authorize="hasRole('MANAGER')" class="card text-bg-warning mb-3">
        <div class="card-body">
            <h5 class="card-title">Management Tools</h5>
            <a th:href="@{/leaders}" class="btn btn-dark">View Leadership Dashboard</a>
        </div>
    </div>

    <!-- Admins Only Content -->
    <div sec:authorize="hasRole('ADMIN')" class="card text-bg-danger mb-3">
        <div class="card-body">
            <h5 class="card-title">Admin Tools</h5>
            <a th:href="@{/systems}" class="btn btn-dark">View IT Systems Control</a>
        </div>
    </div>
    
    <hr>

    <!-- Logout Button -->
    <form action="#" th:action="@{/logout}" method="POST">
        <input type="submit" value="Logout" class="btn btn-outline-danger" />
    </form>

</body>
</html>
```

### 3. `access-denied.html` (The Custom 403 Page)

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <title>Access Denied</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="container mt-5 text-center">
    <div class="alert alert-danger d-inline-block px-5">
        <h2 class="display-4">403</h2>
        <h3>Access Denied</h3>
        <p>You are not authorized to view this page.</p>
        <a th:href="@{/}" class="btn btn-primary mt-3">Back to Dashboard</a>
    </div>
</body>
</html>
```

### 4. `leaders.html` & `systems.html` (The Protected Content)

Just create dummy files for these, for example: `leaders.html`
```html
<!DOCTYPE html>
<html>
<body>
    <h2>Leadership Meeting Minutes (Confidential)</h2>
    <a href="/">Go Back</a>
</body>
</html>
```

---

## 8. Running & Testing

1. Bring up the stack: `docker compose up --build -d`
2. Open your web browser and go to `http://localhost:8080`
3. You will be redirected to the custom login page.
4. **Test accounts (password is `test123` for all):**
   * Log in as `john`: You will see the home page. You will NOT see the Manager or Admin buttons.
   * Log out.
   * Log in as `mary`: You WILL see the yellow Manager button. If you manually type `http://localhost:8080/systems`, you will hit the custom Access Denied page.
   * Log out.
   * Log in as `susan`: You will see all buttons, including the red Admin button, and can access all links.
