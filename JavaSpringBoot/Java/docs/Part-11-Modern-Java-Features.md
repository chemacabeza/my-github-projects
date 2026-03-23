# Part 11: Modern Java Features

> **Sources:** *Java Coding Problems* (Ch. 1–5, 8)

---

## 🎯 Learning Objectives

- Use Records for data-carrying classes
- Apply Sealed Classes for controlled hierarchies
- Master Pattern Matching in `instanceof` and `switch`
- Work with Text Blocks for multi-line strings
- Understand modern switch expressions

---

## 1. Records (Java 16+)

Records are **immutable data carriers** — the compiler generates constructor, getters, `equals()`, `hashCode()`, and `toString()`.

```java
// Classic class — ~40 lines of boilerplate
// Record — 1 line!
public record Point(double x, double y) {}

Point p = new Point(3.0, 4.0);
p.x();              // 3.0 (accessor — NOT getX())
p.y();              // 4.0
p.toString();       // "Point[x=3.0, y=4.0]"
p.equals(new Point(3.0, 4.0)); // true
```

### Custom Records

```java
public record Employee(String name, String department, double salary) {

    // Compact constructor — validation
    public Employee {
        if (salary < 0) throw new IllegalArgumentException("Salary cannot be negative");
        name = name.strip();   // Can modify parameters before assignment
    }

    // Additional constructors
    public Employee(String name) {
        this(name, "Unassigned", 0);
    }

    // Custom methods
    public String displayName() {
        return name + " (" + department + ")";
    }

    // Static methods & fields
    public static final Employee UNKNOWN = new Employee("Unknown", "N/A", 0);
}
```

### Record Restrictions

- All fields are `final` (immutable)
- Cannot extend other classes (implicitly extend `Record`)
- Cannot declare instance fields (only component fields)
- Can implement interfaces
- Can be generic: `record Pair<A, B>(A first, B second) {}`

---

## 2. Sealed Classes (Java 17+)

Sealed classes **restrict which classes can extend** them:

```java
public sealed class Shape permits Circle, Rectangle, Triangle {
    public abstract double area();
}

public final class Circle extends Shape {
    private final double radius;
    public Circle(double radius) { this.radius = radius; }

    @Override
    public double area() { return Math.PI * radius * radius; }
}

public final class Rectangle extends Shape {
    private final double width, height;
    public Rectangle(double w, double h) { this.width = w; this.height = h; }

    @Override
    public double area() { return width * height; }
}

public non-sealed class Triangle extends Shape {
    // non-sealed allows further subclassing
    private final double base, height;
    public Triangle(double b, double h) { this.base = b; this.height = h; }

    @Override
    public double area() { return 0.5 * base * height; }
}
```

### Subclass Modifiers

| Modifier | Meaning |
|----------|---------|
| `final` | Cannot be extended further |
| `sealed` | Must declare its own `permits` |
| `non-sealed` | Opens up to unrestricted subclassing |

### Sealed Interfaces

```java
public sealed interface Result<T> permits Success, Failure {
    T value();
}

public record Success<T>(T value) implements Result<T> {}
public record Failure<T>(Exception error) implements Result<T> {
    public T value() { throw new RuntimeException(error); }
}
```

---

## 3. Pattern Matching

### 3.1 Pattern Matching for `instanceof` (Java 16+)

```java
// Old way
if (obj instanceof String) {
    String s = (String) obj;
    System.out.println(s.length());
}

// New way — binding variable
if (obj instanceof String s) {
    System.out.println(s.length());
}

// With guard conditions
if (obj instanceof String s && s.length() > 5) {
    System.out.println("Long string: " + s);
}
```

### 3.2 Pattern Matching for `switch` (Java 21+)

```java
// Type patterns
String describe(Object obj) {
    return switch (obj) {
        case Integer i when i > 0 -> "Positive: " + i;
        case Integer i            -> "Non-positive: " + i;
        case String s when s.isBlank() -> "Blank string";
        case String s             -> "String: " + s;
        case double[] arr         -> "Array of length " + arr.length;
        case null                 -> "null value";
        default                   -> "Other: " + obj;
    };
}

// Exhaustive switch with sealed classes — no default needed!
double calculateArea(Shape shape) {
    return switch (shape) {
        case Circle c    -> Math.PI * c.radius() * c.radius();
        case Rectangle r -> r.width() * r.height();
        case Triangle t  -> 0.5 * t.base() * t.height();
    };
}

// Record patterns (deconstructing)
record Point(int x, int y) {}
record Line(Point start, Point end) {}

String describePoint(Object obj) {
    return switch (obj) {
        case Point(int x, int y) when x == 0 && y == 0 -> "Origin";
        case Point(int x, int y) -> "Point at (" + x + "," + y + ")";
        case Line(Point s, Point e) -> "Line from " + s + " to " + e;
        default -> "Unknown";
    };
}
```

---

## 4. Text Blocks (Java 15+)

```java
// Traditional multi-line string
String json = "{\n" +
    "    \"name\": \"Alice\",\n" +
    "    \"age\": 30\n" +
    "}";

// Text block — much cleaner
String json = """
        {
            "name": "Alice",
            "age": 30
        }
        """;

// SQL
String query = """
        SELECT e.name, e.salary, d.name
        FROM employees e
        JOIN departments d ON e.dept_id = d.id
        WHERE e.salary > %d
        ORDER BY e.salary DESC
        """.formatted(50000);

// HTML
String html = """
        <html>
            <body>
                <h1>%s</h1>
                <p>Welcome, %s!</p>
            </body>
        </html>
        """.formatted("Home", "Alice");
```

### Text Block Escapes

```java
// Trailing whitespace preserved with \s
String s1 = """
        line1  \s
        line2  \s
        """;

// Line continuation (no newline) with \
String s2 = """
        This is a very long \
        single line of text.\
        """;
// "This is a very long single line of text."
```

---

## 5. Enhanced Switch Expressions (Java 14+)

```java
// Switch as expression — returns a value
int numLetters = switch (dayOfWeek) {
    case MONDAY, FRIDAY, SUNDAY -> 6;
    case TUESDAY                -> 7;
    case WEDNESDAY, THURSDAY    -> 8;
    case SATURDAY               -> 8;
};

// With yield for complex blocks
String description = switch (statusCode) {
    case 200 -> "OK";
    case 404 -> "Not Found";
    case 500 -> {
        logError(statusCode);
        yield "Internal Server Error";
    }
    default -> "Unknown: " + statusCode;
};
```

---

## 6. Local Variable Type Inference — `var` (Java 10+)

```java
var name = "Alice";                    // String
var numbers = List.of(1, 2, 3);        // List<Integer>
var map = new HashMap<String, List<Integer>>();  // Much shorter!

// In loops
for (var entry : map.entrySet()) {
    var key = entry.getKey();
    var value = entry.getValue();
}

// In try-with-resources
try (var reader = new BufferedReader(new FileReader("file.txt"))) {
    var line = reader.readLine();
}
```

**When to use:** Complex generic types, obvious initialization  
**When NOT to use:** When the type isn't obvious: `var result = compute();`

---

## 7. Other Modern Features

### Helpful NullPointerExceptions (Java 14+)

```java
// Before: "NullPointerException"
// After: "Cannot invoke String.length() because the return value of Person.getName() is null"
```

### Stream.toList() (Java 16+)

```java
// Before
List<String> list = stream.collect(Collectors.toList());

// After — returns unmodifiable list
List<String> list = stream.toList();
```

### String Enhancements

```java
// Java 11
"  hello  ".strip()           // "hello"
"  hello  ".stripLeading()    // "hello  "
" ".isBlank()                 // true
"abc\ndef".lines()            // Stream<String>
"ha".repeat(3)                // "hahaha"

// Java 12
"hello".indent(4)             // "    hello\n"
"hello".transform(s -> s + "!")  // "hello!"
```

---

## 8. Exercises

1. **Record Modeling:** Model a library system using records: `Book`, `Author`, `Library`
2. **Sealed Hierarchy:** Create a sealed `Expression` hierarchy (Literal, Add, Multiply) with pattern-matched evaluation
3. **Pattern Matching Calculator:** Build a calculator that evaluates expressions using pattern matching in switch
4. **Text Block Templates:** Create an email template system using text blocks with `.formatted()`
5. **Migration Exercise:** Refactor a legacy class hierarchy to use sealed classes and records

---

## 📖 References

- *Java Coding Problems*, Anghel Leonard — Ch. 1 (Objects, Immutability), Ch. 2–5 (Modern features), Ch. 8 (Sealed & Hidden Classes)
- [JEP 395: Records](https://openjdk.org/jeps/395)
- [JEP 409: Sealed Classes](https://openjdk.org/jeps/409)
- [JEP 441: Pattern Matching for switch](https://openjdk.org/jeps/441)

---

[← Part 10: Advanced OOP](Part-10-Advanced-OOP.md) | [Back to Course Index](../README.md) | [Next: Part 12 — JNI & Project Panama →](Part-12-JNI-And-Panama.md)
