# Section 1: Getting Started with Java Programming

> **Course:** Java Programming Masterclass (2025 Edition)

This guide provides a complete, copy-pasteable introduction to core Java programming. It covers the fundamentals of the language: the `main` method, variables, primitives, control flow, and the compilation model (`javac` → bytecode → `java` JVM).

By following this guide, you will build and run a pure Java console application, fully containerized via Docker so you don't even need to install the JDK on your host machine.

## 1. The Code (`Main.java`)

In pure Java, all code must reside inside a `class`, and the entry point of the application is **always** the `public static void main(String[] args)` method.

Create a file named `Main.java` in your project folder:

```java
public class Main {

    // The Entry Point of the Java Application
    public static void main(String[] args) {
        
        System.out.println("====== Hello, World! ======\n");

        // 1. Primitive Data Types
        // Java is statically typed. You must declare the type of the variable.
        int age = 30;                     // 32-bit integer
        long globalPopulation = 8_000_000_000L; // 64-bit integer (Notice the 'L')
        double price = 19.99;             // 64-bit floating point
        boolean isJavaFun = true;         // true or false
        char grade = 'A';                 // Single 16-bit Unicode character

        System.out.println("--- Variables & Primitives ---");
        System.out.println("Age: " + age);
        System.out.println("Price: $" + price);
        System.out.println("Is Java fun? " + isJavaFun);

        // 2. The 'var' keyword (Java 10+)
        // The compiler infers the type based on the assigned value. Use sparingly for readability.
        var message = "This string type was inferred!";
        System.out.println("Message: " + message);

        // 3. Control Flow (if / else)
        System.out.println("\n--- Control Flow ---");
        int score = 85;
        if (score >= 90) {
            System.out.println("Excellent!");
        } else if (score >= 80) {
            System.out.println("Good job!");
        } else {
            System.out.println("Keep practicing.");
        }

        // 4. Control Flow (switch statement - Modern Syntax)
        System.out.println("\n--- Modern Switch Statement ---");
        String day = "MONDAY";
        switch (day) {
            case "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY" -> System.out.println("It's a weekday.");
            case "SATURDAY", "SUNDAY" -> System.out.println("It's the weekend!");
            default -> System.out.println("Invalid day.");
        }

        // 5. Loops (for, while)
        System.out.println("\n--- Loops ---");
        
        // standard 'for' loop
        System.out.print("For loop counting: ");
        for (int i = 1; i <= 3; i++) {
            System.out.print(i + " ");
        }
        System.out.println();

        // 'while' loop
        System.out.print("While loop countdown: ");
        int countdown = 3;
        while (countdown > 0) {
            System.out.print(countdown + " ");
            countdown--;
        }
        System.out.println("\n\n====== Program Finished! ======");
    }
}
```

---

## 2. Docker Setup (Mac & Ubuntu)

We will use a multi-stage Dockerfile. 
1. The first stage uses the JDK (Java Development Kit) to compile the `.java` source code into `.class` bytecode using `javac`. 
2. The second stage uses the JRE (Java Runtime Environment) to execute the bytecode on the JVM (Java Virtual Machine) using the `java` command.

### `Dockerfile`

Create this file in the same directory as `Main.java`.

```dockerfile
# Stage 1: Compile the Java Source Code
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY Main.java .
# 'javac' compiles the human-readable source code into JVM bytecode (Main.class)
RUN javac Main.java

# Stage 2: Create the execution environment
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
# Copy the compiled bytecode from the build stage
COPY --from=build /app/Main.class .
# 'java' executes the compiled bytecode
ENTRYPOINT ["java", "Main"]
```

### `docker-compose.yml`

This makes running the container a single, easy command.

```yaml
version: '3.8'

services:
  app:
    build: .
    container_name: core_java_basics
```

---

## 3. Running & Testing

To compile and run your pure Java application via Docker:

1. Open your terminal in the directory containing these files.
2. Run the following command:
   ```bash
   docker compose up --build
   ```
3. Docker will start the build process. It will invoke `javac Main.java` inside the container.
4. Once built, the container will run, invoking `java Main`, and you will see the output of your variables, loops, and control flow printed to your terminal.
5. The container will automatically exit when the `main` method finishes.

**Key Concepts to Remember:**
*   **Compilation:** Java is *not* interpreted line-by-line like Python or JavaScript. It must be compiled first (`javac`).
*   **Bytecode:** The compiler produces a `.class` file. This bytecode is platform-independent ("Write Once, Run Anywhere").
*   **JVM:** The `java` command starts the Java Virtual Machine, which translates that bytecode into machine code for your specific CPU architecture (Mac ARM, Ubuntu x86, etc) at runtime.
