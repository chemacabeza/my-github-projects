# Part 12: Java Native Interface (JNI) & Project Panama

> **Sources:** *The Java Native Interface* · *Java Coding Problems* (Ch. 7)

---

## 🎯 Learning Objectives

- Understand when and why to call native code from Java
- Use JNI to bridge Java and C/C++ code
- Explore Project Panama's Foreign Function & Memory API (Java 21+)
- Work with memory segments, arenas, and native layouts
- Call native library functions without JNI boilerplate

---

## 1. Why Native Code?

| Reason | Example |
|--------|---------|
| Performance-critical code | Image processing, cryptography |
| Access OS-specific features | System calls, hardware access |
| Reuse existing C/C++ libraries | OpenGL, SQLite, machine learning libs |
| Legacy system integration | Mainframe connectors |

---

## 2. JNI — The Classic Approach

### 2.1 The JNI Workflow

```
1. Write Java class with native methods
2. Compile the Java class
3. Generate C header with javac -h
4. Implement the C/C++ function
5. Compile the native library (.so / .dylib / .dll)
6. Load and call from Java
```

### 2.2 Java Side

```java
public class NativeGreeter {
    // Load native library
    static {
        System.loadLibrary("greeter");  // Loads libgreeter.so / greeter.dll
    }

    // Declare native method
    public native String greet(String name);
    public native int add(int a, int b);
    public native double[] transform(double[] input);

    public static void main(String[] args) {
        NativeGreeter ng = new NativeGreeter();
        System.out.println(ng.greet("Java"));
        System.out.println(ng.add(3, 4));
    }
}
```

### 2.3 Generate Header

```bash
javac -h . NativeGreeter.java
# Generates: NativeGreeter.h
```

### 2.4 C Implementation

```c
#include <jni.h>
#include <string.h>
#include "NativeGreeter.h"

JNIEXPORT jstring JNICALL Java_NativeGreeter_greet
  (JNIEnv *env, jobject obj, jstring name) {
    const char *nameStr = (*env)->GetStringUTFChars(env, name, NULL);
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "Hello from C, %s!", nameStr);
    (*env)->ReleaseStringUTFChars(env, name, nameStr);
    return (*env)->NewStringUTF(env, buffer);
}

JNIEXPORT jint JNICALL Java_NativeGreeter_add
  (JNIEnv *env, jobject obj, jint a, jint b) {
    return a + b;
}
```

### 2.5 Compile & Run

```bash
# macOS
gcc -shared -o libgreeter.dylib -I$JAVA_HOME/include -I$JAVA_HOME/include/darwin NativeGreeter.c

# Linux
gcc -shared -o libgreeter.so -I$JAVA_HOME/include -I$JAVA_HOME/include/linux NativeGreeter.c -fPIC

# Run
java -Djava.library.path=. NativeGreeter
```

### 2.6 JNI Type Mappings

| Java Type | JNI Type | C Type |
|-----------|----------|--------|
| `boolean` | `jboolean` | `unsigned char` |
| `byte` | `jbyte` | `signed char` |
| `int` | `jint` | `int` |
| `long` | `jlong` | `long long` |
| `float` | `jfloat` | `float` |
| `double` | `jdouble` | `double` |
| `String` | `jstring` | — |
| `Object` | `jobject` | — |
| `int[]` | `jintArray` | — |

### 2.7 JNI Pitfalls

- **Memory leaks** — always release strings/arrays obtained from JNI
- **Thread safety** — JNI calls are not inherently thread-safe
- **Error handling** — C errors can crash the entire JVM
- **Platform-specific** — must compile for each OS/architecture
- **Debugging** — native crashes produce core dumps, not stack traces

---

## 3. Project Panama — The Modern Approach (Java 21+)

Panama replaces JNI with a **pure-Java API** for calling native code — no C header generation, no compilation step.

### 3.1 Key Concepts

| Concept | Description |
|---------|-------------|
| **Arena** | Manages lifecycle of native memory |
| **MemorySegment** | A typed view of native memory |
| **MemoryLayout** | Describes the structure of native data |
| **Linker** | Links Java to native functions |
| **FunctionDescriptor** | Describes native function signature |
| **SymbolLookup** | Finds native functions in libraries |

### 3.2 Allocating Native Memory

```java
import java.lang.foreign.*;

// Using Arena for memory management
try (Arena arena = Arena.ofConfined()) {
    // Allocate a single int
    MemorySegment intSegment = arena.allocate(ValueLayout.JAVA_INT);
    intSegment.set(ValueLayout.JAVA_INT, 0, 42);
    int value = intSegment.get(ValueLayout.JAVA_INT, 0);  // 42

    // Allocate a string
    MemorySegment strSegment = arena.allocateFrom("Hello, Panama!");
    String str = strSegment.getString(0);  // "Hello, Panama!"

    // Allocate an array of doubles
    MemorySegment arraySegment = arena.allocate(ValueLayout.JAVA_DOUBLE, 10);
    arraySegment.setAtIndex(ValueLayout.JAVA_DOUBLE, 0, 3.14);
    arraySegment.setAtIndex(ValueLayout.JAVA_DOUBLE, 1, 2.71);
}
// Memory is automatically freed when arena is closed
```

### 3.3 Calling C Standard Library Functions

```java
import java.lang.foreign.*;
import java.lang.invoke.*;

// Get the standard C library linker
Linker linker = Linker.nativeLinker();
SymbolLookup stdlib = linker.defaultLookup();

// Call strlen
MethodHandle strlen = linker.downcallHandle(
    stdlib.find("strlen").orElseThrow(),
    FunctionDescriptor.of(ValueLayout.JAVA_LONG, ValueLayout.ADDRESS)
);

try (Arena arena = Arena.ofConfined()) {
    MemorySegment str = arena.allocateFrom("Hello, World!");
    long length = (long) strlen.invoke(str);  // 13
    System.out.println("Length: " + length);
}
```

### 3.4 Calling Functions from Custom Libraries

```java
// Load a custom native library
SymbolLookup myLib = SymbolLookup.libraryLookup("libmymath", Arena.global());

// Describe the function: double add(double a, double b)
FunctionDescriptor addDesc = FunctionDescriptor.of(
    ValueLayout.JAVA_DOUBLE,    // return type
    ValueLayout.JAVA_DOUBLE,    // param 1
    ValueLayout.JAVA_DOUBLE     // param 2
);

MethodHandle addHandle = linker.downcallHandle(
    myLib.find("add").orElseThrow(),
    addDesc
);

double result = (double) addHandle.invoke(3.14, 2.71);  // 5.85
```

### 3.5 Working with C Structs

```java
// C struct:
// struct Point { double x; double y; };

StructLayout pointLayout = MemoryLayout.structLayout(
    ValueLayout.JAVA_DOUBLE.withName("x"),
    ValueLayout.JAVA_DOUBLE.withName("y")
);

VarHandle xHandle = pointLayout.varHandle(MemoryLayout.PathElement.groupElement("x"));
VarHandle yHandle = pointLayout.varHandle(MemoryLayout.PathElement.groupElement("y"));

try (Arena arena = Arena.ofConfined()) {
    MemorySegment point = arena.allocate(pointLayout);
    xHandle.set(point, 0L, 3.0);
    yHandle.set(point, 0L, 4.0);

    double x = (double) xHandle.get(point, 0L);  // 3.0
    double y = (double) yHandle.get(point, 0L);  // 4.0
}
```

### 3.6 Jextract — Automatic Binding Generation

```bash
# Generate Java bindings from a C header file
jextract --source -t com.example.mylib -I /usr/include mylib.h

# This generates Java classes that wrap all functions, structs, and constants
```

---

## 4. JNI vs. Panama Comparison

| Feature | JNI | Panama (FFM API) |
|---------|-----|-------------------|
| Requires C code | ✅ Header + implementation | ❌ Pure Java |
| Type safety | ❌ Manual mapping | ✅ Compiler-checked |
| Memory management | ❌ Manual | ✅ Arena-based |
| Performance | Good | Better (no JNI overhead) |
| Debugging | Difficult (native crashes) | Easier (Java exceptions) |
| Platform binaries | Required | Not required |
| Complexity | High | Lower |
| Maturity | Decades | Relatively new |

---

## 5. Best Practices

1. **Prefer Panama over JNI** for new projects (Java 21+)
2. **Always use Arena** for memory management — never leak native memory
3. **Cache MethodHandles** — creating them is expensive
4. **Minimize JNI calls** — batch operations reduce overhead
5. **Use Jextract** for large C headers — don't hand-write bindings
6. **Test on all target platforms** — native code is platform-specific
7. **Handle native errors gracefully** — don't let C crashes kill the JVM

---

## 6. Exercises

1. **JNI Basics:** Write a JNI wrapper for a simple C math library (add, multiply, sqrt)
2. **Panama Hello World:** Call `printf` from C standard library using Panama FFM API
3. **Struct Manipulation:** Create and manipulate a C struct (`Point3D`) using Panama layouts
4. **Library Wrapper:** Use Panama to wrap a system library (e.g., `libz` for compression)
5. **Benchmark:** Compare JNI vs Panama performance for calling a function 1 million times

---

## 📖 References

- *The Java Native Interface*, Sheng Liang — Complete JNI reference
- *Java Coding Problems*, Anghel Leonard — Ch. 7 (Foreign Function & Memory API, Project Panama)
- [JEP 454: Foreign Function & Memory API](https://openjdk.org/jeps/454)
- [Jextract Tool](https://jdk.java.net/jextract/)

---

[← Part 11: Modern Java Features](Part-11-Modern-Java-Features.md) | [Back to Course Index](../README.md)
