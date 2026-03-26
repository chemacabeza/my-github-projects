# 03: The Standard Template Library (STL)

C++ does not include a massive standard library like Java or Python. Instead, it relies on the **Standard Template Library (STL)**, a collection of incredibly fast, template-based data structures and algorithms.

The philosophy of the STL is the separation of Data (`Containers`) and Logic (`Algorithms`) via the concept of `Iterators`.

---

## 1. Containers (Data Structures)

### `std::vector` (Dynamic Arrays)
The `std::vector` is the default container in C++. Unless you have a specific reason (like extreme middle insertions), you should always reach for `vector`. It stores elements contiguously in memory, meaning it is cache-friendly and extremely fast.

```cpp
#include <iostream>
#include <vector>

void vector_basics() {
    // 1. Initialization
    std::vector<int> numbers = {10, 20, 30};

    // 2. Adding Elements 
    // `push_back` copies the given value into the vector.
    // `emplace_back` constructs the value directly in place (faster for objects).
    numbers.push_back(40);
    numbers.emplace_back(50); // Superior

    // 3. Iterating (Range-based for loop)
    for (const auto& num : numbers) {
        std::cout << num << " "; 
    }
    
    // 4. Accessing elements
    std::cout << "\nFirst Element: " << numbers[0]; // Fast, but NO bounds checking!
    std::cout << "\nSecond Element: " << numbers.at(1); // Slower, throws an exception if out of bounds.

    // 5. Shrinking and Clearing
    numbers.clear(); // Empties the container
    std::cout << "\nIs Empty? " << std::boolalpha << numbers.empty(); // Returns true
}
```

### `std::string` (Character Sequences)
Under the hood, `std::string` is essentially a `std::vector<char>` optimized for text.

```cpp
#include <iostream>
#include <string>

void string_manipulation() {
    std::string text = "Hello World";
    
    // Appending
    text += " Welcome";
    
    // Finding Substrings
    size_t pos = text.find("World");
    if (pos != std::string::npos) {
        std::cout << "Found 'World' at index: " << pos << "\n";
    }

    // Modern C++20 view (std::string_view)
    // Non-owning, lightning-fast reference to a string or substring
    std::string_view view = text;
    std::cout << "View reads: " << view.substr(0, 5) << "\n";
}
```

---

## 2. Iterators

An Iterator is an object that acts like a pointer. It navigates a container. Algorithms use Iterators, never Containers directly. 

This means a single algorithm (like `std::sort`) can sort a `vector`, an `array`, or a `deque` without needing three different implementations!

```cpp
#include <iostream>
#include <vector>

void iterator_example() {
    std::vector<int> data = {5, 2, 9, 1};

    // A modern iterator approach
    auto it = data.begin();   // Points to the *first element* (5)
    auto end = data.end();    // Points to ONE PAST the last element (Memory after 1)

    // Manual iteration over the vector
    while (it != end) {
        std::cout << *it << " "; // De-referencing the iterator yields the value
        it++;                    // Move iterator to the next location
    }
}
```

---

## 3. Algorithms (`<algorithm>`)

Never write a raw `for` loop if the STL already has an algorithm for it. Raw loops are prone to off-by-one errors and obscure intent. Using `<algorithm>` makes your code immediately readable to other professionals.

### `std::sort`, `std::find`, `std::count_if`

```cpp
#include <iostream>
#include <vector>
#include <algorithm> // Essential for STL Algorithms

void algorithm_showcase() {
    std::vector<int> data = {42, 12, 88, 5, 22};

    // 1. Sorting (Introspective Sort: O(n log n))
    // Provide the start iterator and end iterator.
    std::sort(data.begin(), data.end());

    // 2. Finding an element (Linear search)
    auto result = std::find(data.begin(), data.end(), 88);
    if (result != data.end()) { // Iterators return .end() if NOT found
        std::cout << "Found 88 at index: " << std::distance(data.begin(), result) << "\n";
    }

    // 3. Predicates and Lambdas (C++11 Anonymous Functions)
    // Count how many elements are totally even.
    auto is_even = [](int i) -> bool { return i % 2 == 0; };
    
    int even_count = std::count_if(data.begin(), data.end(), is_even);
    std::cout << "There are " << even_count << " even numbers.\n";
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

### Conclusion to The STL
The Standard Template Library forces a generic mindset. By understanding that Containers hold data, Algorithms compute logic, and Iterators connect the two, you can begin reading advanced production C++ systems with ease.
