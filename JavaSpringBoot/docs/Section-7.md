# Section 7: Spring MVC CRUD with Database

This guide is a complete, copy-pasteable tutorial for building a full-stack CRUD (Create, Read, Update, Delete) web application using **Spring MVC**, **Thymeleaf**, and **Spring Data JPA**.

We will build an "Employee Directory" that reads from and writes to a PostgreSQL database.

By following this guide, you will build a runnable application, fully containerized via Docker.

## 1. Project Setup (Maven `pom.xml`)

You need dependencies for Web (Controllers), Thymeleaf (HTML Views), and Data JPA (Database access).

```xml
    <dependencies>
        <!-- Spring MVC -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- Thymeleaf Templating Engine -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>

        <!-- Spring Data JPA & Database Driver -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>
    </dependencies>
```

---

## 2. Docker Setup (Mac & Ubuntu)

Place these files in your project root to spin up the PostgreSQL database and the app seamlessly.

### `docker-compose.yml`

```yaml
version: '3.8'

services:
  db:
      image: postgres:15-alpine
      container_name: mvc_crud_db
      environment:
        POSTGRES_USER: springstudent
        POSTGRES_PASSWORD: springstudent
        POSTGRES_DB: employee_directory
      ports:
        - "5432:5432"
      volumes:
        - pg_mvc_crud_data:/var/lib/postgresql/data

  app:
    build: .
    container_name: mvc_crud_app
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/employee_directory

volumes:
  pg_mvc_crud_data:
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

## 3. Configuration (`application.properties`)

Provides the database connection details and tells Hibernate to auto-create our tables.

```properties
spring.datasource.url=${SPRING_DATASOURCE_URL:jdbc:postgresql://localhost:5432/employee_directory}
spring.datasource.username=springstudent
spring.datasource.password=springstudent

# Auto-create the database table based on our Java Entity
spring.jpa.hibernate.ddl-auto=update
```

---

## 4. The Backend Layers (Entity, DAO, Service)

Before we can build the Controller and Views, we need the data access code.

### 1. The Entity: `Employee.java`
```java
package com.luv2code.springboot.demo.entity;

import jakarta.persistence.*;

@Entity
@Table(name="employee")
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String firstName;
    private String lastName;
    private String email;

    public Employee() {}

    public Employee(String firstName, String lastName, String email) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
    }

    // Getters and Setters
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

### 2. The DAO: `EmployeeRepository.java`
Using Spring Data JPA, we get absolute magic. No code required.
```java
package com.luv2code.springboot.demo.dao;

import com.luv2code.springboot.demo.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface EmployeeRepository extends JpaRepository<Employee, Integer> {
    
    // Magic Method: Spring Data JPA will automatically parse this method name
    // and generate a query: "SELECT * FROM employee ORDER BY last_name ASC"
    List<Employee> findAllByOrderByLastNameAsc();
}
```

### 3. The Service Layer: `EmployeeService.java`
```java
package com.luv2code.springboot.demo.service;

import com.luv2code.springboot.demo.entity.Employee;
import java.util.List;

public interface EmployeeService {
    List<Employee> findAll();
    Employee findById(int theId);
    void save(Employee theEmployee);
    void deleteById(int theId);
}
```

### 4. The Service Implementation: `EmployeeServiceImpl.java`
```java
package com.luv2code.springboot.demo.service;

import com.luv2code.springboot.demo.dao.EmployeeRepository;
import com.luv2code.springboot.demo.entity.Employee;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class EmployeeServiceImpl implements EmployeeService {

    private EmployeeRepository employeeRepository;

    public EmployeeServiceImpl(EmployeeRepository employeeRepository) {
        this.employeeRepository = employeeRepository;
    }

    @Override
    public List<Employee> findAll() {
        // Use our custom method to sort data automatically
        return employeeRepository.findAllByOrderByLastNameAsc();
    }

    @Override
    public Employee findById(int theId) {
        Optional<Employee> result = employeeRepository.findById(theId);
        if (result.isPresent()) {
            return result.get();
        } else {
            throw new RuntimeException("Did not find employee id - " + theId);
        }
    }

    @Override
    public void save(Employee theEmployee) {
        employeeRepository.save(theEmployee);
    }

    @Override
    public void deleteById(int theId) {
        employeeRepository.deleteById(theId);
    }
}
```

---

## 5. The Controller (`EmployeeController.java`)

This controller maps URLs to our Thymeleaf templates and passes data back and forth to the Service layer.

```java
package com.luv2code.springboot.demo.controller;

import com.luv2code.springboot.demo.entity.Employee;
import com.luv2code.springboot.demo.service.EmployeeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/employees")
public class EmployeeController {

    private EmployeeService employeeService;

    public EmployeeController(EmployeeService theEmployeeService) {
        employeeService = theEmployeeService;
    }

    // 1. READ (List all)
    @GetMapping("/list")
    public String listEmployees(Model theModel) {
        List<Employee> theEmployees = employeeService.findAll();
        theModel.addAttribute("employees", theEmployees);
        return "employees/list-employees";
    }

    // 2. CREATE (Show Form)
    @GetMapping("/showFormForAdd")
    public String showFormForAdd(Model theModel) {
        theModel.addAttribute("employee", new Employee());
        return "employees/employee-form";
    }

    // 3. UPDATE (Show Form pre-populated)
    @GetMapping("/showFormForUpdate")
    public String showFormForUpdate(@RequestParam("employeeId") int theId, Model theModel) {
        Employee theEmployee = employeeService.findById(theId);
        theModel.addAttribute("employee", theEmployee);
        return "employees/employee-form";
    }

    // 4. SAVE (Handles both Create and Update POSTs)
    @PostMapping("/save")
    public String saveEmployee(@ModelAttribute("employee") Employee theEmployee) {
        employeeService.save(theEmployee);
        // Use a redirect to prevent duplicate submissions on browser refresh
        return "redirect:/employees/list";
    }

    // 5. DELETE
    @GetMapping("/delete")
    public String delete(@RequestParam("employeeId") int theId) {
        employeeService.deleteById(theId);
        return "redirect:/employees/list";
    }
}
```

---

## 6. Thymeleaf HTML Templates

Create these files in `src/main/resources/templates/employees/`. We use Bootstrap 5 for fast, clean styling.

### `list-employees.html` (The Dashboard)

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Employee Directory</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Employee Directory</h3>
        <!-- Add Button -->
        <a th:href="@{/employees/showFormForAdd}" class="btn btn-primary">Add Employee</a>
    </div>

    <!-- Data Table -->
    <table class="table table-bordered table-striped table-hover bg-white shadow-sm">
        <thead class="table-dark">
            <tr>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <!-- We loop over the "employees" list passed by the Controller -->
            <tr th:each="tempEmployee : ${employees}">
                <td th:text="${tempEmployee.firstName}"></td>
                <td th:text="${tempEmployee.lastName}"></td>
                <td th:text="${tempEmployee.email}"></td>
                
                <!-- Action Buttons -->
                <td>
                    <a th:href="@{/employees/showFormForUpdate(employeeId=${tempEmployee.id})}"
                       class="btn btn-info btn-sm text-white">Update</a>

                    <a th:href="@{/employees/delete(employeeId=${tempEmployee.id})}"
                       class="btn btn-danger btn-sm"
                       onclick="if (!(confirm('Are you sure you want to delete this employee?'))) return false">Delete</a>
                </td>
            </tr>
            <!-- Empty state check -->
            <tr th:if="${#lists.isEmpty(employees)}">
                <td colspan="4" class="text-center text-muted py-4">No employees found. Add one!</td>
            </tr>
        </tbody>
    </table>
</div>

</body>
</html>
```

### `employee-form.html` (Used for both Create and Update)

Because we use `<input type="hidden" th:field="*{id}" />`, Spring knows whether to INSERT a new row (if ID is 0) or UPDATE an existing row (if ID > 0).

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Save Employee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow-sm w-50 mx-auto">
        <div class="card-header bg-dark text-white h5">Save Employee</div>
        <div class="card-body">

            <!-- The Form -->
            <form action="#" th:action="@{/employees/save}" th:object="${employee}" method="POST">
                
                <!-- Hidden ID field (crucial for Updates to work instead of creating duplicates) -->
                <input type="hidden" th:field="*{id}" />

                <div class="mb-3">
                    <label class="form-label">First Name</label>
                    <input type="text" th:field="*{firstName}" class="form-control" placeholder="First name" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Last Name</label>
                    <input type="text" th:field="*{lastName}" class="form-control" placeholder="Last name" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" th:field="*{email}" class="form-control" placeholder="Email" required>
                </div>

                <button type="submit" class="btn btn-success w-100 mb-3">Save</button>
            </form>

            <div class="text-center">
                <a th:href="@{/employees/list}" class="text-decoration-none">&larr; Back to Employees List</a>
            </div>
            
        </div>
    </div>
</div>

</body>
</html>
```

---

## 7. Running & Testing

1. Bring up the application: `docker compose up --build -d`
2. Open your web browser and navigate to `http://localhost:8080/employees/list`
3. Since the database is fresh, the table will be empty.
4. Click **"Add Employee"** and create a user. The page will redirect back, and you will see the new user.
5. Click **"Update"** to change their email.
6. Click **"Delete"**, confirm the JavaScript prompt, and watch the row disappear.
