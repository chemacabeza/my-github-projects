# 02: Pointers, References, and Memory Management

<p align="center">
  <img src="images/cpp_pointer.png" alt="C++ Pointer Memory Visualization" width="800"/>
</p>

This module bridges the gap between high-level logic and hardware manipulation. In C++, you have direct control over memory layout and allocation. Understanding this boundary is key to writing safe, lightning-fast code.

---

## 1. Memory Addresses and The Stack

Variables created inside a function live on the **Stack**. The Stack is fast, automatically managed memory that is cleaned up when the function exits (returns).

```cpp
#include <iostream>

int main() {
    int score {100};
    
    // The '&' operator retrieves the exact hexadecimal memory address of a variable
    std::cout << "Value: " << score << "\n";
    std::cout << "Memory Address: " << &score << "\n"; // e.g., 0x7ffeefbff568

    return 0;
}
```

---

## 2. Raw Pointers (`*`)

A **Pointer** is a variable that stores a memory address. Rather than storing `100`, it stores `0x7ffeefbff568`.

```cpp
#include <iostream>

int main() {
    int age {25};
    int* ptr_to_age = &age; // ptr_to_age holds the address of the 'age' variable

    // Dereferencing: Use '*' on a pointer to access or modify the value at that address
    *ptr_to_age = 30;

    std::cout << "Age is now: " << age << "\n"; // Outputs 30

    // Null Pointers (Modern C++)
    // Never use 'NULL' or '0'. Always use 'nullptr'.
    int* safe_ptr = nullptr;
    
    if (safe_ptr != nullptr) {
        std::cout << *safe_ptr << "\n"; // Prevents Segmentation Fault
    }

    return 0;
}
```

---

## 3. Pointers vs References (`&`)

References were introduced in C++ as a safer, easier-to-read alternative to pointers. A reference is essentially an alias for an existing variable. Under the hood, they are often implemented as pointers, but you cannot reassign them to point to something else once initialized.

| Feature | Raw Pointer (`*`) | Reference (`&`) |
| :--- | :--- | :--- |
| **Syntax** | `int* ptr = &val;` | `int& ref = val;` |
| **Nullability**| Can be `nullptr`. Must check before use. | Cannot be null. Safer. |
| **Reassignment** | Can point to different variables later. | Bound to one variable for life. |
| **Dereferencing** | Must use `*ptr`. | Use normally (`ref`). |

```cpp
void demonstrate() {
    int value {10};
    int another_value {20};

    // Reference
    int& ref = value;
    ref = 15; // Modifies 'value'
    // ref = another_value; -> This just sets 'value' to 20, it does NOT re-bind 'ref'.

    // Pointer
    int* ptr = &value;
    *ptr = 15; // Modifies 'value'
    ptr = &another_value; // Re-binds! ptr now addresses a different integer.
}
```

---

## 4. The Heap & Dynamic Allocation (Classic C++)

The Stack is small (a few Megabytes). To store gigantic objects or data whose lifetime must outlive the function that created it, you must use the **Heap** (Dynamic Memory).

In legacy C++, you managed this manually with `new` and `delete`.

```cpp
void classic_memory() {
    // 1. Allocate memory on the Heap. 'new' returns a pointer.
    int* my_array = new int[100]; 

    // 2. Use the memory (Warning: arrays don't bounds-check raw pointers!)
    my_array[0] = 50;
    my_array[99] = 100;

    // 3. YOU MUST FREE IT! Otherwise you cause a Memory Leak.
    // Because we used 'new []', we must use 'delete []'.
    delete[] my_array;

    // 4. Set the pointer to nullptr so you don't accidentally use a "Dangling Pointer".
    my_array = nullptr; 
}
```
**The Problem:** If an exception is thrown before `delete[]` is called, the memory leaks permanently.

---

## 5. Modern Smart Pointers (`<memory>`)

Modern C++ entirely abandons manual `new` and `delete` in application code. Instead, we use Smart Pointers. They automatically `delete` the memory when they fall out of scope, a concept known as **RAII** (Resource Acquisition Is Initialization).

### `std::unique_ptr` (Exclusive Ownership)
An object managed by a unique pointer has exactly one owner. When the owner goes out of scope, the memory is deleted. It is fast and has zero overhead compared to raw pointers.

```cpp
#include <iostream>
#include <memory> 

class Sensor {
public:
    Sensor() { std::cout << "Sensor Created\n"; }
    ~Sensor() { std::cout << "Sensor Destroyed\n"; }
    void read() { std::cout << "Reading data...\n"; }
};

void fetch_data() {
    // std::make_unique is safe and fast. No 'new' or 'delete' visible!
    std::unique_ptr<Sensor> s = std::make_unique<Sensor>();
    
    s->read(); // Use the -> operator just like a raw pointer

    // As soon as this function ends, the Sensor destructor is automatically called.
    // No memory leaks possible!
}
```

### `std::shared_ptr` (Shared Ownership)
Maintains a reference count. The memory is deleted only when the *last* `shared_ptr` pointing to it goes out of scope.

```cpp
#include <memory>

void shared_example() {
    std::shared_ptr<int> p1 = std::make_shared<int>(100);
    {
        std::shared_ptr<int> p2 = p1; // Reference count is now 2
        // Both p1 and p2 point to the same integer (100)
    } // p2 falls out of scope. Reference count drops to 1. Memory is NOT deleted.

} // p1 falls out of scope. Reference count drops to 0. Memory is DELETED.
```



---

## 🛠️ Compilation and Execution

To experiment with the code snippets in this chapter, save them into a file named `main.cpp` and compile using modern C++ standards.

**🐧 Linux (GCC or Clang):**
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

### Conclusion to Memory Management
The golden rule of modern C++: **Never use raw `new` and `delete`. Provide zero overhead using `std::unique_ptr` default, and fallback to `std::shared_ptr` only when multiple, unsynchronized owners exist.**
