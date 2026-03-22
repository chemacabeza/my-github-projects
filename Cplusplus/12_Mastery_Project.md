# 12: C++ Mastery Project

You have completed the C++ Mastery sequence. You understand Memory Architecture (`02`), Object Layouts and Virtual Tables (`06`), Compile-Time Metaprogramming and SFINAE (`08`), Policy-Based Design (`09`), and Reversing ABI mechanisms (`10`).

To prove your mastery, you must build the ultimate C++ data structure: **A Type-Erased Thread-Safe Heterogeneous Container**.

---

## The Challenge

You must implement an `AnyContainer` class. 

### Requirements:
1. **Generic Storage:** It must be able to hold *any* type of object simultaneously in a single `std::vector` (an `int`, a `std::string`, and a custom `Player` class), completely bypassing typical static typing constraints.
2. **Type Erasure:** You cannot use `std::any` (C++17) or `void*`. You must build the mechanism manually using purely virtual inheritance.
3. **Template Metaprogramming (`SFINAE`):** You must provide a custom `get<T>()` method that safely extracts the underlying object ONLY if the requested type exactly matches what is stored. If not, it throws a safe exception.
4. **Policy-Based Thread Safety:** The container must accept a template policy determining if it uses a `std::mutex` for thread safety or executes entirely lock-free for single-threaded zero-overhead operation.
5. **Memory Safety:** It must guarantee absolutely zero memory leaks without ever using raw `new` or `delete` anywhere in your code. You must rely exclusively on `std::unique_ptr` and the Rule of Zero.

---

## Architectural Hints

### 1. Type Erasure Mechanism
To store varying types in one vector, the vector must point to a generalized Base interface. The derived containers handle the specific generic types.

```cpp
// The Interface concept (Base)
struct Concept {
    virtual ~Concept() = default;
    virtual const std::type_info& type() const = 0; // Essential for checking exact type match
};

// The Model (Derived Template)
template <typename T>
struct Model : public Concept {
    T data;
    Model(T val) : data{std::move(val)} {}
    const std::type_info& type() const override { return typeid(T); }
};

// The Container holds Base pointers!
std::vector<std::unique_ptr<Concept>> storage;
```

### 2. Thread Safety Policy
Create two distinct policy structs. Your `AnyContainer` should inherit from them and call `this->lock()` and `this->unlock()`.

```cpp
struct DummyMutex {
    void lock() {} // Optimized away by compiler
    void unlock() {}
};

struct RealMutex {
    std::mutex m;
    void lock() { m.lock(); }
    void unlock() { m.unlock(); }
};

template <typename ThreadPolicy = DummyMutex>
class AnyContainer : private ThreadPolicy { ... };
```

---

## Delivery

When you can write this class from scratch, correctly routing the virtual destructors through the Type Erasure mechanism to safely delete a polymorphic `std::string` nested behind a template inside a `unique_ptr`, you have achieved total mastery of the C++ Object Model and Language Specification.

Happy coding.
