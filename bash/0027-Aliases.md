---
layout: chapter
title: "Chapter 27: Aliases"
---

# Chapter 27: Aliases

## Index
* [Introduction]({{ site.url }}//bash-in-depth/0027-Aliases.html#introduction)
* [What is an alias?]({{ site.url }}//bash-in-depth/0027-Aliases.html#what-is-an-alias)
* [How to create an alias?]({{ site.url }}//bash-in-depth/0027-Aliases.html#how-to-create-an-alias)
* [How to create an alias that accepts arguments?]({{ site.url }}//bash-in-depth/0027-Aliases.html#how-to-create-an-alias-that-accepts-arguments)
* [Reusing aliases]({{ site.url }}//bash-in-depth/0027-Aliases.html#reusing-aliases)
* [How to get the current aliases?]({{ site.url }}//bash-in-depth/0027-Aliases.html#how-to-get-the-current-aliases)
* [How to remove aliases?]({{ site.url }}//bash-in-depth/0027-Aliases.html#how-to-remove-aliases)
* [Summary]({{ site.url }}//bash-in-depth/0027-Aliases.html#summary)
* [References]({{ site.url }}//bash-in-depth/0027-Aliases.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

## Introduction

Aliases in Bash are shortcuts that allow you to define custom command substitutions or abbreviations for frequently used commands. They simplify and speed up your workflow by reducing the need to type lengthy or complex commands repeatedly. An alias essentially maps a user-defined name to a specific command or sequence of commands, making it an invaluable tool for enhancing efficiency and productivity in the command line.

One of the most common use cases for aliases is to replace frequently used commands with shorter alternatives. For example, instead of typing "`ls -la`" every time, you can create an alias like ll to achieve the same result with minimal effort. Aliases can also include options and arguments, allowing you to tailor commands to your specific needs or preferences. This customization empowers users to create a more streamlined and personalized shell environment.

It’s important to note that aliases are typically session-specific, meaning they exist only for the duration of the current terminal session. However, they can be made permanent by adding them to your shell’s configuration files, such as "`~/.bashrc`" or "`~/.bash_profile`". By leveraging aliases effectively, you can significantly reduce repetitive typing, minimize errors, and make your Bash experience more efficient and enjoyable.

## What is an alias?

An alias in Bash acts as a convenient shortcut for commands, allowing you to assign a short, memorable name to a potentially lengthy sequence of commands, with or without arguments. Aliases are designed to streamline your workflow, making it faster and easier to provide instructions to the shell.

Imagine you frequently need to list the contents of the current directory, sorted by modification time, with human-readable file sizes and color-coded output. While you can achieve this with the following command: "`ls -l -t -h --color`", typing it repeatedly can become tedious over time.

Instead of manually re-entering the command every time, you can create an alias to simplify the process and improve your efficiency. With a single alias, you can transform this verbose command into a quick, easy-to-remember shortcut. Let’s explore how to set one up!

## How to create an alias?

In order to create an alias you need to use the “`alias`” built-in command with the following syntax:

<div style="text-align:center">
    <img src="/assets/bash-in-depth/0027-Aliases/Alias-syntax.png"/>
</div>

Once you execute this command you can start using the “`shortcut`” command as if it was the “`long command to execute`”.

Let’s practice what we’ve just learned with an example!

To start, we’ll add the following line to the "`.bash_aliases`" file located in your home directory:

```bash
# Alias for a complex ls command
alias llc="ls -l -t -h --color"
```

Next, let’s create a script that attempts to use this alias:

```bash
 1 #!/usr/bin/env bash
 2 #Script: aliases-0001.sh
 3 echo -e "Calling new alias\n"
 4 llc
 5 echo -e "\nDone calling new alias"
```

When we run the script, we encounter the following output:

```txt
$ ./aliases-0001.sh
Calling new alias

./aliases-0001.sh: line 4: llc: command not found

Done calling new alias

$
```

The script fails to recognize the alias. Why? By default, Bash aliases are **not expanded in scripts**. But why is this the case?

This behavior stems from how the "`.bashrc`" configuration file works. Within "`.bashrc`", there’s typically a block of code like this:

```bash
...
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
...
```

This code checks whether the "`.bash_aliases`" file exists in your home directory. If it does, the aliases within it are loaded into your **interactive shell session**. However, this setup is only applied to interactive Bash instances, such as when you open a terminal, because "`.bashrc`" checks if the environment variable "`$-`"<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a> contains the interactive flag. For non-interactive sessions, like running scripts, aliases defined in "`.bash_aliases`" are not automatically loaded.

To make aliases usable in scripts, you need to explicitly enable their expansion. One way to achieve this is by sourcing the "`.bash_aliases`" file within the script and enabling a special shell option. Here’s how that can be done:

```bash
 1 #!/usr/bin/env bash
 2 #Script: aliases-0002.sh
 3 # Enable alias expansion
 4 shopt -s expand_aliases
 5 # Source the aliases
 6 source ~/.bash_aliases
 7 echo -e "Calling new alias\n"
 8 llc
 9 echo -e "\nDone calling new alias"
```

When you run the previous script you will have the following (or a similar one) output in your terminal window.

<pre>
$ ./aliases-0002.sh
Calling new alias

total 8.0K
-rwxrwxr-x 1 username username 207 Dec 12 05:38 <strong style="color: green;">aliases-0002.sh</strong>
-rwxrwxr-x 1 username username 114 Dec 12 05:31 <strong style="color: green;">aliases-0001.sh</strong>

Done calling new alias
$ 
</pre>

The second method for making aliases available in your scripts is to transform the script into an interactive Bash script. This can be accomplished by adding the "`-i`" flag (short for "interactive") to the script's shebang. Modifying the very first line of your script achieves this, as illustrated below:

```txt
#!/usr/bin/env -S bash -i
               ^^^    ^^^^
OR

#!/usr/bin/bash -i
                ^^^
```

By including the "`-i`" flag in the shebang, the script runs in interactive mode. This ensures that when the "`.bashrc`" file is sourced, it recognizes the interactive flag and loads the "`.bash_aliases`" file, provided it exists.

To clarify, let's look at an example:

```bash
 1 #!/usr/bin/bash -i
 2 #Script: aliases-0003.sh
 3 echo -e "Calling new alias\n"
 4 llc
 5 echo -e "\nDone calling new alias"
```

In this example, the only modification is the inclusion of the "`-i`" flag in the first line (the shebang). When the script is executed, it will properly recognize and expand aliases, producing the expected output.

<pre>
$ ./aliases-0003.sh
Calling new alias

total 12K
-rwxrwxr-x 1 username username 113 Dec 12 06:36 <strong style="color: green;">aliases-0003.sh</strong>
-rwxrwxr-x 1 username username 207 Dec 12 05:38 <strong style="color: green;">aliases-0002.sh</strong>
-rwxrwxr-x 1 username username 114 Dec 12 05:31 <strong style="color: green;">aliases-0001.sh</strong>

Done calling new alias

$ 
</pre>

As demonstrated by the output, we didn't need to enable any special shell options or manually source the aliases file in our script. Bash handled everything automatically, making the process seamless.

If you haven’t already, it’s time to consolidate all your aliases in the "`.bash_aliases`" file located in your home directory. In some cases, this file might already exist; if not, create it now to organize your aliases efficiently.

Let’s revisit our earlier example of the "complex" command:

```bash
    ls -l -t -h --color
```

Previously, we defined an alias called "`llc`" to simplify the execution of this command. To make it available in your current Bash session, open a new terminal or run "`source ~/.bash_aliases`" in your existing terminal. Once done, running "`llc`" will produce output similar to the following:

<pre>
$ source ~/.bash_aliases
$ llc
total 12K
-rwxrwxr-x 1 username username 113 Dec 12 06:36 <strong style="color: green;">aliases-0003.sh</strong>
-rwxrwxr-x 1 username username 207 Dec 12 05:38 <strong style="color: green;">aliases-0002.sh</strong>
-rwxrwxr-x 1 username username 114 Dec 12 05:31 <strong style="color: green;">aliases-0001.sh</strong>

$
</pre>

As shown, the output lists the contents of the current folder, sorted by modification time with the most recently modified files first, and includes color for easier readability.

However, mapping a straightforward alias to a specific command is just the beginning. You can also create aliases that accept arguments, unlocking even greater flexibility. Let’s explore some examples of this in the next section!

## How to create an alias that accepts arguments?

The behavior of an alias depends on the command it represents and your specific use case. Interestingly, you’ve already utilized this functionality in the previous section.

For instance, the "`ls`" command, when executed without a path, lists the contents of the current directory. If you provide it with a path to another directory, it will list the contents of that directory instead. This versatility extends to aliases as well.

Using the alias we created earlier, you could achieve the following:

<pre>
$ llc eval/
total 8.1M
-rw-rw-r-- 1 username username 4.1M Dec 13 05:46 random_words_alpha.txt
-rw-rw-r-- 1 username username 4.1M Dec 13 05:34 words_alpha.txt
-rwxrwxr-x 1 username username    0 Dec 13 05:24 <strong style="color: green;">evil_3_safe.sh</strong>
-rwxrwxr-x 1 username username    0 Dec 13 05:24 <strong style="color: green;">evil_1_safe.sh</strong>
-rwxrwxr-x 1 username username    0 Dec 13 05:24 <strong style="color: green;">evil_2_safe.sh</strong>
-rwxrwxr-x 1 username username    0 Dec 13 05:24 <strong style="color: green;">evil_1.sh</strong>
-rwxrwxr-x 1 username username    0 Dec 13 05:24 <strong style="color: green;">evil_2.sh</strong>
-rwxrwxr-x 1 username username    0 Dec 13 05:24 <strong style="color: green;">evil_3.sh</strong>

$
</pre>

Here, the contents of the "`eval`" directory are displayed, sorted by modification date and with color enabled. But how does this work? The explanation is straightforward.

In the previous case we just created a directory named "`eval`" with a few empty scripts and a couple TXT files that contain the same information but one of them is in random order.

When you pass arguments to an alias, Bash first expands the alias into its underlying command, then appends the arguments you provided to the expanded command. In this case, the process resembles the following:

<div style="text-align:center">
    <img src="/assets/bash-in-depth/0027-Aliases/llc-expansion.png"/>
</div>

This behavior means that aliases can accept arguments directly, depending on the command they represent. However, certain commands might require more complex handling, necessitating a function instead of a simple alias.

Consider the following example:

```bash
    grep -rn <path> -e <content>
```

This command searches within the specified "`<path>`" for files containing "`<content>`", then outputs the file paths, line numbers, and matching lines. Additionally, it highlights the "`<content>`" in red. Notice that this command requires arguments in specific positions (e.g., "`<path>`" in the middle), which makes it unsuitable for a standard alias. To address this, you can use a function that wraps the command.

Here’s how you can create a function-based alias for the "`grep`" command:

```bash
# Alias for a complex ls command
alias llc="ls -l -t -h --color"
# Find file with content
_ffwc() {
    path_to_folder=$1
    content_to_search=$2
    grep -rn $path_to_folder -e "$content_to_search"
}
alias ffwc="_ffwc"
```

After sourcing the "`.bash_aliases`" file or opening a new Bash shell, you can use the new "`ffwc`" alias by providing the folder path and search term as arguments. The output will include the search results, complete with file paths, line numbers, and highlighted matches.

<pre>
$ ffwc . message
<span style="color: purple;">./eval/random_words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">14003</span>:inter<strong style="color: red;">message</strong>
<span style="color: purple;">./eval/random_words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">19011</span>:<strong style="color: red;">message</strong>d
<span style="color: purple;">./eval/random_words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">58470</span>:<strong style="color: red;">message</strong>s
<span style="color: purple;">./eval/random_words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">72346</span>:<strong style="color: red;">message</strong>
<span style="color: purple;">./eval/random_words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">261308</span>:counter<strong style="color: red;">message</strong>
<span style="color: purple;">./eval/random_words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">322289</span>:<strong style="color: red;">message</strong>er
<span style="color: purple;">./eval/random_words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">355054</span>:<strong style="color: red;">message</strong>ry
<span style="color: purple;">./eval/words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">70914</span>:counter<strong style="color: red;">message</strong>
<span style="color: purple;">./eval/words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">155354</span>:inter<strong style="color: red;">message</strong>
<span style="color: purple;">./eval/words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">184462</span>:<strong style="color: red;">message</strong>
<span style="color: purple;">./eval/words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">184463</span>:<strong style="color: red;">message</strong>d
<span style="color: purple;">./eval/words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">184464</span>:<strong style="color: red;">message</strong>er
<span style="color: purple;">./eval/words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">184465</span>:<strong style="color: red;">message</strong>ry
<span style="color: purple;">./eval/words_alpha.txt</span><span style="color: blue;">:</span><span style="color: green;">184466</span>:<strong style="color: red;">message</strong>s

$ 
</pre>

What’s happening here is that Bash expands the alias into the corresponding function, "`_ffwc`", which then takes the provided path and search content as arguments and incorporates them into the appropriate positions within the command. This process ensures that the function handles the inputs seamlessly.

The diagram below illustrates how Bash processes the alias and executes the underlying logic:

<div style="text-align:center">
    <img src="/assets/bash-in-depth/0027-Aliases/ffwc-expansion.png"/>
</div>

Using an alias tied to a function is an incredibly versatile tool. It allows you to encapsulate complex logic—such as conditional statements, loops, and piped commands—within a function, while mapping it to a simple and intuitive alias. This approach not only keeps your commands concise but also enhances productivity by abstracting away intricate details, making your workflow more efficient and elegant.

## Reusing aliases


Aliases in Bash can also be built upon one another, enabling you to create layered, reusable commands. Let’s explore this with an example.

Previously, we defined an alias to search for files containing specific content:

```bash
# Find File With Content
_ffwc() {
    path_to_folder=$1
    content_to_search=$2
    grep -rn $path_to_folder -e "$content_to_search"
}
alias ffwc="_ffwc"
```

This alias, "`ffwc`", expects two arguments: the path to search within and the content to search for. A common scenario is searching for content within the current directory. To simplify this frequent use case, we can create another alias that reuses "`ffwc`" and passes "`.`" (representing the current folder) as the first argument.

The updated "`.bash_aliases`" file would look like this:

```bash
# Find File With Content
_ffwc() {
    path_to_folder=$1
    content_to_search=$2
    grep -rn $path_to_folder -e "$content_to_search"
}
alias ffwc="_ffwc"
# Find File With Content in Current Folder
alias ffwcc="ffwc ."
```

After sourcing the "`.bash_aliases`" file (or opening a new terminal), you can use the "`ffwcc`" command to achieve the same result as running "`ffwc . message`". For instance, executing "`ffwcc message`" will efficiently search the current folder for files containing the word "`message`". This approach demonstrates the power of reusing aliases to streamline repetitive tasks further.

## How to get the current aliases?

To view the aliases currently defined in your system, you can use the "`-p`" flag with the built-in "`alias`" command. This will display a list of all active aliases. For example, here's the output I get on my system:

<pre>
$ <strong style="color: orange;">alias</strong> -p
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias egrep='egrep --color=auto'
alias ffwc='_ffwc'
alias ffwcc='ffwc .'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias llc='ls -l -t -h --color'
alias ls='ls --color=auto'

$
</pre>

The output varies depending on the number of aliases defined in your system. The more aliases you've created, the more entries you'll see in the list. This command is a quick and effective way to review and manage your defined shortcuts.

## How to remove aliases?

Just as Bash lets you create custom aliases using the "`alias`" built-in command, it also provides a way to remove aliases you no longer need. This can be done easily with the "`unalias`" command.

To remove an alias, simply type:

<pre>
    <strong style="color: orange;">unalias</strong> "alias-name"
</pre>

Once you execute this command, the specified alias will be permanently removed from the current session.

## Summary


Aliases in Bash are a powerful feature that lets you define shortcuts for lengthy or frequently used commands, making them quicker and easier to execute. By associating a short name with a complex command or sequence of commands, aliases improve efficiency and simplify repetitive tasks. They allow you to customize your command-line environment to better suit your workflow. Furthermore, aliases can handle arguments, either directly or by using functions, significantly enhancing their flexibility and functionality.

To create an alias, you use the "`alias`" command followed by the desired name and the command it represents. For example, you can define a shortcut for a long "`ls`" command to make directory listings more concise. To make aliases persistent across sessions, you can store them in the "`.bash_aliases`" file in your home directory, which is typically loaded by your "`.bashrc`" configuration file. This ensures your aliases are automatically available whenever you open a new terminal session. However, aliases are not enabled by default in non-interactive scripts. To use them in scripts, you must either enable alias expansion explicitly or execute the script in interactive mode.

Bash allows aliases to reference other aliases, enabling you to create layered or hierarchical shortcuts. For example, you could define a general alias to search files in a directory and then create a second alias that reuses the first to search only in the current directory. This reusability simplifies managing complex commands and promotes consistency in your workflows.

To manage aliases, Bash provides the "`alias`" and "`unalias`" commands. The "`alias`" command lets you view all defined aliases using the "`alias -p`" option, which is particularly useful for troubleshooting or auditing your setup. When an alias is no longer needed, you can remove it with the "`unalias`" command followed by the alias name. Together, these commands give you full control over your aliases, making them a key tool for optimizing command-line operations and enhancing productivity.


*"The best developers work smarter, not harder—aliases make that possible."*

## References

1. <https://itnext.io/bash-aliases-are-awesome-8a76aecc96ab>
2. <https://opensource.com/article/19/7/bash-aliases>
3. <https://tldp.org/LDP/abs/html/aliases.html>
4. <https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html>
5. <https://www.shell-tips.com/bash/alias/>
6. <https://www.warp.dev/terminus/bash-aliases>
7. <https://zegetech.com/blog/2020/03/21/amazing-aliases.html>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">
<p id="footnote-1" style="font-size:10pt">
1. The variable “<code style="font-size:9pt">$-</code>” contains the flags passed to a Bash instance (shell or script)<a href="#footnote-1-ref">&#8617;</a>
</p>

