# My Spring Boot Notes

Links:
* https://docs.spring.io/spring-boot/appendix/application-properties/index.html
* https://docs.spring.io/spring-boot/reference/features/logging.html#page-title

## Logging levels (https://docs.spring.io/spring-boot/reference/features/logging.html)

In the file `application.properties` or `application.yml` you can configure the Logging level using the following syntax:

```txt
logging.level.<the package name>=<LOGGING_LEVEL>
logging.level.org.springframework=DEBUG
logging.level.org.hibernate=TRACE
...
```

Where the LOGGING_LEVEL can be one of:
* TRACE
* DEBUG
* INFO
* WARN
* ERROR
* FATAL
* OFF

## Lazy initialization

There are 2 ways to initialize a class on a lazy way.

You can add the annotation `@Lazy` to every single class that needs to be created on a lazy way.

Or you can use the following property in the `application.properties` file to have all beans as lazy:

```txt
spring.main.lazy-initialization=true
```

Advantages of lazy initialization:
* The start of the application will be faster

Disadvantages of lazy initialization:
* You might discover configuration issues late
* Rest Controllers will not be created until the request is performed
* If you have too many beans you might run into memory issues.

## Spring Bean Scopes

* `singleton`: Create a single shared instance of the bean. Default scope.
* `prototype`: Creates a new bean instance for each container request.

```java
@Component
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class CricketCoach implements Coach {
...
}
```

* `request`: Scoped to an HTTP web request. Only used for web apps.
* `session`: Scoped to an HTTP web session. Only used for web apps.
* `application`: Scoped to a web app ServletContext. Only used for web apps.
* `websocket`: Scoped to a web socket. Only used for web apps.

## Bean Lifecycle Methods

```java
@Component
public class CricketCoach implements Coach {

    public CricketCoach () {
        // Some code here
    }

    /*
     * This method is executed after the constructor
     */
    @PostConstruct
    public void doMyStartupStuff() {
        System.out.println("In doMyStartupStuff(): " + getClass().getSimpleName());
    }


    /*
     * This method is executed before the destructor
     */
    @PreDestroy
    public void doMyCleanupStuff() {
        System.out.println("In doMyCleanupStuff(): " + getClass().getSimpleName());
    }
}
```

## EntityManager vs JpaRepository

In simple terms:
* Use `EntityManager` if you need low-level control and flexibility.
* Use `JpaRepository` if you want a high-level of abstraction.

Use case:
* `EntityManager`
    * Need low-level control over the database operations and want to write custom queries.
    * Provides low-level access to JPA and work directly with JPA entities.
    * Complex queries that required advanced features such as native SQL queries or store procedure calls.
    * When you have custom requirements that are not easily handled by high-level abstractions.
* `JpaRepository`
    * Provides commonly used CRUD operations out of the box, reducing the amount of code you need to write.
    * Additional features as pagination, sorting.
    * Generate queries based on method names.
    * Can also create custom queries using `@Query`.

## Using JPQuery

When using JPQL (Java Persistence Query Language) you need to use the names of the java classes, for example let's say we do have the following class:

```java

public class Student {
   private int id;
   private String firstName;
   private String lastName;
   private String email;
}
```

To use JPQL to find an object Student whose last name is `Doe` we would need to use the following code:

```java
TypedQuery<Student> theQuery = entityManager.createQuery("FROM Student WHERE lastName='Doe'", Student.class);
List<Strudent> students = theQuery.getResultList();
```

Pay attention that we are not using the information of the database but the information in the Java code. The `lastName` is the name of the field of the JPA Entity `Student`.

Let's say we want to use JPQL to retrieve from the database `Student` objects whose `lastName` is a parameter:

```java
public List<Student> findByLastName(String theLastName) {
    TypedQuery<Student> theQuery = entityManager.createQuery("FROM Student WHERE lastName=:theData", Student.class);
    theQuery.setParameter("theData", theLastName);
    return theQuery.getResultList();
}
```

Pay attention to the "parameter" "`theData`". When used in the query on the first line of the method "`findByLastName`" it needs to be preceeded with a colon "`:`". Then when you set it as parameter on the second line of the method "`findByLastName`" it needs to be used WITHOUT the colon.

## How to update an entity object?

In the past sections we saw how to retrieve objects from the database we needed to use some code like the following:

```java
// Here we are retrieving the Student object with a primary key of "1"
Student theStudent = entityManager.find(Student.class, 1);

// Change first name to "Scooby"
theStudent.setFirstName("Scooby");

// UPDATE THE ENTITY
entityManager.merge(theStudent);
```

You can always use JPQL to update the objects in your database. For example, let's say we want to update all the "`lastName`" of every single row of the "`student`" table to "`Tester`".

We can do this update by using the following code:

```java
int numRowsUpdated = entityManager.createQuery(
                           "UPDATE Student SET lastName='Tester'")
                           .executeUpdate();
```

Let's see the following example:

```java
public class StudentDAOImpl implements StudentDAO {

    private EntityManager entityManager;
    //...

    @Override
    @Transactional
    public void update(Student theStudent) {
        entityManager.merge(theStudent);
    }

}
```

Just bear in mind that, as we are **updating** an entry of the database we are required to use the annotation "`@Transactional`". If we were just reading information from the database we don't have the need to use the "`@Transactional`" annotation.

