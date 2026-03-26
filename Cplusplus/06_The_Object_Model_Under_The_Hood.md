# 06: The Object Model Under The Hood

This document dives into the concepts discussed in **Inside the C++ Object Model** by Stanley Lippman. It answers the critical question: *How does C++ lay out object memory compared to C?*

C++ was famously designed with the "Zero Overhead Principle". This means you do not pay for features you don't use.

---

## 1. Class Data Layout

In plain C, a `struct` is simply contiguous data exactly mapping to memory. What happens when we add member functions (`methods`) to a C++ `class`?

```cpp
class PlainObject {
private:
    int x;   // 4 bytes
    float y; // 4 bytes

public:
    void print() { } // Where is this stored?
};
```

**Fact:** `sizeof(PlainObject)` is exactly 8 bytes (assuming tight packing). 

Member functions do **not** take up space inside the object instance. They are simply global functions disguised by the compiler to secretly take a hidden argument: the `this` pointer. 

`obj.print();` becomes `PlainObject_print(&obj);` in assembly.

---

## 2. The Cost of Polymorphism (The `vptr` and `vtable`)

The moment you add a `virtual` keyword to your class, you incur overhead. 
You are asking the runtime to dynamically figure out which function to execute. The compiler can no longer hardcode the function address.

```cpp
class VirtualObject {
private:
    int x;   // 4 bytes
    float y; // 4 bytes

public:
    virtual void print() { } 
};
```

**Fact:** `sizeof(VirtualObject)` is **16 bytes** (on a 64-bit system). 
4 (int) + 4 (float) + 8 (hidden pointer).

### The Mechanism
1. The compiler creates a **Virtual Table (vtable)** statically (once per class). This table is an array of function pointers pointing to the class's specific implementations of the virtual functions.
2. The compiler injects a hidden pointer called the **vptr** into every single *instance* of the class.
3. This `vptr` points to the class's `vtable`.
4. When you call `obj->print()`, the CPU reads the `vptr`, jumps to the `vtable`, looks up the pointer for `print()`, and executes the correct overridden function.

This is extremely fast (just one extra pointer indirection), but it breaks raw memory compatibility with C structures.

---

## 3. Multiple Inheritance

C++ allows a class to inherit from multiple base classes simultaneously. This introduces extreme complexity into the memory layout.

```cpp
class Printer { int ink; virtual void print(); };
class Scanner { int res; virtual void scan(); };

class MultiFunctionDevice : public Printer, public Scanner {
    int fax_number;
    void print() override;
    void scan() override;
};
```

If memory layout in Single Inheritance is contiguous (`[vptr, ink]`), Multiple Inheritance lays them end-to-end:
`[Printer: vptr1, ink] [Scanner: vptr2, res] [MFD: fax_number]`

If you cast an MFD object pointer to a `Scanner` pointer, the compiler silently *adjusts the address* of the pointer to jump past the `Printer` data, pointing perfectly at the start of the `Scanner` sub-object!

### The Diamond Problem
If two base classes inherit from a common grand-parent, you end up with two entirely separate copies of the grand-parent!

```text
    Person
   /      \
Student  Employee
   \      /
  TA (Teaching Assistant)
```
A `TA` would literally have two `name` variables.
You solve this via **Virtual Inheritance** (`class Student : virtual public Person`), which forces the compiler to share a single base instance using hidden offset tables.



---

## 🛠️ Compilation and Execution

To experiment with the code snippets in this chapter, save them into a file named `main.cpp` and compile using modern C++ standards.

<p align="center">
  <img src="images/tux_linux.png" alt="Linux (Tux)" width="120"/>
</p>

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

### Conclusion to The Object Model
C++ is a zero-overhead language until you use `virtual`. When you use `virtual`, you accept the hidden 8-byte `vptr` penalty and an extra pointer lookup per function call. Knowing exactly when you need static binding (Templates) vs dynamic binding (Polymorphism) is what elevates a developer to mastery.
