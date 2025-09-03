# Chapter 6: Working with Numbers - Integers

Bash, by default, primarily operates on integer numerical values. It can perform various arithmetic operations like addition, subtraction, multiplication, and division with integer numbers. These operations are particularly useful for tasks like counting, indexing, and basic mathematical calculations in scripting and automation. Bash's support for integer arithmetic makes it a handy tool for many system-level operations and scripting tasks.

However, Bash does not provide native support for floating-point arithmetic by default. Floating-point numbers include decimal fractions and are used to represent real numbers with high precision. These numbers are essential in scientific computing, financial calculations, and various other domains where precise numerical representations are required. Bash's omission of native support for floating-point arithmetic is largely because it is designed as a lightweight, text-based shell scripting language, and the inclusion of floating-point arithmetic would introduce complexity and potentially slow down the execution of scripts.

To perform floating-point arithmetic in Bash, one often relies on external tools like the “bc” command-line calculator or other scripting languages like Python<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a> or Perl<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[2]</a>, which provides native support for floating-point operations. These tools offer greater precision and flexibility when working with real numbers, but they come at the cost of additional complexity compared to Bash's integer arithmetic operations. Bash's focus on simplicity and efficiency in handling text and system-level operations remains a significant reason why it doesn't natively support floating-point arithmetic.

In this chapter we will focus specifically on working with integer numbers.

In Bash there are 3 different ways to work with integer numbers.
* Using the “`expr`” command line
* Using the “`let`/`declare`” builtin commands
* Using the Bash Arithmetic Expansion `((...))`

In the following sections we will explore each one of them.

## Working with the “`expr`” command line

This is the legacy way to work with arithmetic. It works with **ONLY** Integers.

First of all, it is worth mentioning that “`expr`” is not a builtin command within Bash. It’s a binary apart. This means that for every execution, a child process will be created, making the whole execution significantly slower.

This book is not intended to give you a full detailed tutorial on “`expr`”. The main idea is to explain how it works with a few examples, leaving the full content out of here.

“`expr`” utility is in charge of evaluating an expression and writing the result on standard output.

### Addition
“`expr`” supports the addition operator “`+`”. You need to call “`expr`” as follows.

```bash
    expr <integer/expression_1> + <integer/expression_2> [+ ...]
```

Let's see how it works with an example.
```bash
 1 #!/usr/bin/env bash
 2 #Script: expr_addition.sh
 3 NUM1=3
 4 NUM2=4
 5 echo -n "Result of $NUM1 + $NUM2 is "
 6 expr $NUM1 + $NUM2
```

In the previous script you can see that we declared two integer variables on lines 3 and 4. The you see that in line number 6 we use the operator `expr` to perform the calculation.

When you run the script you will have the following output in the terminal.

```txt
$ ./expr_addition.sh
Result of 3 + 4 is 7
```

### Substraction
“`expr`” supports the subtraction operator “-”. You need to call “expr” as follows:

```bash
    expr <integer/expression_1> - <integer/expression_2> [- ...]
```

Let’s see the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: expr_substraction.sh
 3 NUM1=3
 4 NUM2=4
 5 echo -n "Result of $NUM1 - $NUM2 is "
 6 expr $NUM1 - $NUM2
```

When you run the previous script you will get the following output.

```txt
$ ./subtraction.sh
Result of 3 - 4 is -1
```

### Division
“`expr`” supports the division operator “`/`”. You need to call “`expr`” as follows:

```bash
    expr <integer/expression_1> / <integer/expression_2> [/ ...]
```

Let’s see how it works with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: expr_division.sh
 3 NUM1=9
 4 NUM2=3
 5 echo -n "Result of $NUM1 / $NUM2 is "
 6 expr $NUM1 / $NUM2
```

When you run the previous script you will get the following output.

```txt
$ ./expr_division.sh
Result of 9 / 3 is 3
```

In the case of using operands whose result is a decimal number, **only the integer part will be given as result**. You can see the result by modifying the value of the “`NUM2`” variable in the previous script (“`expr_division.sh`”) to 2. The result will be `4.5` but the script will print only `4`.

### Multiplication
“`expr`” supports the multiplication operator “`*`”. You need to call “`expr`” as follows:

```bash
    expr <integer/expression_1> \* <integer/expression_2> [\* ...]
```

Pay attention to the detail of “*escaping*” the “`*`” character. We do this to avoid bash interpreting such a character as a globbing character so that expansion does not happen. With the escaping character we are forcing a literal interpretation of the character “`*`” without expansion.

Let's see how it works with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: expr_multiplication.sh
 3 NUM1=9
 4 NUM2=3
 5 echo -n "Result of $NUM1 * $NUM2 is "
 6 expr $NUM1 \* $NUM2
```

Whe you execute the previous script you will get the following as result.

```txt
$ ./expr_multiplication.sh
Result of 9 * 3 is 27
```

### Modulo
“`expr`” also supports the modulo operator “`%`”. You need to call “`expr`” as follows:

```bash
    expr <integer/expression_1> % <integer/expression_2> [% ...]
```

Let’s see how it works with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: expr_modulo.sh
 3 NUM1=8
 4 NUM2=3
 5 echo -n "Result of $NUM1 % $NUM2 is "
 6 expr $NUM1 % $NUM2
```

When you execute the previous script you will get the following result.

```txt
$ ./expr_modulo.sh
Result of 8 % 3 is 2
```

### Comparison

“`expr`” supports the comparison operators (“`=`”, “`>`”, “`>=`”, “`<`”, “`<=`”, “`!=`”, will call them “`<op>`”). You need to call “`expr`” as follows:

```bash
    expr <expression_1> <op> <expression_2> [<op> ...]
```

The comparison operators give as result either “`1`“ (if the result of the comparison was `true`) or “`0`” (if the result of the comparison was `false`).

Same as with the multiplication character, with the character “`<`” we have to escape it to avoid Bash confusing it with a redirection character (which we will speak about later in another chapter).

Let’s see how it works with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: expr_comparison.sh
 3 NUM1=8
 4 NUM2=3
 5 echo -n "Result of $NUM1 < $NUM2 is "
 6 expr $NUM1 \< $NUM2
```

When you run the previous script you will get the following result in the terminal.

```txt
$ ./comparison.sh
Result of 8 < 3 is 0
```

The result of the script is `0`, which means that the number `8` is not smaller than the number `3`.


### Boolean

“`expr`” has support for the boolean operands **AND** (“`&`” character) and **OR** (“`|`” character) that we can use to compose logical operations.

These boolean operands allow you combine the comparison expressions that we saw in the previous section.

Pay attention that the operands AND and OR, when passed to the “`expr`” command, need to be between double quotes. 

Let’s see how it works with the following script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: expr_boolean.sh
 3 NUM1=8
 4 NUM2=3
 5 echo -n "Result of $NUM1 > $NUM2 & $NUM2 >= 3 is "
 6 expr  $NUM1 \> $NUM2 "&" $NUM2 \>= 3
 7 #                    ^^^
```

When you execute the previous script you will get the following result:

```txt
$ ./expr_boolean.sh
Result of 8 > 3 & 3 >= 3 is 1
```

As you can see in the execution of the script, the result is `1`. The result `1` means that the two comparisons resulted to be `true`.

If you pay attention to the line 7 of the previous script you will see that the AND operator is within double quotes.


## Working with the “`let`/`declare`” builtin commands

In this section we are going to take a look at how to work with Integers with two builtin commands of Bash:
* `declare`: We already mentioned it in a previous chapter.
* `let`: Which is new to us and we will talk about in a bit.


### "`declare`" command

As we mentioned already, “`declare`” can be used to give to the declared variables some specific behavior (specific semantics). In our case, we are going to use the “`declare`” built-in command to declare integer numbers.

In our current case, we need to use the option “`-i`” to indicate the declaration of an integer variable.

In the following script we use the “`-i`” flag to declare a new integer variable named “`myIntVar`”.

```bash
 1 #!/usr/bin/env bash
 2 #Script: declare_integer.sh
 3 declare -i myIntVar=45
 4 myIntVar=$myIntVar+1
 5 echo $myIntVar
```

When you execute the previous script you will get the following result in the terminal.

```txt
$ ./declare_integer.sh
46
```

In this case the builtin command “`declare`” is specifying that the new variable “`myIntVar`” should behave as an integer number (remember that, by default, variables in Bash behave like STRINGs).

Something to mention is that, in the same way that “`declare`” can add specific behaviors to variables (like the previous one with integer and “`-i`”), it can remove it (setting it back to the default one) by using the “*negated*” option “`+i`”. 

Let’s see it how it works with an example.

```bash
 1 #!/usr/bin/env bash
 2 #Script: declare_integer_negated.sh
 3 declare -i myIntVar=45
 4 myIntVar=$myIntVar+1
 5 echo $myIntVar # 46
 6 declare +i myIntVar
 7 myIntVar=$myIntVar+1
 8 echo $myIntVar # 46+1
```

When you run the previous script you will see the following in the terminal.

```txt
$ ./declare_integer_negated.sh
46
46+1
```

So... What is happening in the script? On line 3 we are declaring a variable named “`myIntVar`” that has a semantic of an integer (it is because of the flag `-i` in the `declare` command).

In line 4 the variable “`myIntVar`” is incremented by one. As it has "*integer semantic*" the operation works perfectly.

However, when we remove the "*integer semantic*" on line 6, the variable “`myintvar`” becomes a String. Due to this, the value printed on line 8 is “`46+1`” as now the variable has "*string semantic*".

You can also invoke the command "`declare`" without any arguments. This invocation will show the attributes and values of all the variables and functions available.

### "`let`" command

“`let`” is a builtin command of Bash that evaluates arithmetic expressions. Its syntax is as follows:

```bash
    let arg1 [arg2 ...]
```

“`let`” evaluates (from left to right) each argument as a mathematical expression. 

This builtin command supports a wide variety of operators, which are as follows:

| Operator | Operation |
| :----    | :----     |
| `var++`, `var--` | Post-increment (`++`), Post-decrement (`--`). Interpret the value of integer variable var and then add or subtract one (1) to it. |
| `++var`, `--var` | Pre-increment (`++`), Pre-decrement (`--`). Add or subtract one (1) to the value of integer variable var, and then interpret the value.|
| `-expr`, `+expr` | Unary minus, Unary plus. Unary minus returns the value of the expression expr it precedes, as if it had been multiplied by negative one (-1). Unary plus returns the expression expr unchanged, as if it had been multiplied by one (1). |
| `!`, `~` | Logical negation, Bitwise negation. Logical negation returns false if its operand is true, and true if the operand is false. Bitwise negation flips the bits in the binary representation of the numeric operand. |
| `**` | Exponentiation |
| `*`, `/`, `%` | Multiplication, division, remainder (modulo) | 
| `+`, `-` | Addition, subtraction. |
| `<<`, `>>` | Bitwise shift left, bitwise shift right. |
| `<=`, `>=` ,`<`, `>` | Comparison: less than or equal to, greater than or equal to, less than, greater than. |
| `==`, `!=` | Equality, inequality. Equality returns true if its operands are equal, false otherwise. Inequality returns true if its operands are not equal, false otherwise. |
| `&` | Bitwise AND. The corresponding binary digits of both operands are multiplied to produce a result. For any given digit, the resulting digit is 1 only if the corresponding digit in both operands is also 1. |
| `^` | Bitwise XOR (eXclusive OR). A binary digit of the result is 1 if and only if the corresponding digits of the operands differ. For instance, if the first binary digit of the first operand is 1, and the second operand's first digit is 0, the result's first digit is 1. |
| `|` | Bitwise OR. If either of the corresponding digits in the operands is 1, that digit in the result is also 1. |
| `&&` | Logical AND. Returns true if both of the operands are true. |
| `||` | Logical OR. Returns true if either of the operands is true. |
| `expr1 ? expr2 : expr3` | Conditional (ternary) operator. If “`expr1`” is true, return “`expr2`”. If “`expr1`” is false, return “`expr3`”. |
| `=`, `*=`, `/=`, `%=`, `+=`, `-=`, `<<=`, `>>=`, `&=`, `^=`, `|=` | Assignment. Assign the value of the expression that follows the operator, to the variable that precedes it. If an operator prefixes the equals sign, that operation is performed before assignment. For example `let "var += 5"` is equivalent to `let "var = var + 5"`. The assignment operation itself evaluates to the value assigned. |

Let’s see an example script where we will use several of the previous operators.

```bash
 1 #!/usr/bin/env bash
 2 #Script: let.sh
 3 # Using the post-increment operator"
 4 let "myVar = 32"
 5 echo "Orignal value of myVar: $myVar"
 6 echo "Using post-increment operator"
 7 let "myVar++"
 8 echo "New value of myVar: $myVar" # 33
 9 # Using the shift left operator
10 let "myNumber = 16"
11 echo "Original value of myNumber: $myNumber"
12 let "myNumber <<= 1"
13 echo "New value of myNumber: $myNumber" # 32
```

In the previous script you see that on line 4 a variable is declared with name "`myVar`" and value 32. On line 7 you see that the post-increment operator is used, that statement increments the value of the variable by 1.

Then on line 10 you see that a variable is declared with name "`myNumber`" with a value of 16. On line 12, we are using the shifting left assignment operator, which will move all the bits of the number once place to the left, resulting in the number being multiplied by 2.

When you run the previous script you will get the following output in your terminal.

```txt
$ ./let.sh
Orignal value of myVar: 32
Using post-increment operator
New value of myVar: 33
Original value of myNumber: 16
New value of myNumber: 32
```

## Other Integer Numbers

With the "`let`" command you have access to other types of numbers. Specifically you have access to:
* Octal numbers
* Hexadecimal numbers
* Custom based numbers (whose base can be between 2 and 64)

We will tackle them one by one.

### Octal numbers<a id="footnote-3-ref" href="#footnote-3" style="font-size:x-small">[3]</a>

An **octal number** is a number expressed in the base-8 numeral system, which uses digits from `0` to `7`. Each digit in an octal number represents a power of 8, just as digits in a decimal number represent powers of 10.

In the base-8 system:
* The rightmost digit is the least significant digit (i.e., `8^{0}`)
* The next digit is multiplied by `8^{1}`, the next by `8^{2}`, and so on.

For example the octal number `157`:
* The rightmost digit is `7`, representing 7 times 8 to the `7 x 8^{0} = 7 x 1 = 7`
* The next digit is `5`, representing `5 x 8^{1} = 5 x 8 = 40`
* The leftmost digit is `1`, representing `1 x 8^{2} = 1 x 64 = 64`

Adding these values gives `64 + 40 + 7 = 111`.

So the octal number `157` in decimal is `111`.

Typically octal numbers are preceded by a zero.

### Hexadecimal numbers<a id="footnote-4-ref" href="#footnote-4" style="font-size:x-small">[4]</a>

A **hexadecimal number** is a number expressed in the base-16 numeral system, which uses sixteen symbols: the digits `0` through `9` represent values zero to nine, and the letters `A` through `F` represent values ten to fifteen.

Hexadecimal system:
* `0` = 0
* `1` = 1
* `2` = 2
* `3` = 3
* `4` = 4
* `5` = 5
* `6` = 6
* `7` = 7
* `8` = 8
* `9` = 9
* `A` = 10
* `B` = 11
* `C` = 12
* `D` = 13
* `E` = 14
* `F` = 15

Each digit in a hexadecimal number represents a power of 16, similar to how digits in a decimal number represent powers of 10.

For example the hexadecimal number `2A3` is converted to decimal like this:
* The rightmost digit `3` represents `3 x 16^{0} = 3 x 1 = 3`
* The next digit A (which is `10` in decimal) represents `10 x 16^{1} = 10 x 16 = 160`
* The leftmost digit `2` represents `2 x 16^{2} = 2 x 256 = 512`

Adding these together gives:

```
    512 + 160 + 3 = 675
```

So... the hexadecimal number `2A3` is `675` in decimal.

Typically hexadecimal numbers are preceded by `0x` or `0X`.


### Other bases

In order to declare other integers with a different base, you can use the following notation.

```bash
    let "number = BASE#NUMBER"
```

Where:
* `BASE` is between 2 and 64
* `NUMBER` must use the symbols within the `BASE` range.

Let's see a few examples with the following script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: let_other_bases.sh
 3 # Binary
 4 let "bin = 2#111100111001101"
 5 echo "binary number = $bin"    # 31181
 6 # Base 32
 7 let "b32 = 32#77"
 8 echo "base-32 number = $b32"   # 231
 9 # Base 64
10 # This notation only works for a limited range (2 - 64) of ASCII characters.
11 # 10 digits +
12 # 26 lowercase characters +
13 # 26 uppercase characters +
14 # @ + _
15 let "b64 = 64#@_"
16 echo "base-64 number = $b64"   # 4031
```

In the previous script you see that on line 4 we declare a binary number. On line 7 we declare a number with base-32 and, finally, on line 15 we declare number with base-64.

When you run the previous script you will see the following in your terminal.

```txt
$ ./let_other_bases.sh
binary number = 31181
base-32 number = 231
base-64 number = 4031
```

## Working with Bash Arithmetic Expansion and Compound Command

There is a third way to operate with integer numbers that can look similar but are very different. This way is by using either:
* Bash Arithmetic Expansion: `$((...))`
* Double Parenthesis Compound Command: `((...))`

They look really similar but are different. So… What is the difference among them and the preferred way to use them?

### Bash Arithmetic Expansion `$((...))`

This way to deal with integer numbers allows us to evaluate an arithmetic expression (or a set of them, separated by commas). This way, will give an output which will be the result of the latest arithmetic operation given.

Let's give it a try with the following script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: bash_arith_expansion_wrong.sh
 3 $((x=4,y=5,z=x*y,u=z/2)) ; # 10: command not found
 4 echo $x $y $z $u
```

What is happening in this script? On line 3 of the script (which is wrong on purpose) we are using the Bash Arithmetic Expansion. Inside this command there are several steps that happen in the following order:
1. A variable is declared with name `x` and with a value of `4`
2. A variable is declared with name `y` and with a value of `5`
3. A variable is declared with name `z` and with a value that is the multiplication of variables `x` and `y`, resulting in a value of `10`
4. A variable is declared with name `u` and with a value that is the result of the division of variable `z` by `2`, resulting in `10`
5. Bash tries to interpret the resulting number (which is `10`) as a command, resulting in an error

When you run the previous script you will get the following output in you terminal.

```txt
$ ./bash_arith_expansion_wrong.sh
./bash_arith_expansion.sh: line 3: 10: command not found
4 5 20 10
```

What happens is that the result of **the last arithmetic operation will replace the expression itself**. And this can be used as another value. Let's see it with an example.

```bash
 1 #!/usr/bin/env bash
 2 #Script: bash_arith_expansion.sh
 3 result=$((x=4,y=5,z=x*y,u=z/2)) ; 
 4 echo $x $y $z $u
 5 echo "Result: $result" # 10
```

When you execute the previous script you will see the following in your terminal.

```txt
$ ./bash_arith_expansion.sh
4 5 20 10
Result: 10
```

Just a note... Before Bash Arithmetic Expansion appeared (`$((...))`), the syntax that was used was `$[...]` which is now **deprecated** but you might still find it in some old scripts.

### Compound Command `((...))`

In Bash, the `((...))` construct is used for arithmetic evaluation. It allows you to perform mathematical operations directly within a script, similar to how expressions are evaluated in programming languages like C or Java. The key advantage of `((...))` over other methods like `expr` or `$((...))` is that it can handle arithmetic operations more efficiently, without the need for external tools.

The key features of the compound command are:
1. **Arithmetic Operations**: It supports common operations such as addition (`+`), subtraction (`-`), multiplication (`*`), division (`/`), modulus (`%`), and more.
2. **No Need for $ for Variables**: Inside `((...))`, you don’t need to prefix variables with `$` to reference them, unlike other parts of Bash scripts.
3. **Return Value**: The `((...))` construct returns a status of `0` (true) if the result of the expression is non-zero, and `1` (false) if the result is zero. This makes it useful in conditional statements.
4. **Increment and Decrement Operators**: You can use operators like `++` and `--` for incrementing and decrementing variables.

The syntax used for this way of operating with integer numbers is as follows:

```bash
    (( expression ))
```

What “`expression`” is you might be asking yourself. When you use this compound command you create an environment where you can operate with integer variables. In this environment you can do assignments of variables, you can do operations, you can do several operations in the same environment. 

The way to do several operations is as follows:

```bash
    (( expr1 , expr2 , ... ))
```

Where the different expressions (assignments, operations, etc) are evaluated in sequence.

This compound command is an actual command after all. This means that it has a result, an exit status, that we can use.<a id="footnote-5-ref" href="#footnote-5" style="font-size:x-small">[5]</a>

Let's see an example, shall we?

```bash
 1 #!/usr/bin/env bash
 2 #Script: compound_command.sh
 3 # Post-increment
 4 ((myVar = 32))
 5 ((myVar++))
 6 echo "myVar: $myVar"
 7 # Shift bits
 8 ((myVar2 = 16, myVar3 = 4))
 9 ((myVar2 <<= 1, myVar3 >>=1 ))
10 echo "myVar2: $myVar2, myVar3: $myVar3"
```

In the previous script we declare a variable named `myVar` on line 4, then we use the post-increment operator on line 5.

On line 8 we declare two variables with names `myVar2` and `myVar3` with values `16` and `4` respectively. The on line 9 we use the shift-left bits operator on variable `myVar2` which will multiply by 2 the value of the variable, and we also apply the shift-right bit operator to the variable `myVar3` which will divide the value of the variable by 2.

If you run the previous script you will see the following in your console.

```txt
$ ./compound_command.sh
myVar: 33
myVar2: 32, myVar3: 2
```

There are several advantages of using the Compound Command `((...))`:
1. More readable and concise than using other tools like `expr`
2. Efficient and well-integrated into Bash for handling numbers
3. Supports bitwise operations and comparison operators

## Operators Order
In Bash, just like in most programming languages, operators have an **order of precedence** (also known as operator precedence) that determines the sequence in which operations are evaluated in an expression. Understanding operator precedence is crucial when writing complex expressions to ensure that they are evaluated as intended.

Bash supports a variety of operators for arithmetic, logical operations, string manipulation, and comparisons. When multiple operators are present in an expression, the precedence rules dictate the order of execution.

The following table contains the order based on which Bash will evaluate the operators.

| Order | Operators | Description |
| :----: | :---- | :---- |
| 1 | `id++`, `id--` | variable post-increment and post-decrement |
| 2 |  `++id`, `--id` | variable pre-increment and pre-decrement |
| 3 | `-`, `+` | unary minus and plus |
| 4 | `!`, `~` | logical and bitwise negation |
| 5 | `**` | exponentiation |
| 6 | `*`, `/`, `%` | multiplication, division, remainder | 
| 7 | `+`, `-` | addition, subtraction |
| 8 | `<<`, `>>` | left and right bitwise shifts |
| 9 | `<=`, `>=`, `<`, `>` | comparison |
| 10 | `==`, `!=` | equality and inequality|
| 11 | `&` | bitwise AND |
| 12 | `^` | bitwise eXclusive OR |
| 13 | `|` | bitwise OR |
| 14 | `&&` | logical AND |
| 15 | `||` | logical OR |
| 16 | `expr?expr:expr` | conditional operator |
| 17 | `=`, `*=`, `/=`, `%=`, `+=`, `-=`, `<<=`, `>>=`, `&=`, `^=`, `|=` | assignment|

In Bash, the order of precedence follows specific rules. Here’s a simplified breakdown:
* **Parentheses** (`()`): Highest precedence. They group expressions and force evaluation inside them first.
* **Arithmetic operators**  (`*`, `/`, `%`, `+`, `-`): Multiplication, division, and modulus have higher precedence than addition and subtraction.
* **Logical NOT** (`!`): Unary negation, with higher precedence than `&&` and `||`.
* **Logical AND** (`&&`): Evaluated after comparisons, but before `||`.
* **Logical OR** (`||`): Lowest precedence among the common operators.

Understanding operator precedence in Bash helps you avoid logic errors in complex expressions and write more predictable, efficient scripts. While Bash generally follows common mathematical precedence rules, always remember that parentheses `()` can be used to ensure the desired order of evaluation.

## Summary
In this chapter we learnt several ways to deal with integer numbers.

We learnt:
* How to use “`expr`” command to do arithmetic, comparisons and boolean operations
* How to use “`let`” and “declare” to initialize variables and the different operators that we can use with them
* How to declare integer numbers using alternative representations such as octal, hexadecimal and other bases
* How to use the Bash arithmetic expansion (“`$((...))`”) and the compound command (“`((...))`”)
* In what order the operators are evaluated

If you managed to get here and understood and practiced the different commands presented in the chapter, you are on the right path.

Remember that *practice makes perfect*. So, practice, practice, practice,...

## References
1. <https://linuxhint.com/expr-command-bash/>
2. <https://www.geeksforgeeks.org/expr-command-in-linux-with-examples/>
3. <https://unix.stackexchange.com/questions/286209/using-expr>
4. <https://www.javatpoint.com/linux-expr-command>
5. <https://tldp.org/LDP/abs/html/declareref.html>
6. <https://phoenixnap.com/kb/bash-let>
7. <https://linuxhint.com/bash_declare_command/>
8. <https://www.computerhope.com/unix/bash/let.htm>
9. <https://tldp.org/LDP/abs/html/numerical-constants.html>
10. <https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html>
11. <https://tldp.org/LDP/abs/html/arithexp.html>
12. <https://www.shell-tips.com/bash/math-arithmetic-calculation/#gsc.tab=0>
13. <https://stackoverflow.com/questions/39199299/what-is-the-essential-difference-between-compound-command-and-normal-command-in>
14. <https://tldp.org/LDP/abs/html/dblparens.html>
15. <https://stackoverflow.com/questions/31255699/double-parenthesis-with-and-without-dollar>
16. <http://mywiki.wooledge.org/ArithmeticExpression>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

<p id="footnote-1" style="font-size:10pt">
1. <a href="https://www.python.org">https://www.python.org</a> <a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. <a href="https://www.perl.org">https://www.perl.org</a> <a href="#footnote-2-ref">&#8617;</a>
</p>
<p id="footnote-3" style="font-size:10pt">
3. Will fix the mathemetical formulas at some point.<a href="#footnote-3-ref">&#8617;</a>
</p>
<p id="footnote-4" style="font-size:10pt">
4. Will fix the mathemetical formulas at some point.<a href="#footnote-4-ref">&#8617;</a>
</p>
<p id="footnote-X" style="font-size:10pt">
5. This is something we will see in a later chapter.<a href="#footnote-X-ref">&#8617;</a>
</p>

