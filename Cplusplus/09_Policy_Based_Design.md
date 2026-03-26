# 09: Policy-Based Class Design

This document covers the revolutionary concepts introduced by Andrei Alexandrescu in **Modern C++ Design**. Policy-Based Design is a masterclass in combining multiple inheritance and generic programming to create hyper-flexible, compile-time configurable classes.

---

## 1. What is a Policy?

Instead of building a massive class with dozens of `if-else` blocks or polymorphic virtual functions to handle different behaviors (like thread-safety or memory allocation), you extract these behaviors into isolated, specialized classes called **Policies**.

The main class (the **Host**) then inherits from or aggregates these Policies as *template parameters*. 

### The Example: A Smart Wrapper

Imagine building a `SmartPointer` class. It needs to know:
1.  How to instantiate objects
2.  How to lock resources for thread safety
3.  How to check for errors.

In standard OOP, you might build a `ThreadSafeSmartPointer` derived from `SmartPointer`. In Policy-Based Design, you simply pass the `ThreadSafetyPolicy` as a template argument!

---

## 2. Implementing a Policy-Based Host

Here is a simplified host class measuring execution time, built entirely using Policies.

```cpp
#include <iostream>
#include <chrono>
#include <thread>

// --- THE POLICIES ---

// Policy 1: How we handle errors
struct StrictErrorPolicy {
    static void handle_error() { 
        std::cerr << "CRITICAL ERROR: Terminating program!\n"; 
        std::terminate(); 
    }
};

struct SilentErrorPolicy {
    static void handle_error() { 
        std::cerr << "Warning: Error ignored.\n"; 
    }
};

// Policy 2: How we synchronize data
struct ThreadTracker {
    void start() { std::cout << "Thread Tracking Enabled.\n";  }
    void end() { std::cout << "Thread Tracking Stopped.\n"; }
};

struct NoTracking {
    void start() {} // Zero overhead! The compiler completely optimizes this away.
    void end() {}
};

// --- THE HOST ---

// The Host takes multiple orthogonal policies as Template Parameters
template <typename ErrorPolicy, typename TrackingPolicy>
class SystemExecutor : public TrackingPolicy { // We inherit from the Policy!
public:
    void execute(bool should_fail) {
        this->start(); // Calls the inherited method from TrackingPolicy

        std::cout << "Executing massive system calculation...\n";
        std::this_thread::sleep_for(std::chrono::milliseconds(20));

        if (should_fail) {
            // We delegate error handling to the policy's static method
            ErrorPolicy::handle_error(); 
        }

        this->end();
    }
};
```

---

## 3. Assembling the Pieces (Instantiation)

Now, the user of your library can mix and match orthogonal policies to create complex types that execute with strictly zero runtime overhead! If they choose `NoTracking`, the empty methods are completely removed during compiler optimization.

```cpp
int main() {
    // 1. Create a Fast, unsafe executor
    using FastExecutor = SystemExecutor<SilentErrorPolicy, NoTracking>;
    FastExecutor fast_exec;
    
    std::cout << "--- Running Fast Executor ---\n";
    // Generates virtually identical assembly to a raw procedural function!
    fast_exec.execute(true); 

    // 2. Create a tracked, strict executor
    using SafeExecutor = SystemExecutor<StrictErrorPolicy, ThreadTracker>;
    SafeExecutor safe_exec;

    std::cout << "\n--- Running Safe Executor ---\n";
    // Will terminate the program!
    safe_exec.execute(true); 

    return 0;
}
```

## Conclusion on Modern C++ Design
Policy-Based Design proves that Multiple Inheritance—when used with orthogonal `<Templates>` rather than deep OOP hierarchies—can produce incredibly powerful standard libraries. This exact pattern was used to implement massive swaths of the C++ standard library's `std::string` and `std::allocator` hierarchies.


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

