# Part 5: Generics & Type Safety

> **Sources:** *OCP Java SE 8 Programmer II* (Ch. 3) · *Thinking in Java* (Ch. 11) · *Java Coding Problems* (Ch. 9)

---

## 🎯 Learning Objectives

By the end of this part, you will:
- Create generic classes, interfaces, and methods
- Understand type parameters, bounds, and wildcards
- Master type erasure and its implications
- Apply generics to build type-safe data structures
- Avoid common generic pitfalls and understand restrictions

---

## 1. Why Generics?

### 1.1 Before Generics (Raw Types)

```java
// Without generics — no compile-time type safety
List names = new ArrayList();
names.add("Alice");
names.add(42);          // No error at compile time!

String name = (String) names.get(1);  // ClassCastException at RUNTIME!
```

### 1.2 With Generics

```java
// With generics — type-safe at compile time
List<String> names = new ArrayList<>();
names.add("Alice");
// names.add(42);       // COMPILE ERROR! Type safety enforced

String name = names.get(0);  // No cast needed
```

---

## 2. Generic Classes

### 2.1 Declaring a Generic Class

```java
public class Box<T> {
    private T content;

    public Box(T content) {
        this.content = content;
    }

    public T getContent() {
        return content;
    }

    public void setContent(T content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "Box[" + content + "]";
    }
}

// Usage:
Box<String> stringBox = new Box<>("Hello");
Box<Integer> intBox = new Box<>(42);
Box<List<String>> nestedBox = new Box<>(List.of("a", "b"));
```

### 2.2 Multiple Type Parameters

```java
public class Pair<K, V> {
    private final K key;
    private final V value;

    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }

    public K getKey() { return key; }
    public V getValue() { return value; }

    @Override
    public String toString() {
        return key + "=" + value;
    }
}

// Usage:
Pair<String, Integer> entry = new Pair<>("Age", 30);
Pair<String, List<String>> complex = new Pair<>("Colors", List.of("Red", "Blue"));
```

### 2.3 Naming Conventions

| Parameter | Convention | Example |
|-----------|-----------|---------|
| `T` | Type | `Box<T>` |
| `E` | Element | `List<E>` |
| `K` | Key | `Map<K, V>` |
| `V` | Value | `Map<K, V>` |
| `N` | Number | `Calculator<N extends Number>` |
| `S`, `U` | Additional types | `Pair<S, U>` |

---

## 3. Generic Methods

```java
public class Util {

    // Generic method — type parameter declared BEFORE return type
    public static <T> List<T> arrayToList(T[] array) {
        List<T> list = new ArrayList<>();
        for (T element : array) {
            list.add(element);
        }
        return list;
    }

    // Multiple type parameters
    public static <K, V> Map<K, V> zipToMap(K[] keys, V[] values) {
        Map<K, V> map = new HashMap<>();
        for (int i = 0; i < Math.min(keys.length, values.length); i++) {
            map.put(keys[i], values[i]);
        }
        return map;
    }

    // Generic method with return type inference
    public static <T> T getFirst(List<T> list) {
        return list.isEmpty() ? null : list.get(0);
    }
}

// Usage — type is inferred:
List<String> names = Util.arrayToList(new String[]{"Alice", "Bob"});
String first = Util.getFirst(names);  // Inferred as String
```

---

## 4. Bounded Type Parameters

### 4.1 Upper Bounds (`extends`)

```java
// T must be a Number or subclass of Number
public class NumberBox<T extends Number> {
    private T value;

    public NumberBox(T value) {
        this.value = value;
    }

    public double doubleValue() {
        return value.doubleValue();  // Safe — Number has doubleValue()
    }
}

NumberBox<Integer> intBox = new NumberBox<>(42);
NumberBox<Double> doubleBox = new NumberBox<>(3.14);
// NumberBox<String> strBox = new NumberBox<>("hello");  // COMPILE ERROR!
```

### 4.2 Multiple Bounds

```java
// T must extend Comparable AND implement Serializable
public <T extends Comparable<T> & Serializable> T findMax(List<T> list) {
    T max = list.get(0);
    for (T item : list) {
        if (item.compareTo(max) > 0) {
            max = item;
        }
    }
    return max;
}
```

**Rules:**
- At most **one class** in the bounds (must be listed first)
- Can have **multiple interfaces**
- Syntax: `<T extends Class & Interface1 & Interface2>`

---

## 5. Wildcards

### 5.1 Unbounded Wildcard `<?>`

```java
// Accepts any type of List
public static void printList(List<?> list) {
    for (Object item : list) {
        System.out.println(item);
    }
}

printList(List.of("Hello", "World"));
printList(List.of(1, 2, 3));
printList(List.of(3.14, 2.71));
```

### 5.2 Upper-Bounded Wildcard `<? extends T>` — "Producer"

```java
// Accepts List<Number>, List<Integer>, List<Double>, etc.
public static double sum(List<? extends Number> numbers) {
    double total = 0;
    for (Number n : numbers) {
        total += n.doubleValue();
    }
    return total;
}

sum(List.of(1, 2, 3));              // List<Integer> — OK
sum(List.of(1.5, 2.5));             // List<Double> — OK
// sum(List.of("a", "b"));          // List<String> — COMPILE ERROR
```

**Limitation:** You can **READ** from `<? extends T>` but cannot **WRITE** (except `null`):
```java
List<? extends Number> numbers = new ArrayList<Integer>();
Number n = numbers.get(0);         // OK — reading
// numbers.add(42);                // COMPILE ERROR — can't add
```

### 5.3 Lower-Bounded Wildcard `<? super T>` — "Consumer"

```java
// Accepts List<Integer>, List<Number>, List<Object>
public static void addIntegers(List<? super Integer> list) {
    list.add(1);
    list.add(2);
    list.add(3);
}

List<Number> numbers = new ArrayList<>();
addIntegers(numbers);  // OK — Number is a supertype of Integer
```

**Limitation:** You can **WRITE** to `<? super T>` but reading returns `Object`:
```java
List<? super Integer> list = new ArrayList<Number>();
list.add(42);             // OK — writing
Object obj = list.get(0); // Returns Object (not Integer or Number)
```

### 5.4 PECS — Producer Extends, Consumer Super

The **PECS principle** (from *Effective Java*):

| Use Case | Wildcard | Example |
|----------|----------|---------|
| **Read** from a collection (producer) | `<? extends T>` | `List<? extends Number>` |
| **Write** to a collection (consumer) | `<? super T>` | `List<? super Integer>` |
| **Both** read and write | No wildcard | `List<T>` |

```java
// Copy from source (producer) to destination (consumer)
public static <T> void copy(List<? extends T> source, List<? super T> dest) {
    for (T item : source) {
        dest.add(item);
    }
}
```

---

## 6. Type Erasure

### 6.1 How It Works

At compile time, generics provide type safety. At runtime, **type information is erased**:

```java
// What you write:
public class Box<T> {
    private T content;
    public T getContent() { return content; }
}

// What the JVM sees (after erasure):
public class Box {
    private Object content;
    public Object getContent() { return content; }
}
```

Bounded types erase to the bound:
```java
// What you write:
public class NumberBox<T extends Number> {
    private T value;
}

// After erasure:
public class NumberBox {
    private Number value;  // Erased to 'Number' (the bound)
}
```

### 6.2 Implications & Restrictions

| Restriction | Why |
|-------------|-----|
| Cannot instantiate: `new T()` | Type unknown at runtime |
| Cannot create arrays: `new T[10]` | Array reification requires type |
| Cannot use `instanceof` with generics: `obj instanceof List<String>` | Type erased at runtime |
| Cannot use primitives: `Box<int>` | Generics require reference types |
| Cannot overload by type parameter: `void f(List<String>)` vs `void f(List<Integer>)` | Both erase to `void f(List)` |

### 6.3 Workarounds

```java
// Creating instances — pass a factory/supplier
public static <T> T create(Supplier<T> factory) {
    return factory.get();
}
String s = create(String::new);

// Creating arrays — use Array.newInstance with Class token
@SuppressWarnings("unchecked")
public static <T> T[] createArray(Class<T> type, int size) {
    return (T[]) Array.newInstance(type, size);
}
String[] arr = createArray(String.class, 10);
```

---

## 7. Generic Interfaces

```java
public interface Repository<T, ID> {
    T findById(ID id);
    List<T> findAll();
    void save(T entity);
    void delete(ID id);
}

public class UserRepository implements Repository<User, Long> {
    @Override
    public User findById(Long id) { /* ... */ return null; }

    @Override
    public List<User> findAll() { /* ... */ return List.of(); }

    @Override
    public void save(User entity) { /* ... */ }

    @Override
    public void delete(Long id) { /* ... */ }
}
```

---

## 8. Recursive Type Bounds

```java
// T must be comparable to itself
public static <T extends Comparable<T>> T max(Collection<T> collection) {
    T result = null;
    for (T item : collection) {
        if (result == null || item.compareTo(result) > 0) {
            result = item;
        }
    }
    return result;
}

// Self-referential builder pattern
public abstract class Builder<T extends Builder<T>> {
    public abstract T self();

    public T withName(String name) {
        // set name
        return self();
    }
}

public class UserBuilder extends Builder<UserBuilder> {
    @Override
    public UserBuilder self() { return this; }
}
```

---

## 9. Best Practices

1. **Always use generics** — never use raw types in new code
2. **Follow PECS** — `extends` for reading, `super` for writing
3. **Prefer generic methods** over wildcard types for return values
4. **Suppress warnings wisely** — use `@SuppressWarnings("unchecked")` only when you've verified type safety
5. **Don't use wildcards in return types** — makes the API harder to use
6. **Prefer `List<T>` over `T[]`** — generic arrays have limitations
7. **Use `Class<T>` as type token** when you need runtime type information
8. **Bound type parameters** to increase the operations available on them

---

## 10. Exercises

1. **Generic Stack:** Implement a generic `Stack<T>` with `push()`, `pop()`, `peek()`, and `isEmpty()`.
2. **Generic Pair:** Create a `Triple<A, B, C>` class. Write a method that swaps the first and last elements.
3. **PECS Practice:** Write a `merge()` method that takes `List<? extends Comparable<? super T>>` and merges two sorted lists.
4. **Type-Safe Heterogeneous Container:** Build a `TypeSafeMap` that can store values of different types keyed by `Class<T>`.
5. **Generic DAO:** Create a generic `CrudRepository<T, ID>` interface and implement it for a `Product` entity.

---

## 📖 References

- *OCP: Oracle Certified Professional Java SE 8 Programmer II Study Guide* — Chapter 3 (Generics & Collections)
- *Thinking in Java*, Bruce Eckel — Chapter 11 (Collections — Generics sections)
- *Java Coding Problems*, Anghel Leonard — Chapter 9 (Functional Style — type inference)
- *Effective Java*, Joshua Bloch — Items 26–33 (Generics best practices)
- [Oracle Generics Tutorial](https://docs.oracle.com/javase/tutorial/java/generics/)

---

[← Part 4: Exception Handling](Part-04-Exception-Handling.md) | [Back to Course Index](../README.md) | [Next: Part 6 — Lambda Expressions →](Part-06-Lambda-Expressions.md)
