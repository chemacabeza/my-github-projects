## Section 4: REST CRUD APIs

### Java JSON Data Binding
* Data binding is the process of converting JSON data to a Java POJO.
* Spring Boot uses Jackson behind the scenes.
* By default, Jackson will call the appropriate getter/setter method.

Let's say you want to pass a "parameter" in your URL. 

Let's say you want to create a new endpoint that given a student id will retrieve from your service. For that you need to use the annotation `@PathVariable` in the method of your endpoint. 

```java
@RestController
@RequestMapping("/api")
public class StudentRestController {
    // define endpoint for "/students/{studentId}" - return student at index
    @GetMapping("/students/{studentId}")
    public Student getStudent(@PathVariable int studentId) {
        List<Student> theStudents = new ArrayList<>();
        // populate theStudents
        ...

        return theStudents.get(studentId);
    }
}
```


### Exception Handling

* Step 1: Create custom error response class

```java
public class StudentErrorResponse {
    private int status;
    private String message;
    private long timeStamp;

    // constructors

    // getters / setters

}
```

* Step 2: Create custom studen exception
    * The custom student exception will be used by our REST service
    * In our code, if we can't find the student, then we'll throw an exception.
    * Need to define a custom student exception class.
        * `StudentNotFoundException`

```java
public class StudentNotFoundException extends RuntimeException {
    public StudentNotFoundException(String message) {
        super(message);
    }
}
```

* Step 3: Update REST service to throw exception

```java
@RestController
@RequestMapping("/api")
public class StudentRestController {
    // define endpoint for "/students/{studentId}" - return student at index
    @GetMapping("/students/{studentId}")
    public Student getStudent(@PathVariable int studentId) {
        
        // check studentId against list size

        if ( (studentId >= theStudents.size()) || (studentId < 0) ) {
            throw new StudentNotFoundException("Student id not found - " + studentId);
        }

        return theStudents.get(studentId);
    }
}
```

* Step 4: Add exception handler method
    * Define exception handler method(s) with `@ExceptionHandler` annotation.
    * Exception handler will return a `ResponseEntity`
    * `ResponseEntity` is a wrapper for the HTTP response object
    * `ResponseEntity` provides fine-grained control to specify:
        * HTTP status code, HTTP headers and Response body


```java
@RestController
@RequestMapping("/api")
public class StudentRestController {
    // define endpoint for "/students/{studentId}" - return student at index
    @GetMapping("/students/{studentId}")
    public Student getStudent(@PathVariable int studentId) {
        
        // check studentId against list size

        if ( (studentId >= theStudents.size()) || (studentId < 0) ) {
            throw new StudentNotFoundException("Student id not found - " + studentId);
        }

        return theStudents.get(studentId);
    }

    @ExceptionHandler
    public ResponseEntity<StudentErrorResponse> handleException(StudentNotFoundException exc) {
        StudenErrorResponse error = new StudentErrorResponse();

        error.setStatus(HttpStatus.NOT_FOUND.value());
        error.setMessage(exc.getMessage());
        error.setTimeStamps(System.currentTimeMillis());

        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }
}
```

The problem that we face with this approach are:
* Exception handler code is only for the specific REST controller
* Can't be reused by other controllers
* We need **global** exception handlers
    * Promotes reused
    * Centralizes exception handling

For this we should use Spring `@ControllerAdvice`:
    * `@ControllerAdvice` is similar to an interceptor / filter
    * Pre-process request to controllers
    * Post-process responses to handle exceptions
    * PERFECT for global exception handling

When we use `@ControllerAdvice` we need to create a single class like the following:

```java
@ControllerAdvice
public class StudentRestExceptionHandler {

    // add exception handling code here

    @ExceptionHandler
    public ResponseEntity<StudentErrorResponse> handleException(StudentNotFoundException exc) {

        // create a StudentErrorResponse

        StudentErrorResponse error = new StudentErrorResponse();

        error.setStatus(HttpStatus.NOT_FOUND.value());
        error.setMessage(exc.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        // return ResponseEntity

        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }

    // add another exception handler ... to catch any exception (catch all)

    @ExceptionHandler
    public ResponseEntity<StudentErrorResponse> handleException(Exception exc) {

        // create a StudentErrorResponse
        StudentErrorResponse error = new StudentErrorResponse();

        error.setStatus(HttpStatus.BAD_REQUEST.value());
        error.setMessage(exc.getMessage());
        error.setTimeStamp(System.currentTimeMillis());

        // return ResponseEntity
        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }
}
```

### Service Layer ("`@Service`" annotation)

Purpose of the Service Layer:
* **Service Facade** design patern
* Intermediate layer for *custom business logic*
* Integrate data from multiple sources (DAO/repositories)

Specialized annotation for Services
* Spring provides the "`@Service`" annotation
    * This annotation is an alias for the "`@Component`" annotation
* "`@Service`" applied to Service implementations
* Spring will automatically register the Service implementation
    * thanks to component-scanning

Just remember that the "`@Component`" annotation has another aliases such as:
* "`@RestController`"
* "`@Repository`"
* "`@Service`"

Service Layer - Best Practice
* Best practice is to apply transactional boundaries at the service layer
* It is the service layer's responsibility to manage transaction boundaries
* For implementation code:
    * Apply "`@Transactional`" on service methods
    * Remove "`@Transactional`" on DAO methods if they already exist

The way it works is a client sends a HTTP REST call to a controller ("`EmployeeRestController`) which delegates the work to a service ("`EmployeeService`") the service is charge of the transactions, so this means that you need to use here the annotation "`@Transactional`"  in the methods that modify the database, and the service will use the DAO layer ("`EmployeeDAO`") to modify the database or to retrieve information from the database.

### Reusing code so that I don't have to write all the code again per entity

Let's say we have created some code to do CRUD with some entities like "`Student`" or "`Employee`"... You would like to redo all the work again for new types of entities, for that you can use Spring Data JPA as a solution.

Create a DAO and just plug in your **entity type** and **primary key** and Spring will give you a CRUD implementation for FREE. This helps us to minimize boiler-plate DAO code. 

**JpaRepository**
* Spring Data JPA provides the interface "`JpaRepository`"
* Exposes methods (some by inheritance from parents)

The development process is as follows:
1. Extend "`JpaRepository`" interface
2. Use your repository in your app
    * There is no need for implementation class

An example:

```java
//                                                      Entity type  Primary key
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {

//...

}
```

Spring Data JPA has some advanced features:
* Advanced features available for:
    * Extending and adding custom queries with JPQL
    * Query Domain Specific Language (Query DSL)
    * Defining custom methods (low-level coding). More information in <a href="https://docs.spring.io/spring-data/jpa/reference/jpa/query-methods.html#jpa.query-methods.at-query">this link</a>.

In the same way that we can use the interface "`JpaRepository`" to create a different repository for other entities... is it possible to do it with REST APIs? The answer is YES you need to use the project "Spring Data REST".

### Spring Data REST

* **Spring Data REST** is the solution!
* Leverages your existing "`JpaRepository`"
* Spring will give you a REST CRUD implementation for FREE .... like MAGIC!
    * Helps to minimize boiler-plate REST code
    * No new coding required

For example for the entity "`Employee`" we created the following endpoints:

| HTTP Method | endpoint | CRUD Action |
| :----: | :---- | :---- |
| `POST` | `/employees` | Create a new employee |
| `GET` | `/employees` | Read a list of employees |
| `GET` | `/employees/{employeeId}` | Read a single employee |
| `PUT` | `/employees/{employeeId}` | Update an existing employee |
| `DELETE` | `/employees/{employeeId}` | Delete an existing employee |

How does it work on the background?
* Spring Data REST will scan your project for "`JpaRepository`"
* Expose REST APIs for each entity type for your "`JpaRepository`"

For example, previously we created this repository class:

```java
//                                                      Entity type  Primary key
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {

//...

}
```

REST endpoints:
* By default, Spring Data REST will create endpoints based on entity type
* Simple pluralized form 
    * First character of Entity type is lowercase
    * Then just adds an "s" to the entity
       * So this means that the class "`Employee`" (which is singular) will create a set of endpoints that will start with "`/employees`" (which is plural)

Development process:
1. Add Spring Data REST to your Maven POM file

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-rest</artifactId>
</dependency>
```

2. And that's it! Absolutely NO CODING required

In a Nutshell you only need 3 items:
1. Your entity: "`Employee`"
2. JpaRepository: "`EmployeeRepository extends JpaRepository`"
3. Maven POM dependency for: "`spring-boot-starter-data-rest`"

Before Spring Data REST we had:
* `EmployeeRestController`
* `EmployeeService`
* `EmployeeServiceImpl`

After Spring Data REST we have:
* "`Employee`"
* "`EmployeeRepository`"
* Spring Data REST will give us the functionality of the controller and the service for free.
* And that's it!

**HATEOAS** (<a href="https://spring.io/projects/spring-hateoas">https://spring.io/projects/spring-hateoas</a>
* Spring Data REST endpoints are HATEOAS compliant
    * **HATEOAS**: **H**permedia **a**s **t**he **E**ngine **o**f **A**pplication **S**tate
* Hypermedia-driven sites provide information to access REST interfaces
    * Think of it as meta-data for REST data

* Spring Data REST response using HATEOAS
* For example REST response from: "`GET /employees/3`" will return something like the following:

```json
{
    "firstName": "Avani",
    "lastName": "Gupta",
    "email": "avani@luv2code.com",
    "_links": {
        "self": {
            "href": "http://localhost:8080/employees/3"
        },
        "employee": {
            "href": "http://localhost:8080/employees/3"
        }
    }
}
```

* For a collection, meta-data includes page size, total elements, pages etc
* For example REST response from: "`GET /employees`"

```json
{
    "_embedded": {
        "employees": [
            {
                "firstName": "Leslie",
                ///...
            },
            ///...
        ]
    },
    "page": {
        "size": 20,
        "totalElements": 5,
        "totalPages": 1,
        "number": 0
    }
}
```

* HATEOAS uses Hypertext Application Language (HAL) data format.

In the case that you wanted to expose a different endpoint name you could use the following annotation:


```java
//                                                      Entity type  Primary key
@RepositoryRestResource(path="members")
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {

//...

}
```

Spring Data REST Configuration (<a href="https://docs.spring.io/spring-boot/appendix/application-properties/index.html">https://docs.spring.io/spring-boot/appendix/application-properties/index.html</a>)
* Following properties available: "`application.properties`"

| Name | Description |
| :--- | :--- |
| `spring.data.rest.base-path` | Base path used to expose repository resources |
| `spring.data.rest.default-page-size` | Default size of pages |
| `spring.data.rest.max-page-size` | Maximum size of pages |
| ... | ... |

