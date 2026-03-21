# Spring Boot Project Catalog

> Complete guide to 70+ Spring Boot projects organized by learning path

---

## 🌟 Recommended Starting Points

### For REST API Development
**Project:** [Employee REST CRUD - List Employees](spring-boot-3-spring-6-hibernate-for-beginners-main/04-spring-boot-rest-crud/07-spring-boot-rest-crud-employee-list-employees/)

**What it demonstrates:** Complete CRUD REST API with layered architecture, exception handling, and JPA repository

**Quick Start:** [REST CRUD Guide](docs/quickstart-rest-crud.md)

**Key Features:**
- Full CRUD operations (Create, Read, Update, Delete)
- Layered architecture (Controller → Service → Repository)
- Spring Data JPA
- Global exception handling
- Proper HTTP status codes

---

### For Spring Security
**Project:** [REST Security - JDBC BCrypt](spring-boot-3-spring-6-hibernate-for-beginners-main/05-spring-boot-rest-security/05-spring-boot-rest-security-jdbc-bcrypt/)

**What it demonstrates:** Database authentication with BCrypt password hashing and role-based authorization

**Quick Start:** [Security Guide](docs/quickstart-security.md)

**Key Features:**
- JDBC authentication with database
- BCrypt password encryption
- Role-based authorization (EMPLOYEE, MANAGER, ADMIN)
- Method-level security
- Custom login/logout

---

### For Full-Stack MVC
**Project:** [Spring MVC CRUD - Employee Directory](spring-boot-3-spring-6-hibernate-for-beginners-main/07-spring-boot-spring-mvc-crud/)

**What it demonstrates:** Complete web application with Thymeleaf templates, form handling, and database persistence

**Quick Start:** [MVC CRUD Guide](docs/quickstart-mvc-crud.md)

**Key Features:**
- Thymeleaf templates and forms
- Bootstrap UI styling
- CRUD operations via web interface
- Form validation
- Session management

---

### For Advanced Persistence
**Project:** [JPA Advanced Mappings](spring-boot-3-spring-6-hibernate-for-beginners-main/09-spring-boot-jpa-advanced-mappings/)

**What it demonstrates:** One-to-Many, Many-to-Many relationships, cascading, and fetch strategies

**Quick Start:** [JPA Mappings Guide](docs/quickstart-jpa-mappings.md)

**Key Features:**
- One-to-One mappings
- One-to-Many (bi-directional)
- Many-to-Many relationships
- Cascade types
- Lazy vs Eager fetching
- Join tables

---

### For Cross-Cutting Concerns
**Project:** [AOP - Aspect-Oriented Programming](spring-boot-3-spring-6-hibernate-for-beginners-main/10-spring-boot-aop/)

**What it demonstrates:** Aspect-Oriented Programming for logging, security, and transaction management

**Quick Start:** [AOP Guide](docs/quickstart-aop.md)

**Key Features:**
- Before/After/Around advice
- Pointcut expressions
- Join points
- Logging aspects
- Exception handling aspects
- Performance monitoring

---

## All Projects by Section

### Section 1: Spring Boot Overview (6 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/01-spring-boot-overview/`

| Project | Key Concepts | Difficulty |
|---------|-------------|-----------|
| 01-spring-boot-demo | Basic Spring Boot app | ⭐ Beginner |
| 02-dev-tools-demo | DevTools for hot reload | ⭐ Beginner |
| 03-actuator-demo | Spring Boot Actuator | ⭐ Beginner |
| 04-actuator-security | Securing actuator endpoints | ⭐⭐ Intermediate |
| 05-command-line-demo | CommandLineRunner | ⭐ Beginner |
| 06-properties-demo | External configuration | ⭐ Beginner |

**Section Focus:** Understanding Spring Boot fundamentals, auto-configuration, and development tools.

---

### Section 2: Spring Core (9 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/02-spring-boot-spring-core/`

| Project | Key Concepts | Difficulty |
|---------|-------------|-----------|
| 01-constructor-injection | Constructor injection | ⭐⭐ Intermediate |
| 02-component-scanning | Component scanning | ⭐⭐ Intermediate |
| 03-setter-injection | Setter injection | ⭐⭐ Intermediate |
| 04-qualifiers | @Qualifier annotation | ⭐⭐ Intermediate |
| 05-primary | @Primary annotation | ⭐⭐ Intermediate |
| 06-lazy-initialization | Lazy initialization | ⭐⭐ Intermediate |
| 07-bean-scopes | Bean scopes (singleton, prototype) | ⭐⭐ Intermediate |
| 08-bean-lifecycle-methods | Init and destroy methods | ⭐⭐ Intermediate |
| 09-java-config-bean | Java configuration | ⭐⭐ Intermediate |

**Section Focus:** Dependency Injection, Inversion of Control, bean lifecycle, and configuration patterns.

---

### Section 3: Hibernate/JPA CRUD (9 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/03-spring-boot-hibernate-jpa-crud/`

| Project | Key Concepts | Difficulty |
|---------|-------------|-----------|
| 01-cruddemo-student | Create Student entity | ⭐⭐ Intermediate |
| 02-cruddemo-student-create | Create operation | ⭐⭐ Intermediate |
| 03-cruddemo-student-read | Read operation | ⭐⭐ Intermediate |
| 04-cruddemo-student-query | JPQL queries | ⭐⭐ Intermediate |
| 05-cruddemo-student-update | Update operation | ⭐⭐ Intermediate |
| 06-cruddemo-student-delete | Delete operation | ⭐⭐ Intermediate |
| 07-cruddemo-student-create-db-tables | Auto table creation | ⭐⭐ Intermediate |

**Section Focus:** JPA entities, EntityManager, CRUD operations, JPQL queries.

---

### Section 4: REST CRUD APIs (17 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/04-spring-boot-rest-crud/`

| Project | Key Concepts | Difficulty |
|---------|-------------|-----------|
| 01-spring-boot-rest-crud-hello-world | Basic REST endpoint | ⭐ Beginner |
| 02-spring-boot-rest-crud-student | REST with list data | ⭐⭐ Intermediate |
| 03-spring-boot-rest-crud-student-pathvariable | Path variables | ⭐⭐ Intermediate |
| 04-spring-boot-rest-crud-student-exception-handling | Exception handling | ⭐⭐⭐ Advanced |
| 05-spring-boot-rest-crud-employee | Employee CRUD | ⭐⭐⭐ Advanced |
| 06-spring-boot-rest-crud-employee-with-spring-data-jpa | Spring Data JPA | ⭐⭐⭐ Advanced |
| 07-spring-boot-rest-crud-employee-list-employees | **Complete REST CRUD** | ⭐⭐⭐ Advanced |
| 08-spring-boot-rest-crud-global-exception-handling | Global exception handler | ⭐⭐⭐ Advanced |
| 09-spring-boot-spring-data-rest | Spring Data REST | ⭐⭐ Intermediate |

**Section Focus:** RESTful API design, exception handling, Spring Data JPA, HATEOAS.

**Recommended:** Start with project 01, progress to 07 for complete implementation.

---

### Section 5: REST API Security (6 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/05-spring-boot-rest-security/`

| Project | Key Concepts | Difficulty |
|---------|-------------|-----------|
| 01-spring-boot-rest-security-employee-starter-code | Security starter | ⭐⭐ Intermediate |
| 02-spring-boot-rest-security-basic-inmemory | In-memory authentication | ⭐⭐ Intermediate |
| 03-spring-boot-rest-security-basic-users-roles | Basic roles | ⭐⭐ Intermediate |
| 04-spring-boot-rest-security-jdbc | JDBC authentication | ⭐⭐⭐ Advanced |
| 05-spring-boot-rest-security-jdbc-bcrypt | **BCrypt + JDBC** | ⭐⭐⭐ Advanced |
| 06-spring-boot-rest-security-jdbc-bcrypt-custom-table-names | Custom tables | ⭐⭐⭐ Advanced |

**Section Focus:** Spring Security, authentication, authorization, password encryption, role-based access.

**Recommended:** Progress from 02 (in-memory) to 05 (production-ready BCrypt).

---

### Section 6: Spring MVC (20 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/06-spring-boot-spring-mvc/`

| Project | Key Concepts | Difficulty |
|---------|-------------|-----------|
| 01-thymeleaf-demo-helloworld | Thymeleaf basics | ⭐ Beginner |
| 02-thymeleaf-demo-helloworld-css | CSS styling | ⭐ Beginner |
| 03-thymeleaf-demo-employees | Display employee list | ⭐⭐ Intermediate |
| 04-thymeleaf-demo-employees-starter-list | Starter code | ⭐⭐ Intermediate |
| validationdemo | Form validation | ⭐⭐⭐ Advanced |

**Section Focus:** Thymeleaf templates, model-view-controller pattern, form handling, validation.

---

### Section 7: Spring MVC CRUD (7 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/07-spring-boot-spring-mvc-crud/`

| Project | Key Concepts | Difficulty |
|---------|-------------|-----------|
| 00-spring-boot-spring-mvc-crud-starter-code/01-thymeleaf-demo-employees-list | Employee list display | ⭐⭐ Intermediate |
| 00-spring-boot-spring-mvc-crud-starter-code/02-thymeleaf-demo-employees-add | Add employee | ⭐⭐⭐ Advanced |
| 00-spring-boot-spring-mvc-crud-starter-code/03-thymeleaf-demo-employees-update | Update employee | ⭐⭐⭐ Advanced |
| 00-spring-boot-spring-mvc-crud-starter-code/04-thymeleaf-demo-employees-delete | Delete employee | ⭐⭐⭐ Advanced |

**Section Focus:** Complete CRUD operations through web interface, form handling, database integration.

**Recommended:** Follow projects 01 → 04 for full CRUD progression.

---

### Section 8: Spring MVC Security (13 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/08-spring-boot-spring-mvc-security/`

| Project | Key Concepts | Difficulty |
|---------|-------------|-----------|
| 01-spring-boot-spring-mvc-security-default | Default security | ⭐⭐ Intermediate |
| 02-spring-boot-spring-mvc-security-basic-inmemory | In-memory users | ⭐⭐ Intermediate |
| 03-spring-boot-spring-mvc-security-custom-login | Custom login page | ⭐⭐⭐ Advanced |
| 04-spring-boot-spring-mvc-security-logout | Logout functionality | ⭐⭐⭐ Advanced |
| 05-spring-boot-spring-mvc-security-jdbc-plain-text | JDBC plain text | ⭐⭐⭐ Advanced |
| 06-spring-boot-spring-mvc-security-jdbc-bcrypt | JDBC + BCrypt | ⭐⭐⭐ Advanced |
| 07-spring-boot-spring-mvc-security-user-roles | Role-based access | ⭐⭐⭐ Advanced |

**Section Focus:** Web application security, login/logout, role-based UI, JDBC authentication.

---

### Section 9: JPA Advanced Mappings (24 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/09-spring-boot-jpa-advanced-mappings/`

**Subsections:**
- **01-jpa-one-to-one-uni**: One-to-One unidirectional mapping
- **02-jpa-one-to-one-bi**: One-to-One bidirectional mapping
- **03-jpa-one-to-many**: One-to-Many mapping (Instructor → Courses)
- **04-jpa-one-to-many-find**: Finding with relationships
- **05-jpa-one-to-many-delete**: Cascade delete
- **06-jpa-fetch-types-eager-vs-lazy**: Fetch strategy comparison
- **07-jpa-one-to-many-bi**: Bidirectional One-to-Many
- **08-jpa-many-to-many**: Many-to-Many (Course ↔ Student)

| Mapping Type | Example | Difficulty |
|-------------|---------|-----------|
| One-to-One (Uni) | Instructor → InstructorDetail | ⭐⭐ Intermediate |
| One-to-One (Bi) | Instructor ↔ InstructorDetail | ⭐⭐⭐ Advanced |
| One-to-Many | Instructor → List<Course> | ⭐⭐⭐ Advanced |
| Many-to-Many | Course ↔ List<Student> | ⭐⭐⭐ Advanced |

**Section Focus:** Advanced JPA mappings, cascading, fetch strategies, bidirectional relationships.

---

### Section 10: AOP - Aspect-Oriented Programming (24 projects)

**Path:** `spring-boot-3-spring-6-hibernate-for-beginners-main/10-spring-boot-aop/`

**Subsections:**
- **01-spring-boot-aop-demo**: Basic AOP setup
- **02-spring-boot-aop-pointcut-declarations**: Pointcut expressions
- **03-spring-boot-aop-pointcut-combo**: Combining pointcuts
- **04-spring-boot-aop-order-aspects**: Aspect ordering
- **05-spring-boot-aop-read-joinpoint**: Reading join points
- **06-spring-boot-aop-after-returning**: @AfterReturning advice
- **07-spring-boot-aop-after-throwing**: @AfterThrowing advice
- **08-spring-boot-aop-after-finally**: @After advice
- **09-spring-boot-aop-around**: @Around advice
- **10-spring-boot-aop-around-handle-exception**: Exception handling in AOP

| Advice Type | Use Case | Difficulty |
|------------|----------|-----------|
| @Before | Pre-processing, logging | ⭐⭐ Intermediate |
| @AfterReturning | Post-processing, audit | ⭐⭐⭐ Advanced |
| @AfterThrowing | Exception handling | ⭐⭐⭐ Advanced |
| @After | Cleanup, finally block | ⭐⭐⭐ Advanced |
| @Around | Complete control, metrics | ⭐⭐⭐ Advanced |

**Section Focus:** Cross-cutting concerns, logging, security, transaction management, performance monitoring.

---

## Learning Paths

### Path 1: REST API Mastery (Backend Focus)

**Time to complete:** 4-6 weeks

1. **Start**: Hello World REST endpoint (Section 4, Project 01)
2. **Basics**: CRUD operations with hardcoded data (Section 4, Project 02-03)
3. **Exception Handling**: Global exception handlers (Section 4, Project 04, 08)
4. **Persistence**: JPA integration (Section 3, all projects)
5. **Architecture**: Service layer pattern (Section 4, Project 05-07)
6. **Security**: Authentication and authorization (Section 5, all projects)
7. **Advanced**: Spring Data REST (Section 4, Project 09)

**Final Project:** Employee REST CRUD with JDBC BCrypt security

---

### Path 2: Full-Stack Web Development (MVC Focus)

**Time to complete:** 4-6 weeks

1. **Start**: Spring MVC basics (Section 6, Project 01)
2. **Views**: Thymeleaf templates and CSS (Section 6, Project 02-03)
3. **Forms**: Data binding and validation (Section 6, validationdemo)
4. **CRUD**: Complete web application (Section 7, all projects)
5. **Security**: Login, logout, role-based access (Section 8, all projects)
6. **Polish**: Bootstrap integration, error pages

**Final Project:** Secure employee directory with full CRUD operations

---

### Path 3: Enterprise Patterns (Advanced)

**Time to complete:** 6-8 weeks

1. **Foundation**: Dependency Injection (Section 2, all projects)
2. **Architecture**: Layered design (Section 4, Projects 05-07)
3. **Persistence**: Advanced JPA Mappings (Section 9, all projects)
4. **AOP**: Aspect-Oriented Programming (Section 10, all projects)
5. **Security**: Role-based authorization (Section 5 + 8)
6. **Integration**: Combining all patterns

**Final Project:** Multi-module application with AOP logging, security, and complex data models

---

### Path 4: Quick Start for Experienced Developers

**Time to complete:** 1-2 weeks

Focus on these key projects:

1. **REST API**: Section 4, Project 07 (Employee REST CRUD)
2. **Security**: Section 5, Project 05 (JDBC BCrypt)
3. **MVC CRUD**: Section 7, all projects
4. **JPA Advanced**: Section 9, Many-to-Many projects
5. **AOP**: Section 10, @Around advice projects

**Goal:** Understand Spring Boot 3 patterns and best practices quickly

---

## Project Statistics

- **Total Projects:** 70+
- **Total Sections:** 10 + Appendix
- **Test Classes:** 133+
- **Lines of Code:** 15,000+ (estimated)
- **Technologies:** Spring Boot 3, Spring Framework 6, Hibernate 6, Spring Security, Thymeleaf
- **Databases:** MySQL, PostgreSQL, H2

---

## Quick Navigation

| Topic | Document |
|-------|----------|
| Spring Boot Overview, Spring Core, JPA/Hibernate CRUD | [docs/Sections-1-to-3.md](docs/Sections-1-to-3.md) |
| REST CRUD APIs | [docs/Section-4.md](docs/Section-4.md) |
| REST API Security | [docs/Section-5.md](docs/Section-5.md) |
| Spring MVC | [docs/Section-6.md](docs/Section-6.md) |
| Spring MVC CRUD | [docs/Section-7.md](docs/Section-7.md) |
| Spring MVC Security | [docs/Section-8.md](docs/Section-8.md) |
| JPA / Hibernate Advanced Mappings | [docs/Section-9.md](docs/Section-9.md) |
| AOP — Aspect-Oriented Programming | [docs/Section-10.md](docs/Section-10.md) |
| Spring Modulith — Introduction | [docs/SpringModulith-Introduction.md](docs/SpringModulith-Introduction.md) |
| Main README | [README.md](README.md) |
| Main Repository | [../README.md](../README.md) |

---

## How to Use This Catalog

### For Recruiters
- **Quick Assessment**: Review "Recommended Starting Points" section
- **Depth Evaluation**: Check section statistics and project counts
- **Quality Indicators**: Note test coverage (133+ tests), architecture patterns

### For Developers
- **Browse by Topic**: Navigate sections to find specific patterns
- **Follow Learning Path**: Use suggested paths based on your goals
- **Hands-on Learning**: Clone and run projects locally

### For Hiring Managers
- **Technical Breadth**: 10 sections covering enterprise Java stack
- **Production Patterns**: Security, testing, layered architecture
- **Continuous Learning**: Progression from basics to advanced concepts

---

## Technologies Summary

| Technology | Version | Usage |
|------------|---------|-------|
| Spring Boot | 3.x | Core framework |
| Spring Framework | 6.x | DI, AOP, MVC |
| Hibernate/JPA | 6.x | ORM, persistence |
| Spring Security | 6.x | Authentication, authorization |
| Thymeleaf | 3.x | Template engine |
| MySQL | 8.x | Production database |
| H2 | 2.x | In-memory testing |
| Maven | 3.6+ | Build tool |
| JUnit | 5.x | Testing framework |

---

**Last Updated:** 2026-02-06

**Note:** This catalog represents a comprehensive learning journey through modern Spring Boot development, from fundamentals to advanced enterprise patterns.
