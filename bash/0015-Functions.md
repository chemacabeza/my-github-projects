---
layout: chapter
title: "Chapter 15: Functions"
---

# Chapter 15: Functions

## Index
* [Declaration]({{ site.url }}//bash-in-depth/0015-Functions.html#declaration)
* [Declaration vs Call]({{ site.url }}//bash-in-depth/0015-Functions.html#declaration-vs-call)
* [Local variables]({{ site.url }}//bash-in-depth/0015-Functions.html#local-variables)
* [Overriding functions and commands]({{ site.url }}//bash-in-depth/0015-Functions.html#overriding-functions-and-commands)
* [Variable `$FUNCNAME` associated to a function]({{ site.url }}//bash-in-depth/0015-Functions.html#variable-funcname-associated-to-a-function)
* [Positional parameters]({{ site.url }}//bash-in-depth/0015-Functions.html#positional-parameters)
* [`shift` built-in command]({{ site.url }}//bash-in-depth/0015-Functions.html#shift-built-in-command)
* [Return status (`$?`) and `return`]({{ site.url }}//bash-in-depth/0015-Functions.html#return-status--and-return)
* [Returning non-integer values]({{ site.url }}//bash-in-depth/0015-Functions.html#returning-non-integer-values)
* [Recursivity]({{ site.url }}//bash-in-depth/0015-Functions.html#recursivity)
* [Summary]({{ site.url }}//bash-in-depth/0015-Functions.html#summary)
* [References]({{ site.url }}//bash-in-depth/0015-Functions.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

Now that we have learnt the basic blocks of Bash we are going to add another layer of abstraction that are… the functions.

In Bash scripting, functions serve as essential building blocks that allow for the modularization and organization of code. A function in Bash is a self-contained block of code that performs a specific task, and it can be invoked or called from anywhere within the script. This modular approach not only enhances code readability but also promotes code reuse, making scripts more efficient and maintainable.

To declare a function in Bash, the “`function`” keyword or a shorthand syntax with parentheses is used, followed by the function name and the curly braces that encapsulate the function body. Functions may or may not receive arguments, allowing for flexibility in handling input parameters. Additionally, they can return values to the calling code, contributing to the versatility of Bash scripts.

Functions in Bash enable the creation of structured and organized scripts by encapsulating specific functionalities. As we go deeper into Bash scripting, we will explore the syntax, parameters, return values, and best practices for utilizing functions. Understanding how to leverage functions enhances the efficiency and readability of Bash scripts, contributing to the development of robust and maintainable automation solutions.

## Declaration

In Bash scripting, declaring a function involves specifying the function's name, defining its behavior or code block, and optionally providing parameters that the function can accept. The syntax for declaring a function is straightforward and can be done using either the “`function`” keyword or a concise shorthand notation.

<div style="text-align:center">
    <img src="/assets/bash-in-depth/0015-Functions/Function-Declaration.png" width="450px"/>
</div>

Let’s see next a couple of examples of how to declare a function.

The first example is by using the “`function`” keyword.

```bash
 1 #!/usr/bin/env bash
 2 # Script: function-0001.sh
 3 function my_function() {
 4     echo "Hello from inside the function"
 5 }
 6 my_function
```

When you run the previous script you get the following output.

```txt
$ ./function-0001.sh
Hello from inside the function
```

And the second example is by declaring the function without the “`function`” keyword, like the following script.

```bash
 1 #!/usr/bin/env bash
 2 # Script: function-0002.sh
 3 my_function() {
 4     echo "Hello from inside the function"
 5 }
 6 my_function
```

If you run the last script you will see that it produces the same output as the "`function-0002.sh`" script.

Although both approaches are equivalent, the second one (without the “`function`” keyword) is more portable and because of portability reasons it will be the approach that we will use in this book.

Something to notice is that a function **can NEVER have an empty body**. For example, if we try to execute the following script.

```bash
 1 #!/usr/bin/env bash
 2 # Script: function-0003.sh
 3 error_fn_1() {
 4 }
 5 error_fn_2() {
 6     echo "Some commands"
 7 }
```

If you try to run the previous script you will get the following error.

```txt
$ ./function-0003.sh
./function-0003.sh: line 4: syntax error near unexpected token `}'
./function-0003.sh: line 4: `}'
```

The body of a function must contain any combination of commands and statements like the ones we learnt before (`if`, `case`, `for` loop, `while` loop,...). You have to write code that is clean so that you can understand it when you come back to it.

In the next sections we will dive into different details of functions. We will start by comparing declaration vs call of a function.

## Declaration vs Call

In Bash scripting you cannot call a function unless it has been previously declared. Bear in mind that declaring and calling a function are two different things. You can declare functions that call other functions/commands and it will work as long as at the moment of the execution the commands/functions are available to the script.

Let’s see what happens when you try to invoke a function that has not been declared before the call.

```bash
 1 #!/usr/bin/env bash
 2 # Script: function-0004.sh
 3 my_function # not declared before execution
 4 my_function() {
 5     echo "My function"
 6 }
```

When you run the previous script you will receive the following error.

```txt
$ ./function-0004.sh
./function-0004.sh: line 3: my_function: command not found
```

Now if you swap the order having the function declared before the call of the function, everything works.

```bash
 1 #!/usr/bin/env bash
 2 # Script: function-0005.sh
 3 my_function() {
 4     echo "My function"
 5 }
 6 my_function
```

When you execute the last script you will get a successful execution.

```txt
$ ./function-0005.sh
My function
```

In the following example you will see that there are two functions being declared which are “`my_function_1`” and “`my_function_2`”. You will also notice that “`my_function_1`” invokes “`my_function_2`”, which is declared **after** “`my_function_1`”.

```bash
 1 #!/usr/bin/env bash
 2 # Script: function-0006.sh
 3 my_function_1() {
 4     echo "Inside my_function_1"
 5     my_function_2
 6 }
 7 my_function_2() {
 8     echo "Inside my_function_2"
 9 }
10 my_function_1
```

This is OK because by the time Bash executes “`my_function_1`” all the information needed by it to execute successfully (in our case, declaration of “`my_function_2`”) is available in memory/context.

If you execute the previous script you will get the following output.

```txt
$ ./function-0006.sh
Inside my_function_1
Inside my_function_2
```

In the same way that a Bash script can have variables, a function can have as well variables that are called “*local variables*”. In the next section we will talk about local variables.

## Local variables
What is the “**scope**” of a variable? *The scope of a variable is the context in which it has meaning, in which it has a value that can be referenced*. For example, the scope of a local variable lies only within the function, block of code (`{...}`), or subshell (we will talk later in the book) within which it is defined, while the scope of a global variable is the entire script in which it appears.

A variable declared as “`local`” is one that is visible only within the block of code in which it appears. If a variable within a function is not declared as local, global scope will be by default.

Before a function is called, all variables declared within the function **are invisible outside the body of the function**, not just those explicitly declared as “`local`”.

Let's see how it works with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 # Script: function-0007.sh
 3 custom1() {
 4     local localVar=324
 5     globalVar=123
 6     echo "localVar: $localVar"
 7     echo "Done with $FUNCNAME"
 8 }
 9 echo "Local variable before function: $localVar"
10 echo "Global variable before function: $globalVar"
11 custom1
12 echo "Local variable after function: $localVar"
13 echo "Global variable after function: $globalVar"
```

When you execute the previous script you will have the following output in the terminal window.

```txt
$ ./function-0007.sh
Local variable before function:
Global variable before function:
localVar: 324
Done with custom1
Local variable after function:
Global variable after function: 123
```

So, what is happening in the execution of this script? When the script reaches lines 9 and 10 it just prints the string without the content of the variables. This is because there is no information about the variables at this point.

Then, on line 11 the function “`custom1`” is executed. Inside the function there are 2 variables. The first variable is a local variable named “`localVar`” whose scope is the function itself and it will not be available outside the function. The second variable, named “`globalVar`”, is a global variable (as the “`local`” keyword was not used, global scope is the default one) that, once the function is executed, will be available to the rest of the script.

Once the execution of the function is done you see that only the global variable is present in the output.

## Overriding functions and commands

In Bash you can override the declaration of a function (or a command) by declaring a new function **with the same exact name**.

The way it works is once the functions (or commands) are available inside the script you are working on, you can add a function with the same name as the function (or command) you want to override and from that moment the overriding will work.

To summarize, **the latest declaration wins**.

Let’s see how it works with a couple of examples to show how we can override functions (or commands).

```bash
 1 #!/usr/bin/env bash
 2 # Script: function-0008.sh
 3 my_function_1() {
 4     echo "Inside my_function_1 - 1"
 5 }
 6 my_function_1() { # Will override the previous declaration
 7     echo "Inside the override of my_function_1"
 8 }
 9 my_function_1
```

As you can see in the previous script the function is declared twice, as we mentioned before the second declaration (the latest one) will be the one that will be used.

If you execute the previous script you get the following result.

```txt
$ ./function-0008.sh
Inside the override of my_function_1
```
As you can see from the execution the second declaration of the function “`my_function_1`” is the one that got executed.

Now that we know how to override functions, let’s try to do the same with commands.

In the following example we are going to override the command “`ls`”<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>.

```bash
 1 #!/usr/bin/env bash
 2 #Script: function-0009.sh
 3 echo "Before overriding"
 4 echo "##########"
 5 ls  # standard command 'ls'. Will print directory content
 6 echo ""
 7 ls() { # Overriding command 'ls'
 8     echo "Nothing to see here"
 9 }
10 echo "After overriding"
11 echo "##########"
12 ls   # Will print "Nothing to see here"
13 echo ""
```

In the previous script, on line 5, the actual “`ls`” command is used to list the contents of the current folder. Later between lines 7 and 9 we do declare a function with the name “`ls`” to be able to override the command “`ls`”.

When you run the previous script you will get the following result in the terminal window.

```txt
$ ./function-0009.sh
Before overriding
##########
function-0001.sh  function-0003.sh  function-0005.sh  function-0007.sh  function-0009.sh
function-0002.sh  function-0004.sh  function-0006.sh  function-0008.sh

After overriding
##########
Nothing to see here
```

As you can see in the execution of the last script before line 7 of the script the actual “`ls`” command is used. After line 7 the function is the one used.

## Variable `$FUNCNAME` associated to a function

The variable “`FUNCNAME`” is an array containing the names of all shell functions currently in the execution call stack. The element with index 0 is the name of any currently-executing shell function. The bottom-most element (the one with the highest index) is "`main`"<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a>. This variable exists only when a shell function is executing. Assignments to “`FUNCNAME`” have no effect. If “`FUNCNAME`” is unset, it loses its special properties, even if it is subsequently reset.

Let's see how it works with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: function-0010.sh
 3 my_custom_function() {
 4     echo "We are inside the function '$FUNCNAME'"
 5     echo "Array: ${FUNCNAME[@]}"
 6     my_custom_function_2
 7 }
 8 my_custom_function_2() {
 9     echo "Array: ${FUNCNAME[@]}"
10     my_custom_function_3
11 }
12 my_custom_function_3() {
13     echo "Array: ${FUNCNAME[@]}"
14 }
15 my_custom_function
16 echo "End"
```

If you run the previous script you will see the following output in the terminal window.

```txt
$ ./function-0010.sh
We are inside the function 'my_custom_function'
Array: my_custom_function main
Array: my_custom_function_2 my_custom_function main
Array: my_custom_function_3 my_custom_function_2 my_custom_function main
End
```

## Positional parameters

This section is going to be very useful because what we will learn here is applicable to both functions and scripts.

Till now we learnt how to write functions and scripts that execute a task without receiving anything from the caller. Now we are going to learn how we can pass arguments to a function/script so that it can be used as parameters.

What is the difference between arguments and parameters? To be on the same page we are going to use the notions that appear on this page of Developer Mozilla<a id="footnote-3-ref" href="#footnote-3" style="font-size:x-small">[3]</a>.

Note the difference between parameters and arguments:
* Function parameters are the names listed in the function's definition.
* Function arguments are the real values passed to the function.
    * An argument is a value passed as input to a function.
* Parameters are initialized to the values of the arguments supplied.

All information we can have regarding positional parameters come inside the following variables:
* `$0`, `$1`, `$2`, etc: Positional parameters, passed from command line to script or passed to a function. 
    * `$0` is a “*special value*” and it’s **ALWAYS** going to be the name of the script being executed in the way you wrote it (relative path, absolute path, etc) 
* `$#`: Number of command-line arguments or positional parameters
* `$*`: All of the positional parameters, seen as a single word (it must be quoted , “`$*`”)
* `$@`: Same as `$*`, but each parameter is a quoted string, that is, the parameters are passed on intact, without interpretation or expansion. This means, among other things, that each parameter in the argument list is seen as a separate word.

## `shift` built-in command

The “`shift`” command is one of the Bourne shell built-ins that comes with Bash. This command takes one argument, a number. The positional parameters are shifted to the left by this number, `N`. The positional parameters from `N+1` to `$#` are renamed to variable names from `$1` to `$# - N+1`.

Say you have a command that takes 10 arguments, and `N` is 4, then `$4` becomes `$1`, `$5` becomes `$2` and so on. `$10` becomes `$7` and the original `$1`, `$2` and `$3` **are thrown away**.

If `N` is zero or greater than `$#`, the positional parameters are not changed and the command has no effect. If `N` is not present, **it is assumed to be 1**. The return status is zero unless `N` is greater than `$#` or less than zero; otherwise it is non-zero.

Let's see how the “`shift`” command works with the following example.

```bash
 1 #!/usr/bin/env bash
 2 #Script: function-0011.sh
 3 args=($@)
 4 echo "Printing original list of arguments"
 5 for((index=0; index <= ${#args[@]}; index++)) {
 6     echo "Arg[$index]: ${!index}"
 7 }
 8 shift 4
 9 args=($@)
10 echo "Printing list after shifting"
11 for((index=0; index <= ${#args[@]}; index++)) {
12     echo "Arg[$index]: ${!index}"
13 }
```

When you execute the previous script with the numbers from 1 to 9 you will get the following output.

```txt
$ ./function-0011.sh
Printing original list of arguments
Arg[0]: ./function-0011.sh
Arg[1]: 1
Arg[2]: 2
Arg[3]: 3
Arg[4]: 4
Arg[5]: 5
Arg[6]: 6
Arg[7]: 7
Arg[8]: 8
Arg[9]: 9
Printing list after shifting
Arg[0]: ./function-0011.sh
Arg[1]: 5
Arg[2]: 6
Arg[3]: 7
Arg[4]: 8
Arg[5]: 9
```

Pay attention to a few things:
* Parameter `$0`, as we mentioned previously, it’s always the name of the script
* Arguments from index 1 to index 4 were **discarded**
* Arguments from index 5 to index 9 were moved to indices 1 to 5

## Return status (`$?`) and `return`

In Bash, every function and script “*returns*” a value which is an integer. For that, the keyword “`return`” tends to be used.

Once the result is returned from the function and the scope of the function is over, the result will be stored in the variable “`$?`” which will always contain the return value (integer) of the last statement or function or script executed.

Let's see how it works with an example.

```bash
 1 #!/usr/bin/env bash
 2 #Script: function-0012.sh
 3 # Declaring a function
 4 my_ok_function() {
 5     echo "This function returns zero"
 6     return 0 
 7 }
 8 # Invoking the function
 9 my_ok_function
10 # Printing the result of the function
11 echo "Result: $?"
```

When you run the previous script you will have the following output in the terminal window.

```txt
$ ./function-0012.sh
This function returns zero
Result: 0
```

As you already saw the script printed “`Result: 0`” to the output. Something to be aware of is that the “`return`” keyword **only accepts an integer in the range [0-255]**. If an integer beyond this range is specified its binary value will be truncated to what 8 bits allow. For example:
* If 256 is specified, the actual value will be zero
* If 257 is specified, the actual value will be 1
* If -1 is specified, the actual value will be 255
* If -2 is specified, the actual value will be 254
* And so on.

If no “`return`” keyword is specified in the return of a function, the value returned will be the return value of the last command in the function.

You can see “`return`” as the way to signal the exit status of a function.

Once the result is returned from the function and the scope of the function is over, the result will be stored in the variable “`$?`” which will always contain the return value (integer) of the last statement or function or script executed.

## Returning non-integer values

As we saw before, the keyword “`return`” is used to terminate the execution of the current function with a specific status code [0-255]. “`return`” cannot be used to return other values apart from integers in the specified range. In order to “`return`” other kinds of values we need to use another builtin command we learnt already, which is the “`echo`” command.

Let's see how it works with the following example.

```bash
$ ./function-0013.sh
Result is 'NON_INTEGER_VALUE'
```

The previous script will printed “`Result is ‘NON_INTEGER_VALUE’`” to the screen. But you could be more creative by creating JSON strings, XML strings and so much more!

## Recursivity

In computer science, recursion is a programming technique using a function or an algorithm that calls itself one or more times until a specified condition is met, time at which the rest of each repetition is processed from the last one called to the first.

Let's see how it works with the following example script that implements the Fibonacci<a id="footnote-4-ref" href="#footnote-4" style="font-size:x-small">[4]</a> function.

```bash
 1 #!/usr/bin/env bash
 2 #Script: function-0014.sh
 3 # Declaring the Fibonacci function
 4 fibonacci() {
 5     nthTerm=$1
 6     if [ $nthTerm -eq 0 ]; then # F(0)
 7         echo 0
 8     elif [ $nthTerm -eq 1 ]; then # F(1)
 9         echo 1
10     else # F(N-1) + F(N-2)
11         local n1=$(($nthTerm - 1))
12         local fn1=$(fibonacci $n1)
13         local n2=$(($nthTerm - 2))
14         local fn2=$(fibonacci $n2)
15         echo $(($fn1 + $fn2))
16     fi
17 }
18 # Calling the Fibonacci function with the number 10
19 fibonacci 10
```

When you run the previous script you will see the following the terminal window.

```txt
$ ./function-0014.sh
55
```

Just for the record, recursivity is not only specific to functions. It’s a concept that can be used at script level.

The previous function could be written as the following so that the recursion is applied to the script itself.

```bash
 1 #!/usr/bin/env bash
 2 #Script: function-0015.sh
 3 nthTerm=$1
 4 if [ $nthTerm -eq 0 ]; then # F(0)
 5     echo 0
 6 elif [ $nthTerm -eq 1 ]; then # F(1)
 7     echo 1
 8 else # F(N-1) + F(N-2)
 9     n1=$(($nthTerm - 1))
10     fn1=$($0 $n1) # script calling itself
11     n2=$(($nthTerm - 2))
12     fn2=$($0 $n2) # script calling itself
13     echo $(($fn1 + $fn2))
14 fi
```

When you run the previous script providing 10 as input it will generate the same output as the previous script.

```txt
$ ./function-0015.sh
55
```

You will notice that takes a bit longer for the script to be executed because it's creating different processes<a id="footnote-5-ref" href="#footnote-5" style="font-size:x-small">[5]</a>.

## Summary

In this electrifying chapter, we dove headfirst into one of the most powerful tools in a Bash scripter's arsenal: **functions**! Functions allow us to streamline our scripts, making them more efficient, reusable, and easy to maintain. We explored how functions are declared and discovered that simply declaring them isn't enough — they only spring into action when explicitly called. This distinction is crucial for building more complex scripts, where we can define logic once and call it as many times as needed!

We also uncovered the beauty of **local variables** inside functions, which keep our code clean and isolated, preventing conflicts with global variables. This not only improves readability but also ensures that our functions don't unintentionally mess up other parts of the script. Then came the mind-blowing revelation: **overriding functions** and **even commands**! That's right — with a little creativity, you can redefine how certain commands work in your script, but with great power comes great responsibility!

One of the most intriguing topics covered was the **`$FUNCNAME` variable**, a hidden gem that helps you track the function call stack. It provides a look under the hood when debugging or working with nested functions. To round things off, we dove into **positional parameters** and the game-changing **`shift` built-in command**, which lets us control how arguments are passed and managed within functions. Mastering these concepts opens the door to writing flexible, adaptable scripts that can handle any input thrown their way. This chapter was a true exploration of the versatility and power of functions in Bash!

## References

1. <https://linux101.hashnode.dev/bash-function-return-value-a-beginners-guide>
2. <https://linuxize.com/post/bash-functions/>
3. <https://phoenixnap.com/kb/bash-function>
4. <https://ryanstutorials.net/bash-scripting-tutorial/bash-functions.php>
5. <https://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-8.html>
6. <https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html>
7. <https://www.shell-tips.com/bash/functions/#gsc.tab=0>

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">
<p id="footnote-1" style="font-size:10pt">
1. The “<code style="font-size:10pt">ls</code>” command is used to list the content of the folders that you pass as arguments, or the current folder if you do not provide any argument.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. "<code style="font-size:10pt">main</code>" represents the global (non-function) execution context of the Bash script.<a href="#footnote-2-ref">&#8617;</a>
</p>
<p id="footnote-3" style="font-size:10pt">
3. <a href="https://developer.mozilla.org/en-US/docs/Glossary/Parameter">https://developer.mozilla.org/en-US/docs/Glossary/Parameter</a> <a href="#footnote-3-ref">&#8617;</a>
</p>
<p id="footnote-4" style="font-size:10pt">
4. <a href="https://en.wikipedia.org/wiki/Fibonacci_sequence">https://en.wikipedia.org/wiki/Fibonacci_sequence</a><a href="#footnote-4-ref">&#8617;</a>
</p>
<p id="footnote-5" style="font-size:10pt">
5. We will speak about processes in a later chapter.<a href="#footnote-5-ref">&#8617;</a>
</p>

