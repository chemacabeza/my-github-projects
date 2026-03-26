# 05: Inheritance and Polymorphism

<p align="center">
  <img src="images/cpp_inheritance.png" alt="C++ Inheritance and Polymorphism" width="800"/>
</p>

Inheritance allows us to model "is-a" relationships, extending existing classes to create derived versions. When combined with Virtual Functions, we unlock **Runtime Polymorphism**, allowing one interface to control many distinct types of objects.

---

## 1. Inheritance Syntax

By default, class inheritance is `private` in C++. You almost always want to explicitly label it `public`.

```cpp
#include <iostream>
#include <string>

// The Base Class
class Animal {
protected: // Accessible to derived classes, hidden from the public API
    std::string name;

public:
    Animal(std::string n) : name{n} {}

    void eat() const {
        std::cout << name << " is eating.\n";
    }
};

// The Derived Class
// Public inheritance: "A Dog IS-A Animal"
class Dog : public Animal {
public:
    // We MUST initialize the Base class explicitly in the init list!
    Dog(std::string n) : Animal(n) {}

    void bark() const {
        std::cout << name << " says Woof!\n"; // Can access 'name' because it's protected
    }
};

int main() {
    Dog rex{"Rex"};
    rex.eat();  // Inherited from Animal
    rex.bark(); // Specific to Dog

    return 0;
}
```

---

## 2. Virtual Functions and Polymorphism (The Core of OOP)

To achieve Polymorphism (the ability for an object to be treated as its base type but behave as its actual derived type), C++ requires the `virtual` keyword. 

Without `virtual`, C++ uses **Early Binding** (Static Binding). The compiler decides which function to call based solely on the pointer's type at compile time.
With `virtual`, C++ uses **Late Binding** (Dynamic Binding) via a Virtual Table (vtable). It checks the actual object type at runtime.

### Example: The Virtual Table in Action

```cpp
#include <iostream>
#include <vector>
#include <memory> 

// Abstract Base Class
class Enemy {
public:
    // 1. A pure virtual function (= 0) MAKES the class Abstract.
    // It cannot be instantiated directly.
    virtual void attack() const = 0;

    // 2. CRITICAL RULE: Base classes MUST have a virtual destructor!
    // Otherwise, deleting a derived object via a base pointer leaks memory!
    virtual ~Enemy() {
        std::cout << "Enemy Base Destroyed\n";
    }
};

class Orc : public Enemy {
public:
    // The 'override' keyword (C++11) forces the compiler to check if we are 
    // actually overriding a base virtual function. It catches typos!
    void attack() const override {
        std::cout << "Orc swings an axe!\n";
    }
    
    ~Orc() override {
        std::cout << "Orc Destroyed\n";
    }
};

class Mage : public Enemy {
public:
    void attack() const override {
        std::cout << "Mage casts a fireball!\n";
    }

    ~Mage() override {
        std::cout << "Mage Destroyed\n";
    }
};

void battle_system() {
    // We create a vector of Smart Pointers pointing to the Base class
    std::vector<std::unique_ptr<Enemy>> current_enemies;

    // We can store actual derived types in this Base-type vector!
    current_enemies.push_back(std::make_unique<Orc>());
    current_enemies.push_back(std::make_unique<Mage>());

    // Iterate through them and invoke polymorphism
    for (const auto& enemy : current_enemies) {
        enemy->attack(); // Runtime chooses the correct method!
    }
    
    // When current_enemies falls out of scope, the destructors are called.
    // Because Enemy has a `virtual ~Enemy()`, the correct Orc/Mage 
    // destructors will be invoked, preventing leaks.
}
```

---

## 3. Object Slicing

Polymorphism only works with Pointers (`*`) or References (`&`). If you attempt to pass derived objects to a base class function *by value*, the derived parts are sliced off!

```cpp
void slice_example(Enemy e) { // By Value!
    e.attack(); // DANGER! 'e' has been sliced down to just an Enemy.
}

void correct_example(const Enemy& e) { // By Reference!
    e.attack(); // Polymorphism works perfectly!
}
```

---

## Conclusion
C++ requires explicit virtual keywords for performance reasons. In languages like Java or C#, every method is virtual by default, which incurs a slight performance penalty on every call. In C++, you only pay for dynamic dispatch when you explicitly ask for it (`virtual`).


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

