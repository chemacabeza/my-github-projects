---
layout: chapter
title: "Chapter 7: Working with Numbers - Floating-point numbers"
---

# Chapter 7: Working with Numbers - Floating-point numbers

## Index
* [`printf` command]({{ site.url }}//bash-in-depth/0007-Working-with-Numbers-Floating.html#printf-command)
* [`bc` command]({{ site.url }}//bash-in-depth/0007-Working-with-Numbers-Floating.html#bc-command)
* [Summary]({{ site.url }}//bash-in-depth/0007-Working-with-Numbers-Floating.html#summary)
* [References]({{ site.url }}//bash-in-depth/0007-Working-with-Numbers-Floating.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

In Bash, working with floating-point numbers can be a bit tricky because Bash’s built-in arithmetic only supports **integer operations**. This means that directly performing calculations involving decimals or fractions is not possible using the default arithmetic capabilities of Bash (`$((...))` or `let`), which are limited to whole numbers.

To handle floating-point numbers, you need to use external tools like `bc` (an arbitrary precision calculator) or `printf` (a format string utility). These tools extend Bash's capability to handle real numbers and precision-based arithmetic.

In the next sections we will learn about the commands `bc` and `printf`.


## `printf` command
An unconventional way, although practical, to work with floating point numbers with native bash is by using together with Scientific Notation.

What is the “*Scientific Notation*”? It’s a way to express numbers which has the following format.

```bash
    <base>e<exponent>
```

which would be equivalent to `<base> * 10^{<exponent>}`<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>

This way of expressing numbers will tell the “`printf`” command where to put the decimal comma.

Let's see how it works with the following script.

```bash
 1 #!/usr/bin/env bash
 2 ##Script: printf.sh
 3 printf "Number 1: %.3f\n" 12345e3
 4 printf "Number 2: %.3f\n" 12345e-3
 5 printf "Number 3: %.3f\n" 1234.5e3
 6 printf "Number 4: %.3f\n" 1234.5e-3
```

When you run the previous script you will get the following output in your terminal.

```txt
$ ./printf.sh
Number 1: 12345000.000
Number 2: 12.345
Number 3: 1234500.000
Number 4: 1.235
```

From this script and its output we can understand that the scientific notation is a way of representing numbers that tells how many places should the decimal comma be moved and in what direction.

In lines 1 and 3 of the output, the decimal comma will be moved to the right, while the lines 2 and 4 will move the decimal comma to the left.

Let’s summarize the basics of using this approach:
* Make sure the operation you want to do is expressed using integer numbers only (otherwise Bash will fail)
* Decide in advance how many decimals you want to have in your result.
* When you use the Bash arithmetic expansion make sure you multiply the operation by “`10**<#decimals>`”. Like that you will calculate a number that is “#decimals” times bigger.
* Use scientific notation “`e-<#decimals>`” to be able to move the comma to the left to be able to have the number of decimals you want.

We could summarize it even more with the following line.

```bash
    printf %.<precision>f "$((10**<multiplier>*<operation>))e-<multiplier>”
```

Now let’s use the previous points in a more complex operation. We are going to create a script that will calculate the volume of a sphere.

```bash
 1 #!/usr/bin/env bash
 2 #Script: sphere.sh
 3 #!/usr/bin/env bash
 4 PI=314
 5 NUM_DECIMALS=2
 6 RADIUS=2
 7 printf "The volume of a sphere with radius $RADIUS is %.3f\n" "$((10**$NUM_DECIMALS * $PI * $RADIUS**3 * 4 / 3))e-$(($NUM_DECIMALS*2))"
```

This script will calculate the volume of a sphere with radius of 2 units. When you run the previous script you will see this in your terminal.

```txt
$ ./sphere.sh
The volume of a sphere with radius 2 is 33.493
```

Now that we know how to use the `printf` command to operate with floating-point numbers, we are going to take a look to the command `bc`.

## `bc` command

The “`bc`” command is a tool that will allow us to develop more complex calculations. It can be used in both interactive and non-interactive ways. It comes with its own language (with similarities to the C programming language) that allows you to develop scripts making mathematical calculations.

To have a quick introduction to the language behind the “`bc`” command, we are going to present a few tables with the basics so that we can move forward quickly.

The “`bc`” command has its own syntax (almost a full programming language) that allows you to define complex programs. 

Next we will present to you a few tables that contain a summary of the basic syntax we can use with the “`bc`” command.

The first table contains the operands that you can use in the language of "`bc`".

| Operand | Description |
| :----:  | :----       |
| `-expr` | Negation of a expression |
| `++var` | Pre-incrementing the variable before using the new value |
| `--var` | Pre-decrementing the variable before using the new value |
| `var++` | Post-incrementing the variable after using the old value | 
| `var--` | Post-decrementing the variable after using the old value |
| `expr1 + expr2` | Addition of the two expressions |
| `expr1 - expr2` | Difference of the two expressions |
| `expr1 * expr2` | Multiplication of the two expressions |
| `expr1 / expr2` | Division of the two expressions |
| `expr1 % expr2` | Reminder |
| `expr1 ^ expr2` | Exponentiation. The second expression **must be an integer** |
| `( expr )` | Force evaluation of the expression inside the parenthesis, altering the standard precedence |
| `var = expr` | Assigns the value of the expression to the variable |
| `var <op>= expr` | Equivalent to “`var = var <op> expr`”, where “`<op>`” is any of the previous operands (`+`, `-`, `*`, …) |


The next table contains relational expression that you can use with the "`bc`" command.

| Relational Expression | Description |
| :----: | :---- |
| `expr1 < expr2` | Result is 1 (true) if “`expr1`” is strictly less than “`expr2`” |
| `expr1 <= expr2` | Result is 1 (true) if “`expr1`” is strictly less than or equal to “`expr2`” |
| `expr1 > expr2` | Result is 1 (true) if “`expr1`” is strictly greater than “`expr2`” |
| `expr1 >= expr2` | Result is 1 (true) if “`expr1`” is strictly greater than or equal to “`expr2`” |
| `expr1 == expr2` | Result is 1 (true) if “`expr1`” is equal to “`expr2`” |
| `expr1 != expr2` | Result is 1 (true) if “`expr1`” is not equal to “`expr2`” |


The following table contains the boolean expressions that you can use with the "`bc`" command.

| Boolean Expression | Description |
| :----: | :---- |
| `!expr` | Result is 1 (true) if “`expr`” is 0 (zero, false). |
| `expr1 && expr2` | Result is 1 (true) if both expressions are non-zero (true) |
| `expr1 || expr2` | Result is 1 (true) if either expression in non-zero (true) |


The "`bc`" command also contains some standard functions that are represented in the following table.

| Standard Function | Desription |
| :----: | :---- |
| `length(expr)` | Returns the number of significant digits in the expression |
| `read()` | Reads a number from the standard input |
| `scale(expr)` | Number of digits after the decimal point in the expression |
| `sqrt(expr)` | Square root of the expression |


But the "`bc`" command also comes with internal variables that you can use in your "*bc scripts*" which are defined in the following table.

| Internal Variable | Description |
| :-----: | :----- |
| `scale` | Defines the number of digits after the decimal point. The default is zero |
| `ibase` | Defines the conversion base for input numbers. Default is base 10 |
| `obase` | Defines the conversion base for output numbers. Default is base 10 |
| `last` | It contains the value of the last printed number |


The next table contains the statements you can use in your "*bc scripts*".

| Statement | Description |
| :----- | :----- |
| `“string”` | The string is printed to the output |
| `print list` | Provides another method to print information. “`list`” is a list of expressions and strings separated by commas. |
| `{statement_list}` | Allows multiple statements to be grouped together for execution |
| <code class="language-plaintext highlighter-rouge">if (expression){<br>&emsp;statements1<br>}[else {<br>&emsp;statements2<br>}]</code>| If “`expression`” is non-zero, “`statements1`” is executed.<br>If “`expression`” is zero and “`else`” is present,  “`statements2`” will be executed. |
| <code class="language-plaintext highlighter-rouge">while (expression) {<br>&emsp; statements<br>}</code> | Will execute “`statements`” as long as “`expression`” is non-zero (true) |
| <code class="language-plaintext highlighter-rouge">for([expr1];[expr2];[expr3]){<br>&emsp;statements<br>}</code> | “`expr1`” is evaluated once before “`statements`” are executed. <br>“`expr2`” is evaluated before each execution of “`statements`”. If it’s evaluated to non-zero, “`statements`” will be executed. If it’s evaluated to zero, the execution of the loop will be terminated.<br>“`expr3`” is evaluated after the execution of “`statements`” and before “expr2” is evaluated. | 
| `break` | Forces to exit in the most recent enclosing “`while`” or “`for`” loop statement. |
| `continue` | Forces the execution of the next iteration in the most recent enclosing “`while`” or “`for`” loop statement. |
| `halt` | Causes the “`bc`” processor to quit when it’s executed |
| `return` | Returns value zero from a function |
| `return (expression)` | Returns the value of “`expression`” from a function. |


The "`bc`" command comes as well with what are called "*Pseudo Statements*" which are the following ones:
* `limits`: Prints the limits enforced by the version of “`bc`”
* `quit`: Causes the “`bc`” processor to quit, regardless of where the quit statement is found.
    * “`if (0 == 1) quit`” will cause “`bc`” to terminate.
    * “`if (0 == 1) halt`” will **NOT** cause “`bc`” to terminate.
* `warranty`: Prints a warranty notice


You can also define functions in a "*bc script*". For that you need to use the following syntax.

```bc
define name (params) {
    auto_list
    statement_list
}
```

Where:
* `name` is the name of your function
* `params` is a list of zero or more parameters separated by commas
* `auto_list` is an optional list of variables intended to be used locally to the function. The syntax is “`auto variable_name,...`”
* `statement_list` is a list of statements that you will use in the function


The "`bc`" command comes as well with some mathematical functions that you can use when you invoke the "`bc`" command with the "`-l`" flag. The functions are as follows:
* `s(x)`: Sine of “`x`”. “`x`” is in radians
* `c(x)`: Cosine of “`x`”. “`x`” is in radians
* `a(x)`: Arctangent of “`x`”. It returns radians
* `l(x)`: Natural logarithm of “`x`”
* `e(x)`: Exponential function. It does `e^{x}`

As you can see, the “`bc`” command comes with a whole language that deals with variables that are either numbers or an array of numbers. With this we are going to revisit the example of the script to calculate the volume of a sphere.

First of all we need to write a “`bc`” script that will do the calculation.

```txt
 1 /* Number of decimals */
 2 scale=10
 3 /* Arc whose tangent is 1 (a(1)) is 45 degrees, which is pi/4 */
 4 pi=4*a(1)
 5 /* Function that will calculate the volume of a sphere according to the radius */
 6 define volume(radius) {
 7     return((radius^3)*pi*4/3)
 8 }
 9 /* Call to calculate the volume of a sphere of radius 2 */
10 volume(2)
11 /* End of script */
12 halt
```

With this script we have to invoke the “`bc`” command with the options “`-l`” (to load the mathematical functions), “`-q`” (quiet mode) and the name of the file holding the script previously written.

When execute it you will get the following output in your terminal.

```txt
$ bc -l -q volume_sphere_bc.txt
33.5103216341
```

The “*problem*” you could see with this script is that it’s static and calculates the volume of a sphere with radius 2. We could fix this very easily by replacing “`2`” with “`read()`”. In this case our new script would be as follows.

```txt
 1 /* Number of decimals */
 2 scale=10
 3 /* Arc whose tangent is 1 (a(1)) is 45 degrees, which is pi/4 */
 4 pi=4*a(1)
 5 /* Function that will calculate the volume of a sphere according to the radius */
 6 define volume(radius) {
 7     return((radius^3)*pi*4/3)
 8 }
 9 /* Call to calculate the volume of a sphere of radius 2 */
10 volume(read()) /* <<<<<<<<<<<<<<<<< */
11 /* End of script */
12 halt
```

When you execute with the new script you will notice that the "`bc`" command seems to be hanging.

```txt
$ bc -l -q volume_sphere_bc_read.txt 
<waiting...>
```

This is because the script has stopped at “`read()`” and it’s waiting for a number to be provided via the standard input. If we introduce “`2`” and press enter we do have the following in our terminal.

```txt
$ bc -l -q volume_sphere_bc_read.txt 
2
33.5103216341
```

We could make this script non-interactive by providing the number directly to the standard input when executing the “`bc`” command. We can do that by piping<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a> the number into the standard input, like this.

```txt
$ echo 2 | bc -l -q volume_sphere_bc_read.txt 
33.5103216341
```

## Summary

In this chapter we learnt how to deal with floating-point numbers in Bash by using the command "`printf`" and the command "`bc`" which comes with a very basic programming language and allows you to create very powerful scripts.

## References

1. <https://www.ibm.com/docs/zh/aix/7.2?topic=b-bc-command>
2. <https://en.wikipedia.org/wiki/Bc_(programming_language)>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

<p id="footnote-1" style="font-size:10pt">
1. Will fix the mathematical representation at some point.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. We will learn more about pipes in a later chapter.<a href="#footnote-2-ref">&#8617;</a>
</p>

