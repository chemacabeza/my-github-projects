# Section 10: Aspect-Oriented Programming (AOP)

This guide provides a complete, copy-pasteable tutorial for using **Spring AOP**.

AOP allows you to modularize cross-cutting concerns—such as logging, security, and transaction management—without cluttering your core business logic. Instead of pasting logging code into every method, you define an "Aspect" that automatically intercepts method calls based on rules you define.

By following this guide, you will build a runnable Spring Boot Console Application, containerized via Docker.

## 1. Project Setup (Maven `pom.xml`)

We need the Spring Boot Starter for AOP.

```xml
    <dependencies>
        <!-- Spring Boot Starter -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <!-- Spring AOP -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-aop</artifactId>
        </dependency>
    </dependencies>
```

---

## 2. Docker Setup

Even though this is a console application that will execute and immediately exit, we can still containerize it for reproducibility.

### `docker-compose.yml`

```yaml
version: '3.8'

services:
  app:
    build: .
    container_name: aop_demo_app
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

## 3. The Core Business Logic (To be Intercepted)

Create these classes in your project. These contain standard business logic with **no logging code inside them**.

### `Account.java`
```java
package com.luv2code.aopdemo;

public class Account {
    private String name;
    private String level;

    public Account() {}
    public Account(String name, String level) {
        this.name = name;
        this.level = level;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }

    @Override
    public String toString() {
        return "Account{name='" + name + "', level='" + level + "'}";
    }
}
```

### `AccountDAO.java`
```java
package com.luv2code.aopdemo.dao;

import com.luv2code.aopdemo.Account;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class AccountDAO {

    public void addAccount(Account theAccount, boolean vipFlag) {
        System.out.println(getClass() + ": DOING MY DB WORK: ADDING AN ACCOUNT");
    }

    public List<Account> findAccounts(boolean tripWire) {
        // Simulate an exception if tripWire is true
        if (tripWire) {
            throw new RuntimeException("Simulated Database Exception! No accounts for you!");
        }

        List<Account> myAccounts = new ArrayList<>();
        myAccounts.add(new Account("John", "Silver"));
        myAccounts.add(new Account("Madhu", "Platinum"));
        myAccounts.add(new Account("Luca", "Gold"));

        return myAccounts;
    }
}
```

### `TrafficFortuneService.java`
```java
package com.luv2code.aopdemo.service;

import org.springframework.stereotype.Service;
import java.util.concurrent.TimeUnit;

@Service
public class TrafficFortuneService {

    public String getFortune(boolean tripWire) {
        if (tripWire) {
            throw new RuntimeException("Major highway accident! Highway closed!");
        }

        try {
            TimeUnit.SECONDS.sleep(2); // Simulate slow API call
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        return "Expect heavy traffic this morning";
    }
}
```

---

## 4. The AOP Aspects

Now we create Aspects to intercept calls to the classes above.

### `LuvAopExpressions.java` (Centralized Pointcuts)
A Pointcut defines *where* an advice should be applied. We centralize them here so multiple Aspects can reuse them.

```java
package com.luv2code.aopdemo.aspect;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;

@Aspect
public class LuvAopExpressions {

    // Match all methods in the dao package
    @Pointcut("execution(* com.luv2code.aopdemo.dao.*.*(..))")
    public void forDaoPackage() {}

    // Match all getter methods in the dao package
    @Pointcut("execution(* com.luv2code.aopdemo.dao.*.get*(..))")
    public void getter() {}

    // Match all setter methods in the dao package
    @Pointcut("execution(* com.luv2code.aopdemo.dao.*.set*(..))")
    public void setter() {}

    // Combine pointcuts: Include DAO package, but EXCLUDE getters and setters
    @Pointcut("forDaoPackage() && !(getter() || setter())")
    public void forDaoPackageNoGetterSetter() {}
}
```

### `MyDemoLoggingAspect.java` (The Advice)
This class actually performs the logging. We use `@Order` to guarantee execution sequence if multiple Aspects match the same method.

```java
package com.luv2code.aopdemo.aspect;

import com.luv2code.aopdemo.Account;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Aspect
@Component
@Order(2)
public class MyDemoLoggingAspect {

    // 1. @Before: Runs before the method executes. Great for auditing and reading arguments.
    @Before("com.luv2code.aopdemo.aspect.LuvAopExpressions.forDaoPackageNoGetterSetter()")
    public void beforeAddAccountAdvice(JoinPoint theJoinPoint) {
        System.out.println("\n=====>>> @Before: Executing advice");

        MethodSignature methodSignature = (MethodSignature) theJoinPoint.getSignature();
        System.out.println("Method: " + methodSignature);

        // Read and display method arguments
        Object[] args = theJoinPoint.getArgs();
        for (Object tempArg : args) {
            System.out.println("Argument: " + tempArg);
        }
    }

    // 2. @AfterReturning: Runs after successful execution. Can intercept and MODIFY the return data!
    @AfterReturning(
            pointcut = "execution(* com.luv2code.aopdemo.dao.AccountDAO.findAccounts(..))",
            returning = "result")
    public void afterReturningFindAccountsAdvice(JoinPoint theJoinPoint, List<Account> result) {
        System.out.println("\n=====>>> @AfterReturning: Method: " + theJoinPoint.getSignature().toShortString());
        
        // Post-process data: Convert all account names to uppercase before they reach the caller
        if (result != null) {
            for (Account tempAccount : result) {
                tempAccount.setName(tempAccount.getName().toUpperCase());
            }
        }
        System.out.println("=====>>> @AfterReturning: Modified result is: " + result);
    }

    // 3. @AfterThrowing: Runs if the method throws an exception. Great for alert logging.
    @AfterThrowing(
            pointcut = "execution(* com.luv2code.aopdemo.dao.AccountDAO.findAccounts(..))",
            throwing = "theExc")
    public void afterThrowingFindAccountsAdvice(JoinPoint theJoinPoint, Throwable theExc) {
        System.out.println("\n=====>>> @AfterThrowing: Method: " + theJoinPoint.getSignature().toShortString());
        System.out.println("=====>>> @AfterThrowing: Exception caught: " + theExc.getMessage());
    }

    // 4. @After: Runs REGARDLESS of success or failure (like a finally block).
    @After("execution(* com.luv2code.aopdemo.dao.AccountDAO.findAccounts(..))")
    public void afterFinallyFindAccountsAdvice(JoinPoint theJoinPoint) {
        System.out.println("\n=====>>> @After (finally): Method: " + theJoinPoint.getSignature().toShortString());
    }

    // 5. @Around: Runs before AND after. Can swallow, handle, or re-throw exceptions, and measure duration.
    @Around("execution(* com.luv2code.aopdemo.service.TrafficFortuneService.getFortune(..))")
    public Object aroundGetFortune(ProceedingJoinPoint theProceedingJoinPoint) throws Throwable {
        System.out.println("\n=====>>> @Around: Method: " + theProceedingJoinPoint.getSignature().toShortString());

        long begin = System.currentTimeMillis();

        Object result = null;
        try {
            // Execute the actual method
            result = theProceedingJoinPoint.proceed();
        } catch (Exception exc) {
            System.out.println("=====>>> @Around: Exception intercepted: " + exc.getMessage());
            // We Swallow/Handle the exception and return a fallback message instead of crashing!
            result = "Default Fortune: Your private AOP helicopter is on the way!";
        }

        long end = System.currentTimeMillis();
        long duration = end - begin;
        System.out.println("=====>>> @Around: Duration: " + duration / 1000.0 + " seconds");

        return result;
    }
}
```

---

## 5. Main Application Runner

```java
package com.luv2code.aopdemo;

import com.luv2code.aopdemo.dao.AccountDAO;
import com.luv2code.aopdemo.service.TrafficFortuneService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class AopdemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(AopdemoApplication.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner(AccountDAO accountDAO, TrafficFortuneService trafficService) {
        return runner -> {
            System.out.println("\n--- 1. Testing @Before ---");
            accountDAO.addAccount(new Account("Chema", "Gold"), true);

            System.out.println("\n--- 2. Testing @AfterReturning (Success) ---");
            System.out.println("Main output: " + accountDAO.findAccounts(false)); // Names will be UPPERCASE

            System.out.println("\n--- 3. Testing @AfterThrowing & @After (Failure) ---");
            try {
                accountDAO.findAccounts(true);
            } catch (Exception e) {
                System.out.println("Main output: Exception was caught in main.");
            }

            System.out.println("\n--- 4. Testing @Around (Success with Profiling) ---");
            System.out.println("Main output: " + trafficService.getFortune(false));

            System.out.println("\n--- 5. Testing @Around (Exception Handling/Swallowing) ---");
            System.out.println("Main output: " + trafficService.getFortune(true));
        };
    }
}
```

---

## 6. Running & Testing

1. Bring up the application: `docker compose up --build`
2. Since it's a CLI application, it will boot Spring, run through the `CommandLineRunner` tests, output the AOP intercepted logs to the console, and then gracefully exit.
3. Observe how the Aspects intercept the core logic, read arguments, modify return types, trap exceptions, and profile execution times!
