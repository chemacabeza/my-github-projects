# Part 7: Streams API & Data Processing

> **Sources:** *Java 8 Lambdas* (Ch. 3, 5–6) · *OCP Java SE 8 Programmer II* (Ch. 4) · *Java Coding Problems* (Ch. 9)

---

## 🎯 Learning Objectives

- Understand stream pipelines: source → intermediate → terminal operations
- Master `map`, `filter`, `reduce`, `collect`, `flatMap`
- Use collectors for grouping, partitioning, and summarizing
- Apply parallel streams correctly
- Build real-world data processing pipelines

---

## 1. What Are Streams?

Streams are **lazy, one-pass pipelines** for processing collections of data:

```java
List<String> names = List.of("Alice", "Bob", "Charlie", "Dave", "Eve");

List<String> result = names.stream()        // Source
    .filter(n -> n.length() > 3)            // Intermediate
    .map(String::toUpperCase)               // Intermediate
    .sorted()                               // Intermediate
    .collect(Collectors.toList());           // Terminal

// [ALICE, CHARLIE, DAVE]
```

**Key properties:**
- **Lazy:** Intermediate operations aren't executed until a terminal operation is invoked
- **One-pass:** A stream can only be consumed once
- **Non-mutating:** Streams don't modify the source collection
- **Optionally parallel:** `.parallelStream()` or `.parallel()`

---

## 2. Creating Streams

```java
// From collections
List<String> list = List.of("a", "b", "c");
Stream<String> stream1 = list.stream();

// From arrays
String[] arr = {"x", "y", "z"};
Stream<String> stream2 = Arrays.stream(arr);

// From values
Stream<Integer> stream3 = Stream.of(1, 2, 3, 4, 5);

// Empty stream
Stream<String> empty = Stream.empty();

// Infinite streams
Stream<Double> randoms = Stream.generate(Math::random);
Stream<Integer> counting = Stream.iterate(0, n -> n + 1);
Stream<Integer> bounded = Stream.iterate(0, n -> n < 100, n -> n + 2); // Java 9+

// Primitive streams
IntStream ints = IntStream.range(1, 10);        // 1 to 9
IntStream intsInclusive = IntStream.rangeClosed(1, 10); // 1 to 10
DoubleStream doubles = DoubleStream.of(1.1, 2.2, 3.3);

// From String
IntStream chars = "Hello".chars();

// From files
Stream<String> lines = Files.lines(Path.of("data.txt"));
```

---

## 3. Intermediate Operations (Lazy)

### filter — Keep elements matching a predicate
```java
List<Integer> evens = IntStream.rangeClosed(1, 20)
    .filter(n -> n % 2 == 0)
    .boxed()
    .collect(Collectors.toList());
// [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
```

### map — Transform each element
```java
List<Integer> lengths = List.of("Hello", "World", "Java")
    .stream()
    .map(String::length)
    .collect(Collectors.toList());
// [5, 5, 4]
```

### flatMap — Flatten nested structures
```java
List<List<String>> nested = List.of(
    List.of("a", "b"),
    List.of("c", "d"),
    List.of("e")
);

List<String> flat = nested.stream()
    .flatMap(Collection::stream)
    .collect(Collectors.toList());
// [a, b, c, d, e]

// Real-world: extract all words from sentences
List<String> sentences = List.of("Hello World", "Java Streams");
List<String> words = sentences.stream()
    .flatMap(s -> Arrays.stream(s.split(" ")))
    .collect(Collectors.toList());
// [Hello, World, Java, Streams]
```

### sorted — Sort elements
```java
List<String> sorted = names.stream()
    .sorted()                                    // Natural order
    .collect(Collectors.toList());

List<String> customSort = names.stream()
    .sorted(Comparator.comparingInt(String::length).reversed())
    .collect(Collectors.toList());
```

### distinct — Remove duplicates
```java
List<Integer> unique = List.of(1, 2, 2, 3, 3, 3)
    .stream()
    .distinct()
    .collect(Collectors.toList());
// [1, 2, 3]
```

### peek — Debug without consuming
```java
List<String> result = names.stream()
    .filter(n -> n.length() > 3)
    .peek(n -> System.out.println("After filter: " + n))
    .map(String::toUpperCase)
    .peek(n -> System.out.println("After map: " + n))
    .collect(Collectors.toList());
```

### limit & skip — Pagination
```java
List<Integer> page = IntStream.rangeClosed(1, 100)
    .skip(20)       // Skip first 20
    .limit(10)      // Take next 10
    .boxed()
    .collect(Collectors.toList());
// [21, 22, 23, ..., 30]
```

### takeWhile & dropWhile (Java 9+)
```java
List<Integer> taken = List.of(1, 2, 3, 4, 5, 1, 2)
    .stream()
    .takeWhile(n -> n < 4)
    .collect(Collectors.toList());
// [1, 2, 3]

List<Integer> dropped = List.of(1, 2, 3, 4, 5, 1, 2)
    .stream()
    .dropWhile(n -> n < 4)
    .collect(Collectors.toList());
// [4, 5, 1, 2]
```

---

## 4. Terminal Operations

### collect — Gather results
```java
// To List
List<String> list = stream.collect(Collectors.toList());
List<String> list2 = stream.toList();  // Java 16+ (unmodifiable)

// To Set
Set<String> set = stream.collect(Collectors.toSet());

// To Map
Map<String, Integer> map = names.stream()
    .collect(Collectors.toMap(
        Function.identity(),     // key
        String::length           // value
    ));

// Joining strings
String joined = names.stream()
    .collect(Collectors.joining(", ", "[", "]"));
// "[Alice, Bob, Charlie]"
```

### forEach — Perform action on each element
```java
names.stream().forEach(System.out::println);
names.forEach(System.out::println);  // Collection method (preferred)
```

### reduce — Combine elements
```java
// Sum
int sum = IntStream.rangeClosed(1, 10).reduce(0, Integer::sum);
// 55

// Max
Optional<Integer> max = List.of(3, 1, 4, 1, 5, 9).stream()
    .reduce(Integer::max);

// String concatenation
String result = List.of("Hello", " ", "World").stream()
    .reduce("", String::concat);
```

### count, min, max, findFirst, findAny
```java
long count = names.stream().filter(n -> n.length() > 3).count();

Optional<String> first = names.stream()
    .filter(n -> n.startsWith("A"))
    .findFirst();

Optional<String> any = names.parallelStream()
    .filter(n -> n.length() > 3)
    .findAny();  // Non-deterministic in parallel

Optional<String> min = names.stream().min(Comparator.naturalOrder());
Optional<String> max = names.stream().max(Comparator.naturalOrder());
```

### anyMatch, allMatch, noneMatch
```java
boolean hasLongName = names.stream().anyMatch(n -> n.length() > 10);
boolean allShort = names.stream().allMatch(n -> n.length() < 20);
boolean noneEmpty = names.stream().noneMatch(String::isEmpty);
```

---

## 5. Collectors — Advanced Grouping & Summarizing

### groupingBy
```java
Map<Integer, List<String>> byLength = names.stream()
    .collect(Collectors.groupingBy(String::length));
// {3=[Bob, Eve], 5=[Alice], 7=[Charlie]}

// Downstream collector — count per group
Map<Integer, Long> countByLength = names.stream()
    .collect(Collectors.groupingBy(String::length, Collectors.counting()));

// Group and transform
Map<String, List<String>> byFirstLetter = names.stream()
    .collect(Collectors.groupingBy(
        n -> n.substring(0, 1),
        Collectors.mapping(String::toUpperCase, Collectors.toList())
    ));
```

### partitioningBy
```java
Map<Boolean, List<String>> partitioned = names.stream()
    .collect(Collectors.partitioningBy(n -> n.length() > 3));
// {false=[Bob, Eve], true=[Alice, Charlie, Dave]}
```

### Summarizing statistics
```java
IntSummaryStatistics stats = names.stream()
    .collect(Collectors.summarizingInt(String::length));

stats.getCount();    // 5
stats.getSum();      // 24
stats.getMin();      // 3
stats.getMax();      // 7
stats.getAverage();  // 4.8
```

---

## 6. Optional

```java
Optional<String> opt = names.stream()
    .filter(n -> n.startsWith("Z"))
    .findFirst();

// Safe operations
opt.isPresent();                          // false
opt.isEmpty();                            // true (Java 11+)
opt.ifPresent(System.out::println);       // Does nothing
opt.orElse("default");                    // "default"
opt.orElseGet(() -> computeDefault());    // Lazy default
opt.orElseThrow();                        // NoSuchElementException
opt.orElseThrow(() -> new RuntimeException("Not found"));

// Transformation
Optional<Integer> length = opt.map(String::length);
Optional<String> flat = opt.flatMap(this::findByName);

// Stream of Optional values (Java 9+)
List<Optional<String>> optionals = List.of(
    Optional.of("A"), Optional.empty(), Optional.of("B")
);
List<String> values = optionals.stream()
    .flatMap(Optional::stream)
    .collect(Collectors.toList());
// [A, B]
```

---

## 7. Parallel Streams

```java
long sum = LongStream.rangeClosed(1, 10_000_000)
    .parallel()
    .sum();

List<String> result = names.parallelStream()
    .filter(n -> n.length() > 3)
    .map(String::toUpperCase)
    .collect(Collectors.toList());
```

**When to use parallel streams:**
- ✅ Large datasets (thousands+ elements)
- ✅ Computationally expensive per-element operations
- ✅ Stateless, independent operations
- ✅ Easily splittable sources (`ArrayList`, arrays)

**When NOT to use:**
- ❌ Small datasets (overhead exceeds benefit)
- ❌ I/O-bound operations
- ❌ Order-dependent operations
- ❌ Shared mutable state
- ❌ `LinkedList` or `Stream.iterate()` sources (hard to split)

---

## 8. Best Practices

1. **Prefer method references** over lambdas when possible
2. **Don't modify external state** in stream operations (side-effect free)
3. **Use `toList()` (Java 16+)** instead of `Collectors.toList()`
4. **Handle `Optional` properly** — don't call `get()` without checking
5. **Profile before parallelizing** — parallel isn't always faster
6. **Close streams from I/O sources** — use try-with-resources for `Files.lines()`
7. **Avoid nested streams** — use `flatMap` to flatten

---

## 9. Exercises

1. **Word Frequency Counter:** Read a text file, split into words, count frequency, display top 10
2. **Employee Analytics:** Given a list of employees, find average salary by department, highest paid per dept, employees earning above average
3. **Custom Collector:** Write a collector that collects into a `TreeMap<K, List<V>>`
4. **Flat Mapping:** Given a list of orders (each with a list of items), extract all unique product names sorted alphabetically
5. **Parallel Performance:** Compare sequential vs parallel stream performance for computing the sum of squares of the first 100M integers

---

## 📖 References

- *Java 8 Lambdas*, Richard Warburton — Ch. 3, 5–6 (Streams, Advanced Collections, Parallelism)
- *OCP Java SE 8 Programmer II Study Guide* — Ch. 4 (Functional Programming)
- *Java Coding Problems*, Anghel Leonard — Ch. 9 (Functional Style Programming)

---

[← Part 6: Lambda Expressions](Part-06-Lambda-Expressions.md) | [Back to Course Index](../README.md) | [Next: Part 8 — Concurrency →](Part-08-Concurrency.md)
