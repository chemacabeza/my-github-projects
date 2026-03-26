# 11: Advanced Persistence (Object-Relational Mapping in C++)

This module draws inspiration from the comprehensive **ODB Manual**. 
Unlike high-level languages (Java with Hibernate, C# with Entity Framework), persistence in C++ is notoriously difficult. Standard C++ does not possess native "Reflection" (the ability of a program to examine its own variables and types at runtime). 

Without Reflection, an ORM cannot automatically map the private fields `int age` and `std::string name` to database columns.

---

## 1. The C++ Problem: Lack of Introspection

If you write this standard C++ class:
```cpp
class Employee {
private:
    unsigned long id;
    std::string name;
    unsigned short age;
};
```
Once compiled into machine code, those variable names (`id`, `name`, `age`) are entirely stripped from the executable to save size. A runtime framework like JDBC cannot read them.

## 2. The Solution: Compile-Time Code Generation

To achieve ORM in C++, libraries like **ODB (Object-Relational Mapping)** rely on a specialized compile-time preprocessor.

Before you compile your code with `g++` or `clang++`, you run the `odb` compiler over your header files. 

```bash
# 1. Provide the C++ header to ODB, targeting PostgreSQL
odb -d pgsql --generate-query --generate-schema employee.hxx

# 2. Compile the resulting generated code bridging C++ to PostgreSQL
c++ -c employee.cxx
c++ -c employee-odb.cxx
```

The ODB compiler parses your C++ syntax tree, extracts the variables, and actively *writes thousands of lines of raw C++ SQL-binding code* behind the scenes to bridge the gap.

## 3. Creating an ODB Persistent Class

To tell the ODB compiler what to parse, we use `#pragma` directives. These inject metadata strictly for the ODB tool and are completely ignored by the standard C++ compiler.

**`employee.hxx`**
```cpp
#ifndef EMPLOYEE_HXX
#define EMPLOYEE_HXX

#include <string>
#include <odb/core.hxx> // The core ODB framework

#pragma db object // Tells ODB: "Treat this entire class as a Database Table"
class Employee {
public: // ODB requires public defaults, or friend classes, to instantiate from DB
    Employee() {}
    Employee(const std::string& name, unsigned short age) 
        : name_(name), age_(age) {}

    // Getters and setters...
    unsigned long get_id() const { return id_; }

private:
    friend class odb::access; // Allows ODB to read private fields without Getters!

    // Instructs ODB that this is the Primary Key, and it automatically increments.
    #pragma db id auto
    unsigned long id_;

    // Standard column mapping
    std::string name_;

    // Override the DB column name
    #pragma db column("years_old")
    unsigned short age_;
};

#endif
```

---

## 4. Traversing and Querying the Database in Modern C++

Because ODB generated the binding code (`employee-odb.cxx`), querying the database is strictly typed and absolutely seamless. If you make a typo in the field name, the code will fail at *compile time*, not runtime!

**`main.cpp`**
```cpp
#include <iostream>
#include <memory>
#include <odb/database.hxx>
#include <odb/pgsql/database.hxx>
#include <odb/transaction.hxx>

#include "employee.hxx"
#include "employee-odb.hxx" // The generated binding header

int main() {
    try {
        // 1. Establish connection to postgres
        std::unique_ptr<odb::database> db(
            new odb::pgsql::database("user", "password", "company_db"));

        // 2. Instantiating a normal C++ Object
        Employee john("John Doe", 33);
        Employee jane("Jane Smith", 28);

        // 3. Persist the objects within an ACID Transaction
        {
            odb::transaction t(db->begin());
            db->persist(john);
            db->persist(jane);
            t.commit();
        } // Connection goes out of scope here

        // 4. Querying using C++ Syntax (Type-Safe!)
        {
            odb::transaction t(db->begin());
            
            // Look how clean this query is! It generates: 
            // SELECT * FROM Employee WHERE years_old < 30;
            // The compiler enforces that `age_` exists and is a number!
            odb::result<Employee> res(db->query<Employee>(odb::query<Employee>::age_ < 30));

            for (odb::result<Employee>::iterator i(res.begin()); i != res.end(); ++i) {
                std::cout << "Target match: " << i->get_id() << "\n";
            }
            t.commit();
        }

    } catch (const odb::exception& e) {
        std::cerr << e.what() << "\n";
        return 1;
    }

    return 0;
}
```



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

### Conclusion
By relying on heavy compile-time generation (the core C++ philosophy), ODB provides a type-safe, reflection-free ORM that executes incredibly fast, maintaining the performance standards expected by C++ engineers while delivering the high-level syntax of Java or C#.
