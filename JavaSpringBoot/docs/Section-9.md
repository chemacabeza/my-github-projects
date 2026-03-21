# Section 9: JPA / Hibernate Advanced Mappings

This guide provides a complete, copy-pasteable backend application that demonstrates advanced relational mappings in JPA/Hibernate. 

In a database, tables are rarely isolated. They relate to one another. Hibernate maps these relationships using annotations:
* **One-to-One:** e.g., An `Instructor` has exactly one `InstructorDetail` (profile).
* **One-to-Many & Many-to-One:** e.g., An `Instructor` teaches multiple `Course`s. One `Course` has multiple `Review`s.
* **Many-to-Many:** e.g., A `Student` enrolls in many `Course`s, and a `Course` has many `Student`s.

By following this guide, you will build a runnable application, fully containerized via Docker.

## 1. Project Setup (Maven `pom.xml`)

We need Spring Data JPA to talk to the database, and the PostgreSQL driver. Since this is purely a database mapping tutorial, we don't strictly *need* Spring Web, but it's often included.

```xml
    <dependencies>
        <!-- Spring Boot Starter for JPA (includes Hibernate) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>

        <!-- PostgreSQL Database Driver -->
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>
    </dependencies>
```

---

## 2. Docker Setup (Mac & Ubuntu)

Place these files in your project root to spin up the PostgreSQL database. 

### `docker-compose.yml`

```yaml
version: '3.8'

services:
  db:
      image: postgres:15-alpine
      container_name: advanced_jpa_db
      environment:
        POSTGRES_USER: hbstudent
        POSTGRES_PASSWORD: hbstudent
        POSTGRES_DB: hb_advanced_mappings
      ports:
        - "5432:5432"
      volumes:
        - pg_advanced_jpa_data:/var/lib/postgresql/data

  app:
    build: .
    container_name: advanced_jpa_app
    depends_on:
      - db
    environment:
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/hb_advanced_mappings

volumes:
  pg_advanced_jpa_data:
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
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 3. Configuration (`application.properties`)

Provides the DB connection details. We use `ddl-auto=update` to let Hibernate generate all the tricky association tables and foreign keys automatically based on our `@Entity` classes!

```properties
spring.datasource.url=${SPRING_DATASOURCE_URL:jdbc:postgresql://localhost:5432/hb_advanced_mappings}
spring.datasource.username=hbstudent
spring.datasource.password=hbstudent

# Automatically create the required tables and foreign key constraints
spring.jpa.hibernate.ddl-auto=update

# Show SQL queries in the console for learning purposes
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

---

## 4. The Entity Classes (The Mappings)

Create these classes in `src/main/java/com/luv2code/springboot/demo/entity/`.

### 1. `InstructorDetail.java` (The child in a One-to-One)
```java
package com.luv2code.springboot.demo.entity;

import jakarta.persistence.*;

@Entity
@Table(name="instructor_detail")
public class InstructorDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name="youtube_channel")
    private String youtubeChannel;

    @Column(name="hobby")
    private String hobby;

    // Bi-directional mapping back to Instructor. 
    // "mappedBy" means Instructor owns the foreign key column.
    // Cascade everything except DELETE, so deleting details doesn't delete the instructor.
    @OneToOne(mappedBy = "instructorDetail", 
              cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    private Instructor instructor;

    public InstructorDetail() {}

    public InstructorDetail(String youtubeChannel, String hobby) {
        this.youtubeChannel = youtubeChannel;
        this.hobby = hobby;
    }

    // Getters / Setters omitted for brevity... (Auto-generate these in your IDE)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getYoutubeChannel() { return youtubeChannel; }
    public void setYoutubeChannel(String youtubeChannel) { this.youtubeChannel = youtubeChannel; }
    public String getHobby() { return hobby; }
    public void setHobby(String hobby) { this.hobby = hobby; }
    public Instructor getInstructor() { return instructor; }
    public void setInstructor(Instructor instructor) { this.instructor = instructor; }

    @Override
    public String toString() {
        return "InstructorDetail{id=" + id + ", youtubeChannel='" + youtubeChannel + "', hobby='" + hobby + "'}";
    }
}
```

### 2. `Instructor.java` (One-to-One & One-to-Many)
```java
package com.luv2code.springboot.demo.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name="instructor")
public class Instructor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String firstName;
    private String lastName;
    private String email;

    // ONE-TO-ONE: The instructor "owns" the foreign key column "instructor_detail_id" in the DB.
    // CascadeType.ALL means deleting an instructor ALSO deletes their detail profile.
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "instructor_detail_id")
    private InstructorDetail instructorDetail;

    // ONE-TO-MANY: One instructor teaches many courses. 
    // FetchType.LAZY (default) means courses are only loaded if explicitly requested.
    @OneToMany(mappedBy = "instructor", fetch = FetchType.LAZY,
               cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
    private List<Course> courses;

    public Instructor() {}

    public Instructor(String firstName, String lastName, String email) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
    }

    // Convenience method for bi-directional relationship
    public void add(Course tempCourse) {
        if (courses == null) {
            courses = new ArrayList<>();
        }
        courses.add(tempCourse);
        tempCourse.setInstructor(this); // Setup reverse link
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
    public InstructorDetail getInstructorDetail() { return instructorDetail; }
    public void setInstructorDetail(InstructorDetail instructorDetail) { this.instructorDetail = instructorDetail; }
    public List<Course> getCourses() { return courses; }
    public void setCourses(List<Course> courses) { this.courses = courses; }

    @Override
    public String toString() {
        return "Instructor{id=" + id + ", firstName='" + firstName + "'}";
    }
}
```

### 3. `Course.java` (Many-to-One, One-to-Many, Many-to-Many)
```java
package com.luv2code.springboot.demo.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name="course")
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String title;

    // MANY-TO-ONE: Many courses belong to one Instructor.
    @ManyToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
    @JoinColumn(name="instructor_id")
    private Instructor instructor;

    // ONE-TO-MANY: One course has many Reviews.
    // CascadeType.ALL: Deleting a course deletes all its reviews!
    @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "course_id")
    private List<Review> reviews;

    // MANY-TO-MANY: Courses have many students, students have many courses.
    // Requires a @JoinTable to act as the intermediate link in the database.
    @ManyToMany(fetch = FetchType.LAZY, 
                cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
    @JoinTable(
            name = "course_student",                      // Name of the intermediate table
            joinColumns = @JoinColumn(name = "course_id"), // The column for THIS entity
            inverseJoinColumns = @JoinColumn(name = "student_id") // The column for the OTHER entity
    )
    private List<Student> students;

    public Course() {}
    public Course(String title) { this.title = title; }

    // Convenience Methods
    public void addReview(Review theReview) {
        if (reviews == null) { reviews = new ArrayList<>(); }
        reviews.add(theReview);
    }

    public void addStudent(Student theStudent) {
        if (students == null) { students = new ArrayList<>(); }
        students.add(theStudent);
    }

    // Getters and Setters...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public Instructor getInstructor() { return instructor; }
    public void setInstructor(Instructor instructor) { this.instructor = instructor; }
    public List<Review> getReviews() { return reviews; }
    public void setReviews(List<Review> reviews) { this.reviews = reviews; }
    public List<Student> getStudents() { return students; }
    public void setStudents(List<Student> students) { this.students = students; }

    @Override
    public String toString() {
        return "Course{id=" + id + ", title='" + title + "'}";
    }
}
```

### 4. `Review.java`
```java
package com.luv2code.springboot.demo.entity;

import jakarta.persistence.*;

@Entity
@Table(name="review")
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String comment;

    public Review() {}
    public Review(String comment) { this.comment = comment; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    @Override
    public String toString() {
        return "Review{id=" + id + ", comment='" + comment + "'}";
    }
}
```

### 5. `Student.java` (Many-to-Many Inverse Side)
```java
package com.luv2code.springboot.demo.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "student")
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String firstName;
    private String lastName;
    private String email;

    // MANY-TO-MANY (Inverse Side)
    @ManyToMany(fetch = FetchType.LAZY,
                cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.DETACH, CascadeType.REFRESH})
    @JoinTable(
            name = "course_student",
            joinColumns = @JoinColumn(name = "student_id"), // Note: Flipped from the Course class!
            inverseJoinColumns = @JoinColumn(name = "course_id")
    )
    private List<Course> courses;

    public Student() {}
    public Student(String firstName, String lastName, String email) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
    }

    public void addCourse(Course theCourse) {
        if (courses == null) { courses = new ArrayList<>(); }
        courses.add(theCourse);
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
    public List<Course> getCourses() { return courses; }
    public void setCourses(List<Course> courses) { this.courses = courses; }
}
```

---

## 5. Fetching Lazy Data via DAO `JOIN FETCH`

Because Collections (`@OneToMany`, `@ManyToMany`) default to `FetchType.LAZY`, calling `getCostumes()` or `getCourses()` outside of an active Hibernate transaction will throw a `LazyInitializationException`.

To solve this, we write a DAO method that uses **`JOIN FETCH`** in a JPQL query to load the Instructor AND their lazy Courses in a single hit to the DB.

### `AppDAOImpl.java`
```java
package com.luv2code.springboot.demo.dao;

import com.luv2code.springboot.demo.entity.Instructor;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;

@Repository
public class AppDAOImpl {

    private EntityManager entityManager;

    public AppDAOImpl(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    // Solves the LAZY fetch issue by forcing a JOIN FETCH query
    public Instructor findInstructorByIdJoinFetch(int theId) {
        
        TypedQuery<Instructor> query = entityManager.createQuery(
                "select i from Instructor i "
                    + "JOIN FETCH i.courses "
                    + "JOIN FETCH i.instructorDetail "
                    + "where i.id = :data", Instructor.class);
        
        query.setParameter("data", theId);
        
        return query.getSingleResult(); // Returns Instructor with Courses fully loaded
    }
}
```

---

## 6. Testing

1. Bring up the stack: `docker compose up --build -d`
2. Since `spring.jpa.hibernate.ddl-auto=update` is set, Hibernate will automatically connect to PostgreSQL and generate the `instructor`, `instructor_detail`, `course`, `review`, `student`, and `course_student` tables with all the correct Foreign Keys!
3. You can verify this by looking at your Docker logs (`docker logs advanced_jpa_app`) to see the Hibernate `CREATE TABLE` and `ALTER TABLE ADD CONSTRAINT` statements in action.
