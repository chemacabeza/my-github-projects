# Section 6: Spring MVC with Thymeleaf (Forms & Validation)

This guide is a complete, copy-pasteable tutorial covering **Spring MVC Form Handling** and **Data Validation** using Thymeleaf. 

You will build a "Student Registration Form" that handles dropdowns, radio buttons, checkboxes, standard validation (required fields, regex), and a custom validation annotation (`@CourseCode`). To demonstrate property binding, options for the dropdowns and checkboxes will be loaded from `application.properties`.

By following this guide, you will build a runnable application, entirely containerized via Docker.

## 1. Project Setup (Maven `pom.xml`)

You need the Spring Web starter, Thymeleaf, and the Validation starter.

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

        <!-- Spring Boot Validation (Hibernate Validator) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
    </dependencies>
```

---

## 2. Docker Setup (Mac & Ubuntu)

Since this specific section does not require a database (everything is held in memory for form processing), the Docker setup is very simple. Place this file in your project root.

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

> **To run:** Open a terminal in the project root and run `docker build -t mvc-forms . && docker run -p 8080:8080 mvc-forms`.

---

## 3. Configuration & Error Messages (`application.properties`)

Create this in `src/main/resources/application.properties`. It holds the dynamic options for our form dropdowns and custom error messages for type mismatch failures (e.g., typing letters into a number field).

```properties
# Dynamic Form Options
countries=Brazil,France,Germany,India,Mexico,Spain,United States
languages=Java,Go,Python,Rust,TypeScript
systems=Linux,macOS,Microsoft Windows

# Custom Validation Message for Type Mismatch
# Format: typeMismatch.[ModelName].[FieldName]=Message
typeMismatch.student.freePasses=Invalid number format. Please enter an integer.
```

---

## 4. Custom Validation Annotation (`@CourseCode`)

We will create our own Java annotation! We want to enforce that a course code must start with a specific string (e.g., "LUV").

### 1. The Annotation Interface: `CourseCode.java`
```java
package com.luv2code.springboot.demo.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = CourseCodeConstraintValidator.class)
@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface CourseCode {

    // default course code prefix
    String value() default "LUV";

    // default error message
    String message() default "must start with LUV";

    // define default groups (required by validation API)
    Class<?>[] groups() default {};

    // define default payloads (required by validation API)
    Class<? extends Payload>[] payload() default {};
}
```

### 2. The Validator Logic: `CourseCodeConstraintValidator.java`
```java
package com.luv2code.springboot.demo.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class CourseCodeConstraintValidator implements ConstraintValidator<CourseCode, String> {

    private String coursePrefix;

    @Override
    public void initialize(CourseCode theCourseCode) {
        coursePrefix = theCourseCode.value();
    }

    @Override
    public boolean isValid(String theCode, ConstraintValidatorContext context) {
        
        // Validation logic: If not null, must start with the prefix. If null, it's valid (let @NotNull handle nulls).
        if (theCode != null) {
            return theCode.startsWith(coursePrefix);
        } else {
            return true;
        }
    }
}
```

---

## 5. The Model (`Student.java`)

This maps directly to the HTML form fields. We apply our validation rules here using standard annotations like `@NotNull` and our custom `@CourseCode`.

```java
package com.luv2code.springboot.demo.model;

import com.luv2code.springboot.demo.validation.CourseCode;
import jakarta.validation.constraints.*;

import java.util.List;

public class Student {

    private String firstName; // Optional

    @NotNull(message="is required")
    @Size(min=1, message="is required")
    private String lastName; // Required

    private String country;
    private String favoriteLanguage;
    private List<String> favoriteSystems;

    @NotNull(message="is required")
    @Min(value=0, message="must be greater than or equal to zero")
    @Max(value=10, message="must be less than or equal to 10")
    private Integer freePasses; // Required, must be between 0 and 10

    @Pattern(regexp = "^[a-zA-Z0-9]{5}", message = "must be exactly 5 chars/digits")
    private String postalCode; // Optional, but if provided must be exactly 5 chars

    @CourseCode(value="TOPS", message="must start with TOPS")
    private String courseCode; // Uses our custom validator

    public Student() {}

    // --- Getters and Setters ---
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }
    public String getFavoriteLanguage() { return favoriteLanguage; }
    public void setFavoriteLanguage(String favoriteLanguage) { this.favoriteLanguage = favoriteLanguage; }
    public List<String> getFavoriteSystems() { return favoriteSystems; }
    public void setFavoriteSystems(List<String> favoriteSystems) { this.favoriteSystems = favoriteSystems; }
    public Integer getFreePasses() { return freePasses; }
    public void setFreePasses(Integer freePasses) { this.freePasses = freePasses; }
    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }
    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }
}
```

---

## 6. The Controller (`StudentController.java`)

The controller binds the form options from `application.properties`, provides the empty `Student` object to the form, and processes the POST request checking for `@Valid` errors. It also uses an `@InitBinder` to fix whitespace issues.

```java
package com.luv2code.springboot.demo.controller;

import com.luv2code.springboot.demo.model.Student;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class StudentController {

    // 1. Inject UI values from application.properties
    @Value("${countries}")
    private List<String> countries;

    @Value("${languages}")
    private List<String> languages;

    @Value("${systems}")
    private List<String> systems;

    // 2. Pre-process all web requests to remove leading/trailing whitespace.
    // If a string only has whitespace, trim it to null to ensure @NotNull catches it!
    @InitBinder
    public void initBinder(WebDataBinder dataBinder) {
        StringTrimmerEditor stringTrimmerEditor = new StringTrimmerEditor(true);
        dataBinder.registerCustomEditor(String.class, stringTrimmerEditor);
    }

    // 3. Show the Form
    @GetMapping("/")
    public String showForm(Model theModel) {
        // Create an empty Student object for the form to bind to
        theModel.addAttribute("student", new Student());

        // Add dropdown/radio/checkbox options
        theModel.addAttribute("countries", countries);
        theModel.addAttribute("languages", languages);
        theModel.addAttribute("systems", systems);

        return "student-form";
    }

    // 4. Process the Form Submission
    @PostMapping("/processForm")
    public String processForm(
            @Valid @ModelAttribute("student") Student theStudent,
            BindingResult theBindingResult, 
            Model theModel) {

        // Log the result to the server console
        System.out.println("Processing student: " + theStudent.getFirstName() + " " + theStudent.getLastName());
        System.out.println("Binding results: " + theBindingResult.toString());

        // If there are validation errors, send them back to the form
        if (theBindingResult.hasErrors()) {
            // Need to re-populate the dropdowns/radios/checkboxes because we are rendering the form again
            theModel.addAttribute("countries", countries);
            theModel.addAttribute("languages", languages);
            theModel.addAttribute("systems", systems);
            
            return "student-form"; 
        } else {
            // Success! Send them to the confirmation page
            return "student-confirmation";
        }
    }
}
```

---

## 7. Thymeleaf HTML Templates

Create these files in `src/main/resources/templates/`.

### `student-form.html`

Notice how we use `th:if="${#fields.hasErrors('fieldName')}"` to render the validation error texts directly below the inputs.

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Student Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .error { color: red; font-size: 0.9em; margin-left: 10px; }
    </style>
</head>
<body class="container mt-5">

    <div class="card p-4 shadow-sm w-75 mx-auto">
        <h3 class="mb-4">Student Registration Form</h3>
        <p class="text-muted"><i>Fields marked with (*) are required.</i></p>

        <!-- Form bound to the "student" ModelAttribute -->
        <form th:action="@{/processForm}" th:object="${student}" method="POST">

            <!-- Name -->
            <div class="mb-3">
                <label class="form-label">First name:</label>
                <input type="text" th:field="*{firstName}" class="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Last name (*):</label>
                <input type="text" th:field="*{lastName}" class="form-control d-inline w-75" />
                <span th:if="${#fields.hasErrors('lastName')}" th:errors="*{lastName}" class="error"></span>
            </div>

            <!-- Dropdown (Select) -->
            <div class="mb-3">
                <label class="form-label">Country:</label>
                <select th:field="*{country}" class="form-select">
                    <option th:each="tempCountry : ${countries}" th:value="${tempCountry}" th:text="${tempCountry}" />
                </select>
            </div>

            <!-- Radio Buttons -->
            <div class="mb-3">
                <label class="form-label">Favorite Programming Language:</label>
                <div class="form-check" th:each="tempLang : ${languages}">
                    <input type="radio" th:field="*{favoriteLanguage}" th:value="${tempLang}" class="form-check-input">
                    <label th:text="${tempLang}" class="form-check-label"></label>
                </div>
            </div>

            <!-- Checkboxes (Multiple Selection) -->
            <div class="mb-3">
                <label class="form-label">Favorite Operating Systems:</label>
                <div class="form-check" th:each="tempSystem : ${systems}">
                    <input type="checkbox" th:field="*{favoriteSystems}" th:value="${tempSystem}" class="form-check-input">
                    <!-- Note the single quotes handling spaces in application.properties -->
                    <label th:text="${tempSystem}" class="form-check-label"></label>
                </div>
            </div>

            <!-- Number Validation -->
            <div class="mb-3">
                <label class="form-label">Free Passes (0-10) (*):</label>
                <input type="text" th:field="*{freePasses}" class="form-control d-inline w-25" />
                <span th:if="${#fields.hasErrors('freePasses')}" th:errors="*{freePasses}" class="error"></span>
            </div>

            <!-- Regex Pattern Validation -->
            <div class="mb-3">
                <label class="form-label">Postal Code:</label>
                <input type="text" th:field="*{postalCode}" class="form-control d-inline w-50" placeholder="e.g. 1A2B3"/>
                <span th:if="${#fields.hasErrors('postalCode')}" th:errors="*{postalCode}" class="error"></span>
            </div>

            <!-- Custom Validation -->
            <div class="mb-3">
                <label class="form-label">Course Code (Must start with TOPS):</label>
                <input type="text" th:field="*{courseCode}" class="form-control d-inline w-50" />
                <span th:if="${#fields.hasErrors('courseCode')}" th:errors="*{courseCode}" class="error"></span>
            </div>

            <button type="submit" class="btn btn-primary w-100">Submit</button>
        </form>
    </div>

</body>
</html>
```

### `student-confirmation.html`

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Registration Success</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="container mt-5 text-center">

    <div class="alert alert-success d-inline-block px-5 py-4 w-75 shadow">
        <h2 class="display-5 text-success">Registration Confirmed!</h2>
        <hr>
        <p class="fs-4">Welcome, <strong th:text="${student.firstName + ' ' + student.lastName}"></strong>!</p>
        
        <ul class="list-group text-start">
            <li class="list-group-item"><strong>Country:</strong> <span th:text="${student.country}"></span></li>
            <li class="list-group-item"><strong>Language:</strong> <span th:text="${student.favoriteLanguage}"></span></li>
            <li class="list-group-item"><strong>Systems:</strong> 
                <span th:if="${student.favoriteSystems != null}" th:each="sys, iterStat : ${student.favoriteSystems}" 
                      th:text="${sys} + ${!iterStat.last ? ', ' : ''}"></span>
                <span th:unless="${student.favoriteSystems != null}">None Selected</span>
            </li>
            <li class="list-group-item"><strong>Passes:</strong> <span th:text="${student.freePasses}"></span></li>
            <li class="list-group-item"><strong>Postal Code:</strong> <span th:text="${student.postalCode}"></span></li>
            <li class="list-group-item"><strong>Course Code:</strong> <span th:text="${student.courseCode}"></span></li>
        </ul>

        <a th:href="@{/}" class="btn btn-primary mt-4">Register Another</a>
    </div>

</body>
</html>
```

---

## 8. Running & Testing

1. Bring up the application: `docker build -t mvc-forms . && docker run -p 8080:8080 mvc-forms`
2. Open your web browser and navigate to `http://localhost:8080/`
3. Hit "Submit" without filling anything out to trigger the validation errors on `lastName` and `freePasses`.
4. Enter an invalid postal code (e.g., "123") and an invalid course code (e.g., "MATH200") to see the Regex and Custom Validator in action.
