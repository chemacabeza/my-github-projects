# 07: Template Basics 

This phase distills the knowledge from **C++ Templates: The Complete Guide** by David Vandevoorde and Nicolai M. Josuttis. 

Templates are the foundation of C++’s "Generic Programming." Instead of writing one function for `int` and another for `double`, you write a generic *Template*, and the compiler generates the specific functions for you when you use them.

This forms the basis of **Static Polymorphism** (Compile-Time), avoiding the performance overhead of the `vtable` we saw in Object-Oriented Programming (Dynamic Polymorphism).

---

## 1. Function Templates

A function template is a blueprint for generating functions. Wait, that means the source code you write using `template <typename T>` doesn't exist in the compiled binary! Only the specific *instantiations* (e.g., `T = int`, `T = double`) actually become machine code.

```cpp
#include <iostream>

// The Template Parameter List defines abstract generalized types
template <typename T>
T find_max(T a, T b) {
    // The compiler simply replaces 'T' with 'int' or 'double' behind the scenes.
    // As long as the types support the '>' operator, this works!
    return (a > b) ? a : b;
}

int main() {
    int x1 {10}, y1 {20};
    // 1. Implicit Deduction (Compiler looks at parameters x1 and y1)
    std::cout << find_max(x1, y1) << "\n"; // Instantiates find_max<int>

    double x2 {3.14}, y2 {2.71};
    // 2. Explicit Instantiation (Forcing the type)
    std::cout << find_max<double>(x2, y2) << "\n"; // Instantiates find_max<double>

    return 0;
}
```

### The Cost of Templates
Code bloat! If you call `find_max` with an `int`, a `double`, a `float`, and a custom `Player` class, the compiler copies and pastes the function body 4 separate times in your compiled executable.

---

## 2. Class Templates

The exact same concept applies to entire classes. In fact, this is how `std::vector` is implemented in the Standard Template Library.

```cpp
#include <iostream>

template <typename T>
class Box {
private:
    T content; // The actual data type is deferred until instantiation

public:
    // Constructor
    Box(T val) : content{val} {}

    // Method to retrieve content
    T get_content() const {
        return content;
    }
};

int main() {
    Box<int> int_box{100};       // The compiler builds 'class Box_int { int content; ... }'
    Box<double> double_box{99.9};

    std::cout << int_box.get_content() << "\n";
}
```

---

## 3. Template Parameters: Non-Types

Templates aren't just limited to *types* (`typename T`). They can also accept actual values (like integers or pointers) known strictly at compile time.

```cpp
#include <iostream>

// We accept a Type (T) and an integer constant (Size). 
// Size MUST be known at compile-time.
template <typename T, int Size>
class FixedArray {
private:
    T data[Size]; // This allows the array to live on the Stack instead of the Heap!

public:
    int get_size() const { return Size; }
};

int main() {
    FixedArray<double, 10> my_array; // A perfectly sized, Stack-allocated 10-element array of doubles
    std::cout << my_array.get_size() << "\n";
}
```
*Note: This is exactly how `std::array<T, N>` works in Modern C++.*

---

## Conclusion
Function and Class Templates are straightforward tools for reusability. However, their true power comes when you try to manipulate *how* the compiler instantiates them using Specialization and Constexpr manipulation, leading to the realm of Template Metaprogramming (TMP). That is what we explore next in **08_Advanced_Templates.md**.


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

