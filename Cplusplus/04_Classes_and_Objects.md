# 04: Classes, Objects, and Resource Management

This module initiates Phase 2, drawing heavy inspiration from Bjarne Stroustrup's designs and Stanley Lippman's "Inside the C++ Object Model". 

C++ structures the concept of Object-Oriented Programming (OOP) around explicit control over an object’s lifetime: its **Construction**, **Copying**, **Moving**, and **Destruction**. 

---

## 1. The Structure of a Class

A `class` is indistinguishable from a `struct` in C++, except that a `struct` defaults its members to `public`, whereas a `class` defaults to `private`. 

```cpp
#include <iostream>
#include <string>

// Encapsulation: Grouping data and methods
class Player {
private: // Data hidden from external access
    std::string name;
    int health;
    int ammo;

public:  // API exposed to the user
    // 1. The Constructor (Initialization)
    Player(std::string n, int h, int a) 
        : name{n}, health{h}, ammo{a} { // The Member Initialization List (Fastest Initialization)
        std::cout << "Player " << name << " spawned in!\n";
    }

    // Const-correctness: Appending 'const' to a method guarantees it won't mutate the member variables
    void display() const {
        std::cout << "Player[" << name << "]: HP=" << health << " Ammo=" << ammo << "\n";
    }

    void shoot() {
        if (ammo > 0) {
            ammo--;
            std::cout << name << " fired! Ammo remaining: " << ammo << "\n";
        }
    }
};

int main() {
    Player doomguy{"Doomguy", 100, 50}; // Object created on the Stack
    doomguy.display();
    doomguy.shoot();
    
    // Player p2; // ERROR: No Default Constructor exists.
    return 0; // Stack unwinds, doomguy is automatically destroyed.
}
```

---

## 2. The Rule of Three (Legacy C++)

When your class manages a dynamic resource (like raw `new` memory, a file handle, or a network socket), C++'s default operations will destroy your program via double-frees or memory leaks.

If you manage a raw resource, you **must** manually define three things:
1. **Destructor:** To free the memory.
2. **Copy Constructor:** To deep-copy the resource when another object is assigned.
3. **Copy Assignment Operator (`operator=`):** same as above, but for reassignment.

```cpp
#include <iostream>

class DynamicArray {
private:
    int* data;
    size_t size;

public:
    // Constructor
    DynamicArray(size_t s) : size{s}, data{new int[s]} {
        std::cout << "Allocating Array\n";
    }

    // 1. Destructor
    ~DynamicArray() {
        delete[] data;
        std::cout << "Freeing Array\n";
    }

    // 2. Copy Constructor (Deep Copy)
    // Runs when: DynamicArray arr2 = arr1;
    DynamicArray(const DynamicArray& other) : size{other.size}, data{new int[other.size]} {
        std::copy(other.data, other.data + size, data);
        std::cout << "DEEP Copy Constructor Fired\n";
    }

    // 3. Copy Assignment Operator
    // Runs when: arr2 = arr1; (Both already instantiated)
    DynamicArray& operator=(const DynamicArray& other) {
        if (this == &other) return *this; // Protect against self-assignment: arr = arr;

        delete[] data; // Destroy our old data

        size = other.size; // Copy new sizes
        data = new int[other.size];
        std::copy(other.data, other.data + size, data); // Deep Copy

        std::cout << "DEEP Copy Assignment Fired\n";
        return *this;
    }
};
```

---

## 3. Move Semantics & The Rule of Five (Modern C++11)

Deep copying gigabytes of memory is slow. What if you just want to *transfer ownership* of a temporary object to a new one, without copying anything? 
C++11 introduced the Move Constructor and Move Assignment. `std::move()` forces an lvalue (persistent variable) to become an rvalue (temporary, stealable variable).

We add these two to the Rule of 3, making it the **Rule of 5**:

```cpp
    // 4. Move Constructor
    // The '&&' denotes an rvalue reference (a temporary object about to die)
    DynamicArray(DynamicArray&& other) noexcept 
        : size{other.size}, data{other.data} { // Steal the pointer!
        
        other.data = nullptr; // Null out the dying object so its destructor doesn't free the memory!
        other.size = 0;
        std::cout << "MOVE Constructor Fired (Zero Cost)\n";
    }

    // 5. Move Assignment Operator
    DynamicArray& operator=(DynamicArray&& other) noexcept {
        if (this == &other) return *this;

        delete[] data; // Free current memory

        size = other.size; // Steal size
        data = other.data; // Steal memory pointer

        other.data = nullptr; // Neutralize target
        other.size = 0;

        std::cout << "MOVE Assignment Fired\n";
        return *this;
    }
```

---

## 4. The Rule of Zero (Best Practice)

While the Rule of Five exists for library writers, application developers should follow the **Rule of Zero**.

If you use STL containers (`std::vector`, `std::string`) or Smart Pointers (`std::unique_ptr`), they already handle the Rule of Five correctly! You don't need to write custom destructors or copy mechanisms at all.

```cpp
#include <string>
#include <vector>

// This class follows the Rule of Zero
class ApplicationData {
private:
    std::string user_name;         // Handles its own destruction and copying!
    std::vector<int> user_scores;  // Automatically deep copies elements, and cleans up itself!
    // No raw pointers!

public:
    ApplicationData(std::string name) : user_name{name} {}
    // The compiler auto-generates perfect Copy/Move/Destructors.
};
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

