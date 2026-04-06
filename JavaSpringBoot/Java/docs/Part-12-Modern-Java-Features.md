# Part 12: Modern Java Features

<p align="center">
<img src="../images/part13_cover.png" alt="Modern Java Features" width="800"/>
</p>

> **Sources:** *Modern Java in Action* (Urma, Fusco) · *Effective Java* (Bloch) · *Core Java, Vol. I* (Horstmann) · *Java: The Complete Reference* (Schildt)

---

## 🎯 Learning Objectives

By the end of this part, you will:
- Use Records to eliminate boilerplate data classes
- Apply Sealed Classes and Pattern Matching for exhaustive type hierarchies
- Write readable multi-line strings with Text Blocks
- Use `switch` expressions for concise branching
- Leverage `Optional` to eliminate `NullPointerException`

---

## 1. Java's Evolution — A Timeline

> **Feynman Insight:** Java has reinvented itself multiple times. Java 8 (2014) was a revolution — lambdas and streams changed how every Java developer thinks. Java 9–11 brought modularization and HTTP client improvements. Java 14–21 brought a burst of quality-of-life features that make Java feel like a modern language again: Records, Text Blocks, Pattern Matching, Sealed Classes, and Virtual Threads. These aren't bolt-ons — they fundamentally simplify how you model and reason about data.

| Version | Feature | Significance |
|---------|---------|-------------|
| Java 8 | Lambdas, Streams, Optional | Functional programming arrives |
| Java 11 | `var` in lambdas, HTTP Client | LTS baseline |
| Java 14 | Records (preview) | Immutable data carriers |
| Java 15 | Text Blocks (stable) | Multi-line strings done right |
| Java 16 | Records (stable), Pattern Matching `instanceof` | |
| Java 17 | Sealed Classes (stable) | Exhaustive type hierarchies (LTS) |
| Java 21 | Virtual Threads (stable), Pattern Matching in `switch` | Major LTS release |

---

## 2. Records — Zero-Boilerplate Data Classes

> **Feynman Insight:** Before records, creating a simple data class in Java required writing a class, private final fields, a constructor, `getters()`, `equals()`, `hashCode()`, and `toString()` — often 50+ lines of code. And if you forgot one of these (especially `hashCode()`), subtle bugs crept in. A Record is Java saying: "We understand that you want an immutable data carrier. Tell me the fields, and I'll generate everything else automatically." It's like filing a tax form vs. calculating your taxes by hand.

```java
// Before Records — 50+ lines of pure boilerplate
public class Point {
    private final int x;
    private final int y;

    public Point(int x, int y) { this.x = x; this.y = y; }
    public int x() { return x; }
    public int y() { return y; }

    @Override
    public boolean equals(Object o) { /* ... 10 lines ... */ }
    @Override
    public int hashCode() { return Objects.hash(x, y); }
    @Override
    public String toString() { return "Point[x=" + x + ", y=" + y + "]"; }
}

// After Records — 1 line!
public record Point(int x, int y) { }

// The compiler generates: constructor, getters (x(), y()), equals, hashCode, toString
Point p1 = new Point(3, 4);
Point p2 = new Point(3, 4);
p1.x();           // 3
p1.equals(p2);    // true — value-based equality!
System.out.println(p1);  // Point[x=3, y=4]
```

### 2.1 Compact Constructors & Validation

```java
public record Range(int min, int max) {
    // Compact constructor — automatic assignment still happens!
    Range {
        if (min > max) throw new IllegalArgumentException(
            "min (%d) must be <= max (%d)".formatted(min, max));
    }

    // Custom methods are fine
    public int size() { return max - min; }
    public boolean contains(int value) { return value >= min && value <= max; }
}

// Records can implement interfaces
public record Money(BigDecimal amount, Currency currency) implements Comparable<Money> {
    @Override
    public int compareTo(Money other) { return amount.compareTo(other.amount); }
}
```

---

## 3. Sealed Classes — Closed Type Hierarchies

> **Feynman Insight:** A regular class hierarchy is an "open world" — anyone can subclass it. But sometimes you KNOW there are only a fixed number of valid subtypes. A `Shape` is either a `Circle`, `Rectangle`, or `Triangle` — nothing else. Sealed classes let you say "this is a closed set." The compiler then enforces that every `switch` handles ALL cases — like a contract that you've covered every scenario.

```java
// Sealed class — only permitted types can extend it
public sealed interface Shape permits Circle, Rectangle, Triangle { }

public record Circle(double radius) implements Shape { }
public record Rectangle(double width, double height) implements Shape { }
public record Triangle(double base, double height) implements Shape { }

// The magic: switch is now EXHAUSTIVE — compiler checks you cover all cases!
double area = switch (shape) {
    case Circle c    -> Math.PI * c.radius() * c.radius();
    case Rectangle r -> r.width() * r.height();
    case Triangle t  -> 0.5 * t.base() * t.height();
    // No default needed — the compiler knows these are ALL the options
};
```

> **Feynman Insight:** Sealed classes + pattern matching in `switch` is a superpower. When you add a new subtype to a sealed hierarchy, the **compiler will tell you everywhere you need to update your switch** — like a type-safe TODO list. No more forgetting to handle a new case.

---

## 4. Pattern Matching

### 4.1 Pattern Matching in `instanceof` (Java 16+)

```java
// Old way — noisy
if (obj instanceof String) {
    String s = (String) obj;       // Reduntant cast!
    System.out.println(s.length());
}

// Pattern matching — clean!
if (obj instanceof String s) {    // Declares 's' in scope
    System.out.println(s.length());
}

// Works with conditions too
if (obj instanceof String s && s.length() > 10) {
    System.out.println("Long string: " + s);
}
```

### 4.2 Pattern Matching in `switch` (Java 21+)

```java
// Type-safe dispatch with no casting
String format(Object obj) {
    return switch (obj) {
        case Integer i    -> "Int: " + i;
        case Double d     -> "Double: %.2f".formatted(d);
        case String s     -> "String: " + s;
        case int[] arr    -> "IntArray of length " + arr.length;
        case null         -> "null";
        default           -> "Unknown: " + obj.getClass().getSimpleName();
    };
}

// Guarded patterns
String describe(Number n) {
    return switch (n) {
        case Integer i when i < 0 -> "Negative integer: " + i;
        case Integer i when i == 0 -> "Zero";
        case Integer i            -> "Positive integer: " + i;
        case Double d             -> "Double: " + d;
        default                   -> "Other number";
    };
}
```

---

## 5. Text Blocks (Java 15+)

> **Feynman Insight:** Before text blocks, embedding multi-line strings (like SQL, JSON, HTML) in Java was a nightmare — you had to escape every quote, add `\n` everywhere, and concatenate strings. Text blocks are like a "raw mode" — write the string exactly as it should look.

```java
// Old way — painful!
String json = "{\n" +
    "  \"name\": \"Alice\",\n" +
    "  \"age\": 30,\n" +
    "  \"city\": \"London\"\n" +
    "}";

// Text block — natural!
String json = """
    {
      "name": "Alice",
      "age": 30,
      "city": "London"
    }
    """;

// SQL without escape hell
String sql = """
    SELECT u.name, o.total
    FROM users u
    JOIN orders o ON u.id = o.user_id
    WHERE u.active = true
      AND o.total > 100
    ORDER BY o.total DESC
    """;

// HTML template
String html = """
    <html>
        <body>
            <h1>Hello, %s!</h1>
        </body>
    </html>
    """.formatted(userName);
```

---

## 6. Switch Expressions (Java 14+)

```java
// Old switch statement — fall-through nightmare
int days;
switch (month) {
    case JUNE: case JULY: case AUGUST:
        days = 30; break;
    case FEBRUARY:
        days = 28; break;
    default:
        days = 31;
}

// New switch expression — clean, no fall-through, returns a value!
int days = switch (month) {
    case JUNE, JULY, AUGUST -> 30;
    case FEBRUARY            -> 28;
    default                  -> 31;
};

// With yield for multi-statement blocks
int days = switch (month) {
    case FEBRUARY -> {
        int d = isLeapYear(year) ? 29 : 28;
        yield d;
    }
    default -> 31;
};
```

---

## 7. var — Local Variable Type Inference (Java 11+)

```java
// var infers the type from the right side — less noise
var name = "Alice";              // String
var numbers = new ArrayList<Integer>();  // ArrayList<Integer>
var map = new HashMap<String, List<Integer>>();  // Complex types benefit most

// Use var where it's obvious — avoid where it hides important types
var result = process(data);  // BAD — what type is 'result'?
ProcessedData result = process(data);  // BETTER — type is informative

// Works great in for-each and try-with-resources
for (var entry : map.entrySet()) {
    System.out.println(entry.getKey() + " = " + entry.getValue());
}

try (var reader = new BufferedReader(new FileReader("data.txt"))) {
    var line = reader.readLine();
}
```

---

## 8. String Enhancements

```java
// Java 11+
"  hello  ".strip();           // "hello" — Unicode-aware (prefer over trim())
"   ".isBlank();               // true
"line1\nline2\nline3".lines()  // Stream<String>
"Java".repeat(3);              // "JavaJavaJava"

// Java 15+
"Hello".stripIndent();         // Strips common indentation
"Hello\nWorld".translateEscapes();  // Processes escape sequences

// Java 21 — String Templates (preview)
String name = "Alice";
String message = STR."Hello, \{name}! You have \{count} messages.";
```

---

## 9. Best Practices

1. **Use Records** for all data-only classes — they're immutable, concise, and correct
2. **Use Sealed Classes** when you have a fixed set of subtypes
3. **Use Text Blocks** for all multi-line strings (SQL, JSON, HTML)
4. **Use switch expressions** instead of switch statements
5. **Use `var`** where it reduces noise without hiding important type information
6. **Use Pattern Matching** instead of `instanceof` casts
7. **Stay on LTS releases**: Java 11, 17, 21 are the LTS (Long-Term Support) versions

---

## 10. Exercises

1. **Records:** Convert a classical `Person` POJO with 5 fields to a Record. Add a compact constructor with validation.
2. **Sealed AST:** Model an expression AST with sealed classes: `Num(int)`, `Add(Expr, Expr)`, `Mul(Expr, Expr)`. Implement an `eval()` function using pattern matching.
3. **Text Block SQL:** Rewrite 3 SQL queries using text blocks. Parameterize them with `formatted()`.
4. **Switch Expression:** Convert a 20-line `if-else if` chain into a switch expression.

---

## 📖 References

- *Modern Java in Action*, Urma, Fusco — Chapters 14–16 (Modern Java in Practice, Records, Modules)
- *Effective Java*, Joshua Bloch — Item 17 (Immutability), Item 3 (Singleton via enum)
- *Core Java, Volume I*, Cay S. Horstmann — Chapter 3 (Fundamental Java Structures)
- *Java: The Complete Reference*, Herbert Schildt — Chapter 17 (Enumerations, Autoboxing)

---

[← Part 11: Testing](Part-11-Testing.md) | [Back to Course Index](../README.md) | [Next: Part 13 — JDBC & Databases →](Part-13-JDBC-And-Databases.md)
