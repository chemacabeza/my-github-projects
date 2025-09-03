---
layout: chapter
title: "Chapter 28: Here Documents"
---

# Chapter 28: Here Documents

## Index
* [Introduction]({{ site.url }}//bash-in-depth/0028-Here-Documents.html#introduction)
* [Syntax of HereDocs]({{ site.url }}//bash-in-depth/0028-Here-Documents.html#syntax-of-heredocs)
* [Sending input to another program]({{ site.url }}//bash-in-depth/0028-Here-Documents.html#sending-input-to-another-program)
* [Using HereDocs along with the “`cat`” command to print text]({{ site.url }}//bash-in-depth/0028-Here-Documents.html#using-heredocs-along-with-the-cat-command-to-print-text)
* [Ignoring tabs]({{ site.url }}//bash-in-depth/0028-Here-Documents.html#ignoring-tabs)
* [Pipes and Redirections]({{ site.url }}//bash-in-depth/0028-Here-Documents.html#pipes-and-redirections)
* [Multiline Comments With Null Command]({{ site.url }}//bash-in-depth/0028-Here-Documents.html#multiline-comments-with-null-command)
* [Summary]({{ site.url }}//bash-in-depth/0028-Here-Documents.html#summary)
* [References]({{ site.url }}//bash-in-depth/0028-Here-Documents.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

## Introduction

A **Here Document** (commonly referred to as "*HereDoc*") is a powerful feature in Bash that allows you to embed a block of text or commands directly within a script, treating it as though it were a separate file. This feature acts as a multiline string or file literal, making it especially useful for sending input streams to commands or programs.

HereDocs are invaluable when dealing with scenarios that require multiple commands to be redirected simultaneously. They help streamline scripts, enhancing both their readability and organization. By consolidating complex input into a single, cohesive block, HereDocs make Bash scripting neater and more intuitive.

A HereDoc begins with a delimiter specified after the "`<<` operator and continues until a line containing only the delimiter (with no additional spaces or characters) is encountered. This delimiter marks the end of the HereDoc, ensuring that its content is treated as a singular unit. If multiple HereDocs are present, they are processed sequentially, starting immediately after the preceding HereDoc ends.

## Syntax of HereDocs

The syntax for a Here Document (HereDoc) in Bash is structured as follows:

```bash
    [COMMAND] [fd]<<[-] 'DELIMITER'
      Line 1
      Line 2
      ...
    DELIMITER
```

Here’s a breakdown of each element:
* "`COMMAND`": This is optional and represents any command that can accept redirected input. If omitted, the HereDoc simply provides input for redirection.
* "`fd`": Also optional, this specifies the file descriptor for redirection. If left out, it defaults to 0 (standard input).
* "`<<`": The redirection operator, which forwards the HereDoc content to the specified command.
* "`-`": An optional parameter that suppresses leading tabs in the HereDoc content.
* "`DELIMITER`" **(First Line)**: A user-defined token that marks the start and end of the HereDoc content. Common choices include "`END`", "`EOT`", or "`EOF`", but any unique word works as long as it doesn’t appear in the body. Omitting quotes, double quotes, or backslashes in this line enables command and variable expansion within the HereDoc.
* "`DELIMITER`" **(Last Line)**: This signals the end of the HereDoc and must exactly match the token used in the first line. Ensure there are no leading spaces or extra characters.

This syntax ensures a clear and structured way to handle multiline input directly within scripts.

## Sending input to another program

HereDocs are primarily used to provide input to programs that accept data through standard input. Let’s consider an example where input is passed to Python:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0001.sh
 3 read -p "Introduce the radius of the circle: " RADIUS
 4 echo "Radius: $RADIUS"
 5 python <<EOF
 6 import math
 7 radius=$RADIUS
 8 area=math.pi*(radius**2)
 9 print("Area: ", area)
10 EOF
```

In this script, the "`read`" built-in command is first used to capture user input. Once the input is provided, it is forwarded to Python as input via a HereDoc. When the script is executed, it prompts the user to enter a value:

<pre>
$ ./heredoc-0001.sh
Introduce the radius of the circle:

</pre>

The script waits for a number, which represents the radius of a circle, to calculate its area. For example, if you enter the number "`2.5`", the script processes this input and uses Python to calculate the result.

<pre>
$ ./heredoc-0001.sh
Introduce the radius of the circle: 2.5
Radius: 2.5
Area:  19.634954084936208

$
</pre>

The output displays the calculated area of the circle based on the provided radius.

This example demonstrates how HereDocs can facilitate seamless interaction between Bash and other programs, simplifying the process of feeding dynamic input into commands.

## Using HereDocs along with the “`cat`” command to print text

One of the most common uses for HereDocs is to display text, such as the help message for a program. This is often achieved by enclosing the opening delimiter in single or double quotes to prevent variable or command substitution.

Consider the following example:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0002.sh
 3 TEST="My test"
 4 cat <<"EOF"
 5 cd: cd [-L|[-P [-e]] [-@]] [dir]
 6     Change the shell working directory.
 7     Change the current directory to DIR.  The default DIR is the value of the
 8     HOME shell variable.
 9     The variable CDPATH defines the search path for the directory containing
10     DIR.  Alternative directory names in CDPATH are separated by a colon (:).
11     A null directory name is the same as the current directory.  If DIR begins
12     with a slash (/), then CDPATH is not used.
13     ...
14     Exit Status:
15     Returns 0 if the directory is changed, and if $PWD is set successfully when
16     -P is used; non-zero otherwise.
17     Some additional example:
18     Whoami: $(whoami)
19     TEST: $TEST
20 EOF
```

In this script, a portion of the help for the "`cd`" command is printed. The opening delimiter ("`EOF`") is enclosed in double quotes ("`"EOF"`"), which disables variable and command substitution. As a result, the output remains unchanged and displays the text exactly as written:

<pre>
$ ./heredoc-0002.sh
cd: cd [-L|[-P [-e]] [-@]] [dir]
    Change the shell working directory.

    Change the current directory to DIR.  The default DIR is the value of the
    HOME shell variable.

    The variable CDPATH defines the search path for the directory containing
    DIR.  Alternative directory names in CDPATH are separated by a colon (:).
    A null directory name is the same as the current directory.  If DIR begins
    with a slash (/), then CDPATH is not used.
    ...
    Exit Status:
    Returns 0 if the directory is changed, and if $PWD is set successfully when
    -P is used; non-zero otherwise.

    Some additional example:
    Whoami: $(whoami)
    TEST: $TEST

$
</pre>

The output is a literal representation of the HereDoc content. This behavior can also be achieved with other formats, such as:
* "`cat <<"EOF"`" (as used in the example)
* "`cat <<'EOF'`"
* "`cat <<\EOF`"

However, if the quotes or backslashes are omitted from the opening delimiter, variable and command substitution become active:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0003.sh
 3 TEST="My test"
 4 cat <<EOF
 5 cd: cd [-L|[-P [-e]] [-@]] [dir]
 6     Change the shell working directory.
 7     Change the current directory to DIR.  The default DIR is the value of the
 8     HOME shell variable.
 9     The variable CDPATH defines the search path for the directory containing
10     DIR.  Alternative directory names in CDPATH are separated by a colon (:).
11     A null directory name is the same as the current directory.  If DIR begins
12     with a slash (/), then CDPATH is not used.
13     ...
14     Exit Status:
15     Returns 0 if the directory is changed, and if $PWD is set successfully when
16     -P is used; non-zero otherwise.
17     Some additional example:
18     Whoami: $(whoami)
19     TEST: $TEST
20 EOF
```

In this case, the script processes the variables and commands within the HereDoc, producing a modified output:

<pre>
$ ./heredoc-0003.sh
cd: cd [-L|[-P [-e]] [-@]] [dir]
    Change the shell working directory.

    Change the current directory to DIR.  The default DIR is the value of the
    HOME shell variable.

    The variable CDPATH defines the search path for the directory containing
    DIR.  Alternative directory names in CDPATH are separated by a colon (:).
    A null directory name is the same as the current directory.  If DIR begins
    with a slash (/), then CDPATH is not used.
    ...
    Exit Status:
    Returns 0 if the directory is changed, and if <strong>/home/username/Repositories/somerepo/_bash-in-depth/chapters/0028-Here-Documents/script</strong> is set successfully when
    -P is used; non-zero otherwise.

    Some additional example:
    Whoami: <strong>username</strong>
    TEST: <strong>My test</strong>

$
</pre>

The result reflects the evaluated variables and executed commands, demonstrating how HereDocs can be tailored for both literal and dynamic content, depending on your requirements.

## Ignoring tabs

In a previous example, we used a HereDoc to send input to a "`python`" command that calculated the area of a circle. The script worked as intended, but the HereDoc was not very readable since it was aligned at the same indentation level as the surrounding command.

To improve readability, we could try indenting the HereDoc content using tabs. For instance:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0004.sh
 3 read -p "Introduce the radius of the circle: " RADIUS
 4 echo "Radius: $RADIUS"
 5 python <<EOF
 6 		import math
 7 		radius=$RADIUS
 8 		area=math.pi*(radius**2)
 9 		print("Area: ", area)
10 EOF
```

However, running this modified script leads to an error:

```txt
$ ./heredoc-0004.sh
Introduce the radius of the circle: 2.5
Radius: 2.5
  File "<stdin>", line 1
    import math
IndentationError: unexpected indent

$
```

The issue arises because Python treats leading tabs as part of the input, resulting in an "`IndentationError: unexpected indent`". This happens because HereDocs in Bash include all characters exactly as they appear, including indentation with tabs or spaces.

Fortunately, Bash provides a simple solution to this problem. By adding a dash ("`-`") immediately after the HereDoc operator ("`<<`"), you can instruct Bash to ignore leading tabs in the HereDoc content. For example:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0005.sh
 3 read -p "Introduce the radius of the circle: " RADIUS
 4 echo "Radius: $RADIUS"
 5 python <<-EOF
 6 		import math
 7 		radius=$RADIUS
 8 		area=math.pi*(radius**2)
 9 		print("Area: ", area)
10 EOF
```

With this adjustment, the script executes successfully, as the leading tabs are ignored, and the HereDoc content is passed to the Python program cleanly:

<pre>
$ ./heredoc-0005.sh
Introduce the radius of the circle: 2.5
Radius: 2.5
Area:  19.634954084936208

$ 
</pre>

This approach allows you to maintain clean and readable indentation in your script without introducing syntax issues in the HereDoc's content.

## Pipes and Redirections

As mentioned earlier, a HereDoc in Bash starts after the next newline and continues until a line containing only the specified delimiter is encountered, with no spaces or other characters in between. If another HereDoc follows, it begins immediately after the previous one ends.

This behavior gives us a powerful tool: the ability to use HereDocs in combination with pipes, allowing their content to be passed as input to subsequent commands. For example:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0006.sh
 3 cat <<EOF | base64 -d
 4 RXhhbXBsZSBvZiBsaW5lCg==
 5 EOF
```

Here, the first command consists of "`cat`" reading the HereDoc and passing its output to "`base64`", which then decodes the provided base64 string. When the script runs, it produces the following output:

<pre>
$ ./heredoc-0006.sh
Example of line

$
</pre>

The previous example would be the equivalent of the following code:

<pre>
$ echo "RXhhbXBsZSBvZiBsaW5lCg==" | base64 -d
Example of line

$
</pre>

This approach achieves the same result as writing the content manually into a base64 command, but in a cleaner, more efficient way. Similarly, we can use this technique to rewrite earlier examples, such as sending commands to Python, by piping a HereDoc into the Python interpreter.

In addition to working with pipes, HereDocs can also be used with input and output redirections. For instance:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0007.sh
 3 { 
 4   cat; 
 5   echo ---; 
 6   cat <&3 
 7 } <<EOF 3<<EOF2
 8 hi
 9 EOF
10 there
11 EOF2
```

In this script:

1. The first "`cat`" reads from the standard input (file descriptor 0) and prints it to the standard output.
2. The "`echo`" command prints a line separator.
3. The second "`cat`" reads from file descriptor 3 and prints its content.

The script includes two HereDocs:
* The first HereDoc starts after "`<<EOF`" and contains a single line of text (“`hi`”).
* The second HereDoc begins after "`<<EOF2`" and ends at a line containing only "`EOF2`".

If we accidentally add a space after the delimiter "`EOF`", as shown below:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0008.sh
 3 {
 4   cat;
 5   echo ---;
 6   cat <&3
 7 } <<EOF 3<<EOF2
 8 hi
 9 EOF
10 there
11 EOF2
```

Bash will fail to identify the end of the HereDoc because the delimiter "`EOF`" with an extra space ("`EOF `") does not match the expected format. As a result, Bash will continue reading until the end of the file and throw an error:

<pre>
$ ./heredoc-0008.sh
./heredoc-0008.sh: line 11: warning: here-document at line 7 delimited by end-of-file (wanted `EOF')
./heredoc-0008.sh: line 11: warning: here-document at line 11 delimited by end-of-file (wanted `EOF2')
hi
EOF
there
EOF2
---

$
</pre>

This demonstrates the importance of ensuring that the ending delimiter is written exactly as specified, without any leading or trailing spaces.

Finally, HereDocs can also be used to write to or append content to files using standard I/O redirection operators ("`>`" or "`>>`"). For example:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0009.sh
 3 cat <<EOF >/tmp/testfile.txt
 4 First line
 5 Second line
 6 Third line
 7 EOF
```

When the script is executed, it creates a file and writes the content from the HereDoc into it. Checking the file reveals the following output:

<pre>
$ ./heredoc-0009.sh

$ cat /tmp/testfile.txt
First line
Second line
Third line

$
</pre>

This flexibility—using HereDocs with pipes, redirections, and as input streams—makes them a versatile tool for scripting, enabling clean and readable handling of multiline text and complex command workflows.

## Multiline Comments With Null Command

In a previous chapter, we discussed the Null command—a simple command in Bash that performs no action and has no effect. Interestingly, this command can be utilized to simulate multiline comments in Bash scripts.

As a reminder, comments in Bash are created by prefixing each line with the "`#`" character. To write a comment that spans multiple lines, you would typically need to add a "`#`" at the beginning of each line.

However, there is a more innovative way to create multiline comments by combining the Null command with HereDocs. Let’s explore an example:

```bash
 1 #!/usr/bin/env bash
 2 #Script: heredoc-0010.sh
 3 : <<COMMENT
 4 This is a comment for a piece
 5 of code that seems to be very complex
 6 blah blah blah
 7 COMMENT
 8 echo "Script with HereDoc comment"
```

## Summary

Here Documents (HereDocs) are a powerful feature in Bash scripting that allow you to create multiline input streams or file literals. They act as a temporary section of text or code that can be treated as input for commands, scripts, or programs. By redirecting large blocks of text, HereDocs make it easier to handle commands that require extensive input, improving the readability and organization of Bash scripts. A HereDoc starts with the "`<<`" operator followed by a delimiter and ends when the delimiter appears on a line by itself. This mechanism is particularly useful for simplifying workflows and consolidating complex input into a single, manageable structure.

One of the most common applications of HereDocs is sending input to commands or programs that accept standard input. For instance, you can use HereDocs to pass multiline input to an interpreter like Python or to create custom help messages for scripts. By combining HereDocs with commands like "`cat`", you can redirect or pipe input for processing by other tools, such as "`base64`" for encoding and decoding. HereDocs also support redirection to files, allowing users to write or append content efficiently. Adding a "`-`" after the "`<<`" operator enables the suppression of leading tabs, ensuring proper formatting when indentation is used for readability.

Another innovative use of HereDocs involves their integration with the Null command ("`:`"), which allows you to simulate multiline comments in Bash. By treating the HereDoc block as input to the Null command, you can document your scripts in a clean and readable format without affecting execution. This approach is especially useful for creating large blocks of descriptive text or notes within scripts.

While HereDocs are versatile, they have some strict requirements. The delimiter that defines the end of the HereDoc must appear exactly as specified, with no leading or trailing spaces. Failing to meet this condition will result in errors or unexpected behavior. Overall, HereDocs provide a flexible and elegant way to handle multiline input and improve script maintainability, making them an essential tool in Bash scripting.

*"Every powerful script begins with mastering the tools, and Here Documents are one of the best."*

## References

1. <https://linuxhint.com/bash-heredoc-tutorial/>
2. <https://linuxize.com/post/bash-heredoc/>
3. <https://phoenixnap.com/kb/bash-heredoc>
4. <https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_07_04>
5. <https://tldp.org/LDP/abs/html/here-docs.html>
6. <https://unix.stackexchange.com/questions/88490/how-do-you-use-output-redirection-in-combination-with-here-documents-and-cat>
7. <https://www.howtogeek.com/719058/how-to-use-here-documents-in-bash-on-linux/>
8. <https://www.tecmint.com/use-heredoc-in-shell-scripting/>


<!--hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px" -->
