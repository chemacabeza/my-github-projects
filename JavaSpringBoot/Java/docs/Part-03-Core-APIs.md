# Part 3: Core APIs

> **Sources:** *Thinking in Java* (Ch. 11) · *OCA Java SE 8 Programmer I* (Ch. 3) · *OCP Java SE 8 Programmer II* (Ch. 3) · *Java Coding Problems* (Ch. 1, 9)

---

## 🎯 Learning Objectives

By the end of this part, you will:
- Master `String`, `StringBuilder`, and `StringBuffer`
- Work fluently with arrays and multidimensional arrays
- Use the Collections Framework: `List`, `Set`, `Map`, `Queue`
- Handle dates and times with the `java.time` API
- Understand wrapper classes, autoboxing, and the String pool

---

## 1. Strings

### 1.1 String Basics

Strings in Java are **immutable** objects. Every modification creates a new String.

```java
String greeting = "Hello";         // String literal (String pool)
String name = new String("World"); // Explicit object (heap)

String combined = greeting + ", " + name + "!";  // "Hello, World!"
```

### 1.2 The String Pool

```java
String s1 = "Hello";
String s2 = "Hello";
String s3 = new String("Hello");

System.out.println(s1 == s2);      // true  — same pool reference
System.out.println(s1 == s3);      // false — s3 is a different object
System.out.println(s1.equals(s3)); // true  — same content
```

> **Rule:** Always use `.equals()` to compare String content, never `==`.

### 1.3 Important String Methods

```java
String s = "Hello, World!";

s.length()                  // 13
s.charAt(0)                 // 'H'
s.indexOf("World")          // 7
s.substring(7)              // "World!"
s.substring(7, 12)          // "World"
s.toLowerCase()             // "hello, world!"
s.toUpperCase()             // "HELLO, WORLD!"
s.trim()                    // Removes leading/trailing whitespace
s.strip()                   // (Java 11+) Unicode-aware trim
s.replace("World", "Java") // "Hello, Java!"
s.contains("World")         // true
s.startsWith("Hello")       // true
s.endsWith("!")              // true
s.isEmpty()                 // false
s.isBlank()                 // false (Java 11+)
s.toCharArray()             // char[] {'H','e','l','l','o',...}
s.chars()                   // IntStream of character values

// Java 15+ — Text Blocks
String json = """
        {
            "name": "Alice",
            "age": 30
        }
        """;
```

### 1.4 StringBuilder & StringBuffer

For **mutable** string manipulation (especially in loops):

```java
StringBuilder sb = new StringBuilder("Hello");
sb.append(", World");      // "Hello, World"
sb.insert(5, " Beautiful"); // "Hello Beautiful, World"
sb.delete(5, 15);           // "Hello, World"
sb.reverse();               // "dlroW ,olleH"
sb.replace(0, 5, "Java");  // "Java ,olleH"

String result = sb.toString();
```

| Feature | `String` | `StringBuilder` | `StringBuffer` |
|---------|----------|-----------------|----------------|
| Mutable | ❌ | ✅ | ✅ |
| Thread-safe | ✅ (immutable) | ❌ | ✅ (synchronized) |
| Performance | Slow for concatenation | Fast | Slower than StringBuilder |
| Use when | Read-only / few changes | Single-threaded mutation | Multi-threaded mutation |

### 1.5 String Formatting

```java
// String.format() / printf()
String formatted = String.format("Name: %s, Age: %d, GPA: %.2f", "Alice", 20, 3.85);
// "Name: Alice, Age: 20, GPA: 3.85"

// Java 15+ — formatted() instance method
String result = "Name: %s, Age: %d".formatted("Bob", 25);
```

---

## 2. Arrays

### 2.1 Creating Arrays

```java
// Declaration and instantiation
int[] numbers = new int[5];           // [0, 0, 0, 0, 0]
String[] names = new String[3];       // [null, null, null]

// Declaration with initialization
int[] primes = {2, 3, 5, 7, 11};
String[] colors = {"Red", "Green", "Blue"};

// Alternative syntax (valid but less common)
int numbers2[] = new int[5];
```

### 2.2 Accessing & Modifying

```java
int[] arr = {10, 20, 30, 40, 50};

arr[0]          // 10
arr[arr.length - 1]  // 50
arr[2] = 99;    // arr is now {10, 20, 99, 40, 50}

// ArrayIndexOutOfBoundsException if index < 0 or >= length
```

### 2.3 Iterating Over Arrays

```java
int[] nums = {1, 2, 3, 4, 5};

// Classic for loop
for (int i = 0; i < nums.length; i++) {
    System.out.println(nums[i]);
}

// Enhanced for-each
for (int n : nums) {
    System.out.println(n);
}

// Using streams
Arrays.stream(nums).forEach(System.out::println);
```

### 2.4 Array Utilities — `java.util.Arrays`

```java
int[] arr = {5, 3, 1, 4, 2};

Arrays.sort(arr);                    // [1, 2, 3, 4, 5]
int idx = Arrays.binarySearch(arr, 3); // 2 (array MUST be sorted first)
Arrays.fill(arr, 0);                // [0, 0, 0, 0, 0]
int[] copy = Arrays.copyOf(arr, 10); // Copy + extend to length 10
int[] range = Arrays.copyOfRange(arr, 1, 3);  // Elements at index 1,2
boolean eq = Arrays.equals(arr, copy);         // Content equality
String str = Arrays.toString(arr);  // "[0, 0, 0, 0, 0]"
```

### 2.5 Multidimensional Arrays

```java
// 2D array (matrix)
int[][] matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

matrix[1][2]  // 6 (row 1, col 2)

// Jagged array (rows of different lengths)
int[][] jagged = new int[3][];
jagged[0] = new int[]{1, 2};
jagged[1] = new int[]{3, 4, 5};
jagged[2] = new int[]{6};

// Iterating 2D array
for (int[] row : matrix) {
    for (int val : row) {
        System.out.print(val + " ");
    }
    System.out.println();
}
```

### 2.6 Varargs

```java
public int sum(int... numbers) {
    int total = 0;
    for (int n : numbers) {
        total += n;
    }
    return total;
}

sum(1, 2, 3);        // 6
sum(10, 20);          // 30
sum();                // 0
sum(new int[]{5, 5}); // 10 — can also pass an array
```

**Rules:** Varargs must be the **last** parameter, and there can be only **one** per method.

---

## 3. The Collections Framework

### 3.1 Collection Hierarchy

```
              Iterable
                 │
            Collection
           /     |     \
        List    Set    Queue
        │       │       │
     ArrayList HashSet  LinkedList (also List)
     LinkedList TreeSet PriorityQueue
     Vector    LinkedHashSet ArrayDeque
```

Separate hierarchy:
```
        Map
       /   \
  HashMap  TreeMap
  LinkedHashMap
  Hashtable
```

### 3.2 List — Ordered, Allows Duplicates

```java
// ArrayList — fast random access, slow insert/delete in middle
List<String> fruits = new ArrayList<>();
fruits.add("Apple");
fruits.add("Banana");
fruits.add("Cherry");
fruits.add("Banana");       // Duplicates OK

fruits.get(0);               // "Apple"
fruits.set(1, "Blueberry");  // Replace at index 1
fruits.remove("Cherry");     // Remove by object
fruits.remove(0);            // Remove by index
fruits.size();               // 2
fruits.contains("Blueberry"); // true
fruits.indexOf("Banana");    // 1

// LinkedList — fast insert/delete, slower random access
List<String> linked = new LinkedList<>(fruits);

// Immutable lists (Java 9+)
List<String> immutable = List.of("A", "B", "C");  // Cannot be modified!

// Iterate
for (String fruit : fruits) {
    System.out.println(fruit);
}

// Sort
Collections.sort(fruits);
fruits.sort(Comparator.naturalOrder());
fruits.sort(Comparator.reverseOrder());
```

### 3.3 Set — Unique Elements

```java
// HashSet — no order guaranteed, O(1) add/contains
Set<String> colors = new HashSet<>();
colors.add("Red");
colors.add("Green");
colors.add("Blue");
colors.add("Red");         // Ignored — duplicate
colors.size();             // 3

// TreeSet — sorted order, O(log n)
Set<Integer> sorted = new TreeSet<>(List.of(5, 2, 8, 1, 9));
// sorted = [1, 2, 5, 8, 9]

// LinkedHashSet — insertion order preserved
Set<String> ordered = new LinkedHashSet<>();
ordered.add("First");
ordered.add("Second");
ordered.add("Third");     // Iteration order: First, Second, Third

// Immutable set (Java 9+)
Set<String> immutable = Set.of("A", "B", "C");
```

### 3.4 Map — Key-Value Pairs

```java
// HashMap — O(1) average for get/put
Map<String, Integer> ages = new HashMap<>();
ages.put("Alice", 30);
ages.put("Bob", 25);
ages.put("Charlie", 35);

ages.get("Alice");           // 30
ages.getOrDefault("Dave", 0); // 0 (not found)
ages.containsKey("Bob");     // true
ages.containsValue(25);      // true
ages.remove("Charlie");
ages.size();                  // 2

// Iteration
for (Map.Entry<String, Integer> entry : ages.entrySet()) {
    System.out.println(entry.getKey() + " = " + entry.getValue());
}

ages.forEach((name, age) -> System.out.println(name + ": " + age));

// Useful methods
ages.putIfAbsent("Dave", 28);
ages.computeIfAbsent("Eve", k -> k.length());   // "Eve" → 3
ages.merge("Alice", 1, Integer::sum);            // Alice: 30 → 31

// TreeMap — sorted by keys
Map<String, Integer> sorted = new TreeMap<>(ages);

// Immutable map (Java 9+)
Map<String, Integer> immutable = Map.of("A", 1, "B", 2);
```

### 3.5 Queue & Deque

```java
// Queue — FIFO
Queue<String> queue = new LinkedList<>();
queue.offer("First");     // Add to tail
queue.offer("Second");
queue.offer("Third");
queue.peek();              // "First" (look, don't remove)
queue.poll();              // "First" (remove and return)

// Deque — Double-ended queue
Deque<String> deque = new ArrayDeque<>();
deque.offerFirst("A");
deque.offerLast("B");
deque.peekFirst();         // "A"
deque.peekLast();          // "B"

// Using Deque as a Stack
Deque<Integer> stack = new ArrayDeque<>();
stack.push(1);
stack.push(2);
stack.push(3);
stack.pop();               // 3 (LIFO)
stack.peek();              // 2
```

### 3.6 Choosing the Right Collection

| Need | Use |
|------|-----|
| Ordered list with index access | `ArrayList` |
| Frequent insert/remove at ends | `LinkedList` / `ArrayDeque` |
| Unique elements, no order | `HashSet` |
| Unique elements, sorted | `TreeSet` |
| Unique elements, insertion order | `LinkedHashSet` |
| Key-value lookup | `HashMap` |
| Key-value, sorted keys | `TreeMap` |
| Key-value, insertion order | `LinkedHashMap` |
| FIFO queue | `LinkedList` / `ArrayDeque` |
| Stack (LIFO) | `ArrayDeque` |
| Thread-safe map | `ConcurrentHashMap` |

---

## 4. Comparable & Comparator

### 4.1 Natural Ordering with `Comparable`

```java
public class Employee implements Comparable<Employee> {
    private String name;
    private double salary;

    @Override
    public int compareTo(Employee other) {
        return Double.compare(this.salary, other.salary);
    }
}

List<Employee> employees = new ArrayList<>(...);
Collections.sort(employees);   // Sorts by salary (natural order)
```

### 4.2 Custom Ordering with `Comparator`

```java
// Sort by name
Comparator<Employee> byName = Comparator.comparing(Employee::getName);

// Sort by salary descending then by name
Comparator<Employee> bySalaryDesc = Comparator
    .comparingDouble(Employee::getSalary)
    .reversed()
    .thenComparing(Employee::getName);

employees.sort(bySalaryDesc);
```

---

## 5. Wrapper Classes & Autoboxing

### 5.1 Wrapper Classes

| Primitive | Wrapper | Parse Method |
|-----------|---------|-------------|
| `byte` | `Byte` | `Byte.parseByte("42")` |
| `short` | `Short` | `Short.parseShort("42")` |
| `int` | `Integer` | `Integer.parseInt("42")` |
| `long` | `Long` | `Long.parseLong("42")` |
| `float` | `Float` | `Float.parseFloat("3.14")` |
| `double` | `Double` | `Double.parseDouble("3.14")` |
| `boolean` | `Boolean` | `Boolean.parseBoolean("true")` |
| `char` | `Character` | — |

### 5.2 Autoboxing & Unboxing

```java
// Autoboxing: primitive → Wrapper
Integer wrapped = 42;          // int → Integer (automatic)
List<Integer> list = new ArrayList<>();
list.add(5);                   // int 5 autoboxed to Integer

// Unboxing: Wrapper → primitive
int unwrapped = wrapped;      // Integer → int (automatic)
int fromList = list.get(0);   // Integer → int

// DANGER: Unboxing null throws NullPointerException
Integer nullInt = null;
// int crash = nullInt;  // NullPointerException!
```

### 5.3 Integer Cache

```java
Integer a = 127, b = 127;
System.out.println(a == b);    // true  — cached (-128 to 127)

Integer c = 128, d = 128;
System.out.println(c == d);    // false — different objects!
System.out.println(c.equals(d)); // true — always use equals()
```

---

## 6. Dates & Times (`java.time`)

### 6.1 Core Classes

```java
import java.time.*;

LocalDate date = LocalDate.now();                    // 2026-03-23
LocalDate birthday = LocalDate.of(1990, Month.JUNE, 15);

LocalTime time = LocalTime.now();                    // 08:30:45.123
LocalTime lunch = LocalTime.of(12, 30);

LocalDateTime dateTime = LocalDateTime.now();        // 2026-03-23T08:30:45
LocalDateTime meeting = LocalDateTime.of(2026, 3, 25, 14, 0);

ZonedDateTime zoned = ZonedDateTime.now(ZoneId.of("Europe/Madrid"));
Instant instant = Instant.now();                     // UTC timestamp
```

### 6.2 Manipulating Dates & Times

All `java.time` objects are **immutable** — methods return new instances:

```java
LocalDate date = LocalDate.of(2026, 3, 23);

date.plusDays(10)          // 2026-04-02
date.minusMonths(1)        // 2026-02-23
date.plusYears(5)          // 2031-03-23
date.withMonth(12)         // 2026-12-23
date.withDayOfMonth(1)     // 2026-03-01

// Chaining
LocalDate future = date.plusYears(1).plusMonths(2).plusDays(5);
```

### 6.3 Periods & Durations

```java
// Period — for dates (years, months, days)
Period period = Period.of(1, 2, 15);   // 1 year, 2 months, 15 days
Period between = Period.between(LocalDate.of(2020, 1, 1), LocalDate.now());

LocalDate future = LocalDate.now().plus(period);

// Duration — for times (hours, minutes, seconds, nanos)
Duration duration = Duration.ofHours(2).plusMinutes(30);
Duration gap = Duration.between(LocalTime.of(9, 0), LocalTime.of(17, 30));
// PT8H30M (8 hours 30 minutes)
```

### 6.4 Formatting & Parsing

```java
import java.time.format.DateTimeFormatter;

LocalDate date = LocalDate.of(2026, 3, 23);

// Predefined formatters
date.format(DateTimeFormatter.ISO_LOCAL_DATE)        // "2026-03-23"

// Custom formatters
DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
date.format(fmt)                                      // "23/03/2026"

DateTimeFormatter fmtFull = DateTimeFormatter.ofPattern("EEEE, MMMM dd, yyyy");
date.format(fmtFull)                                  // "Monday, March 23, 2026"

// Parsing
LocalDate parsed = LocalDate.parse("23/03/2026", fmt);
```

---

## 7. Best Practices

1. **Always use `.equals()` for String comparison**, never `==`
2. **Use `StringBuilder`** for string concatenation in loops
3. **Program to interfaces:** declare `List<>`, not `ArrayList<>`
4. **Use `java.time`** for dates — avoid legacy `Date` and `Calendar`
5. **Check for null** before unboxing wrapper classes
6. **Use `List.of()`, `Set.of()`, `Map.of()`** for immutable collections
7. **Override `hashCode()` when you override `equals()`** for objects used in Sets/Maps

---

## 8. Common Pitfalls

| Pitfall | Example | Fix |
|---------|---------|-----|
| `String` comparison with `==` | `"abc" == new String("abc")` → false | Use `.equals()` |
| Modifying list during iteration | `ConcurrentModificationException` | Use `Iterator.remove()` or `removeIf()` |
| Null autoboxing | `Integer x = null; int y = x;` → NPE | Null check first |
| Array vs ArrayList confusion | Arrays are fixed-size | Use ArrayList for dynamic sizing |
| `Arrays.asList()` returns fixed-size list | Cannot add/remove | Use `new ArrayList<>(Arrays.asList(...))` |
| TreeSet with non-Comparable | `ClassCastException` | Implement `Comparable` or provide `Comparator` |

---

## 9. Exercises

1. **String Manipulation:** Write a method that reverses each word in a sentence while keeping word order.
2. **Array Operations:** Implement binary search on a sorted array without using `Arrays.binarySearch()`.
3. **Collection Practice:** Read a text file, count word frequencies, and display the top 10 most common words using a `Map`.
4. **Date Calculator:** Write a birthday calculator that tells how many days until the next birthday and how old the person will be.
5. **Custom Sorting:** Create a list of `Student` objects and sort by GPA (descending), then by name (ascending) using `Comparator`.

---

## 📖 References

- *Thinking in Java*, Bruce Eckel — Chapter 11 (Collections of Objects)
- *OCA: Oracle Certified Associate Java SE 8 Programmer I Study Guide* — Chapter 3 (Core Java APIs)
- *OCP: Oracle Certified Professional Java SE 8 Programmer II Study Guide* — Chapter 3 (Generics & Collections)
- *Java Coding Problems*, Anghel Leonard — Chapters 1 & 9 (Strings, Functional Programming)
- [Java Collections Framework Tutorial](https://docs.oracle.com/javase/tutorial/collections/)

---

[← Part 2: OOP Essentials](Part-02-OOP-Essentials.md) | [Back to Course Index](../README.md) | [Next: Part 4 — Exception Handling →](Part-04-Exception-Handling.md)
