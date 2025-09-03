---
layout: chapter
title: "Chapter 32: Customizing The Prompt"
---

# Chapter 32: Customizing The Prompt

## Index
* [Introduction]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#introduction)
* [Why Customize the Prompt?]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#why-customize-the-prompt)
* [How many prompts are there?]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#how-many-prompts-are-there)
* ["`PROMPT_COMMAND`"]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#prompt_command)
    * [String Value]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#string-value)
    * [String Array Value]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#string-array-value)
* [Prompt String 1]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#prompt-string-1)
    * [Special Characters]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#special-characters)
    * [How does PS1 get evaluated?]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#how-does-ps1-get-evaluated)
* [Changing the color and text formatting]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#changing-the-color-and-text-formatting)
* [Using command substitution in the prompt string]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#using-command-substitution-in-the-prompt-string)
    * [Simple behavior with command substitution]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#simple-behavior-with-command-substitution)
    * [Not so simple behavior with command substitution]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#not-so-simple-behavior-with-command-substitution)
* [Where to put the configuration]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#where-to-put-the-configuration)
* [Summary]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#summary)
* [References]({{ site.url }}//bash-in-depth/0032-Customizing-The-Prompt.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

## Introduction

The **prompt** in Bash is the text displayed in your terminal, signaling that the shell is ready to receive and execute commands. It is the interface between you and the Bash shell, making it a fundamental part of the user experience.

By default, the prompt in Bash provides useful information such as the current user, hostname, and working directory. However, it is highly customizable, allowing you to tailor it to your workflow, preferences, or environment. A well-designed prompt can enhance productivity by displaying relevant details, such as the current Git branch, exit status of the last command, or even system resource usage.

The main components of the prompt in Bash are:

1. **Primary Prompt** (`PS1`): This is the most commonly seen prompt, used for interactive shells to signal that Bash is ready for a command. For instance:

```bash
user@hostname:~$
```

2. **Secondary Prompt** (`PS2`): This prompt appears when more input is needed, such as when a command spans multiple lines. The default is "`>`".

3. **Error Prompt** (`PS3`): Used in the "`select`" loop when Bash requires input for choices.

4. **Debug Prompt** (`PS4`): Used when the "`-x`" debugging option is enabled, with the default value being "`+`".

## Why Customize the Prompt?

Customizing the prompt is not just about aesthetics; it can improve your workflow by:
* Displaying critical system information at a glance.
* Indicating the state of the shell or current command.
* Reducing errors by showing contextual information, like the working directory or version control status.

**Example of a Custom Prompt**

Here’s an example of a more informative prompt:

```bash
PS1="\u@\h:\w ($(git branch 2>/dev/null | grep '*' | sed "s/* //")) \$ "
```

This prompt includes:
* "`\u`": Current username.
* "`\h`": Hostname of the system.
* "`\w`": Current working directory.
* Git branch name if inside a Git repository.

The result might look like this:

<pre style="background-color:#2d2d37">
<span style="color:white;">user</span><span style="color:pink;">@hostname</span><span style="color:red;">:~/projects/myapp</span> <span style="color:white;">(main)</span> <span style="color:white;">$</span>
</pre>

## How many prompts are there?

Bash provides **six** different types of prompts, each serving a distinct purpose:
1. "`PROMPT_COMMAND`": This variable holds code that is executed just before the "`PS1`" prompt is displayed.
2. "`PS0`": Known as **P**rompt **S**tring **0**, it behaves similarly to PS1 but appears after each command and before the command’s output.
3. "`PS1`": **P**rompt **S**tring **1** is the default interactive prompt we discussed earlier. It is the primary prompt displayed when Bash is ready for user input.
4. "`PS2`": **P**rompt **S**tring **2**, the continuation prompt, appears when a command is too long and is split across multiple lines using the backslash "`\`". By default, it is set to "`> `".
5. "`PS3`": **P**rompt **S**tring **3** is used within Bash scripts by the select command for generating a menu. The default value is "`#? `".
6. "`PS4`": **P**rompt **S**tring **4** is displayed when a script is run in debug mode, prefixed with "`+`" by default.

In this chapter, we’ll primarily focus on configuring the "`PS1`" prompt. However, the principles we explore can also be applied to customize the other prompt strings.

Lastly, it’s worth noting that the prompts "`PS1`", "`PS2`", "`PS3`", and "`PS4`" were briefly introduced in the Introduction section of this chapter, providing a foundational context for their usage.


## "`PROMPT_COMMAND`"

Before diving into how to configure the Prompt Strings, let's take a closer look at the "`PROMPT_COMMAND`" variable.

This variable can hold a string (or an array of strings) that Bash interprets as a command to execute just before displaying the "`PS1`" prompt. If you're imagining that this means "`PROMPT_COMMAND`" allows you to execute code as a string, you're absolutely correct.

Why not explore a couple of examples to see it in action? Let’s get started!

### String Value

Let’s explore a simple example to understand how the "`PROMPT_COMMAND`" variable works. Imagine you want your terminal to display the current time right before showing the "`PS1`" prompt. To achieve this, you can set the "`PROMPT_COMMAND`" variable to a command that combines echo and date using command substitution.

Here’s how it looks:

```shell
$ PROMPT_COMMAND="echo -n \[\$(date +%H:%M:%S)\]\ "
                          ^ ^                 ^ ^
```

Notice the backslashes used to escape certain characters. These escapes are crucial; without them, the command will simply evaluate to a static string containing the timestamp at the moment you assign the variable. In other words, the "`date`" command will NOT execute dynamically.

If the variable is correctly set with the escape characters, your prompt will display the following:

```shell
$ PROMPT_COMMAND="echo -n \[\$(date +%H:%M:%S)\]\ "
[06:25:43] $
^^^^^^^^^^^
This is the new addition
```

The "`PROMPT_COMMAND`" variable is incredibly flexible—it’s not limited to echo commands. You can include any valid Bash commands or even scripts to customize your prompt further. Let’s consider a more advanced example.

Suppose you want your prompt to indicate whether the last executed command was successful. You can achieve this by assigning a small Bash script to "`PROMPT_COMMAND`":

```bash
 1 #!/usr/bin/env bash
 2 #Script: prompt-0001.sh
 3 PROMPT_COMMAND='
 4 result=$?
 5 if [[ "$result" != "0" ]]; then
 6 echo -n "[Last command: KO] "
 7 else
 8 echo -n "[Last command: OK] "
 9 fi'
```

This script captures the value of the "`$?`" variable (which holds the exit status of the last command). Based on this value, it prints a message indicating whether the previous command succeeded or failed, just before displaying the "`PS1`" prompt.

```shell
$ source prompt-0001.sh
[Last command: OK] $ ls /tmp &>/dev/null
[Last command: OK] $ ls non-existing-file &>/dev/null
[Last command: KO] $
```

In this example:
1. After sourcing the script, the prompt starts showing the result of the last command.
2. Running "`ls /tmp`" (with output redirected to "`/dev/null`") succeeds, so the prompt displays "`[Last command: OK]`".
3. Trying to list a non-existent file results in "`[Last command: KO]`" because the command fails, as expected.

This demonstrates the power and versatility of "`PROMPT_COMMAND`"—it can enrich your terminal experience in countless ways!


### String Array Value

As previously mentioned, the "`PROMPT_COMMAND`" variable can also hold an array of strings, where each element is a command or a small program. These commands are executed sequentially before the main prompt ("`PS1`") is displayed. Let’s look at an example:

```bash
 1 #!/usr/bin/env bash
 2 #Script: prompt-0002.sh
 3 PROMPT_COMMAND=(
 4 "echo -n \"[\$(date +%Y/%m/%d-%H:%M:%S)] \""
 5 'result=$?
 6 if [[ "$result" != "0" ]]; then
 7 echo -n "[Last command: KO] "
 8 else
 9 echo -n "[Last command: OK] "
10 fi'
11 "echo \"\""
12 )
```

In this example, the "`PROMPT_COMMAND`" variable is assigned an array containing three elements, each serving a specific purpose:
1. **Element #1**: Displays the current date and time in the format "`[YYYY/mm/dd-HH:MM:SS]`". For instance, "`[2023/02/28-06:29:00]`".
2. **Element #2**: Indicates whether the last command executed successfully ("`OK`") or failed ("`KO`"), as demonstrated in the previous section.
3. **Element #3**: Adds a new line to enhance readability and improve formatting.

Once the script is sourced into the current terminal session, the prompt behaves as follows:

```shell
$ source prompt-0002.sh
[2024/02/28-06:29:36] [Last command: OK]
$ ls /tmp &>/dev/null
[2024/02/28-06:30:01] [Last command: OK]
$ ls does-not-exist
[2024/02/28-06:30:11] [Last command: KO]
$
```

As shown, each command in the array is executed in the order it is defined, enriching the prompt with useful and dynamically updated information.

## Prompt String 1

The environment variable "`PS1`" is used to define the format of your command prompt. By assigning it a specific string, you can customize how your prompt looks.

For example, let’s create a simple prompt that displays the text "`---Introduce Command--->`" like this:

```shell
$ PS1="---Introduce Command---> "
---Introduce Command---> 
```

In the first line of the example, we assign the value "`---Introduce Command--->`" to the "`PS1`" variable. From that point on, the prompt changes to display this string instead of the default prompt ("`$`").

While this is a basic example, the possibilities with "`PS1`" are virtually endless!

The "`PS1`" variable supports special characters that can dynamically display information such as the current date, username, hostname, and more. You can even customize colors, including both the background and font. And if you want to go further, you can introduce custom functionality by defining your own functions and incorporating them into the prompt using command substitution.

In the upcoming sections, we’ll explore:
* Special characters
* Changing colors (background and font)
* Using command substitution to enhance your prompt with additional information

### Special Characters

The Bash shell is able to recognize special characters that provide information about your system. The following table provides an overview of the special characters available to you:

{% raw %}
| Special Character | Description |
| :----: | :----- |
| `\A` | The current time with the format `HH:MM` and 24-hour. For example: `15:23` |
| `\a` | This character tells the shell to play a beep sound through the speakers. | 
| `\D{format}` | This will show the current date in the specified format given. “format” should be replaced by any format code that “strftime”<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a> admits. For example, “`\D{%d.%m.%Y}`” will display the day of the month followed by the month followed by the year (e.g: “`08.02.2012`”) |
| `\d` | Shows the current date with the format “Weekday Month Day-of-the-month”. For example: '`Tue Feb 21`' | 
| `\e` | An ASCII escape character. This is used to print special characters. It is equivalent to “`\033`” but in octal representation. |
| `\H` | The full hostname |
| `\h` | The hostname up to the first `.` dot. |
| `\j` | The number of jobs currently managed by the shell. |
| `\l` | The basename of the shell's terminal device. |
| `\n` | A newline character. |
| `\r` | A carriage return character. | 
| `\s` | The name of the shell, the basename of `$0`. For example: “`-bash`” (in the case of a **login shell**) or ”`bash`” (in the case of a **non-login shell**) |
| `\T` | The current time in 12-hour "`HH:MM:SS`" format. | 
| `\t` | The current time in 24-hour "`HH:MM:SS`" format. |
| `\u` | The username of the current user. |
| `\V` | The release of bash, with the patch level. For example: “`5.1.16`”. |
| `\v` | The version of Bash. For example: “`5.1`”. |
| `\W` | The current working directory name (rather than the entire path as is used for "`\w`"). For example: “`Pictures`”. |
| `\w` | The current working directory, with `$HOME` abbreviated with a “`~`” tilde symbol. For example: “`~/Pictures`”. |
| `\@` | The current time in 12-hour am/pm format. |
| `\!` | The history number of this command. |
| `\#` | The command number of this command. | 
| `\$` | The `$` dollar symbol, unless we are a super-user, in which case the `#` hash symbol is used. |
| `\nnn` | The character corresponding to the octal number “`nnn`”, used to show special characters. |
| `\\` | A "`\`" backslash character. |
| `\[` | The 'start of non-printing characters' sequence. |
| `\]` | The 'end of non-printing characters' sequence. |
{% endraw %}

Now we are going to use some of these special characters to create a custom prompt string.

Our custom format is going to contain:
* Time with hours minutes and seconds
* The username of the current user
* The full hostname
* The “`@`” character
* The path of the current working directory
* The dollar sign before the command to be run
* A space

As this is quite a lot of information to be shown in one single line along with the command to be run, we will put the dollar sign and the command in a separate line.

To accomplish this we are going to create a small script that we will source into our shell.

```bash
 1 #!/usr/bin/env bash
 2 #Script: prompt-0003.sh
 3 PS1="\n\t \u@\H \w\n\$ "
```

<pre>
$ source prompt-0003.sh

06:23:25 username@hostname ~/Repositories/bash_in_depth/_bash-in-depth/chapters/0032-Customizing-The-Prompt/script
$ 
</pre>

### How does PS1 get evaluated?

When Bash reads the value of the PS1 variable from its declaration (e.g., in the "`.bashrc`" file), it interprets the string and processes it to produce the desired result. This involves several steps of decoding and evaluation.

Let’s explore this process with a specific example. Suppose the "`PS1`" variable is set as follows:

```bash
PS1="\u@\h:\W \$(echo "hello there!")\$ "
              ^______________________^
              Note the use of escape characters
```

When Bash sources the file containing this line, it initially interprets the string and produces the following intermediate value:

```txt
\u@\h:\W $(echo "hello there!")$
```

Notice that the escape characters preceding the dollar signs are removed. This interpreted string will then be evaluated by Bash every time the prompt is displayed. Before the prompt appears, Bash performs a series of substitutions to produce the final output.

<strong>Step 1: Replace Special Characters</strong>

Bash begins by replacing the special placeholders in the string:
* "`\u`" is replaced with the current username.
* "`\h`" is replaced with the hostname, truncated at the first dot.
* "`\W`" is replaced with the name of the current working directory.

For example, this could result in:

```txt
username@hostname:directory $(echo "hello there!")$
```

<strong>Step 2: Perform Expansions and Substitutions</strong>

Next, Bash processes the remaining parts of the string:
* Parameter expansion
* Command substitution
* Arithmetic expansion
* Quote removal

In this example, "`$(echo "hello there!")`" is evaluated, resulting in:

```txt
username@hostname:directory hello there!$
```

This final output represents the customized prompt displayed in the terminal.

<strong>Summary of the Process</strong>

To summarize, here’s what happens step by step:
1. Bash sources the file containing the "`PS1`" variable.
2. It decodes the value of "`PS1`".
3. Each time the prompt is about to be displayed, Bash performs the following:
    * **Special character replacement** (e.g., "`\u`", "`\h`", "`\W`").
    * **Expansions and substitutions**, including parameter expansion, command substitution, arithmetic expansion, and quote removal.
4. Finally, the processed value of "`PS1`" is printed as the prompt.

<strong>Beyond Special Characters</strong>

In addition to special placeholders, you can further customize your prompt by adding colors, changing the background, or even including emojis. The next section will explore these advanced customizations.


## Changing the color and text formatting

In the earlier sections of this chapter, we explored how to customize various prompt strings by modifying the values of the "`PS0`", "`PS1`", "`PS2`", "`PS3`", and "`PS4`" variables.

Beyond altering the content of these prompts, Bash also allows us to customize their appearance by changing the text color and formatting. This is achieved using special sequences of characters that Bash interprets to apply the desired styling.

<strong>The Special Formatting Sequence</strong>

To apply formatting, you use a specific sequence of characters that begins the desired style. For example:

<div style="text-align:center">
    <img src="/assets/bash-in-depth/0032-Customizing-The-Prompt/Escape-Sequence-For-Formatting-The-Text.png"/>
</div>

Once this sequence is inserted into the prompt, the specified format will remain active until you explicitly stop it. To reset the formatting, a separate special sequence is used, as shown below:

<div style="text-align:center">
    <img src="/assets/bash-in-depth/0032-Customizing-The-Prompt/Equivalent-Escape-Sequences.png" width="300"/>
</div>

<strong>Formatting Rules and Order of Application</strong>

When using these special sequences to style your prompt, the order of application is important. Follow these steps to ensure the formatting is applied correctly:
1. **Set the Background Color**: Apply the desired background color first, if needed.
2. **Set the Text Color**: Specify the foreground (text) color next.
3. **Print the Styled Text**: Display the text using the applied formatting.
4. **Reset the Format**: Use the reset sequence to revert to the default formatting.

By following this order, you can ensure that your prompt's appearance is styled as intended.

Now we are going to create a version of the script "`prompt-0003.sh`" to color the output.

The new script is as follows:

```bash
 1 #!/usr/bin/env bash
 2 #Script: prompt-0004.sh
 3 TIME="\e[0;47m\e[1;34m\t\e[0m"
 4 USER="\e[1;31m\u\e[0m"
 5 HOST="\e[0;44m\e[4;32m\H\e[0m"
 6 CURRENT_DIR="\e[1;33m\e[1;40\w\e[0m"
 7 PS1="\n${TIME} ${USER}@${HOST} ${CURRENT_DIR}\n$ "
```

In the previous script, we assigned the different fields we wanted to style to separate variables. This approach made the code more readable and avoided a long, hard-to-decipher string of characters. Each variable was configured with its desired color and formatting. Here's how we set them up:
* "`TIME`": White background with bold blue text.
* "`USER`": Bold red text.
* "`HOST`": Blue background with underlined green text.
* "`CURRENT_DIR`": Bold yellow text with black background.

When you source the "`prompt-0004.sh`" into your Bash terminal you will see something like the following:

<pre style="background-color:black">
<span style="font-weight: bold; color: white">$</span> <span style="font-weight: bold; color: yellow">source</span> <span style="color: white">prompt-0004.sh</span>

<span style="background-color: white; color: blue; font-weight: bold;">05:53:09</span> <span style="color: red; font-weight: bold;">username</span><span style="font-weight: bold; color: white">@</span><span style="background-color: blue; color: green; text-decoration: underline;">hostname</span> <span style="background-color: black; color: yellow; font-weight: bold;">~/Repositories/bash-in-depth/_bash-in-depth/chapters/0032-Customizing-The-Prompt/script</span>
<span style="font-weight: bold; color: white">$</span>
</pre>

Configuring prompt strings is both simple and highly flexible. Not only can you customize their color and formatting, but you can also enhance them by incorporating additional information. This is achieved by executing commands and using their output directly in the prompt string.

Shall we explore some examples in the next section?

## Using command substitution in the prompt string

Sometimes, you may need a more advanced configuration for your "`PS1`" prompt. For instance, you might want to:
* Display the current branch of your Git repository.
* Show the current date in a custom format.
* Include additional information about the current directory, such as its total size.
* And much more!

These and countless other use cases can be achieved by incorporating command substitution into your "`PS1`".

The approach you take will depend on the complexity of the desired behavior:
* For **simple tasks**, you can use commands directly within command substitution.
* For **more complex tasks**, it's better to define a function in one of Bash's configuration files and source it.

Let’s explore examples of both methods in the following subsections!

### Simple behavior with command substitution

Imagine you want your "`PS1`" prompt to display the number of files in the current working directory. To achieve this, you can use the command "`ls`" (to list files) and pipe its output to "`wc -l`" (to count the number of lines). This results in the command:

```bash
    ls | wc -l
```

<strong>How to Include This in Your `PS1`</strong>

It’s simple! Modify your "`PS1`" definition in the configuration file to include command substitution for counting files. Suppose your current "`PS1`" is:


```bash
    PS1="\u@\H:\w\$ "
```

This displays:
* The username ("`\u`")
* The full hostname ("`\H`")
* The current working directory ("`\w`")
* A dollar symbol ("`\$`") followed by a space

For example:

<pre>
username@hostname:~$ 
</pre>

To include the file count in the format like the following:

<pre>
username@hostname:~[NumFiles:123]$ 
</pre>


Yo need to update "`PS1`" as follows:

```bash
PS1="\u@\H:\w[NumFiles:\$(ls | wc -l)]\$ "
             ^^^^^^^^^^^^^^^^^^^^^^^^^
```

Once you source this configuration, the terminal will display the expected result with the file count dynamically updated.

### Not so simple behavior with command substitution

When the desired behavior for your "`PS1`" is too complex for a simple command substitution, the best solution is to create a function and call it within the substitution.

For example, suppose you want your prompt to display the number of items (files and folders) in the current directory, but only if there are 10 or fewer. If there are more than 10, it should display "`TOO MANY`." To achieve this, you can write a function to handle the logic and ensure it’s available to your shell<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a>.

Add the following snippet to your "`.bashrc`" file:

```bash
...
_number_of_items_in_folder() {
    local numberItems=$(ls | wc -l)
    if (( numberItems > 10 )); then
        echo "[ TOO MANY ]"
    else
        echo "[ NumFiles: $numberItems ]"
    fi
}

PS1="\u@\H:\w\$(_number_of_items_in_folder)\$ "
      #        ^^^^^^^^^^^^^^^^^^^^^^^^^^^
      #           Calls the function

```

After sourcing this file, the prompt will adapt based on the number of items:

* If 10 or fewer:

```shell
username@hostname:~[ NumFiles:7 ]$
```

* If more than 10:

```shell
username@hostname:~[ TOO MANY ]$
```

This approach allows you to implement as much complexity as needed within the function. However, keep in mind that the function will execute every time the prompt is rendered. For a better user experience, aim to keep the function lightweight and fast.


## Where to put the configuration

So far, we've explored how to configure the various prompt strings available in Bash.

Now, let’s discuss where you should place these configurations for the best results. The choice depends on a few key questions:
1. **Are you the administrator of the machine?**
    * **Yes** (You have full access to the operating system):
        * Do you want the same prompt for all users?
            * Use "`/etc/profile`" or "`/etc/bashrc`".
            * Keep in mind, users can override the default prompt by customizing their own "`.bashrc`".
    * **No** (You only have access to your own configuration):
        * Use "`~/.bash_profile`" or "`~/.bashrc`".

By placing your prompt configuration in the appropriate file, you can ensure it applies at the correct scope—either system-wide or just for your user account.

## Summary

Customizing the Bash prompt involves configuring several prompt variables to personalize and enhance your command-line experience. These variables include "`PROMPT_COMMAND`", "`PS0`", "`PS1`", "`PS2`", "`PS3`", and "`PS4`", each serving a distinct purpose. "`PS1`" is the primary prompt string, displayed before every command, while "`PS0`" appears before each interactive line of input. "`PS2`" is shown when a command spans multiple lines, and "`PS3`" is used when prompting for input in a select command. Lastly, "`PS4`" helps in debugging scripts by showing trace output for commands executed in the shell. The "`PROMPT_COMMAND`" variable, on the other hand, allows you to execute a command before displaying the "`PS1`" prompt, offering an additional layer of customization.

Special characters can be used within prompt strings to display dynamic information. For instance, "`\u`" represents the current username, "`\h`" displays the hostname, "`\w`" shows the current working directory, and "`\$`" indicates the user’s privilege level ("`$`" for regular users and "`#`" for root). These placeholders make it easy to construct informative and meaningful prompts without requiring additional commands or scripts.

To further enrich your prompt, you can incorporate **command substitution**. This allows you to dynamically execute and display the output of commands directly within the prompt. For example, you can display the current Git branch, the number of files in the working directory, or the current date in a specific format. If the logic for the command substitution is simple, you can embed it directly into the prompt string. For more complex behaviors, defining a function in your Bash configuration file and calling it from within the prompt ensures better readability and maintainability. It’s important to keep these functions efficient, as they are executed every time the prompt is displayed.

Customizing the colors and text formatting of your prompt adds an aesthetic and functional element to its design. Using ANSI escape sequences, you can change text and background colors, apply bold or underlined styles, and even reset formatting at specific points. For example, you can highlight the time with a bold blue font on a white background, underline the hostname with a blue background, or emphasize the current working directory with bold yellow text. Proper use of escape sequences ensures that formatting applies only where intended and does not interfere with command output.

Finally, the placement of your prompt configuration determines its scope. If you are an administrator and want system-wide settings, you can place the configuration in files like "`/etc/profile`" or "`/etc/bashrc`". Individual users can override these settings in their personal files, such as "`~/.bashrc`" or "`~/.bash_profile`", if they only wish to customize their own shell. By understanding these tools and approaches, you can create a highly functional and visually appealing Bash prompt tailored to your preferences and workflow.


*"Master your prompt, and you'll master the rhythm of your workday."*

## References

1. <https://apps.timwhitlock.info/emoji/tables/unicode>
2. <https://effective-shell.com/part-5-building-your-toolkit/customising-your-command-prompt/>
3. <https://linux.101hacks.com/ps1-examples/change-prompt-background-color/>
4. <https://stackoverflow.com/questions/3058325/what-is-the-difference-between-ps1-and-prompt-command>
5. <https://stackoverflow.com/questions/55235564/command-substitution-in-ps1-doesnt-update-when-it-should-cached-output>
6. <https://tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html>
7. <https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html>
8. <https://www.howtogeek.com/307701/how-to-customize-and-colorize-your-bash-prompt/>
9. <https://www.thegeekstuff.com/2008/09/bash-shell-take-control-of-ps1-ps2-ps3-ps4-and-prompt_command/>
10. <https://www.unicode.org/emoji/charts/full-emoji-list.html>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">
<p id="footnote-1" style="font-size:10pt">
1. For more information about the available formats consult “<code style="font-size:10pt">man strftime</code>” in your command line.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. You could declare this function inside one of the configuration files. For instance inside “<code style="font-size:10pt">.bashrc</code>” in your home folder.<a href="#footnote-2-ref">&#8617;</a>
</p>

