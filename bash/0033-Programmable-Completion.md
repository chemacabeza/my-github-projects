---
layout: chapter
title: "Chapter 33: Programmable Completion"
---

# Chapter 33: Programmable Completion


## Index
* [Introduction]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#introduction)
* [Programmable completion environment variables]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#programmable-completion-environment-variables)
    * [The "`COMP_CWORD`" variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-comp_cword-variable)
    * [The "`COMP_KEY`" variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-comp_key-variable)
    * [The "`COMP_LINE`" variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-comp_line-variable)
    * [The "`COMP_POINT`" variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-comp_point-variable)
    * [The "`COMP_TYPE`" variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-comp_type-variable)
    * [The "`COMP_WORDBREAKS`" variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-comp_wordbreaks-variable)
    * [The "`COMPREPLY`" variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-compreply-variable)
    * [The "`COMP_WORDS`" variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-comp_words-variable)
* [Programmable completion built-in commands]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#programmable-completion-built-in-commands)
    * [The "`compgen`" Command]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-compgen-command)
        * [Actions (the "`-A`" flag)]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#actions-the--a-flag)
        * [Function (the "`-F`" flag)]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#function-the--f-flag)
        * [Globbing (the “`-G`” flag)]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#globbing-the--g-flag)
        * [Word list (the “`-W`” flag)]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#word-list-the--w-flag)
        * [Filter out (the “`-X`” flag)]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#filter-out-the--x-flag)
        * [Suffix (the “`-S`” flag)]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#suffix-the--s-flag)
        * [Options (the “`-o`” flag)]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#options-the--o-flag)
    * [The "`complete`" Command]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#the-complete-command)
    * [How to use “`compgen`” and “`complete`” together?]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#how-to-use-compgen-and-complete-together)
        * [Adding static values to the "`COMPREPLY`" array variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#adding-static-values-to-the-compreply-array-variable)
        * [Adding static values with “`compgen`”]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#adding-static-values-with-compgen)
        * [Dynamic completion based on what has been typed so far]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#dynamic-completion-based-on-what-has-been-typed-so-far)
        * [Dynamic completion using “`COMP_CWORD`” variable]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#dynamic-completion-using-comp_cword-variable)
        * [Dynamic completion with several arguments and sub-arguments]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#dynamic-completion-with-several-arguments-and-sub-arguments)
* [Where to place the programmable completion scripts?]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#where-to-place-the-programmable-completion-scripts)
* [What happens with ZSH users?]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#what-happens-with-zsh-users)
* [Summary]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#summary)
* [References]({{ site.url }}//bash-in-depth/0033-Programmable-Completion.html#references)


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

## Introduction

Programmable completion, or autocompletion, is a powerful feature that enhances command-line efficiency by suggesting or completing commands, arguments, filenames, and other elements as you type. It simplifies interactions with the terminal, helping users enter commands quickly and accurately while minimizing manual effort.

This feature offers several key benefits. It saves time by reducing the need to type long commands or filenames in full; a few characters followed by pressing the Tab key allow Bash to complete the input. Autocompletion also helps prevent errors by suggesting valid options based on the current context, ensuring accuracy in command entry. Furthermore, it enhances discoverability by displaying a list of available commands, options, or files, making it easier to explore and utilize system resources effectively.

Autocompletion is particularly useful for working with command parameters, as it can display available flags, options, and arguments for specific commands. This aids users in constructing precise and meaningful commands without relying on memory alone. It’s also invaluable when developing shell scripts, suggesting valid command names, system variables, or file paths to ensure accuracy and streamline the scripting process. For complex commands involving multiple arguments or filenames, autocompletion reduces both the effort required and the likelihood of mistakes.

In essence, Bash autocompletion boosts productivity and precision on the command line. By providing an intuitive and efficient way to interact with the shell, it simplifies command entry, aids discovery, and makes working in the terminal more seamless.

In this chapter, we will explore the environment variables and built-in commands that enable programmable completion for various commands of our choosing. To apply what we learn, we will create a dummy script designed to display the arguments provided to it, and then use that script as the basis for building a programmable completion script. Let’s begin with an overview of the relevant environment variables.


## Programmable completion environment variables

The following sections provide detailed descriptions of the key variables used in scripts to enable programmable completion in Bash.

### The "`COMP_CWORD`" variable

The "`COMP_CWORD`" variable serves as an index within the "`COMP_WORDS`" array, identifying the word currently being autocompleted. This variable functions as an input variable and is accessible only within shell functions invoked by Bash’s programmable completion framework.

### The "`COMP_KEY`" variable

The "`COMP_KEY`" variable holds the ASCII code <a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>of the key pressed to trigger the current completion function. For most cases, this value will be **9**, which represents the Tab key. Like other input variables, it is limited to use within shell functions called by Bash’s completion mechanisms.

### The "`COMP_LINE`" variable

The "`COMP_LINE`" variable contains the entire command line that is being autocompleted. It provides the full context for the autocomplete process and is also an input variable available exclusively within Bash’s completion-related shell functions.

### The "`COMP_POINT`" variable

The "`COMP_POINT`" variable represents the cursor’s position within the command line. If the cursor is at the end of the command, its value will equal the length of "`COMP_LINE`". This variable is crucial for determining where completion should occur and, like others, is an input variable used only in Bash’s completion facilities.

### The "`COMP_TYPE`" variable

The "`COMP_TYPE`" variable indicates the type of completion that triggered the function call, represented by an integer ASCII code. The possible values include:
* **9 (Tab)**: Normal completion
* **33** (“`!`”): Lists alternatives for partially completed words
* **37** (“`%`”): Indicates menu completion
* **63** (“`?`”): Lists completions after multiple Tab presses
* **64** (“`@`”): Lists completions for unmodified words
This variable is an input value, confined to completion-specific shell functions.

### The "`COMP_WORDBREAKS`" variable

The "`COMP_WORDBREAKS`" variable defines the characters considered as word separators by the "`readline`" library during completion. Modifying this variable removes its special properties, **so it is recommended not to alter it**.

### The "`COMPREPLY`" variable

The "`COMPREPLY`" variable is an array used to store suggestions for autocompletion. These suggestions are generated within a shell function and read by Bash to present possible completions to the user. Unlike the input variables above, "`COMPREPLY`" serves as an output variable.

### The "`COMP_WORDS`" variable

The "`COMP_WORDS`" variable is an array containing the individual words of the current command line. It acts as an input variable, providing the components of the command for processing. Like other input variables, it is only accessible within Bash’s completion-related functions.

With an understanding of these variables, the next step is to explore the built-in commands that work in conjunction with them to create and manage programmable completion functionality effectively.

## Programmable completion built-in commands


In the following sections, we will explore the built-in commands that Bash provides to create programmable completion scripts. These commands serve as essential tools for enhancing command-line efficiency by offering dynamic and context-sensitive suggestions.

### The "`compgen`" Command

The "`compgen`" command is a powerful built-in tool in Bash designed to facilitate command-line completion. Its primary function is to generate a list of possible completions based on specific criteria, such as command names, file names, or environment variables. When a user begins typing a command or argument and presses the Tab key, Bash relies on "`compgen`" to propose relevant suggestions, simplifying navigation and command entry.

"`compgen`" can be utilized both interactively on the command line and within scripts, making it versatile for generating completions. It supports a wide range of completion types, including commands, options, files, directories, usernames, and more. By leveraging "`compgen`", users can quickly view valid options or arguments for a command, reducing the need to recall or type them manually and minimizing the likelihood of errors.

In essence, "`compgen`" enhances the user experience in Bash by streamlining command-line operations, providing immediate access to available resources, and reducing typing errors. Its flexibility allows it to be adapted for various scenarios, improving both usability and productivity.

The "`compgen`" command offers numerous options and flags that can be used to tailor suggestions for programmable completion. These flags and options collectively form what is known as a "*compspec*" (completion specification). A **compspec** defines the criteria that guide "`compgen`" in determining the suggestions it generates. In this section and subsequent sections, you will learn about various flags and options that can be passed to "`compgen`" to produce the desired completions for commands.

The following table outlines the initial and most straightforward flags of the compgen command, along with descriptions of their associated behaviors:

| Flag | Description of the completion suggested |
| :----: | :---- |
| `-a` | Names of aliases |
| `-b` | Names of shell built-ins |
| `-c` | Names of commands |
| `-d` | Names of directories | 
| `-e` | Names of exported shell variables |
| `-f` | Names of files |
| `-g` | Names of user groups |
| `-j` | Names of jobs |
| `-k` | Names of Bash reserved words |
| `-s` | Names of services in the system |
| `-u` | Names of users |
| `-v` | Names of shell variables |

While these flags provide a solid foundation, "`compgen`" also includes more advanced options for generating and modifying suggestions. These capabilities make it an indispensable tool for developing sophisticated programmable completion scripts. Typically, "`compgen`" is invoked within shell functions specifically designed to generate the possible completions, ensuring precise and context-appropriate suggestions.

#### <b>Actions (the "`-A`" flag)</b>

The “`-A`” flag is part of the compspec. In a nutshell, this flag admits an action as an argument. Depending on the value passed, you will have one or another suggestion.

The following table provides an overview of the different values you can pass as action to the “`-A`” flag, with a description of the behavior.

<table border="1" style="border-collapse: collapse; width: 100%;">
    <thead>
        <tr>
            <th style="text-align: center; padding: 10px;">Flag</th>
            <th style="text-align: center; padding: 10px;">Action</th>
            <th style="text-align: left; padding: 10px;">Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="24" style="text-align: center; vertical-align: middle; padding: 10px;"><code>-A</code></td>
            <td style="text-align: center; padding: 10px;"><code>alias</code></td>
            <td style="text-align: left; padding: 10px;">Aliases as suggestions. Same as with “<code>-a</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>arrayvar</code></td>
            <td style="text-align: left; padding: 10px;">Names of array variables as suggestions</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>binding</code></td>
            <td style="text-align: left; padding: 10px;">Key binding names as suggestions</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>builtin</code></td>
            <td style="text-align: left; padding: 10px;">Names of shell built-ins as suggestions. Same as with “<code>-b</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>command</code></td>
            <td style="text-align: left; padding: 10px;">Names of commands as suggestions. Same as with “<code>-c</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>directory</code></td>
            <td style="text-align: left; padding: 10px;">Names of directory as suggestions. Same as “<code>-d</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>disabled</code></td>
            <td style="text-align: left; padding: 10px;">Names of disabled shell built-ins as suggestions</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>enabled</code></td>
            <td style="text-align: left; padding: 10px;">Names of enabled shell built-ins as suggestions</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>export</code></td>
            <td style="text-align: left; padding: 10px;">Names of exported shell variables. Same as “<code>-e</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>file</code></td>
            <td style="text-align: left; padding: 10px;">Names of files. Same as “<code>-f</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>function</code></td>
            <td style="text-align: left; padding: 10px;">Names of shell functions</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>group</code></td>
            <td style="text-align: left; padding: 10px;">Names of user groups. Same as “<code>-g</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>helptopic</code></td>
            <td style="text-align: left; padding: 10px;">Names of help topics as accepted by the “<code>help</code>” built-in command</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>hostname</code></td>
            <td style="text-align: left; padding: 10px;">Names of hosts as suggestions</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>job</code></td>
            <td style="text-align: left; padding: 10px;">If job control is active it will provide the names of jobs. Same as “<code>-j</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>keyword</code></td>
            <td style="text-align: left; padding: 10px;">Names of reserved words. Sames as “<code>-k</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>running</code></td>
            <td style="text-align: left; padding: 10px;">If job control is active it will provide the names of running jobs</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>service</code></td>
            <td style="text-align: left; padding: 10px;">Names of services. Same as “<code>-s</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>setopt</code></td>
            <td style="text-align: left; padding: 10px;">Names of valid arguments for the “<code>-o</code>” option of the “<code>set</code>” built-in command</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>shopt</code></td>
            <td style="text-align: left; padding: 10px;">Names of shell options accepted by the “<code>shopt</code>” built-in command</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>signal</code></td>
            <td style="text-align: left; padding: 10px;">Names of signals</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>stopped</code></td>
            <td style="text-align: left; padding: 10px;">If job control is active it will provide the names of stopped jobs</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>user</code></td>
            <td style="text-align: left; padding: 10px;">Names of users. Same as “<code>-u</code>”</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>variable</code></td>
            <td style="text-align: left; padding: 10px;">Names of shell variables. Same as “<code>-v</code>”</td>
        </tr>
    </tbody>
</table>

#### <b>Function (the "`-F`" flag)</b>

Using the "`-F`" flag, you can specify the name of a function to generate a custom list of suggestions for your command.

Within this function, you'll have access to various environment variables described in the section on programmable completion environment variables.

The sole requirement for the function is to populate the "`COMPREPLY`" array with the desired suggestions. As we've learned earlier, Bash uses this array to display the suggestions for your command.

#### <b>Globbing (the “`-G`” flag)</b>

The "`-G`" flag enables you to provide an expression as its argument, which will be expanded to match file names. This expression supports various wildcards, allowing for more flexible and dynamic pattern matching.

#### <b>Word list (the “`-W`” flag)</b>

The "`-W`" flag allows you to specify a string containing a list of items that will serve as suggestions for your command when using programmable completion. This means you can directly define a set of predefined options that Bash will present as autocompletion suggestions. By including this flag, you can ensure that users of your command are guided toward selecting from a specific range of values, making the interaction more intuitive and efficient. This approach is particularly useful when the list of potential options is fixed or easily determined in advance.

#### <b>Filter out (the “`-X`” flag)</b>

The "`-X`" flag provides a way to refine the suggestions generated for your command by excluding specific options that match a pattern you specify as its argument. This pattern serves as a filter, ensuring that any suggestions aligning with it are removed from the list of completions presented to the user.

However, the "`-X`" flag does not generate suggestions on its own. Instead, it works in conjunction with other flags, serving as a complementary tool to exclude unwanted matches from an existing set of completions. By using this flag effectively, you can create a more tailored and user-friendly set of suggestions, ensuring that irrelevant or redundant options are omitted.

#### <b>Suffix (the “`-S`” flag)</b>

The "`-S`"<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a> flag enables you to append a specified suffix to every suggestion generated during programmable completion. By providing the suffix as an argument to this flag, you can ensure that each suggestion includes the desired text appended to the end, enhancing the clarity or functionality of the completion results.

It’s important to note that the "`-S`" flag does not operate independently. Instead, it works in tandem with other flags that generate the actual suggestions. Its role is purely to modify these existing suggestions by adding the specified suffix. This feature can be particularly useful in scenarios where a consistent format or additional context is needed for each suggestion.

#### <b>Options (the “`-o`” flag)</b>

The "`-o`" flag introduces specific behaviors that take effect once the completion specification (compspec) has been evaluated. This flag allows you to fine-tune how the completion system behaves, adding flexibility and control to the overall completion process.

To help you better understand its functionality, the table below outlines the various option values you can pass to the "`-o`" flag. Each value is accompanied by a description detailing the corresponding behavior it activates, making it easier to determine the most appropriate choice for your needs.

<table border="1" style="border-collapse: collapse; width: 100%;">
    <thead>
        <tr>
            <th style="text-align: center; padding: 10px;">Flag</th>
            <th style="text-align: center; padding: 10px;">Option</th>
            <th style="text-align: left; padding: 10px;">Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="8" style="text-align: center; vertical-align: middle; padding: 10px;"><code>-o</code></td>
            <td style="text-align: center; padding: 10px;"><code>bashdefault</code></td>
            <td style="text-align: left; padding: 10px;">If the compspec generates no suggestions, Bash will perform the rest of default completions</td>
        </tr>
        <!-- Repeat rows for additional options -->
        <tr>
            <td style="text-align: center; padding: 10px;"><code>default</code></td>
            <td style="text-align: left; padding: 10px;">If the compspec generates no suggestions, Bash will use Readline’s default filename completion</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>dirnames</code></td>
            <td style="text-align: left; padding: 10px;">If the compspec generates no suggestions, Bash will use directory names</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>filenames</code></td>
            <td style="text-align: left; padding: 10px;">Suggests names of files and folders</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>noquote</code></td>
            <td style="text-align: left; padding: 10px;">Not to quote the suggestions if they are file names</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>nosort</code></td>
            <td style="text-align: left; padding: 10px;">Not to sort the suggestions alphabetically</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>nospace</code></td>
            <td style="text-align: left; padding: 10px;">Not to append a space to words completed at the end of the line.</td>
        </tr>
        <tr>
            <td style="text-align: center; padding: 10px;"><code>plusdirs</code></td>
            <td style="text-align: left; padding: 10px;">After any matches defined by the compspec are generated, directory name completion is attempted and any matches are added to the results of the other actions.</td>
        </tr>
    </tbody>
</table>

### The "`complete`" Command

The "`complete`" command serves as the primary tool for implementing programmable completion in Bash. It can be used on its own or in conjunction with the "`compgen`" command, which we explored in the previous section.

The "`complete`" command offers the same options as "`compgen`", with the addition of two unique flags: "`-p`" and "`-r`".

| Flag | Description of completion suggested |
| :----: | :---- |
| `-p` | Prints existing compspec in a reusable format |
| `-r` | If a name is provided to the “`complete`” command, it removes the compspec associated. If no name is provided to the “`complete`” command, it removes all compspecs. |

Now that you understand the roles of both "`compgen`" and "`complete`", it’s time to delve into how these commands can be effectively combined. This topic will be the focus of the next section.

### How to use “`compgen`” and “`complete`” together?

So far, we have explored the purpose of the compgen and complete commands, understanding their roles in programmable completion. However, to enable programmable completion effectively, these commands must be used together.

In this section, we will learn how to combine these two commands to implement programmable completion. But before diving into the details, let’s start by creating a very simple script as the basis for our example. This lightweight script will be the target for which we’ll provide programmable completion.

Here’s the script:

```bash
 1 #!/usr/bin/env bash
 2 #Script: programmable-completion-0001.sh
 3 echo "COMMAND: $0 $@"
```

As you can see, the script’s sole purpose is to print the string "`COMMAND: `" followed by the script’s name and any arguments passed to it. It’s minimal by design, serving as a straightforward example for our completion logic.

Now, how do we add programmable completion to this script? As mentioned earlier, we need to leverage the built-in "`compgen`" and "`complete`" commands. To achieve this, we’ll create a separate script that contains the logic for handling programmable completion.

Here’s the completion script:

```bash
 1 #!/usr/bin/env bash
 2 #Script: programmable-completion-0001-completion.bash
 3 _mucommand_completions() {
 4 		"[[LOGIC_TAKING_CARE_OF_PROGRAMMABLE_COMPLETION]]"
 5 }
 6 complete -F _mycommand_completions programmable-completion-0001
```

In this script, pay close attention to line 6, where the "`complete`" command is used. This command employs the "`-F`" flag to associate a specific function—named "`_mycommand_completions`" in our example—with the command "`programmable-completion-0001`". By sourcing this file, Bash is informed that whenever "`programmable-completion-0001`" is invoked, it must call the "`_mycommand_completions`" function to generate a list of suggestions.

After the "`_mycommand_completions`" function executes, Bash retrieves the suggestions stored in the "`COMPREPLY`" array and presents them to the user.

Within the "`_mycommand_completions`" function, you’ll define the logic for generating suggestions. This typically involves using the "`compgen`" command to dynamically build the list of possible completions<a id="footnote-3-ref" href="#footnote-3" style="font-size:x-small">[3]</a>.

In the subsections that follow, we’ll explore a series of examples to help you become comfortable with programmable completion. Each example will introduce progressively more advanced concepts, ensuring a clear learning path. I hope you find this journey both engaging and enjoyable!

#### <b>Adding static values to the "`COMPREPLY`" array variable</b>

In our first example, we will start by adding static values to the "`COMPREPLY`" array.

```bash
 1 #!/usr/bin/env bash
 2 #Script: programmable-completion-0002-completion.bash
 3 _mycommand_completions(){
 4     COMPREPLY=("opt1" "opt2" "opt3")
 5 }
 6 complete -F _mycommand_completions programmable-completion-0001
```

In this version of the script, we are manually defining three fixed suggestions: "`opt1`", "`opt2`", and "`opt3`". Once you source<a id="footnote-4-ref" href="#footnote-4" style="font-size:x-small">[4]</a> this script in your current terminal session, you can test it by typing "`programmable-completion-0001`"<a id="footnote-5-ref" href="#footnote-5" style="font-size:x-small">[5]</a> and pressing the **Tab** key.

When you press **Tab** for the first time, Bash will suggest "`opt`", as all available completions share this common prefix. Pressing **Tab** twice more will reveal the full list of suggestions:

<pre>
$ programmable-completion-0001 opt
opt1  opt2  opt3

</pre>

At this point, you can choose the option you want. For example, if you select "`opt2`" and press **Enter**, the command will execute with the following output:

<pre>
$ programmable-completion-0001 opt2
COMMAND: programmable-completion-0001 opt2
$
</pre>

With this approach, Bash will always provide the static values stored in the "`COMPREPLY`" array as suggestions.

In the next section, we’ll explore how to use the "`compgen`" command along with its various flags to dynamically generate completions.

#### <b>Adding static values with “`compgen`”</b>

In this section, we will explore how to use the "`compgen`" command to generate static suggestions for programmable completion.

For this example, our completion script will provide suggestions for file names (using the "`-f`" flag), group names ("`-g`" flag), and user names ("`-u`" flag).

```bash
 1 #!/usr/bin/env bash
 2 #Script: programmable-completion-0003-completion.bash
 3 _mycommand_completions(){
 4 		COMPREPLY=($(compgen -f -g -u))
 5 }
 6 complete -F _mycommand_completions programmable-completion-0001
```

After saving the script, source it in your terminal as you did previously, and then test it by typing the command followed by the Tab key. You should see output similar to the following:

```
$ programmable-completion-0001 <Tab><Tab>
adm              gnome-initial-setup             sgx
_apt             hplip                           shadow
audio            input                           speech-dispatcher
...
```

Keep in mind that the actual output will vary depending on your system's files, users, and groups.

While this script improves upon the previous example by generating dynamic suggestions, it still has a limitation: it suggests the same options repeatedly, without considering what the user has already typed.

In the next section, we’ll address this issue and refine our completion logic to make it more intelligent and context-aware.

#### <b>Dynamic completion based on what has been typed so far</b>

Building upon the previous section, we will once again use the "`compgen`" command—this time incorporating the user’s input so that the suggestions provided are more relevant to what has been typed so far.

To achieve this, we need to utilize the "`COMP_WORDS`" array variable. As a reminder, this array holds the individual words in the current command line, where each word is indexed sequentially.

Since we want to provide autocompletion for the first argument after the command itself, we need to reference index "`1`" of the "`COMP_WORDS`" array. This is because index "`0`" contains the command name ("`programmable-completion-0001`"), while index "`1`" represents the first argument the user is typing.

Here’s how our improved completion script looks:

```bash
 1 #!/usr/bin/env bash
 2 #Script: programmable-completion-0004-completion.bash
 3 _mycommand_completions(){
 4 		COMPREPLY=($(compgen -f -g -u ${COMP_WORDS[1]}))
 5 }
 6 complete -F _mycommand_completions programmable-completion-0001
```

With this approach, Bash will only suggest options that begin with the characters you have already typed. For example, after sourcing the script, if you start typing the command and enter the letter "`v`", then press **Tab**, Bash will filter the suggestions to display only those that start with "`v`":

```
$ programmable-completion-0001 v<Tab><Tab>
vboxusers  video      voice
```

Now, let’s say you select "`video`" from the suggestions. If you press **Tab** again, you might notice an unusual behavior—Bash will repeatedly suggest "`video`" without offering any new completions.

This happens because our script is always referencing the same position in the "`COMP_WORDS`" array, which now permanently holds the value "`video`". As a result, it keeps generating the same suggestion repeatedly.

To fix this issue, we need to dynamically determine which position in the command line we are providing suggestions for.

In the next section, we’ll explore how to refine our script to handle this scenario more effectively.


#### <b>Dynamic completion using “`COMP_CWORD`” variable</b>

In the previous section, we encountered an odd behavior: the programmable completion kept suggesting the same option repeatedly.

This happened because our script was always checking index "`1`" of the "`COMP_WORDS`" array. After selecting the option video, that position still held the same value. So, when we tried to get suggestions for the next word, the script simply returned video again—because that’s what was stored at index "`1`".

To solve this, we can use the "`COMP_CWORD`" variable. As we’ve seen earlier, "`COMP_CWORD`" represents the index in the "`COMP_WORDS`" array that corresponds to the word currently being completed.

In our case, since we want to provide suggestions specifically for the first argument of the command, we need to check whether "`COMP_CWORD`" equals "`1`".

Let’s take a look at how this works in the example below:

```bash
 1 #!/usr/bin/env bash
 2 #Script: mycommand-completion.bash
 3 _mycommand_completions(){
 4     if [[ "$COMP_CWORD" == 1 ]]; then
 5         COMPREPLY=($(compgen -f -g -u ${COMP_WORDS[1]}))
 6         return
 7     fi
 8 }
 9 complete -F _mycommand_completions mycommand
```

Now, source the "`mycommand-completion.bash`" script and try it again. When you type the character "`v`" and press "`<Tab><Tab>`", the behavior will appear the same as before:

```shell
$ ./mycommand v<Tab><Tab>
vboxusers  video      voice
```

Next, complete the input to video and press "`<Tab>`" a couple more times. You should now see something like this:

```shell
$ ./mycommand video <Tab><Tab>

```

Notice that the strange behavior from before is no longer present.

In the next section, we’ll take a deeper look into this approach for writing programmable completion scripts.


#### <b>Dynamic completion with several arguments and sub-arguments</b>

In this section, we will create a programmable completion script for a command that takes three main arguments, each with two corresponding sub-arguments.

<div style="text-align:center">
    <img src="/assets/bash-in-depth/0033-Programmable-Completion/3-arguments-and-2-subarguments.png"/>
</div>

To implement this feature correctly, we must clearly identify which "`COMP_CWORD`" values need to be checked. The diagram below illustrates this concept:

<div style="text-align:center">
    <img src="/assets/bash-in-depth/0033-Programmable-Completion/COMP_CWORD_with_the_command.png"/>
</div>

From the diagram, we can see that:
* To provide argument suggestions, we check the "`COMP_CWORD`" value.
* To suggest sub-arguments, we check both "`COMP_CWORD`" and the selected argument.

**Step 1: Suggesting Arguments**

Let's begin by implementing argument suggestions using the "`-W`" option of the "`compgen`" built-in command.

```bash
 1 #!/usr/bin/env bash
 2 # Script: mycommand-completion.bash
 3 _mycommand_completions() {
 4    if [[ "$COMP_CWORD" == 1 ]]; then
 5       COMPREPLY=($(compgen -W "user video image" ${COMP_WORDS[1]}))
 6       return
 7    fi
 8 }
 9 complete -F _mycommand_completions mycommand
```

Now, source the script and test it:

```shell
$ ./mycommand <Tab><Tab>
image  user   video
```

At this stage, selecting an argument and pressing **Tab** again should not produce any further suggestions:

```shell
$ ./mycommand image <Tab><Tab>
```

Great job! We have successfully provided argument completion. Now, let's move on to sub-arguments.

**Step 2: Suggesting Sub-Arguments**

As mentioned earlier, to provide sub-argument suggestions, we need to:
1. Ensure "`COMP_CWORD`" is set to "`2`".
2. Identify which argument is currently selected.

To achieve this, we store the argument in a variable and use conditional checks to provide appropriate sub-argument suggestions.

```bash
 1 #!/usr/bin/env bash
 2 # Script: mycommand-completion.bash
 3 _mycommand_completions() {
 4    if [[ "$COMP_CWORD" == 1 ]]; then
 5       COMPREPLY=($(compgen -W "user video image" ${COMP_WORDS[1]}))
 6       return
 7    fi
 8    local argument=${COMP_WORDS[ (( COMP_CWORD - 1 )) ]}
 9    if [[ "$COMP_CWORD" == 2 ]]; then
10       case "$argument" in
11          image) COMPREPLY=($(compgen -W "resize rotate" ${COMP_WORDS[2]})) ;;
12          user)  COMPREPLY=($(compgen -W "add remove" ${COMP_WORDS[2]})) ;;
13          video) COMPREPLY=($(compgen -W "compress record" ${COMP_WORDS[2]})) ;;
14       esac
15       return
16    fi
17 }
18 complete -F _mycommand_completions mycommand
```

**Testing Sub-Argument Completion**

Source the script again and test the completion process:

```shell
$ ./mycommand <Tab><Tab>
image  user   video
```

Now select "`image`" and press **Tab** again:

```shell
$ ./mycommand image <Tab><Tab>

```

At first, you’ll only see the letter "`r`", as both available sub-arguments ("`resize`" and "`rotate`") start with this letter.

```shell
$ ./mycommand image r

```

Pressing **Tab** again will display the full options:

```shell
$ ./mycommand image r<Tab><Tab>
resize  rotate
```

**Wrapping Up**

If everything is working as expected, congratulations! You’ve successfully implemented programmable completion for both arguments and sub-arguments.

If you encounter issues, don't worry—double-check your script and try again. Debugging is a natural part of the learning process.

While we could explore more advanced examples, you now have a solid understanding of how to create programmable completion scripts.

In the following section, we'll learn where to place these scripts so that Bash loads them automatically when you start a new terminal session.

## Where to place the programmable completion scripts?

To make Bash automatically recognize and load your programmable completion scripts, the standard location to place them is in the "`/etc/bash_completion.d/`" directory.

You have two options:
1. Copy your script directly into that directory, or
2. Create a symbolic link in "`/etc/bash_completion.d/`" that points to the script stored elsewhere, such as in your home directory.

Once the script is in that location—either as a file or a symbolic link—Bash will automatically load it each time a new shell session starts. This eliminates the need to manually source the script.

If you don’t have administrative permissions to write to "`/etc/bash_completion.d/`", that’s not a problem. You can keep your completion scripts in a folder within your home directory and configure your "`.bashrc`" file to load them when your shell starts.

```bash
# Inside your ~/.bashrc
for file in ~/.bash_completions/*; do
  [ -f "$file" ] && . "$file"
done
```

In the next section, you’ll find a script snippet that you can add to your "`.bashrc`". Just make sure to update it with the path to the folder where you’ve stored your completion scripts.

## What happens with ZSH users?

Believe it or not, even Zsh users can take advantage of Bash's programmable completion scripts.

To enable this functionality in Zsh, simply add the following lines to your "`.zshrc`" file:

```bash
 1 if [[ -e /etc/bash_completion.d/ ]]; then
 2     for file in /etc/bash_completion.d/*; do
 3         if [[ -r $file ]]; then
 4             . $file
 5         fi
 6     done
 7 fi
```

Let’s break down what this snippet does:
* **Line 1**: It checks whether the specified directory exists.
* **Line 2**: If the directory is found, the script loops through each file inside it.
* **Line 3**: For every file, it checks if the file is readable.
* **Line 4**: If the file passes the check, it is sourced—this activates the completion definitions within it.

With this simple setup, Zsh can reuse Bash’s completion logic, allowing you to enjoy intelligent tab completions without rewriting scripts.

## Summary

In this chapter, we explored one of the most powerful features available in Bash: **programmable completion**.

We began by examining the advantages of programmable completion and how it can significantly enhance command-line productivity by offering intelligent, context-aware suggestions.

We introduced key environment variables used in completion scripts, including "`COMP_WORDS`" and "`COMP_CWORD`", which help identify the user's input context. We also discussed the "`COMPREPLY`" array, where custom suggestions are populated for Bash to display during tab completion.

Next, we examined the "`compgen`" command, which provides a flexible way to generate dynamic completion options. With various built-in flags, "`compgen`" can produce common suggestions efficiently and with minimal configuration.

We then introduced the "`complete`" command, which acts as the bridge between a user-defined command and its completion logic. By using the "`-F`" flag, developers can register a custom function to supply the desired completions.

By combining "`compgen`" and "`complete`", we demonstrated how to build tailored completion behavior for specific commands.

We also covered how to make these completion scripts persistently available by placing them in the "`/etc/bash_completion.d/`" directory or, alternatively, sourcing them from a custom directory via "`.bashrc`" when system-level access is not available. Furthermore, we showed how Zsh users can also take advantage of Bash completion scripts by sourcing them conditionally in their "`.zshrc`" files.

While not strictly necessary, programmable completion can be a powerful addition to any developer’s workflow, providing a smoother and more efficient terminal experience.

As with any technical topic, practice is essential. If something doesn't work as expected, reviewing the logic and trying again will often lead to a solution.

" *Behind every efficient command-line wizard is a collection of custom scripts, clever completions, and years of tinkering.*"

## References

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">
<p id="footnote-1" style="font-size:10pt">
1. <a href="https://www.ascii-code.com/">https://www.ascii-code.com/</a><a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. There is another flag that is supposed to have a similar behavior to attach prefixes. The flag is “<code style="font-size:10pt">-P</code>”. But every time I tried to use it does not behave consistently as the “<code style="font-size:10pt">-S</code>” flag. Funny thing is that if you use the “<code style="font-size:10pt">-P</code>” flag from Zsh it provides the expected behavior.<a href="#footnote-2-ref">&#8617;</a>
</p>
<p id="footnote-3" style="font-size:10pt">
3. For the record, using the "<code style="font-size:10pt">compgen</code>" command is not mandatory. However, it is an incredibly powerful tool designed to simplify your work and enhance efficiency.<a href="#footnote-3-ref">&#8617;</a>
</p>
<p id="footnote-4" style="font-size:10pt">
4. You can use the command “<code style="font-size:10pt">source programmable-completion-0002-completion.bash</code>” to make the changes effective in the current terminal.<a href="#footnote-4-ref">&#8617;</a>
</p>
<p id="footnote-5" style="font-size:10pt">
5. “<code style="font-size:10pt">./programmable-completion-0001</code>” because it is in the current folder. If have the script in a folder that is the “<code style="font-size:10pt">PATH</code>” variable you can remove the “<code style="font-size:10pt">./</code>” and just use “<code style="font-size:10pt">programmable-completion-0001</code>”.<a href="#footnote-5-ref">&#8617;</a>
</p>

