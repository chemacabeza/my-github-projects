# Part 9: I/O & NIO

<p align="center">
<img src="../images/part09_cover.png" alt="I/O & NIO" width="800"/>
</p>

> **Sources:** *Core Java, Vol. I* (Horstmann) · *Java: The Complete Reference* (Schildt) · *Effective Java* (Bloch, Item 9)

---

## 🎯 Learning Objectives

By the end of this part, you will:
- Read and write files using modern `java.nio.file` APIs
- Work with byte streams, character streams, and buffered I/O
- Navigate the filesystem with `Path` and `Files`
- Understand serialization and its dangers
- Use try-with-resources for safe resource management

---

## 1. The Two I/O Systems

> **Feynman Insight:** Java has two I/O systems. The **old one** (`java.io`) is like sending letters through the postal service — reliable but slow, one letter at a time. The **new one** (`java.nio`) is like a highway system with channels and buffers — faster, more flexible, and designed for modern workloads. For new code, always start with `java.nio.file`.

---

## 2. Path & Files — The Modern Way

### 2.1 Creating Paths

```java
import java.nio.file.*;

Path path = Path.of("data", "users.txt");            // data/users.txt
Path path = Path.of("/home/user/documents/file.txt"); // Absolute
Path path = Paths.get("data", "users.txt");           // Alternative (older API)

// Path operations
path.getFileName();     // users.txt
path.getParent();       // data
path.toAbsolutePath();  // /full/path/to/data/users.txt
path.resolve("sub");    // data/users.txt/sub
path.getParent().resolve("other.txt");  // data/other.txt
```

### 2.2 Reading Files

```java
// Read entire file as String (small files)
String content = Files.readString(Path.of("data.txt"));

// Read all lines into a List
List<String> lines = Files.readAllLines(Path.of("data.txt"));

// Read all bytes
byte[] bytes = Files.readAllBytes(Path.of("image.png"));

// Stream lines lazily (large files — memory-efficient)
try (Stream<String> lines = Files.lines(Path.of("huge.txt"))) {
    lines.filter(line -> line.contains("ERROR"))
         .forEach(System.out::println);
}
```

### 2.3 Writing Files

```java
// Write string to file
Files.writeString(Path.of("output.txt"), "Hello, World!");

// Write lines
Files.write(Path.of("output.txt"), List.of("Line 1", "Line 2", "Line 3"));

// Append to existing file
Files.writeString(Path.of("log.txt"), "New entry\n",
    StandardOpenOption.APPEND, StandardOpenOption.CREATE);

// Write bytes
Files.write(Path.of("output.bin"), byteArray);
```

### 2.4 File Operations

```java
// Check existence
boolean exists = Files.exists(Path.of("data.txt"));
boolean isDir = Files.isDirectory(Path.of("data"));

// Create directories
Files.createDirectories(Path.of("a/b/c"));  // Creates all parent dirs

// Copy, move, delete
Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING);
Files.move(source, target, StandardCopyOption.ATOMIC_MOVE);
Files.delete(path);            // Throws if not exists
Files.deleteIfExists(path);    // Returns false if not exists

// List directory contents
try (DirectoryStream<Path> stream = Files.newDirectoryStream(dir, "*.txt")) {
    for (Path entry : stream) {
        System.out.println(entry.getFileName());
    }
}

// Walk directory tree
try (Stream<Path> walk = Files.walk(Path.of("src"))) {
    walk.filter(p -> p.toString().endsWith(".java"))
        .forEach(System.out::println);
}
```

---

## 3. Classic I/O Streams

### 3.1 Byte Streams

```java
// Reading bytes
try (FileInputStream fis = new FileInputStream("image.png")) {
    byte[] buffer = new byte[1024];
    int bytesRead;
    while ((bytesRead = fis.read(buffer)) != -1) {
        process(buffer, bytesRead);
    }
}

// Buffered for performance
try (BufferedInputStream bis = new BufferedInputStream(new FileInputStream("large.dat"))) {
    // Much faster — reads in chunks instead of byte by byte
}
```

### 3.2 Character Streams

```java
// Reading text
try (BufferedReader reader = new BufferedReader(new FileReader("data.txt"))) {
    String line;
    while ((line = reader.readLine()) != null) {
        System.out.println(line);
    }
}

// Writing text
try (BufferedWriter writer = new BufferedWriter(new FileWriter("output.txt"))) {
    writer.write("Hello, World!");
    writer.newLine();
    writer.write("Second line");
}

// PrintWriter — more convenient
try (PrintWriter pw = new PrintWriter(new FileWriter("output.txt"))) {
    pw.println("Line 1");
    pw.printf("Name: %s, Age: %d%n", "Alice", 30);
}
```

> **Bloch, Item 9:** *"Prefer try-with-resources to try-finally."* Every example above uses try-with-resources because it guarantees resources are closed even if exceptions occur.

---

## 4. Serialization

> **Bloch's Warning** (*Effective Java*, Items 85–90): Serialization is a "minefield" and the source of many security vulnerabilities. Prefer JSON or Protocol Buffers for data interchange.

```java
// Serializable class
public class Person implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;  // Version control

    private String name;
    private transient String password;  // Won't be serialized!
    private int age;
}

// Serialize (write object to file)
try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("person.ser"))) {
    oos.writeObject(new Person("Alice", "secret", 30));
}

// Deserialize (read object from file)
try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream("person.ser"))) {
    Person person = (Person) ois.readObject();
}
```

---

## 5. Best Practices

1. **Use `java.nio.file`** (`Path`, `Files`) for all new file operations
2. **Always use try-with-resources** for I/O (Bloch, Item 9)
3. **Use `Files.readString()`/`Files.writeString()`** for simple file operations
4. **Use `Files.lines()`** for large files — lazy, memory-efficient
5. **Buffer your streams** — `BufferedReader`/`BufferedWriter` dramatically improves performance
6. **Avoid Java serialization** — prefer JSON/Jackson for data interchange (Bloch, Items 85–90)
7. **Specify character encoding** explicitly — `StandardCharsets.UTF_8`

---

## 6. Exercises

1. **File Copier:** Copy a file byte-by-byte using `FileInputStream`/`FileOutputStream`, then compare performance with `Files.copy()`.
2. **Log Analyzer:** Read a large log file using `Files.lines()` and count occurrences of "ERROR", "WARN", and "INFO".
3. **Directory Tree:** Walk a directory tree and list all files by extension with their total sizes.
4. **CSV Parser:** Read a CSV file, parse each line, and create a `List<Map<String, String>>`.

---

## 📖 References

- *Core Java, Volume I*, Cay S. Horstmann — Chapters 1–2 (Input/Output, NIO)
- *Java: The Complete Reference*, Herbert Schildt — Chapters 13, 20 (I/O, NIO)
- *Effective Java*, Joshua Bloch — Item 9 (try-with-resources), Items 85–90 (serialization)

---

[← Part 8: Concurrency](Part-08-Concurrency.md) | [Back to Course Index](../README.md) | [Next: Part 10 — JDBC & Databases →](Part-10-JDBC-And-Databases.md)
