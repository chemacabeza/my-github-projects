# Part 10: Advanced OOP — Design Patterns & Reflection

> **Sources:** *Thinking in Java* (Ch. 10) · *OCP Java SE 8 Programmer II* (Ch. 2) · *Java Coding Problems* (Ch. 1)

---

## 🎯 Learning Objectives

- Apply key design patterns: Singleton, Factory, Builder, Strategy, Observer
- Understand RTTI, reflection, and the `Class` object
- Apply SOLID principles in Java code
- Master the `instanceof` operator and pattern matching

---

## 1. Design Principles — SOLID

| Principle | Description | Example |
|-----------|-------------|---------|
| **S** — Single Responsibility | A class should have one reason to change | Separate `UserValidator` from `UserService` |
| **O** — Open/Closed | Open for extension, closed for modification | Use interfaces/abstract classes |
| **L** — Liskov Substitution | Subtypes must be substitutable for their parent | `Square extends Rectangle` — be careful! |
| **I** — Interface Segregation | Many specific interfaces > one general-purpose | `Readable`, `Writable` vs `ReadWritable` |
| **D** — Dependency Inversion | Depend on abstractions, not concretions | Inject interfaces, not implementations |

---

## 2. Creational Patterns

### 2.1 Singleton

```java
// Thread-safe lazy Singleton (enum approach — recommended)
public enum DatabaseConnection {
    INSTANCE;

    private final Connection conn;

    DatabaseConnection() {
        this.conn = createConnection();
    }

    public Connection getConnection() { return conn; }
    private Connection createConnection() { /* ... */ return null; }
}

// Usage:
Connection db = DatabaseConnection.INSTANCE.getConnection();
```

### 2.2 Factory Method

```java
public interface Shape { double area(); }
public class Circle implements Shape { /* ... */ }
public class Rectangle implements Shape { /* ... */ }

public class ShapeFactory {
    public static Shape create(String type, double... params) {
        return switch (type.toLowerCase()) {
            case "circle"    -> new Circle(params[0]);
            case "rectangle" -> new Rectangle(params[0], params[1]);
            default -> throw new IllegalArgumentException("Unknown shape: " + type);
        };
    }
}

Shape s = ShapeFactory.create("circle", 5.0);
```

### 2.3 Builder

```java
public class HttpRequest {
    private final String url;
    private final String method;
    private final Map<String, String> headers;
    private final String body;

    private HttpRequest(Builder builder) {
        this.url = builder.url;
        this.method = builder.method;
        this.headers = Map.copyOf(builder.headers);
        this.body = builder.body;
    }

    public static class Builder {
        private final String url;
        private String method = "GET";
        private final Map<String, String> headers = new HashMap<>();
        private String body;

        public Builder(String url) { this.url = url; }
        public Builder method(String m) { this.method = m; return this; }
        public Builder header(String k, String v) { headers.put(k, v); return this; }
        public Builder body(String b) { this.body = b; return this; }
        public HttpRequest build() { return new HttpRequest(this); }
    }
}

HttpRequest req = new HttpRequest.Builder("https://api.example.com")
    .method("POST")
    .header("Content-Type", "application/json")
    .body("{\"name\":\"Alice\"}")
    .build();
```

---

## 3. Behavioral Patterns

### 3.1 Strategy

```java
@FunctionalInterface
public interface SortStrategy<T> {
    void sort(List<T> data);
}

public class DataProcessor<T> {
    private SortStrategy<T> strategy;

    public DataProcessor(SortStrategy<T> strategy) {
        this.strategy = strategy;
    }

    public void process(List<T> data) {
        strategy.sort(data);
    }
}

// With lambdas:
DataProcessor<String> processor = new DataProcessor<>(Collections::sort);
DataProcessor<String> reverser = new DataProcessor<>(list -> list.sort(Comparator.reverseOrder()));
```

### 3.2 Observer

```java
@FunctionalInterface
public interface EventListener<T> {
    void onEvent(T event);
}

public class EventBus<T> {
    private final List<EventListener<T>> listeners = new CopyOnWriteArrayList<>();

    public void subscribe(EventListener<T> listener) { listeners.add(listener); }
    public void unsubscribe(EventListener<T> listener) { listeners.remove(listener); }

    public void publish(T event) {
        listeners.forEach(l -> l.onEvent(event));
    }
}

EventBus<String> bus = new EventBus<>();
bus.subscribe(msg -> System.out.println("Logger: " + msg));
bus.subscribe(msg -> System.out.println("Analytics: " + msg));
bus.publish("User logged in");
```

### 3.3 Template Method

```java
public abstract class DataMiner {
    // Template method — defines the algorithm structure
    public final void mine(String path) {
        String data = readData(path);
        String parsed = parseData(data);
        String analyzed = analyzeData(parsed);
        sendReport(analyzed);
    }

    protected abstract String readData(String path);
    protected abstract String parseData(String data);
    protected String analyzeData(String data) { return data; } // Hook
    protected void sendReport(String report) { System.out.println(report); }
}
```

---

## 4. Reflection & RTTI

### 4.1 The `Class` Object

```java
// Three ways to get a Class object
Class<?> c1 = String.class;
Class<?> c2 = "hello".getClass();
Class<?> c3 = Class.forName("java.lang.String");

// Class information
c1.getName();              // "java.lang.String"
c1.getSimpleName();        // "String"
c1.getPackageName();       // "java.lang"
c1.getSuperclass();        // class java.lang.Object
c1.getInterfaces();        // [Serializable, Comparable, CharSequence, ...]
c1.isInterface();          // false
c1.isEnum();               // false
c1.isRecord();             // false (Java 16+)
```

### 4.2 Reflection API

```java
import java.lang.reflect.*;

Class<?> clazz = Person.class;

// Inspect fields
for (Field field : clazz.getDeclaredFields()) {
    System.out.printf("%s %s %s%n", 
        Modifier.toString(field.getModifiers()), 
        field.getType().getSimpleName(), 
        field.getName());
}

// Inspect methods
for (Method method : clazz.getDeclaredMethods()) {
    System.out.printf("%s %s(%s)%n",
        method.getReturnType().getSimpleName(),
        method.getName(),
        Arrays.stream(method.getParameterTypes())
            .map(Class::getSimpleName)
            .collect(Collectors.joining(", ")));
}

// Dynamic invocation
Object person = clazz.getDeclaredConstructor(String.class, int.class)
    .newInstance("Alice", 30);

Method getName = clazz.getMethod("getName");
String name = (String) getName.invoke(person);

// Access private fields
Field ageField = clazz.getDeclaredField("age");
ageField.setAccessible(true);
ageField.set(person, 31);
```

### 4.3 instanceof & Pattern Matching (Java 16+)

```java
// Classic instanceof
if (obj instanceof String) {
    String s = (String) obj;
    System.out.println(s.length());
}

// Pattern matching — no cast needed
if (obj instanceof String s) {
    System.out.println(s.length());
}

// In switch (Java 21+)
String describe(Object obj) {
    return switch (obj) {
        case Integer i -> "Integer: " + i;
        case String s  -> "String of length " + s.length();
        case null      -> "null";
        default        -> "Unknown: " + obj.getClass();
    };
}
```

---

## 5. Best Practices

1. **Favor composition over inheritance** for code reuse
2. **Use the Strategy pattern** with lambdas for flexible behavior
3. **Apply Builder** for objects with many optional parameters
4. **Use Singleton sparingly** — consider dependency injection instead
5. **Avoid reflection in production** — it's slow and bypasses type safety
6. **Follow SOLID principles** — they guide almost every design decision

---

## 6. Exercises

1. **Plugin System:** Build a plugin loader using reflection that discovers and instantiates classes implementing a `Plugin` interface
2. **Builder Generator:** Create a generic builder for any data class using reflection
3. **Strategy + Lambda:** Implement a text processor with interchangeable strategies (compress, encrypt, encode)
4. **Observer Pattern:** Build a reactive event system with typed events and filtered subscriptions
5. **Pattern Matching:** Rewrite a complex if-else chain using `switch` with pattern matching

---

## 📖 References

- *Thinking in Java*, Bruce Eckel — Ch. 10 (Detecting Types)
- *OCP Java SE 8 Programmer II Study Guide* — Ch. 2 (Design Patterns)
- *Java Coding Problems*, Anghel Leonard — Ch. 1 (Objects & Immutability)

---

[← Part 9: I/O & NIO](Part-09-IO-And-NIO.md) | [Back to Course Index](../README.md) | [Next: Part 11 — Modern Java Features →](Part-11-Modern-Java-Features.md)
