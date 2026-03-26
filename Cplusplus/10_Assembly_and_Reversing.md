# 10: Reverse Engineering and Assembly

This module transitions into **Phase 4: Mastery**, inspired by Jan Gray's *C++ Under The Hood* and classical *Reversing C++* techniques.

To reach mastery, you must visualize what the compiler does to your high-level abstractions, effectively reading C++ backward from its compiled Assembly (x86/x64). 

---

## 1. Name Mangling

C supports exactly one function per name. C++ supports Function Overloading (writing two functions with the same name but different arguments or namespaces).

To maintain compatibility with standard C linkers, the C++ compiler silently renames ("mangles") your generic function names into complex strings containing the argument types and scope.

```cpp
namespace Engine {
    class Player {
    public:
        void move(int x, int y) {}
    };
}

void move(float f) {}
```
If you compile this and view the raw symbols (via `nm` or `objdump`), you will rarely see `move`.

You will see mangled symbols like:
1. `_ZN6Engine6Player4moveEii`
   - `_Z`: Indicator of a mangled C++ symbol
   - `N`: Nested name start
   - `6`: Length of "Engine"
   - `6`: Length of "Player"
   - `4`: Length of "move"
   - `E`: End of nested name
   - `ii`: Two integer arguments.

2. `_Z4movef`
   - `_Z`: Indicator
   - `4`: Length of "move"
   - `f`: Floating point argument.

### `extern "C"`
If you are writing a C++ DLL/Shared Library that must be accessed by Python, C#, or raw C, you must disable Name Mangling. You wrap the public API in an `extern "C"` block.

```cpp
extern "C" {
    void standard_c_function() {
        // This symbol will appear exactly as "standard_c_function" in the assembly.
    }
}
```

---

## 2. Calling Conventions & The `this` Pointer

When you call a global C function `calculate(10, 20)`, the compiler pushes `20` and `10` onto the Stack (or into registers like `ECX` and `EDX` depending on ABI), then executes the `CALL` instruction.

What happens when you call a class method?
```cpp
Player p;
p.move(10, 20);
```

Under the hood, C++ injects the instance address (`&p`) as the first hidden parameter using a specific calling convention called **`__thiscall`**.

In Assembly (x86 32-bit `__thiscall`), it looks like this:
```assembly
push 20          ; argument y
push 10          ; argument x
lea ecx, [ebp-4] ; Load Effective Address of 'p' into the ECX register! (The 'this' pointer)
call _ZN6Engine6Player4moveEii ; Call the mangled function
```

In Reverse Engineering (IDA Pro / Ghidra), spotting a function load an object address into `RCX` / `ECX` right before a `CALL` is the universal fingerprint of an Object-Oriented C++ method invocation.

---

## 3. Exception Handling (Zero-Cost Exceptions)

Standard modern C++ uses "Zero-Cost Exception Handling". The name is misleading: it is zero-cost *only if no exception is thrown*.

```cpp
void risky_operation() {
    try {
        throw std::runtime_error("Crash");
    } catch(const std::exception& e) {
        // Handle
    }
}
```

Instead of injecting slow `if (error)` checks everywhere, the compiler generates a massive, hidden, read-only table in the `.eh_frame` (Exception Handling Frame) section of the binary.

If `throw` executes:
1. Execution halts.
2. The runtime looks up the current Instruction Pointer (`EIP`/`RIP`) in the `.eh_frame`.
3. It finds the exact stack-unwinding instructions and Catch block required.
4. It manually travels backward up the call stack, destroying all local stack variables (calling destructors for RAII!) until it hits the `catch` block.

**Mastery Strategy:** Exceptions bloat the executable size dramatically with offset tables and slow down the "unhappy path" massively. Use `noexcept` on functions that cannot fail (like destructors and move constructors). The compiler will completely erase the `.eh_frame` generation for those functions, resulting in tight, rapid assembly.


---

## 🛠️ Compilation and Execution

To experiment with the code snippets in this chapter, save them into a file named `main.cpp` and compile using modern C++ standards.

<p align="center">
  <img src="images/tux_linux.png" alt="Linux (Tux)" width="120"/>
</p>

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

