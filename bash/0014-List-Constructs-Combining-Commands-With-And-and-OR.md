---
layout: chapter
title: "Chapter 14: List constructs - Combining commands with && and ||"
---

# Chapter 14: List constructs - Combining commands with `&&` and `||`

## Index
* [Operator && (Double Ampersand)]({{ site.url }}//bash-in-depth/0014-List-Constructs-Combining-Commands-With-And-and-OR.html#operator--double-ampersand)
* [Operator `||` (Double Vertical Bar)]({{ site.url }}//bash-in-depth/0014-List-Constructs-Combining-Commands-With-And-and-OR.html#operator--double-vertical-bar)
* [Combining operators “`&&`” and “`||`” with commands]({{ site.url }}//bash-in-depth/0014-List-Constructs-Combining-Commands-With-And-and-OR.html#combining-operators--and--with-commands)
* [Summary]({{ site.url }}//bash-in-depth/0014-List-Constructs-Combining-Commands-With-And-and-OR.html#summary)
* [References]({{ site.url }}//bash-in-depth/0014-List-Constructs-Combining-Commands-With-And-and-OR.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

Up until now we have been executing commands one at a time. Did you know that you can combine them using the “`&&`” and “`||`” operators?

Let’s see how to use them, shall we?

## Operator && (Double Ampersand)

In the same way that we used the “`&&`” operand to check for conditions that should be true at both sides of the operand before executing the instructions inside an IF clause, this operand can be used to execute two or more commands that must succeed in order to consider the combination of commands successful.

The syntax of this operand is as follows.

```bash
    command1 && command2
```

And the way success is calculated is as follows.

| Command1 | Command2 | Is it Successful? |
| :-----: | :-----: | :-----: |
| Succeeds | Succeeds | YES |
| Succeeds | Fails | NO |
| Fails | Succeeds | NO |
| Fails | Fails | NO |

To illustrate the previous table we are going to write the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: double-ampersand-cases.sh
 3 # Succeeds and Succeeds
 4 echo -n "case 1" && echo " succeeds"
 5 echo "Result case 1: $?"
 6 # Succeeds and Fails
 7 echo "case 2" && rm does_not_exist
 8 echo "Result case 2: $?"
 9 # Fails and Succeeds
10 rm does_not_exist && echo "case 3, not executed"
11 echo "Result case 3: $?"
12 # Fails and Fails
13 rm does_not_exist && rm another_file_that_does_not_exist
14 echo "Result case 4: $?"
15 # End
16 echo "End of program"
```

When the previous script is executed the following output will appear in the terminal window.

```txt
$ ./double-ampersand-cases.sh
case 1 succeeds
Result case 1: 0
case 2
rm: cannot remove 'does_not_exist': No such file or directory
Result case 2: 1
rm: cannot remove 'does_not_exist': No such file or directory
Result case 3: 1
rm: cannot remove 'does_not_exist': No such file or directory
Result case 4: 1
End of program
```

As you can see from the execution of the script, the result of the execution of the commands succeeds only in the first execution (status is zero), while on the other three it fails (status is one).

In this example we were using only two commands but that does not mean that the operator “`&&`” is restricted to just two commands. We could add as many commands as we wanted in the following way

```bash
    command1 && command2 && command3 && ...
```

Executing commands like this will succeed only when all commands in the list of commands to be executed succeed. If only one command fails, the whole execution will be considered as failed and will have a status code of one (failure).

## Operator `||` (Double Vertical Bar)

In the same way that we used the “`||`” operand to check for conditions that should be true at **either** side of the operand before executing the instructions inside an IF clause, this operand can be used to execute commands, sequentially, until one succeeds. At the moment that a command succeeds, Bash will consider the execution successful (status code will be zero) and will stop the execution of further commands.

The syntax of this operand is.

```bash
    command1 || command2
```

And the way success is calculated is as follows.

| Command1 | Command2 | Is it Successful? |
| :-----: | :-----: | :-----: |
| Succeeds | Succeeds | YES |
| Succeeds | Fails | YES |
| Fails | Succeeds | YES |
| Fails | Fails | NO |

In a similar way as we did with the operator “`&&`”, we are going to write a small script to illustrate the previous table.

```bash
 1 #!/usr/bin/env bash
 2 #Script: double-vertical-bar-cases.sh
 3 # Succeeds and Succeeds
 4 echo -n "case 1" || echo " succeeds"
 5 echo "Result case 1: $?"
 6 # Succeeds and Fails
 7 echo "case 2" || rm does_not_exist
 8 echo "Result case 2: $?"
 9 # Fails and Succeeds
10 rm does_not_exist || echo "case 3, not executed"
11 echo "Result case 3: $?"
12 # Fails and Fails
13 rm does_not_exist || rm another_file_that_does_not_exist
14 echo "Result case 4: $?"
15 # End
16 echo "End of program"
```

When the previous script is run, you will see the following in the terminal window.

```txt
$ ./double-vertical-bar-cases.sh
case 1Result case 1: 0
case 2
Result case 2: 0
rm: cannot remove 'does_not_exist': No such file or directory
case 3, not executed
Result case 3: 0
rm: cannot remove 'does_not_exist': No such file or directory
rm: cannot remove 'another_file_that_does_not_exist': No such file or directory
Result case 4: 1
End of program
```

As you can see from the execution of the script, the result of the execution of the commands succeeds in the first three executions (status is zero), while on the last one it fails (status is one).

In this example we were using only two commands but that does not mean that the operator “`||`” is restricted to just two commands. We could add as many commands as we wanted in the following way.

```bash
    command1 || command2 || command3 || ...
```

Executing commands like this will succeed only when at least one of the commands succeeds. When a command succeeds, it will stop executing the rest of the commands.

For example, let’s say we execute the following.

```bash
$ command1 || command2 || command3 || command4
```

In this case Bash will execute the command “`command1`”.

If “`command1`” succeeds the result of the execution will be success and will stop executing the rest of the commands (“`command2`”, “`command3`” and “`command4`”). If “`command1`” fails, Bash will move to execute “`command2`”.

If “`command2`” succeeds the result of the execution will be success and will stop executing the rest of the commands (“`command3`” and “`command4`”). If “`command2`” fails, Bash will move to execute “`command3`”.

If “`command3`” succeeds the result of the execution will be success and will stop executing the rest of the commands (“`command4`”). If “`command3`” fails, Bash will move to execute “`command4`”.

If “`command4`” succeeds the result of the execution of the whole command will be success. If “`command4`” fails, Bash will set the execution of the whole combination of commands as failure.

## Combining operators “`&&`” and “`||`” with commands

The operators “&&” and “||” can be used together in the same command. The only thing to bear in mind when using the operators in combination is **their precedence**.

Just to make it very clear, **the operator “`&&`” will always be evaluated before operator “`||`”**.

We are going to write a simple Bash script to play with both operators.

```bash
 1 #!/usr/bin/env bash
 2 #Script: test-or-and.sh
 3 #       EXECUTED                  NOT EXECUTED                  EXECUTED
 4 # vvvvvvvvvvvvvvvvvvv      vvvvvvvvvvvvvvvvvvvvvvvv    vvvvvvvvvvvvvvvvvvvvvvvvv
 5 echo -n "Is executed, " || echo "It's not executed" && echo "It's also executed"
 6 echo "Result: $?"
 7 echo "End of program"
```

When the previous script is executed the following will appear in the terminal window.

```txt
$ ./test-or-and.sh
Is executed, It's also executed
Result: 0
End of program
```

Bash detects that there are two operands linking three commands. The first operator is “`||`” while the second operator is “`&&`”. As the operator “`&&`” **has higher preference than** “`||`”, the three commands will be divided into two groups.

The first group of commands is composed of the first two “`echo`” commands. The second group is composed of the last “`echo`” command.

Once Bash has identified the two groups (one at each side of the “`&&`” operator) it will execute first the one on the left. As the one of the left is composed by two commands linked by the operator “`||`” Bash will execute first the one on the left.

As the execution of the command at the left of the “`||`” operator is successful, the command at the right of the operator will not be executed.

As the first group of commands resulted in a successful execution, Bash will go to execute the command at the right of the “`&&`” operator. As this command also results in success the whole execution of the whole command has a status code of zero (success).

## Summary

In this chapter we learnt:
* How to combine commands into a single one with the “`&&`” operator. To have a successful execution of the new resulting command, all the commands chained by the operator “`&&`” must be successful. If only one of the commands fails, the whole set of commands will be considered as failed.
* With the operator “`&&`” commands are executed from left to right. Bash will stop executing commands from left to right when a command fails.
* How to combine commands into a single one with the “`||`” operator. To have a successful execution of the new resulting command, at least one of the chained commands must be successful. If all the commands fail, the execution of the whole command will be considered failed.
* With the operator “`||`” commands are executed from left to right. If a command fails, Bash will go to the next command chained. Bash will stop executing commands from left to right when a command succeeds.
* How to combine both “`&&`” and “`||`” operators.
* That operator “`||`” has lower priority than the operator “`&&`” and will be evaluated after.

## References

1. <https://linuxhint.com/bash-logical-and-operator>
2. <https://unix.stackexchange.com/questions/24684/confusing-use-of-and-operators/24685#24685>
3. <https://www.gnu.org/software/bash/manual/bash.html>
4. <https://www.linuxtopia.org/online_books/advanced_bash_scripting_guide/ops.html>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

