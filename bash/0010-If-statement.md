# Chapter 10: if / elif / else statements

In Bash, the “`if`”, “`elif`”, and “`else`” statements are fundamental constructs used for conditional execution of commands. These statements provide the means to make decisions within a script or in the command-line environment, enabling you to create dynamic and responsive scripts that respond to specific conditions.

In the next sections we will speak about the three statements.

## The "`if`" Statement

The “`if`” statement is the cornerstone of conditional execution in Bash. It allows you to specify a condition or test that evaluates to either true (success) or false (failure). If the condition is true, the code within the “`if`” block is executed. If it's false, the code is skipped. The syntax of an “`if`” statement typically looks like follows.

```bash
    if [ CONDITION ]; then
        COMMANDS;
    fi
```

For example, you can use an “`if`” statement to check if a file exists before attempting to read or manipulate it. If the condition inside the square brackets is satisfied (e.g., the file exists), the code within the “`if`” block is executed.


## The "`elif`" Statement

The “`elif`” (short for "*else if*") statement is used when you have multiple conditions to check in a sequence. It follows an “`if`” statement and is evaluated only if the preceding “`if`” or “`elif`” conditions are false. If an “`elif`” condition is true, the corresponding code block is executed. The syntax of an “`elif`” statement typically looks like follows.

```bash
    if [ CONDITION ]; then
        COMMANDS;
    elif [ CONDITION2 ]; then # elif can be repeated
        COMMANDS2;
    fi
```

If the evaluation of “`CONDITION`” results in “`true`” then “`COMMANDS`” will be executed. If not, then the next condition (“`CONDITION2`”) will be evaluated and depending on the result of its evaluation “`COMMANDS2`” will be executed or not.

For instance, you might use “`elif`” to check various file types within a directory. If the first condition doesn't match (e.g., it's not a text file), the script checks the next condition (e.g., an image file).

## The "`else`" Statement

The “`else`” statement is used in conjunction with the “`if`” statement to specify a block of code that should execute when none of the preceding conditions (in the “`if`” or “`elif`” statements) are met. It provides a default or fallback action when all previous conditions are false. The syntax of an “else” statement typically looks like the following.

```bash
    if [ CONDITION ]; then
        COMMANDS;
    else
        COMMANDS2;
    fi
```

In a real-world example, if you're checking for the existence of a file and none of the preceding conditions match (the file doesn't exist), you can use “`else`” to execute an alternative action, such as creating the file.

In the case of having multiple conditions in an “`if`/`elif`/`else`” statement that evaluates to “`true`” Bash will execute that first one it finds. So yes, **the order of the different conditions matters**.

Also bear in mind that you can have multiple “`elif`” branches as we already mentioned previously.

## How to test stuff?

In Bash there are 4 ways to test for conditions. In the following subsections we will take a look at:
* “`test`” operator
* “`[...]`” operator
* “`[[...]]`” operator
* “`((...))`” operator

In the next sub-sections we will explore each one of them. Let’s start!

### “test” operator

The “`test`” operator is used to evaluate conditional expressions. It’s not a built-in command of Bash. It’s in fact a separate binary<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>.

The “`test`” operator comes with a set of flags/operators that allow you to test for different conditions. The following table contains some of the different operators you can use with “`test`”. For an exhaustive list of options, please consult the manual of the test operator<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a>.

The following table contains an exhaustive list of operators that you can use with “`test`” and their descriptions.

| Operator | Description |
| :-----: | :----- |
| `-b FILE` | `FILE` exists and is a block special |
| `-c FILE` | `FILE` exists and is a character special |
| `-d FILE` | True if `FILE` is a directory |
| `-e FILE` | True if `FILE` exists |
| `-f FILE` | `FILE` exists and is a regular file|
| `FILE1 -ef FILE2` | `FILE1` and `FILE2` have the same device and inode numbers|
| `FILE1 -nt FILE2` | `FILE1` has a more recent modification date than `FILE2` |
| `FILE1 -ot FILE2` | `FILE1` is older than `FILE2` |
| `-z STRING` | True if string is empty |
| `-n STRING` | True if string is **NOT** empty |
| `STRING1 = STRING2` | True if the strings are equal |
| `STRING1 != STRING2` | True if the strings are not equal |
| `STRING1 < STRING2` | True if `STRING1` sorts before `STRING2` lexicographically |
| `STRING1 > STRING2` | True if `STRING1` sorts after `STRING2` lexicographically |
| `-v VAR` | True if the shell variable `VAR` is set |
| `( EXPR )` | The parentheses are used to group expressions |
| `! EXPR` | True if the result of the evaluation of `EXPR` is false |
| `EXPR1 -a EXPR2` | True if both `EXPR1` and `EXPR2` are true |
| `EXPR1 -o EXPR2` | True if either `EXPR1` or `EXPR2` is true |
| `ARG1 OP ARG2` | Arithmetic tests.  OP is one of `-eq`, `-ne`, `-lt`, `-le`, `-gt`, or `-ge`. <br>Arithmetic binary operators return true if `ARG1` is equal, not-equal, less-than, less-than-or-equal, greater-than, or greater-than-or-equal than `ARG2` |

You might be wondering what are the different arguments for the operators we provided in the previous table. They are:
* `FILE`:  The absolute or relative path of a file or a variable that references it. For example: “`/etc/profile`”.
* `STRING`: A sequence of characters or a variable with a sequence of characters. (For example: “`Hello world`”, the quotes are included).
* `VAR`: The name of a variable. (For example: “`PATH`”)
* `EXPR`: An “*expression*”. This could be a combination of other operators. (For example: `"TEST" = "TEST" -a "TEST1" != "TEST2"`)
* `INT`: An integer number. (For example: 3)

In the following examples script we are going to use a few of these operators.

```bash
#!/usr/bin/env bash
#Script: if_statement.sh
# Declaring some variables
FILE_PATH="/etc/profile"
NUMBER_1=3
NUMBER_2=4
EMPTY=
# Test if the file exists
if test -e $FILE_PATH; then
    echo "'$FILE_PATH' does exist"
fi
# Test if the variable is empty
if test -z $EMPTY; then
    echo "The variable EMPTY has nothing"
fi
# Test if the variables are different
if test $FILE_PATH != "different"; then
    echo "The values of the strings are different"
fi
# Test to compare numbers
if test 3 -lt 7; then
    echo "3 is less than 7"
fi
# Combined test
if test $NUMBER_1 -lt $NUMBER_2 -a $FILE_PATH != "boo"; then
    echo "Condition is true"
fi
```

When you execute the previous script you will get something like the following in your terminal.

```txt
$ ./if_statement.sh
'/etc/profile' does exist
The variable EMPTY has nothing
The values of the strings are different
3 is less than 7
Condition is true
```

The “`test`” command has a synonym that is the “`[`“ operator, which is the one we will explore next.

### The “`[...]`” operator (Square Brackets)

Similar to the “`test`” command, the “`[`“ command is a separate binary (located as well in the “`/usr/bin`” folder).

The “`[`“ command is equivalent to the “`test`” command. This means that we can use the exact same flags and operators. The only difference with respect to the “`test`” command is that the last argument should be “`]`” in order to match the opening bracket.

In the next example we rewrote the script we had in the previous subsection but using the “`[`“ command.

```bash
#!/usr/bin/env bash
#Script: if_statement_with_square_bracket.sh
# Declaring some variables
FILE_PATH="/etc/profile"
NUMBER_1=3
NUMBER_2=4
EMPTY=
# Test if the file exists
if [ -e $FILE_PATH ]; then
    echo "'$FILE_PATH' does exist"
fi
# Test if the variable is empty
if [ -z $EMPTY ]; then
    echo "The variable EMPTY has nothing"
fi
# Test if the variables are different
if [ $FILE_PATH != "different" ]; then
    echo "The values of the strings are different"
fi
# Test to compare numbers
if [ 3 -lt 7 ]; then
    echo "3 is less than 7"
fi
# Combined test
if [ $NUMBER_1 -lt $NUMBER_2 -a $FILE_PATH != "boo" ]; then
    echo "Condition is true"
fi
```

When you execute the previous script you will see that it generates the same result as “`if_statement.sh`”.

```txt
$ ./if_statement_with_square_bracket.sh
'/etc/profile' does exist
The variable EMPTY has nothing
The values of the strings are different
3 is less than 7
Condition is true
```

“`test`” and “`[...]`”  commands are preferred to be used to generate a more portable code.

### The “`[[...]]`” operator (Double Square Brackets)

The “`[[...]]`” operator is a Bash extension inspired by another shell.<a id="footnote-3-ref" href="#footnote-3" style="font-size:x-small">[3]</a> This operator is a new, improved version of the previous “`test`” and “`[...]`”. On top of that is a built-in command instead of a separate binary.

The following table will give you a high-level overview of the differences between “`[[...]]`” and “`test`” (or “`[...]`”).

<table>
  <thead>
    <tr>
      <th style="text-align: center">Feature</th>
      <th style="text-align: center">[[…]]</th>
      <th style="text-align: center">[…]</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: center" rowspan="4">String comparison</td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">&gt;</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">\&gt;</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">&lt;</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">\&lt;</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">=</code> (or <code class="language-plaintext highlighter-rouge">==</code>)</td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">=</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">!=</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">!=</code></td>
    </tr>
    <tr>
      <td style="text-align: center" rowspan="6">Integer comparison</td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-gt</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-gt</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-lt</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-lt</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-ge</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-ge</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-le</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-le</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-eq</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-eq</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-ne</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-ne</code></td>
    </tr>
    <tr>
      <td style="text-align: center" rowspan="2">Conditional evaluation</td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">&amp;&amp;</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-a</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">||</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">-o</code></td>
    </tr>
    <tr>
      <td style="text-align: center">Expression grouping</td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">(...)</code></td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">\(...\)</code></td>
    </tr>
    <tr>
      <td style="text-align: center">Pattern Matching</td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">=</code> (or <code class="language-plaintext highlighter-rouge">==</code>)</td>
      <td style="text-align: center"><em>(not available)</em></td>
    </tr>
    <tr>
      <td style="text-align: center">Regular Expression Matching</td>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">=~</code></td>
      <td style="text-align: center"><em>(not available)</em></td>
    </tr>
  </tbody>
</table>

Let’s see how the script we used in the last two sections would look like using the “`[[...]]`” operator.

```bash
#!/usr/bin/env bash
#Script: if_statement_with_double_square_bracket.sh
# Declaring some variables
FILE_PATH="/etc/profile"
NUMBER_1=3
NUMBER_2=4
EMPTY=
# Test if the file exists
if [[ -e $FILE_PATH ]]; then
    echo "'$FILE_PATH' does exist"
fi
# Test if the variable is empty
if [[ -z $EMPTY ]]; then
    echo "The variable EMPTY has nothing"
fi
# Test if the variables are different
if [[ $FILE_PATH != "different" ]]; then
    echo "The values of the strings are different"
fi
# Test to compare numbers
if [[ 3 -lt 7 ]]; then
    echo "3 is less than 7"
fi
# Combined test
if [[ $NUMBER_1 -lt $NUMBER_2 && $FILE_PATH != "boo" ]]; then
    echo "Condition is true"
fi
```

Notice that the main changes we did in the script were replacing “`[...]`” with “`[[...]]`” and replacing the “`-a`” operator with “`&&`”. When you execute the previous script you get the same result as in the two previous sections.

```txt
$ ./if_statement_with_double_square_bracket.sh
'/etc/profile' does exist
The variable EMPTY has nothing
The values of the strings are different
3 is less than 7
Condition is true
```

### Compound command “`((...))`”

In a previous chapter we talked about the compound command “`((...))`”. In that chapter we used the command to declare integer variables and to modify the values of **integer variables**.

We also mentioned in that chapter that the “`((...))`” *is an actual command after all, meaning that it has a result, an exit status, that we can use*.

The “`((...))`” command creates an environment where you can do assignments, arithmetic operations or even several operations in the same environment (between the double parenthesis). The result of the command will be determined by the last expression that will be evaluated inside the environment.

This means that we can use the result of the “`((...))`” command in conditions of the “`if`/`elif`” statements (and as we will see later, in loops as well).

In the following script we see a few examples with the “`((...))`” command.

```bash
#!/usr/bin/env bash
#Script: if_statement_double_parentheses.sh
# Declaring some variables
FILE_PATH="/etc/profile"
NUMBER_1=3
NUMBER_2=4
# Combined test
if (( $NUMBER_1 < $NUMBER_2 )) && [[ $FILE_PATH != "boo" ]]; then
    echo "Condition is true"
fi
# Test less than
if (( 3 < 7 )); then
    echo "3 is less than 7"
fi
# Test less than or equal
if (( 7 <= 7 )); then
    echo "7 is less than or equal to 7"
fi
# Test equality
if (( 7 == 7 )); then
    echo "7 is equal to 7"
fi
# Test inequality
if (( a = 3, 8 != 7 && 7 < 10 )); then
    echo "8 is not equal to 7 and 7 is less than 10"
fi
# Remove a file that does not exist
rm /tmp/does_not_exist
echo "Result: $?"
(( b = 4 ))
echo "Result: $?"
```

In the last script you can see several uses of the compound command “`((...))`” by itself (lines 12, 16, 20 and 30), in combination with another operator (line 9) and using several expressions in the same environment (line 29).

If you pay attention to line 24, you will see that there are two expressions between the parenthesis. The first one is assigning the value “`3`” to the variable “`a`”. The second expression is evaluating a boolean condition whose result is true. This value of true will be used in the “`if`” statement as a condition. As the condition is true the message in line 25 will be printed.

The last four lines (28 to 31) are showing the result code of two commands. First we try to remove a file that does not exist and, obviously, this command will fail (generating an exit status of “`1`”). Second we use an assignment with the “`((...))`” command which is successful, having an exit status of “`0`”.

When run the script you will get the following output in your terminal.

```txt
$ ./if_statement_double_parentheses.sh
Condition is true
3 is less than 7
7 is less than or equal to 7
7 is equal to 7
8 is not equal to 7 and 7 is less than 10
rm: cannot remove '/tmp/does_not_exist': No such file or directory
Result: 1
Result: 0
```

## Summary

In this chapter we learnt how to use the “`if`” statement and its different variations (“`if`”, “`if-else`”, “`if-elif`”, “`if-elif-else`”).

We also learnt the different ways to test for conditions that will be evaluated in “`if`” or “`elif`”.

First we learnt about the “`test`” and “`[...]`” operators which are basically doing the same thing.

Then we learnt about the “`[[...]]`” operator which is an improved version of the previous two operators.

Finally we learnt about the compound command “`((...))`” that we use to evaluate numerical operations.

We learnt a lot in this chapter, so take your time to go over this material again if there is something that you didn’t fully get.

Remember, *practice makes perfect*. So? Practice, practice practice.

## References

1. <https://linuxhint.com/bash-test-command/>
2. <https://linuxhint.com/bash_if_else_examples/>
3. <https://linuxize.com/post/bash-if-else-statement/>
4. <https://stackoverflow.com/questions/2188199/how-to-use-double-or-single-brackets-parentheses-curly-braces>
5. <https://stackoverflow.com/questions/31255699/double-parenthesis-with-and-without-dollar>
6. <https://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-6.html>
7. <https://tldp.org/LDP/abs/html/dblparens.html>
8. <https://unix.stackexchange.com/questions/306111/what-is-the-difference-between-the-bash-operators-vs-vs-vs>
9. <https://www.baeldung.com/linux/bash-single-vs-double-brackets>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

<p id="footnote-1" style="font-size:10pt">
1. Located usually in the “/usr/bin” folder.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. Type in your terminal “man test” to know more.<a href="#footnote-2-ref">&#8617;</a>
</p>
<p id="footnote-X" style="font-size:10pt">
3. The Korn shell. Check <a href="https://en.wikipedia.org/wiki/KornShell">KornShell</a> for more information.<a href="#footnote-X-ref">&#8617;</a>
</p>

