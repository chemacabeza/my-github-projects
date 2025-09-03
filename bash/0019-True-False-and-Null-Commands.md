---
layout: chapter
title: "Chapter 19: True, False and Null Commands"
---

# Chapter 19: True, False and Null Commands

## Index
* [The `true` command]({{ site.url }}//bash-in-depth/0019-True-False-and-Null-Commands.html#the-true-command)
* [The Null command]({{ site.url }}//bash-in-depth/0019-True-False-and-Null-Commands.html#the-null-command)
* [Null command vs `true` command]({{ site.url }}//bash-in-depth/0019-True-False-and-Null-Commands.html#null-command-vs-true-command)
* [The `false` command]({{ site.url }}//bash-in-depth/0019-True-False-and-Null-Commands.html#the-false-command)
* [Summary]({{ site.url }}//bash-in-depth/0019-True-False-and-Null-Commands.html#summary)
* [References]({{ site.url }}//bash-in-depth/0019-True-False-and-Null-Commands.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

In Bash, the "`true`", "`false`", and null commands play essential roles in scripting by providing fundamental control over conditional logic and flow.

The "`true`" command is a built-in Bash command that does nothing but return an exit status of 0, which represents success. It's often used in scripts or loops where an infinite loop is needed, or as a placeholder in conditions that require a positive (true) result. For example, in a while loop, "`while true; do ... done`" creates a loop that continues indefinitely until it's explicitly stopped.

The "`false`" command is the opposite of "`true`". It does nothing except return an exit status of "`1`", representing failure. It's useful for testing error conditions or to force a script to behave as though a condition has failed. For example, if you want a loop or condition to exit early, you might use "`false`" to simulate an error state or stop a loop.

The **Null command**, written as a colon ("`:`"), is another built-in Bash command that returns a successful exit status ("`0`"). It's often used as a placeholder for commands that you plan to add later or when a statement requires a command but no operation is needed. Like "`true`", it ensures that the script or condition passes, but it performs no action. For example, "`if :; then ... fi`" will always execute the commands inside the if block since "`:`" always returns success.

Each of these commands is lightweight and serves a specific purpose in structuring scripts and handling conditions. Whether used to control loops, handle conditions, or serve as placeholders, they add flexibility and clarity to your Bash scripts.

## The `true` command

The purpose of the “`true`” command is to return a successful exit status, **always**. It’s also referred to as “*Do nothing, successfully*”.

This command has no output and will always return zero (success).

The syntax of the command is as follows.

```bash
    true [ignored command line arguments]
```

One of the use cases for the "`true`" command is **Infinite Loops**. In a "`while`" loop, the condition has to be evaluated for each iteration. If you want the loop to run indefinitely (until explicitly broken), you can use "`true`" as the condition, ensuring it always returns success.

The following example script shows an infinite loop,

```bash
 1 #!/usr/bin/env bash
 2 #Script: true-0001.sh
 3 while true; do
 4     echo "This loop will run forever until it's interrupted manually with Control+C"
 5 done
```

If you run the previous script the you will see the following in your terminal window.

```txt
$ ./true-0001.sh
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever unt^C
```

In the previous execution you will see that the "`while`" loop is running forever until I stop the execution with "Control+C" (which is the "`^C`" that appears at the end).

Another use case for the "`true`" command is being a **Placeholder in Conditions**, when writing a script, sometimes you need to add conditional logic that will be developed later. You can use "`true`" as a placeholder in "`if`" statements or loops to ensure the script remains valid without breaking.

Let's see with use case with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: true-0002.sh
 3 if true; then
 4   # Placeholder for future logic
 5   echo "This IF statement will always execute"
 6 fi
```

When you execute the previous script you will the following result in your terminal window.

```txt
$ ./true-0002.sh
This IF statement will always execute
```

Another use case for the "`true`" command is **Ensuring a Command Always Returns Success**. If you're chaining multiple commands and want to ensure that a failure in one part doesn't affect the overall execution, you can use "`true`" as a fallback. You can use the "`true`" command in the following way.

```bash
    command_that_might_fail || true
```

Let's see with a real example with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: true-0003.sh
 3 rm file_that_does_not_exist
 4 echo "Result: $?"
 5 rm file_that_does_not_exist || true
 6 echo "Result: $?"
```

When you run the previous script in your terminal window you will see the following result in the screen.

```txt
$ ./true-0003.sh
rm: cannot remove 'file_that_does_not_exist': No such file or directory
Result: 1
rm: cannot remove 'file_that_does_not_exist': No such file or directory
Result: 0
```

In line 3 of the previous script we try to remove file with name "`file_that_does_not_exist`" which does not exist in the current directory (or any directory in our computer). In line 4 it's printed the result of the previous operation which is "`1`"<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>.

In line 5 we use the exact command to remove the file that does not exist but we are attaching at the end of the command `|| true` which makes the command "successful"<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a>.


## The Null command

The Null command in Bash, represented by a colon (`:`), is designed to do nothing but return a successful exit status, always producing zero. This command is useful in cases where the structure of the script expects a command, yet no action needs to be taken. The Null command is particularly handy for placeholder logic, as it ensures that required command spaces are filled without affecting the flow or exit status of the script.

The syntax of the Null command is as follows.

```bash
    : [argument ...]
```

Beyond serving as a command that simply does nothing and succeeds, the Null command ("`:`") can also be used interchangeably with the "`true`" command. To demonstrate this, we can modify a previous script ("`true-0003.sh`") by replacing "`true`" with "`:`" and observe that the script's behavior remains identical. This flexibility makes the Null command a practical substitute in cases where we require a no-op that ensures successful execution.

```bash
 1 #!/usr/bin/env bash
 2 #Script: null-0001.sh
 3 rm file_that_does_not_exist
 4 echo "Result: $?"
 5 rm file_that_does_not_exist || :
 6 echo "Result: $?"
```

When you run the previous script you will get exactly the same result as the script "`true-0003.sh`".

```txt
$ ./null-0001.sh
rm: cannot remove 'file_that_does_not_exist': No such file or directory
Result: 1
rm: cannot remove 'file_that_does_not_exist': No such file or directory
Result: 0
```

It appears that the Null and True commands perform similarly. But is there any difference between them? We’ll explore this question in the next section.

## Null command vs `true` command

In Bash, the "`:`" (Null command) and "`true`" command both serve similar roles as "do-nothing" commands that return a success status (exit code 0), but they have subtle differences in usage and functionality.
1. **Performance**: The "`:`" (Null command) is a shell built-in, meaning it's handled directly by the Bash shell and is slightly faster than "`true`", which is usually an external command or a shell built-in depending on the system. For performance-sensitive scripts, using "`:`" may be preferable since it executes with minimal overhead.
2. **Use in Scripts and Expressions**: The Null command ("`:`") is commonly used as a placeholder within conditional structures, loops, or expressions where a command is required but no action is needed. For example, in "`while :; do ...; done`", "`:`" acts as an infinite loop placeholder. The true command, on the other hand, is frequently used in scripts where its readability makes intent clearer, particularly when you want to emphasize a positive conditional outcome explicitly, such as in "`while true; do ...; done`".
3. **Compatibility**: In some shells, such as Bourne shell, "`:`" is more universally supported as a built-in, while "`true`" may not be built-in. This makes "`:`" a safer option for maximum compatibility across older or minimal shell environments.
4. **Syntax Flexibility**: Because "`:`" is a shell built-in, it has more flexibility in syntax, allowing it to work in compound commands like "`if :; then ...; fi`" without needing subshell calls. This can make scripts more efficient and concise when "`:`" is used instead of "`true`".

In general, both commands are interchangeable in basic usage, but "`:`" is generally faster and more compatible, while "`true`" may be slightly more readable for commands requiring a deliberate indication of "truth."

## The `false` command

In Bash scripting, the "`false`" command is a simple, yet essential tool that represents failure or a "false" outcome in scripts and commands. When executed, "`false`" does nothing but return an exit status of "`1`", which in Bash (and Unix-like operating systems in general) is a signal for "*failure*" or "*unsuccessful execution*". Unlike most commands that return "`0`" on success, "`false`" provides a way to explicitly create a failing condition, making it useful for scripting logic, testing, and command chaining.

The "`false`" command is typically used in control flow and conditional statements where a failure condition needs to be simulated or tested. For example, it can be used in scripts that require specific actions if a certain condition fails. You may see it in loops or conditional structures to end a script or perform error handling, especially in conjunction with logical operators.

There are some common scenario for the "`false`" command which are as follows:
1. **Infinite Loops with Break Conditions**: You might see false used as a loop condition, such as "`while false; do ...; done`", which would immediately terminate since the loop condition is always false. In testing and debugging, however, it’s common to swap "`true`" with "`false`" to test error-handling branches of a script.
2. **Logical Operations and Short-Circuiting**: The "`false`" command is often combined with other commands using "`&&`" and "`||`" operators to create logical structures. For instance, in the command "`false && echo "This won’t print" || echo "This will print"`", the second "`echo`" will execute due to the failure of "`false`".
3. **Scripting and Automation**: "`false`" is useful in automated testing scripts for checking error conditions or simulating failures. For instance, it can be used to ensure that error-handling routines are correctly triggered without needing an actual command failure.

Let's see the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: false-0001.sh
 3 if false; then
 4     echo "This line will NOT be printed"
 5 else
 6     echo "This is the line that will be printed"
 7 fi
```

With the "`false`" command you can simulate failures. Let's see it with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: false-0002.sh
 3 process_files() {
 4     echo "Starting file processing..."
 5     # Simulate a processing step
 6     echo "Processing file1.txt..."
 7     sleep 1
 8     # Simulate a failure condition
 9     false
10     # Check if the last command failed
11     if [ $? -ne 0 ]; then
12         echo "Error: Failed to process file1.txt" >&2
13         return 1
14     fi
15     echo "Processing file2.txt..."
16     sleep 1
17     echo "File processing complete."
18     return 0
19 }
20 # Error-handling routine
21 main() {
22     if ! process_files; then
23         echo "An error occurred during file processing. Triggering error handler..."
24         # Trigger cleanup, alert, or other recovery actions here
25         echo "Error handler executed."
26     else
27         echo "All files processed successfully!"
28     fi
29 }
30 # Execute main function
31 main
```

In the previous script we are creating 2 functions named "`main`" and "`process_files`". On line 31 the "`main`" function is called which will call the "`process_files`" function on line 22. After that we will simulate the failure on line 9 of the "`process_files`" function. When you execute the previous script you will have the following output in your terminal window.

```txt
$ ./false-0002.sh
Starting file processing...
Processing file1.txt...
Error: Failed to process file1.txt
An error occurred during file processing. Triggering error handler...
Error handler executed.
```

With the "`false`" command you can create infinite loops using the "`until`" loop.

```bash
 1 #!/usr/bin/env bash
 2 #Script: false-0003.sh
 3 until false; do
 4     echo "This loop will run forever until it's interrupted manually with Control+C"
 5 done
```

When you execute the previous script it will generate the same output as the script "`true-0001.sh`".

```txt
$ ./false-0003.sh
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run forever until it's interrupted manually with Control+C
This loop will run fore^C
```

## Summary

In Bash, the "`true`", "`false`", and Null ("`:`") commands each serve specific roles for handling logic flow and control within scripts, especially when performing conditional checks or simulating command success and failure. The "`true`" command is a standalone command that always exits successfully, with an exit status of "`0`". It’s frequently used in loop structures and conditional statements to create a "no-op" (no operation) placeholder that continues to yield success without any further actions. For instance, using "`true`" in a "`while`" loop allows continuous execution, which can be broken only with user intervention or other conditional logic. The Null command, denoted by a colon ("`:`"), also exits successfully and performs no action. However, being a built-in Bash command, it’s more lightweight and efficient than "`true`:. This efficiency makes Null command ideal in similar contexts, such as default variable assignments and inactive pipeline steps, where minimal resource usage is preferred.

The "`false`" command contrasts with "`true`" and Null command by consistently returning an exit status of "`1`", signaling a **failure**. This command is especially useful in testing and automation, as it allows developers to simulate errors without causing real command failures. By incorporating "`false`" in scripts, users can verify error-handling routines and ensure that failure scenarios are correctly processed. Collectively, these commands provide essential tools in Bash scripting, enabling fine-grained control over success and failure pathways, optimizing placeholder commands, and enhancing script reliability and predictability in handling a wide range of scenarios.

"*Master the small essentials, and you’ll unlock the power to tackle any scripting challenge.*"

## References

1. <https://pubs.opengroup.org/onlinepubs/009695399/utilities/colon.html>
2. <https://unix.stackexchange.com/questions/716557/when-to-use-true-in-bash>
3. <https://www.computerhope.com/unix/false.htm>
4. <https://www.computerhope.com/unix/true.htm>
5. <https://www.shell-tips.com/bash/null-command/#gsc.tab=0>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">
<p id="footnote-1" style="font-size:10pt">
1. Which means that there was an error in the execution of the previous command.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. The status "<code style="font-size:10pt">0</code>" means that the previous command was executed successfully.<a href="#footnote-2-ref">&#8617;</a>
</p>

