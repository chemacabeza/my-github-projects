# Part 2: OOP Essentials

> **Sources:** *Thinking in Java* (Ch. 4–8) · *OCA Java SE 8 Programmer I* (Ch. 5) · *Java Coding Problems* (Ch. 1)

---

## 🎯 Learning Objectives

By the end of this part, you will:
- Design classes with encapsulation, constructors, and access control
- Apply inheritance and understand the `extends` / `implements` keywords
- Master polymorphism, method overriding, and dynamic dispatch
- Distinguish abstract classes from interfaces and know when to use each
- Understand composition vs. inheritance trade-offs

---

## 1. Classes & Objects

### 1.1 Anatomy of a Java Class

```java
package com.example.model;

public class Person {
    // ─── Fields (state) ───
    private String name;
    private int age;

    // ─── Constructor ───
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // ─── Methods (behavior) ───
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        if (age < 0) throw new IllegalArgumentException("Age cannot be negative");
        this.age = age;
    }

    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + "}";
    }
}
```

### 1.2 Creating Objects

```java
Person alice = new Person("Alice", 30);
Person bob = new Person("Bob", 25);

System.out.println(alice);        // Person{name='Alice', age=30}
System.out.println(alice.getName()); // Alice
```

**What happens with `new`:**
1. Memory is allocated on the **heap**
2. Fields are initialized to **default values** (`null`, `0`, `false`)
3. Instance initializer blocks run (in order of appearance)
4. The **constructor** body executes
5. A **reference** to the new object is returned

### 1.3 The `this` Keyword

```java
public class Point {
    private int x, y;

    // 'this' disambiguates field from parameter
    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // 'this()' calls another constructor (constructor chaining)
    public Point() {
        this(0, 0);  // Must be FIRST statement
    }

    // 'this' as a reference to the current object
    public Point translate(int dx, int dy) {
        this.x += dx;
        this.y += dy;
        return this;   // Enables fluent API
    }
}
```

---

## 2. Encapsulation

### 2.1 Access Modifiers

| Modifier | Class | Package | Subclass | World |
|----------|-------|---------|----------|-------|
| `private` | ✅ | ❌ | ❌ | ❌ |
| *(default/package-private)* | ✅ | ✅ | ❌ | ❌ |
| `protected` | ✅ | ✅ | ✅ | ❌ |
| `public` | ✅ | ✅ | ✅ | ✅ |

### 2.2 JavaBeans Convention

```java
public class Employee {
    private String firstName;
    private boolean active;

    // Getter for non-boolean
    public String getFirstName() { return firstName; }

    // Setter
    public void setFirstName(String firstName) { this.firstName = firstName; }

    // Getter for boolean — uses 'is' prefix
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
```

### 2.3 Immutable Classes

An immutable class cannot be modified after creation:

```java
public final class ImmutablePerson {
    private final String name;
    private final int age;
    private final List<String> hobbies;

    public ImmutablePerson(String name, int age, List<String> hobbies) {
        this.name = name;
        this.age = age;
        this.hobbies = List.copyOf(hobbies);  // Defensive copy!
    }

    public String getName() { return name; }
    public int getAge() { return age; }
    public List<String> getHobbies() { return hobbies; }  // Already immutable

    // No setters!
}
```

**Rules for immutability:**
1. Class is `final` (cannot be subclassed)
2. All fields are `private final`
3. No setters
4. Defensive copies of mutable fields in constructor and getters

---

## 3. Constructors & Initialization

### 3.1 Constructor Overloading

```java
public class Rectangle {
    private double width;
    private double height;

    // No-arg constructor
    public Rectangle() {
        this(1.0, 1.0);
    }

    // Parameterized constructor
    public Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }

    // Copy constructor
    public Rectangle(Rectangle other) {
        this(other.width, other.height);
    }
}
```

### 3.2 Initialization Order

The complete initialization sequence:

1. **Static** content (once per class, in order of appearance):
   - Static fields → default values
   - Static initializer blocks
2. **Instance** content (each time `new` is called):
   - Instance fields → default values
   - Instance initializer blocks (in order of appearance)
   - Constructor body

```java
public class InitOrder {
    // 3. Instance field
    private int x = initX();

    // 1. Static initializer
    static { System.out.println("Static block"); }

    // 4. Instance initializer
    { System.out.println("Instance block, x=" + x); }

    // 2. Static field
    private static int STATIC_FIELD = initStatic();

    // 5. Constructor
    public InitOrder() {
        System.out.println("Constructor");
    }

    private int initX() { System.out.println("initX"); return 42; }
    private static int initStatic() { System.out.println("initStatic"); return 99; }
}
```

---

## 4. Inheritance

### 4.1 The `extends` Keyword

```java
public class Animal {
    protected String name;

    public Animal(String name) {
        this.name = name;
    }

    public void speak() {
        System.out.println(name + " makes a sound");
    }

    public void eat() {
        System.out.println(name + " is eating");
    }
}

public class Dog extends Animal {
    private String breed;

    public Dog(String name, String breed) {
        super(name);          // MUST be first statement
        this.breed = breed;
    }

    @Override
    public void speak() {
        System.out.println(name + " barks!");
    }

    // Dog inherits eat() from Animal
    // Dog overrides speak() with its own implementation
    public void fetch() {
        System.out.println(name + " fetches the ball!");
    }
}
```

### 4.2 Rules of Inheritance

- Java supports **single inheritance** only (one parent class)
- Every class implicitly extends `java.lang.Object`
- `super()` calls the parent constructor — must be first statement
- If no `super()` is explicit, the compiler inserts `super()` (no-arg)
- `final` classes cannot be extended
- `final` methods cannot be overridden

### 4.3 Method Overriding Rules

For a method in a subclass to **override** a parent method:

| Rule | Description |
|------|-------------|
| Same signature | Same method name and parameter types |
| Covariant return | Return type must be the same or a subtype |
| Access modifier | Cannot be more restrictive (e.g., can't go from `public` to `private`) |
| Exceptions | Cannot throw new/broader checked exceptions |
| Not `final` | The parent method must not be `final` |
| Not `static` | Static methods are **hidden**, not overridden |
| Not `private` | Private methods are not inherited |

```java
public class Animal {
    public Animal reproduce() { return new Animal("baby"); }
    protected void rest() { }
}

public class Dog extends Animal {
    @Override
    public Dog reproduce() { return new Dog("puppy", "Lab"); }    // Covariant return ✅

    @Override
    public void rest() { }   // wider access (protected → public OK, public → private NOT OK)
}
```

---

## 5. Polymorphism

### 5.1 What Is Polymorphism?

Polymorphism means "many forms." A reference of a parent type can point to any subclass object:

```java
Animal myPet = new Dog("Rex", "Shepherd");
myPet.speak();    // "Rex barks!" — Dog's method is called at RUNTIME
myPet.eat();      // "Rex is eating" — inherited from Animal

// myPet.fetch();  // COMPILE ERROR — Animal reference doesn't know about fetch()
```

**Key insight:** The **compiler** checks the **reference type** (Animal). The **JVM** executes the **object type's** method (Dog) at runtime. This is **dynamic dispatch**.

### 5.2 Casting

```java
Animal animal = new Dog("Rex", "Shepherd");

// Downcasting — must be explicit
Dog dog = (Dog) animal;   // OK at runtime because animal IS a Dog
dog.fetch();              // Now we can call Dog-specific methods

// Safe downcasting with instanceof
if (animal instanceof Dog d) {            // Pattern matching (Java 16+)
    d.fetch();
}

// Unsafe cast — ClassCastException at runtime!
Animal cat = new Animal("Kitty");
// Dog notADog = (Dog) cat;  // ClassCastException!
```

### 5.3 Virtual Methods

In Java, **all non-static, non-final, non-private methods are virtual** by default. The JVM determines which method to call based on the actual object type, not the reference type.

```java
public class Shape {
    public double area() { return 0; }
}

public class Circle extends Shape {
    private double radius;
    public Circle(double radius) { this.radius = radius; }

    @Override
    public double area() { return Math.PI * radius * radius; }
}

public class Rectangle extends Shape {
    private double width, height;
    public Rectangle(double w, double h) { this.width = w; this.height = h; }

    @Override
    public double area() { return width * height; }
}

// Polymorphic code:
Shape[] shapes = { new Circle(5), new Rectangle(3, 4), new Circle(2) };
for (Shape s : shapes) {
    System.out.println("Area: " + s.area());  // Calls the correct override
}
// Output:
// Area: 78.53981633974483
// Area: 12.0
// Area: 12.566370614359172
```

---

## 6. Abstract Classes

```java
public abstract class Vehicle {
    protected String make;
    protected int year;

    public Vehicle(String make, int year) {
        this.make = make;
        this.year = year;
    }

    // Abstract method — no body, MUST be overridden by concrete subclass
    public abstract double fuelEfficiency();

    // Concrete method — inherited as-is
    public String getDescription() {
        return year + " " + make;
    }
}

public class ElectricCar extends Vehicle {
    private double batteryCapacity;

    public ElectricCar(String make, int year, double batteryCapacity) {
        super(make, year);
        this.batteryCapacity = batteryCapacity;
    }

    @Override
    public double fuelEfficiency() {
        return batteryCapacity * 3.5;  // miles per kWh * capacity
    }
}
```

**Rules:**
- Cannot instantiate an abstract class: `new Vehicle(...)` → compile error
- Can have constructors (called via `super()`)
- Can have both abstract and concrete methods
- An abstract class can extend another abstract class without implementing all abstract methods
- First **concrete** subclass must implement ALL inherited abstract methods

---

## 7. Interfaces

### 7.1 Interface Basics

```java
public interface Flyable {
    // Constant (implicitly public static final)
    int MAX_ALTITUDE = 10000;

    // Abstract method (implicitly public abstract)
    void fly();
    double getAltitude();

    // Default method (Java 8+) — provides a default implementation
    default void land() {
        System.out.println("Landing...");
    }

    // Static method (Java 8+)
    static boolean canFly(Object obj) {
        return obj instanceof Flyable;
    }

    // Private method (Java 9+) — helper for default methods
    private void logFlight() {
        System.out.println("Flight logged");
    }
}
```

### 7.2 Implementing Interfaces

```java
public class Airplane implements Flyable, Serializable {
    private double altitude;

    @Override
    public void fly() {
        altitude = 30000;
        System.out.println("Flying at " + altitude + " feet");
    }

    @Override
    public double getAltitude() {
        return altitude;
    }

    // land() is inherited from Flyable's default method
}
```

**A class can implement multiple interfaces** — Java's way of supporting multiple inheritance of type.

### 7.3 Abstract Class vs. Interface

| Feature | Abstract Class | Interface |
|---------|---------------|-----------|
| Inheritance | Single (`extends`) | Multiple (`implements`) |
| Constructors | ✅ Yes | ❌ No |
| Instance fields | ✅ Yes | ❌ Only constants |
| Method types | Any | `abstract`, `default`, `static`, `private` |
| Access modifiers on methods | Any | `public` only (abstract/default) |
| Use when... | IS-A + shared state/code | CAN-DO capability contract |

**Design guideline:** *"Prefer interfaces for defining types. Use abstract classes when you need to share code among closely related classes."*

---

## 8. Composition vs. Inheritance

### 8.1 The Problem with Deep Inheritance

```
                    Animal
                   /      \
              Mammal      Bird
             /     \        \
           Dog     Cat    Parrot
          /   \
     Poodle  Bulldog
```

Deep hierarchies become **fragile** — changes to `Animal` can break `Poodle`.

### 8.2 Favor Composition

```java
// Instead of inheriting from Engine, Logger, GPS...
public class Car {
    private final Engine engine;         // HAS-A engine
    private final Logger logger;         // HAS-A logger
    private final GPSNavigator gps;      // HAS-A GPS

    public Car(Engine engine, Logger logger, GPSNavigator gps) {
        this.engine = engine;
        this.logger = logger;
        this.gps = gps;
    }

    public void drive(String destination) {
        engine.start();
        gps.navigateTo(destination);
        logger.log("Driving to " + destination);
    }
}
```

**Benefits:**
- More flexible — swap implementations at runtime
- No fragile base class problem
- Supports multiple "inheritance" of behavior via delegation
- Easier to test (mock individual components)

---

## 9. The `Object` Class

Every Java class inherits from `java.lang.Object`. These methods should be understood and often overridden:

### 9.1 `toString()`

```java
@Override
public String toString() {
    return "Person{name='" + name + "', age=" + age + "}";
}
```

### 9.2 `equals()` and `hashCode()`

```java
@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    Person person = (Person) o;
    return age == person.age && Objects.equals(name, person.name);
}

@Override
public int hashCode() {
    return Objects.hash(name, age);
}
```

**Contract:** If `a.equals(b)` then `a.hashCode() == b.hashCode()`. Violating this breaks `HashMap`, `HashSet`, etc.

---

## 10. Nested & Inner Classes

```java
public class Outer {
    private int x = 10;

    // Static nested class — doesn't have access to outer instance
    public static class StaticNested {
        public void hello() { System.out.println("Static nested"); }
    }

    // Inner class — has access to outer instance
    public class Inner {
        public void hello() { System.out.println("x = " + x); }
    }

    // Local class — inside a method
    public void method() {
        class Local {
            void hello() { System.out.println("Local, x = " + x); }
        }
        new Local().hello();
    }

    // Anonymous class — inline implementation
    public Runnable getRunnable() {
        return new Runnable() {
            @Override
            public void run() {
                System.out.println("Anonymous, x = " + x);
            }
        };
    }
}
```

---

## 11. Best Practices

1. **Favor composition over inheritance** — use `has-a` relationships
2. **Program to an interface, not an implementation** — declare variables as `List`, not `ArrayList`
3. **Override `toString()`, `equals()`, `hashCode()`** for value objects
4. **Use `@Override` annotation** — catches typos at compile time
5. **Follow the Liskov Substitution Principle** — subclass behavior must be compatible with parent
6. **Keep inheritance hierarchies shallow** — max 2–3 levels
7. **Mark classes as `final`** when not designed for extension

---

## 12. Exercises

1. **Shape Hierarchy:** Create an abstract `Shape` class with `area()` and `perimeter()` methods. Implement `Circle`, `Rectangle`, and `Triangle`.
2. **Interface Design:** Create a `Drawable` interface with `draw()` and a default `erase()` method. Implement it in multiple shapes.
3. **Immutable Class:** Create an immutable `Money` class with `amount` and `currency`. Support `add()` and `subtract()` that return new instances.
4. **Composition:** Redesign a `Car` using composition (Engine, Transmission, Chassis) instead of inheritance.
5. **equals/hashCode:** Implement `equals()` and `hashCode()` for a `Student` class. Verify they work correctly with `HashSet`.

---

## 📖 References

- *Thinking in Java*, Bruce Eckel — Chapters 4–8 (Initialization, Hiding, Reusing, Polymorphism, Interfaces)
- *OCA: Oracle Certified Associate Java SE 8 Programmer I Study Guide* — Chapter 5 (Class Design)
- *Java Coding Problems*, Anghel Leonard — Chapter 1 (Objects, Immutability, Switch Expressions)
- *Effective Java*, Joshua Bloch — Items 10–14, 17–18 (Classics on equals, hashCode, immutability, composition)

---

[← Part 1: Java Fundamentals](Part-01-Java-Fundamentals.md) | [Back to Course Index](../README.md) | [Next: Part 3 — Core APIs →](Part-03-Core-APIs.md)
