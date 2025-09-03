# Working with Numbers: Integers
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



<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

<p id="footnote-1" style="font-size:10pt">
1. https://www.python.org <a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. https://www.perl.org <a href="#footnote-2-ref">&#8617;</a>
</p>

