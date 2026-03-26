# 01: C++ Fundamentals and Core Syntax

Welcome to Phase 1 of your C++ journey. This introductory module is inspired by the principles set forth in **The C++ Programming Language (4th Edition)** by Bjarne Stroustrup, the creator of C++.

C++ is a compiled, statically-typed, generic, and object-oriented programming language. Modern C++ (C++11 and beyond) emphasizes performance, safety, and conciseness.

---

## 1. Structure of a C++ Program

Every C++ program begins execution in a global function named `main`.

```cpp
#include <iostream> // Preprocessor directive: Includes the standard I/O library

// The entry point of a C++ application
int main() {
    // std::cout is the standard character output stream
    // << is the insertion operator
    // \n is the newline character (often preferred over std::endl for performance)
    std::cout << "Welcome to Modern C++!\n";

    // Returning 0 indicates successful execution to the operating system
    return 0; 
}
```

### Compilation (g++ or clang++)
To compile and run this code, save it in `main.cpp` and use a compiler:
```bash
g++ -std=c++20 main.cpp -o main
./main
```

---

## 2. Types, Variables, and Initialization

Modern C++ offers several ways to initialize variables. The preferred method is **Uniform Initialization** (using curly braces `{}`), which prevents narrowing conversions (e.g., trying to put a `double` into an `int`).

```cpp
#include <iostream>
#include <string>

int main() {
    // Standard built-in types
    int age {30};                       // Uniform initialization (Modern C++)
    double price = 19.99;               // Old C-style initialization
    bool is_valid {true};
    char grade {'A'};

    // Extended types mapping directly to hardware
    long int world_population {8000000000L};
    unsigned int positive_only {42};    // Cannot be negative

    // Modern C++ 'auto' keyword: Type inference
    // The compiler deduces the type from the initializer.
    auto name = "Bjarne";               // Deduced as const char* (C-style string)
    auto actual_string = std::string{"Stroustrup"}; // Deduced as std::string

    // Constants
    const int MAX_USERS {100};          // Must be evaluated at runtime, cannot be modified
    constexpr double PI {3.14159};      // Evaluated strictly at compile-time (very fast)

    std::cout << "Creator: " << name << " " << actual_string << "\n";
    return 0;
}
```

---

## 3. Control Flow

C++ provides standard control structures heavily optimized by the compiler.

### `if / else` and `switch`
```cpp
#include <iostream>

void evaluate(int score) {
    if (score >= 90) {
        std::cout << "A Grade\n";
    } else if (score >= 80) {
        std::cout << "B Grade\n";
    } else {
        std::cout << "Needs improvement\n";
    }

    // Switch statements require integral or enum types
    int category {2};
    switch (category) {
        case 1:
            std::cout << "Category 1\n";
            // FALLTHROUGH occurs if there is no break!
            break;
        case 2:
            std::cout << "Category 2\n";
            break;
        default:
            std::cout << "Unknown\n";
            break;
    }
}
```

### Loops (`for`, `while`, `do-while`)
Modern C++ relies heavily on the **Range-based for-loop** instead of manual iteration.

```cpp
#include <iostream>
#include <vector>

void loop_examples() {
    // 1. Classic for-loop (C-style)
    for (int i = 0; i < 5; ++i) {
        std::cout << i << " ";
    }
    std::cout << "\n";

    // 2. Range-based for-loop (Modern C++11+)
    // Ideal for iterating over standard library containers
    std::vector<int> numbers {10, 20, 30, 40, 50};
    
    // Using auto& avoids copying the elements, we are referencing them directly
    for (const auto& num : numbers) {
        std::cout << num << " ";
    }
    std::cout << "\n";

    // 3. While loop
    int count {3};
    while (count > 0) {
        std::cout << "Tick: " << count-- << "\n";
    }
}
```

---

## 4. Functions & Parameter Passing

Passing arguments correctly is crucial for performance. In C++, you can pass by **value** (copies the data), by **reference** (aliases the original data), or by **pointer** (holds memory address).

```cpp
#include <iostream>
#include <string>

// Pass By Value: Creates a heavy clone of the string. Slow.
void print_value(std::string text) {
    std::cout << text << "\n";
}

// Pass By Const Reference: No copy is made. Fast and read-only. Modifying is blocked.
void print_ref(const std::string& text) {
    std::cout << text << "\n";
}

// Pass By Reference (Mutable): Modifies the caller's original data.
void increment(int& val) {
    val++; // Modifies the actual integer passed into the function
}

int main() {
    std::string message = "Heavy data payload";
    print_ref(message); // Best practice

    int counter {0};
    increment(counter);
    std::cout << "Counter is now: " << counter << "\n"; // Output: 1

    return 0;
}
```



---

## 🛠️ Compilation and Execution

To experiment with the code snippets in this chapter, save them into a file named `main.cpp` and compile using modern C++ standards.

**Using GCC (`g++`):**
```bash
g++ -std=c++20 -Wall -Wextra -O2 main.cpp -o main
./main
```

**Using Clang (`clang++`):**
```bash
clang++ -std=c++20 -Wall -Wextra -O2 main.cpp -o main
./main
```

*Note: The `-std=c++20` flag enables modern C++ features, `-Wall -Wextra` turns on important compiler warnings, and `-O2` applies standard optimizations.*

### Conclusion to Fundamentals
To truly master C++, you must understand that every copy operation has a cost. By learning `const auto&` and reference syntax early, you adopt the mindset of a systems programmer. Next, we will dive into direct memory control in **02_Pointers_and_Memory.md**.
