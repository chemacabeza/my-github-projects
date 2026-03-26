# 08: Advanced Templates and SFINAE

This module elevates our understanding beyond code generation into the domain of **Template Metaprogramming (TMP)**. In advanced C++, you use templates not just to avoid writing duplicate functions, but to write programs that *execute during compilation*.

---

## 1. Template Specialization

Sometimes, a generic template doesn’t make sense for a specific type. For example, a `print()` template might work perfectly for `int` and `double`, but completely fail for a raw C-Style pointer like `char*`.

You solve this by providing a targeted overwrite called **Full Specialization**.

```cpp
#include <iostream>
#include <cstring>

// 1. The Generic Template Framework
template <typename T>
class DataPrinter {
public:
    void print(T data) {
        std::cout << "Generic Printer: " << data << "\n";
    }
};

// 2. The Full Specialization
// We tell the compiler: "Ignore the generic one if T is exactly 'char*'."
template <>
class DataPrinter<char*> {
public:
    void print(char* data) {
        std::cout << "C-String Specialized Printer: " << data << " (Length: " << std::strlen(data) << ")\n";
    }
};

int main() {
    DataPrinter<int> int_printer;
    int_printer.print(42); // Uses generic

    char text[] = "Hello World";
    DataPrinter<char*> char_printer;
    char_printer.print(text); // Compiles down directly to the Specialized version!
}
```

---

## 2. Variadic Templates (C++11)

Classic C++ had no way to create a function that takes an arbitrary number of strongly typed arguments safely (C's `printf` using `va_list` is notoriously unsafe). 

C++11 introduced Variadic Templates, which use recursion to unroll parameter packs.

```cpp
#include <iostream>

// Base Case: The recursion must stop!
void print_all() {
    std::cout << "Finished.\n";
}

// Recursive Case
// The '...' unpacks multiple types
template <typename T, typename... Args>
void print_all(T first, Args... rest) {
    std::cout << first << "\n";
    print_all(rest...); // Calls itself, passing all remaining arguments
}

int main() {
    // 1. print_all(42, "string", 3.14) (Extracts 42)
    // 2. print_all("string", 3.14)     (Extracts "string")
    // 3. print_all(3.14)               (Extracts 3.14)
    // 4. print_all()                   (Base case triggers, ending recursion)

    print_all(42, "C++", 3.1415, 'A'); 
}
```
*Note: C++17 introduced **Fold Expressions**, which completely replaces the need for recursion in cases like this, unrolling the parameters entirely inline.*

---

## 3. SFINAE (Substitution Failure Is Not An Error)

This is a notorious acronym in advanced C++. When the compiler tries to instantiate a template, it substitutes the generic `T` with the requested type (e.g., `int`). 

If this substitution results in syntactically invalid code, the compiler **does not throw a hard error immediately**. Instead, it silently ignores that specific template and looks to see if *another* overloaded template works.

This allows developers to use type traits (like `std::enable_if`) to actively turn templates "on" or "off" based on the characteristics of the type!

```cpp
#include <iostream>
#include <type_traits> // Critical for Type Traits

// Template 1: Enabled ONLY if T is an Integer!
// std::enable_if yields 'void' if true, allowing this template to exist. If false, it fails silently (SFINAE).
template <typename T>
typename std::enable_if<std::is_integral<T>::value>::type
process(T data) {
    std::cout << data << " is an Integer. Fast integer math applied.\n";
}

// Template 2: Enabled ONLY if T is a Floating Point number!
template <typename T>
typename std::enable_if<std::is_floating_point<T>::value>::type
process(T data) {
    std::cout << data << " is a Float. High precision math applied.\n";
}

int main() {
    process(100);    // Triggers is_integral. process<int> chosen.
    process(3.1415); // Triggers is_floating_point. process<double> chosen.
    
    // process("FAIL"); // Hard compiler error! No template enabled for const char*.
}
```

### Modern Solutions (C++20 Concepts)
The syntax for SFINAE and `std::enable_if` is incredibly verbose. C++20 introduced **Concepts** to replace it with clean logic:

```cpp
// C++20 Concept approach
template <std::integral T>
void process(T data) {
    std::cout << data << " uses clean C++20 Constraints.\n";
}
```


---

## 🛠️ Compilation and Execution

To experiment with the code snippets in this chapter, save them into a file named `main.cpp` and compile using modern C++ standards.

**�� Linux (GCC or Clang):**
```bash
# Using GCC (most common on Linux)
g++ -std=c++20 -Wall -Wextra -O2 main.cpp -o main
./main

# Or using Clang
clang++ -std=c++20 -Wall -Wextra -O2 main.cpp -o main
./main
```

**🍎 macOS (Apple Clang — ships with Xcode Command Line Tools):**
```bash
# Install compiler tools if not already present
xcode-select --install

# Apple Clang supports C++20
clang++ -std=c++20 -Wall -Wextra -O2 main.cpp -o main
./main

# If you installed GCC via Homebrew (brew install gcc):
g++-14 -std=c++20 -Wall -Wextra -O2 main.cpp -o main
./main
```

> **Note:** On macOS, the default `g++` command is actually **Apple Clang**, not GNU GCC. If you installed GCC via Homebrew, use `g++-14` (or your installed version number) to invoke real GCC explicitly.

