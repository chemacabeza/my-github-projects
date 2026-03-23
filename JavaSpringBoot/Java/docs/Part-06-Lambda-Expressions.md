# Part 6: Lambda Expressions & Functional Programming

> **Sources:** *Java 8 Lambdas* (Ch. 1–4) · *OCP Java SE 8 Programmer II* (Ch. 4) · *Java Coding Problems* (Ch. 9)

---

## 🎯 Learning Objectives

- Understand functional interfaces and `@FunctionalInterface`
- Write lambda expressions and method references fluently
- Use built-in functional interfaces: `Predicate`, `Function`, `Consumer`, `Supplier`
- Compose and chain functional operations

---

## 1. From Anonymous Classes to Lambdas

**Before Java 8:**
```java
Collections.sort(names, new Comparator<String>() {
    @Override
    public int compare(String a, String b) {
        return a.compareToIgnoreCase(b);
    }
});
```

**With lambdas:**
```java
names.sort((a, b) -> a.compareToIgnoreCase(b));

// Even shorter with method reference:
names.sort(String::compareToIgnoreCase);
```

### Lambda Syntax Variants

```java
// Full syntax
(String a, String b) -> { return a.compareToIgnoreCase(b); }

// Type inference
(a, b) -> a.compareToIgnoreCase(b)

// Single parameter — no parentheses
name -> name.toUpperCase()

// No parameters
() -> System.out.println("Hello!")
```

---

## 2. Functional Interfaces

A functional interface has **exactly one abstract method** (SAM).

```java
@FunctionalInterface
public interface Greeting {
    String greet(String name);
    default String greetAll(String... names) {
        return Arrays.stream(names).map(this::greet).collect(Collectors.joining(", "));
    }
}

Greeting casual = name -> "Hey, " + name + "!";
```

### Built-in Functional Interfaces (`java.util.function`)

| Interface | Method | Signature | Example |
|-----------|--------|-----------|---------|
| `Predicate<T>` | `test(T)` | T → boolean | `s -> s.isEmpty()` |
| `Function<T,R>` | `apply(T)` | T → R | `s -> s.length()` |
| `Consumer<T>` | `accept(T)` | T → void | `System.out::println` |
| `Supplier<T>` | `get()` | () → T | `ArrayList::new` |
| `UnaryOperator<T>` | `apply(T)` | T → T | `String::toUpperCase` |
| `BinaryOperator<T>` | `apply(T,T)` | (T,T) → T | `Integer::sum` |
| `BiPredicate<T,U>` | `test(T,U)` | (T,U) → boolean | `(s,n) -> s.length() > n` |
| `BiFunction<T,U,R>` | `apply(T,U)` | (T,U) → R | `(s,n) -> s.substring(n)` |

**Primitive specializations** (avoid autoboxing): `IntPredicate`, `DoubleFunction`, `ToIntFunction`, etc.

---

## 3. Predicate — Filtering Logic

```java
Predicate<String> isNotEmpty = s -> !s.isEmpty();
Predicate<String> isLong = s -> s.length() > 10;

// Composition
Predicate<String> combined = isNotEmpty.and(isLong);
Predicate<String> negated = isNotEmpty.negate();
Predicate<String> either = isNotEmpty.or(isLong);

List<String> filtered = names.stream()
    .filter(isNotEmpty.and(isLong))
    .collect(Collectors.toList());
```

---

## 4. Function — Transformation Logic

```java
Function<String, Integer> length = String::length;
Function<Integer, String> toString = i -> "Value: " + i;

// andThen: apply length THEN toString
Function<String, String> pipeline = length.andThen(toString);
pipeline.apply("Hello");  // "Value: 5"

// compose: apply toString first, THEN length (reverse order)
// Function.identity() — returns input unchanged
```

---

## 5. Consumer, Supplier, Operator

```java
// Consumer — performs action, returns nothing
Consumer<String> printer = System.out::println;
Consumer<String> logger = s -> System.err.println("[LOG] " + s);
Consumer<String> both = printer.andThen(logger);

// Supplier — provides values, takes no input
Supplier<List<String>> listFactory = ArrayList::new;
Supplier<LocalDateTime> now = LocalDateTime::now;

// UnaryOperator — transforms T → T
UnaryOperator<String> toUpper = String::toUpperCase;
UnaryOperator<String> trim = String::trim;
UnaryOperator<String> process = trim.andThen(toUpper);

// BinaryOperator — combines (T, T) → T
BinaryOperator<Integer> max = Integer::max;
```

---

## 6. Method References

| Type | Syntax | Lambda Equivalent |
|------|--------|-------------------|
| Static | `Integer::parseInt` | `s -> Integer.parseInt(s)` |
| Instance (bound) | `myStr::concat` | `s -> myStr.concat(s)` |
| Instance (unbound) | `String::toLowerCase` | `s -> s.toLowerCase()` |
| Constructor | `ArrayList::new` | `() -> new ArrayList<>()` |

```java
// Static method reference
Function<String, Integer> parser = Integer::parseInt;

// Instance method of a particular object
String prefix = "Hello, ";
Function<String, String> greeter = prefix::concat;

// Instance method of first parameter
BiFunction<String, String, Integer> cmp = String::compareToIgnoreCase;

// Constructor reference
Function<String, Person> factory = Person::new;
```

---

## 7. Effectively Final & Closures

```java
String greeting = "Hello";  // effectively final
Consumer<String> greet = name -> System.out.println(greeting + ", " + name);

// greeting = "Hi";  // COMPILE ERROR — breaks 'effectively final'
```

---

## 8. Composing Functions (Pipeline Pattern)

```java
Function<String, String> slugify = 
    ((Function<String, String>) String::trim)
    .andThen(String::toLowerCase)
    .andThen(s -> s.replaceAll("[^a-z0-9\\s]", ""))
    .andThen(s -> s.replaceAll("\\s+", "-"));

slugify.apply("  Hello, World!  ");  // "hello-world"

// Complex predicate composition
Predicate<Employee> seniorDev = emp -> emp.getYears() > 5;
Predicate<Employee> engineering = emp -> "Engineering".equals(emp.getDept());
Predicate<Employee> target = seniorDev.and(engineering);
```

---

## 9. Handling Checked Exceptions in Lambdas

```java
// Problem: Function doesn't allow checked exceptions
@FunctionalInterface
interface ThrowingFunction<T, R> {
    R apply(T t) throws Exception;
}

static <T, R> Function<T, R> unchecked(ThrowingFunction<T, R> f) {
    return t -> {
        try { return f.apply(t); }
        catch (Exception e) { throw new RuntimeException(e); }
    };
}

Function<String, String> reader = unchecked(p -> Files.readString(Path.of(p)));
```

---

## 10. Best Practices

1. **Keep lambdas short** — if > 3 lines, extract to a named method
2. **Use method references** when lambda just calls an existing method
3. **Prefer standard functional interfaces** over custom ones
4. **Avoid side effects** — prefer pure functions
5. **Use `@FunctionalInterface`** on custom functional interfaces
6. **Leverage composition** — `and()`, `or()`, `andThen()`, `compose()`
7. **Use primitive specializations** to avoid autoboxing overhead

---

## 11. Exercises

1. **Functional Calculator:** Build a calculator using `BinaryOperator<Double>` stored in a `Map<String, BinaryOperator<Double>>`
2. **String Transformer:** Create a `UnaryOperator<String>` pipeline that trims, lowercases, removes punctuation, replaces spaces with hyphens
3. **Predicate Builder:** Write a `PredicateBuilder<T>` with fluent `and()`, `or()`, `not()` methods
4. **Lazy<T>:** Implement a `Lazy<T>` using `Supplier<T>` that computes only once
5. **Method Reference Drill:** Rewrite 10 lambdas ↔ method references

---

## 📖 References

- *Java 8 Lambdas*, Richard Warburton — Ch. 1–4
- *OCP Java SE 8 Programmer II Study Guide* — Ch. 4 (Functional Programming)
- *Java Coding Problems*, Anghel Leonard — Ch. 9 (Functional Style)

---

[← Part 5: Generics](Part-05-Generics-And-Type-Safety.md) | [Back to Course Index](../README.md) | [Next: Part 7 — Streams API →](Part-07-Streams-API.md)
