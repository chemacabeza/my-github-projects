# Chapter 29: Here Strings


## Introduction

<!--
Here Strings in Bash provide a simple and efficient way to pass a string directly as input to a command, eliminating the need for intermediate files or complex redirections. They are a useful feature for handling single-line input and streamline workflows that require minimal data to be fed into commands.

A Here String uses the "`<<<`" operator to redirect a string to the standard input of a command. Unlike Here Documents, which are designed for multi-line input, Here Strings are specifically tailored for single-line strings or concise inputs. This makes them a perfect fit for quick tasks like testing commands, providing data for pipelines, or processing short strings.

The beauty of Here Strings lies in their clarity and convenience. Instead of manually typing input or reading from a file, you can encapsulate the input string directly in your script. This not only makes your code more readable but also reduces the chance of errors stemming from external dependencies.

By mastering Here Strings, you'll gain yet another tool to make your Bash scripts more efficient and elegant, further enhancing your command-line prowess.
-->

In the previous chapter, we explored HereDocs, a powerful tool for sending multi-line strings as input to a command. Now, we turn our attention to a simpler alternative: the **Here String**.

The syntax for a Here String is as follows:

```bash
    COMMAND<<<$VARIABLE
```

or

```bash
    COMMAND<<<"SOMESTRING"
```

In this form, Bash expands the variable "`$VARIABLE`" or processes the provided string "`"SOMESTRING"`" and passes it directly to the standard input of the specified "`COMMAND`".

To visualize what’s happening, think of the "`<<<`" operator as a mechanism that takes a string or variable on its right-hand side and feeds it seamlessly into the input stream of the command on its left.

This elegant and concise syntax is ideal for scenarios requiring single-line input, offering simplicity and readability to your Bash scripts.

## Plain String as Here String

Let’s explore an example where we use a Here String to pass a plain text string as input to the "`cat`" command.

```bash
#!/usr/bin/env bash
#Script: herestring-0001.sh
cat <<< "This is a plain string"
```

When we execute this script, the output is as follows:

<pre>
$ ./herestring-0001.sh
This is a plain string

$
</pre>

Here, the "`cat`" command simply echoes back to its standard output whatever content it receives via its standard input, demonstrating the straightforward functionality of Here Strings.

## String With Variable as Here String

Let’s create a new script that incorporates a variable into the input string:

```bash
#!/usr/bin/env bash
#Script: herestring-0002.sh
MY_VAR="Variable Value"
cat <<< "The content of \$MY_VAR is: ${MY_VAR}"
```

When executed, this script generates the following output:

<pre>
$ ./herestring-0002.sh
The content of $MY_VAR is: Variable Value

$
</pre>

Here, the "`cat`" command outputs the string with the variable properly expanded and replaced, showcasing how variables can be seamlessly integrated into Here Strings.

## Variable as Here String

Finally, let’s explore an example where a variable is provided as input. As you might expect, the result will be the contents of the variable printed to the standard output:

```bash
#!/usr/bin/env bash
#Script: herestring-0003.sh
MY_VARIABLE="Value of variable"
cat <<< $MY_VARIABLE
```

When this script is executed, it produces the following output:

<pre>
$ ./herestring-0003.sh
Value of variable

$
</pre>

## Summary

Here Strings in Bash are a simplified version of Here Documents, designed to send a single-line string or the contents of a variable directly into the standard input of a command. Unlike HereDocs, which are used for multiline inputs, Here Strings focus on concise, streamlined input handling. The syntax involves the "`<<<`" operator, which takes a string or variable on its right side and feeds it into the command on its left. This makes Here Strings particularly useful for quick, one-liner scripts or for testing commands without creating temporary files.

The functionality of Here Strings is straightforward yet powerful. When a variable is used as input, its value is expanded by Bash and passed to the command, while plain strings are used as-is. This allows for efficient manipulation and testing of commands that process input data. Whether you're redirecting a literal string or a variable's content, Here Strings simplify the process and maintain clarity in your scripts.

By using Here Strings, you can achieve a cleaner and more concise syntax compared to traditional input redirection methods. They are ideal for situations where you need to pass a small amount of data to a command without the overhead of creating additional files or managing complex input streams. This simplicity makes Here Strings a valuable tool for Bash scripting, contributing to more efficient and readable scripts.

*"Every great script begins with understanding the small tools, like Here Strings, that make big differences."*

## References

1. <https://bash.cyberciti.biz/guide/Here_strings>
2. <https://tecadmin.net/bash-here-strings/>
3. <https://tldp.org/LDP/abs/html/x17837.html>
4. <https://www.baeldung.com/linux/heredoc-herestring>
5. <https://www.geeksforgeeks.org/shell-scripting-here-strings/>
6. <https://xinux.net/index.php/Here_String>

