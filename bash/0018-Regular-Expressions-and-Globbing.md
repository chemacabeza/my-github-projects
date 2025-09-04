# Chapter 18: Regular Expressions and Globbing

Regular expressions, or regex, in Bash are a powerful tool for pattern matching and string manipulation. They allow you to search, replace, and validate strings based on complex patterns. Learning regex is crucial for any developer working with text processing in Bash, as it enables efficient data extraction and automation of tasks like log parsing, input validation, and file manipulation. With regular expressions, you can define precise patterns to match specific parts of strings, which makes it easier to handle repetitive tasks without writing verbose code.

Understanding regular expressions can significantly enhance your scripting capabilities in Bash, making you more efficient and enabling you to tackle complex tasks with fewer lines of code. Some key use cases include:
1. **Log file analysis**: Regex can help identify specific error messages or extract timestamps from log files based on a pattern.
2. **Input validation**: You can validate user input (e.g., checking if an email or phone number follows the correct format) to prevent errors or malicious entries.
3. **Text search and replace**: Regex can simplify search-and-replace operations across multiple files by matching patterns like email addresses or dates, rather than exact strings.

Mastering regular expressions allows you to automate tedious tasks and greatly enhance your problem-solving ability in Bash scripting.

Globbing in Bash refers to the process of using wildcard characters<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a> to match file names and paths in a file system. Unlike regular expressions, which allow complex pattern matching, globbing is simpler and focuses on basic filename expansion. Bash uses special characters such as "`*`", "`?`", and "`[]`" for globbing. For example, "`*`" matches any sequence of characters, "`?`" matches a single character, and "`[]`" matches any one of the enclosed characters.

Globbing is particularly useful when you need to operate on multiple files at once without explicitly specifying each one. For instance, the pattern "`*.txt`" would match all files with the "`.txt`" extension, while "`file?.sh`" would match filenames like "`file1.sh`" or "`fileA.sh`". Understanding globbing allows you to write more flexible and efficient Bash scripts for handling files.

## How to use regular expressions?

The way to use pattern matching with regular expressions is by using the operator "`=~`" like this.

```bash
    value =~ RegExp
```

The "`value`" is basically the string you are trying to verify against a regular expressions this string **should always be at the left of the of the operator** "`=~`". 

The "`RegExp`" is the regular expression we are matching our string "`value`" against to. The regular expression **should always be at the right of the operator** "`=~`".

As you can imagine the operator "`=~`" will return either "`true`" if **the string does match** the pattern in the regular expression or "`false`" if **the string does not match** the pattern in the regular expression.

This means that you can use the operator "`=~`" in an "`if`" statement. If you remember from [Chapter 10 we learnt different ways to test]({{ site.url }}/bash-in-depth/0010-If-statement.html#how-to-test-stuff) in an "`if`" statement.

Just to remember a bit of Chapter 10 we saw the following 3 ways to test conditions in an "`if`" statement.

The first one was.

```bash
    if test ...; then
        commands;
    fi
```

The second one was.

```bash
    if [ ... ]; then
        commands;
    fi
```

The limitation that exists with these two ways is that they do not support pattern matching nor the “`=~`” operator. 

To be able to use the "`=~`" operator we need to use the third way which is the one that follows.

```bash
    if [[ $value =~ RegExp ]]; then
        commands;
    fi
```

Now that we know what "`if`" statement we need to use we are going to learn what are the different wildcard characters and different patterns that we can use in a regular expression in Bash.

## Wildcard Character and Patterns

A regular expression can be formed with the elements that appear in the following table.

<table>
  <thead>
    <tr>
      <th style="text-align: center">Element</th>
      <th style="text-align: left">Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">a..z</code></td>
      <td style="text-align: left">Matches the lowercase alphabetical letters</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">A..Z</code></td>
      <td style="text-align: left">Matches the uppercase alphabetical letters</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">0..9</code></td>
      <td style="text-align: left">Matches numbers</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">*</code></td>
      <td style="text-align: left">Special character that matches any number of repeats of the character string or RE preceding it, including zero instances</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">.</code></td>
      <td style="text-align: left">Special character that matches any one character, except a newline</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">^</code></td>
      <td style="text-align: left">Special character that matches the beginning of a line, but sometimes, depending on context, negates the meaning of a set of characters in a Regular Expression</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">$</code></td>
      <td style="text-align: left">At the end of a Regular Expression this Special character matches the end of a line</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">[...]</code></td>
      <td style="text-align: left">Enclose a set of characters to match in a single Regular Expression. <ul><li>“<code class="language-plaintext highlighter-rouge">[xyz]</code>” matches any one of the characters <code class="language-plaintext highlighter-rouge">x</code>, <code class="language-plaintext highlighter-rouge">y</code>, or <code class="language-plaintext highlighter-rouge">z</code>.</li><li>“<code class="language-plaintext highlighter-rouge">[c-n]</code>” matches any one of the characters in the range <code class="language-plaintext highlighter-rouge">c</code> to <code class="language-plaintext highlighter-rouge">n</code>.</li><li>“<code class="language-plaintext highlighter-rouge">[B-Pk-y]</code>” matches any one of the characters in the ranges <code class="language-plaintext highlighter-rouge">B</code> to <code class="language-plaintext highlighter-rouge">P</code> and <code class="language-plaintext highlighter-rouge">k</code> to <code class="language-plaintext highlighter-rouge">y</code>.</li><li>“<code class="language-plaintext highlighter-rouge">[a-z0-9]</code>” matches any single lowercase letter or any digit.</li><li>“<code class="language-plaintext highlighter-rouge">[^b-d]</code>” matches any character except those in the range <code class="language-plaintext highlighter-rouge">b</code> to <code class="language-plaintext highlighter-rouge">d</code>. This is an instance of <code class="language-plaintext highlighter-rouge">^</code> negating or inverting the meaning of the following Regular Expression (taking on a role similar to <code class="language-plaintext highlighter-rouge">!</code> in a different context). “<code class="language-plaintext highlighter-rouge">[!b-d]</code>” is equivalent to the previous one, which means that in this context “<code class="language-plaintext highlighter-rouge">^</code>” and “<code class="language-plaintext highlighter-rouge">!</code>” are used to negate. Combined sequences of bracketed characters match common word patterns.</li><li>“<code class="language-plaintext highlighter-rouge">[Yy][Ee][Ss]</code>” matches <code class="language-plaintext highlighter-rouge">yes</code>, <code class="language-plaintext highlighter-rouge">Yes</code>, <code class="language-plaintext highlighter-rouge">YES</code>, <code class="language-plaintext highlighter-rouge">yEs</code>, and so forth.</li><li>“<code class="language-plaintext highlighter-rouge">[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]</code>” matches any Social Security Number in the United States of America.</li></ul></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">\</code></td>
      <td style="text-align: left">When put before a special character, it will tell Bash to interpret the special character literally without its “special” meaning.</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">?</code></td>
      <td style="text-align: left">Special character that matches zero or one of the previous character in the Regular Expression. It is generally used for matching single characters.</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">+</code></td>
      <td style="text-align: left">Special character that matches one or more of the previous RE. It serves a role similar to the <code class="language-plaintext highlighter-rouge">*</code>, but does not match zero occurrences.</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">{&lt;number&gt;}</code></td>
      <td style="text-align: left">Indicates the number of occurrences of a preceding Regular Expression to match. It is necessary to escape the curly brackets since they have only their literal character meaning otherwise. This usage is technically not part of the basic Regular Expression set.</td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">(..)</code></td>
      <td style="text-align: left">Enclose a group of Regular Expressions. They are useful with the following “<code class="language-plaintext highlighter-rouge">|</code>” operator and in substring extraction using <code class="language-plaintext highlighter-rouge">expr</code></td>
    </tr>
    <tr>
      <td style="text-align: center"><code class="language-plaintext highlighter-rouge">|</code></td>
      <td style="text-align: left">“or” Regular Expression operator matches any of a set of alternate characters.</td>
    </tr>
  </tbody>
</table>

With the previous wildcard characters we are going to write a few scripts to practice.

The first script is the following.

```bash
#!/usr/bin/env bash
#Script: regexp-0001.sh
# Read input
echo -n "Enter input: "
read input
while [[ "$input" != "exit" ]]; do
    echo "Inside the loop. Input was '$input'"
    if [[ "${#input}" > 1 ]]; then
        echo "Please introduce a single character."
    else
        if [[ "$input" =~ [a..z] ]]; then
            echo "The input is a single lowercase character"
        elif [[ "$input" =~ [A..Z] ]]; then
            echo "The input is a single UPPERCASE character"
        elif [[ "$input" =~ [0-9] ]]; then
            echo "The input is a single number"
        else
            echo "None of the previous regular expressions matched"
        fi
    fi
    echo -n "Enter input: "
    read input
done
echo "Exiting program"
```

In the previous script we require the user to enter a single character as input. Once the input is introduced the execution will enter a loop (lines 6 to 19) on which it will check different patterns.

On line 11, the script will check if the character introduced is a single lowercase alphabetical character. 

On line 13, the script will check if the character introduced is a single uppercase alphabetical character.

On line 15, the script will check if the character introduced is a single digit number.

Finally, on line 18, will go the rest of the character that do not match the previous regular expressions.

Let's see what happens when we execute the previous script.

```txt
$ ./regexp-0001.sh
Enter input: a
Inside the loop. Input was 'a'
The input is a single lowercase character
Enter input: Z
Inside the loop. Input was 'Z'
The input is a single UPPERCASE character
Enter input: 1
Inside the loop. Input was '1'
The input is a single number
Enter input: ?
Inside the loop. Input was '?'
None of the previous regular expressions matched
Enter input: exit
Exiting program
```

In the next script we are going to play with repetitions using "`{..}`".

```bash
#!/usr/bin/env bash
#Script: regexp-0002.sh
# Read input
echo -n "Enter input: "
read input
while [[ "$input" != "exit" ]]; do
    echo "Inside the loop. Input was '$input'"
    if [[ "$input" =~ ^a{1}$ ]]; then
        echo "The input was a single 'a'"
    elif [[ "$input" =~ ^a{2}$ ]]; then
        echo "The input was a double 'a'"
    elif [[ "$input" =~ ^a{3}$ ]]; then
        echo "The input was a triple 'a'"
    else
        echo "None of the previous regular expressions matched"
    fi
    echo -n "Enter input: "
    read input
done
echo "Exiting program"
```

In the previous script you will notice that we are matching for either "`a`", "`aa`" or "`aaa`". We needed to use "`^`" and "`$`" to match exact strings. If we don't use "`^`" and "`$`" every match will be the first "`if`" statement (lines 8 and 9).

Let's run the previous script and interact with it.

```txt
$ ./regexp-0002.sh
Enter input: a
Inside the loop. Input was 'a'
The input was a single 'a'
Enter input: aa
Inside the loop. Input was 'aa'
The input was a double 'a'
Enter input: aaa
Inside the loop. Input was 'aaa'
The input was a triple 'a'
Enter input: b
Inside the loop. Input was 'b'
None of the previous regular expressions matched
Enter input: exit
Exiting program
```

In the next section we will talk about "`(..)`" and the "`BASH_REMATCH`" array.

## Using the "`(..)`" and the "`BASH_REMATCH`" array

In Bash, parentheses "`(..)`" are used in regular expressions for **capturing groups**, while the "`BASH_REMATCH`" array stores the matches from a regular expression when using the "`[[ ]]`" conditional expression. These features allow you to extract specific portions of a string that match a certain pattern.

In regular expressions, parentheses are used to group parts of a pattern. The main purpose of grouping is to capture substrings that match the pattern inside the parentheses. This enables you to extract these portions separately.

"`BASH_REMATCH`" is a special array in Bash that holds the results of the regular expression match. After you use a regular expression in a "`[[ ]]`" expression with grouping parentheses, the full match is stored in "`BASH_REMATCH[0]`", and each capturing group is stored in subsequent elements ("`BASH_REMATCH[1]`", "`BASH_REMATCH[2]`", etc.).

In the next script we will parse a string that contains an email.

```bash
#!/usr/bin/env bash
#Script: regexp-0003.sh
email="myuser@mydomain.com"
if [[ $email =~ ([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,}) ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"  # Full email
    echo "Username: ${BASH_REMATCH[1]}"    # myuser
    echo "Domain: ${BASH_REMATCH[2]}"      # mydomain
    echo "TLD: ${BASH_REMATCH[3]}"         # com
fi
```

When you run the previous script you will get the following output.

```txt
$ ./regexp-0003.sh
Full match: myuser@mydomain.com
Username: myuser
Domain: mydomain
TLD: com
```

The regex breaks the email into the username, domain, and top-level domain (TLD). The entire match is in "`BASH_REMATCH[0]`", the username in "`BASH_REMATCH[1]`", the domain in "`BASH_REMATCH[2]`", and the TLD in "`BASH_REMATCH[3]`".

In the next script we are going to parse a date.

```bash
#!/usr/bin/env bash
#Script: regexp-0004.sh
date="2024-10-17"
if [[ $date =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"  # Full date
    echo "Year: ${BASH_REMATCH[1]}"    # 2024
    echo "Month: ${BASH_REMATCH[2]}"   # 10
    echo "Day: ${BASH_REMATCH[3]}"     # 17
fi
```

When you run the previous script you will get the following result in your terminal window.

```txt
$ ./regexp-0004.sh
Full match: 2024-10-17
Year: 2024
Month: 10
Day: 17
```

Knowing how to use parentheses and the "`BASH_REMATCH`" array in Bash is invaluable when working with regular expressions and string manipulation. Parentheses allow you to group parts of a regular expression, enabling you to capture specific segments of a string that match a pattern. This is extremely useful when you want to isolate particular pieces of information within a larger string. For example, if you're processing log files and need to extract just the timestamps or usernames, you can use parentheses to capture those segments while ignoring the rest. This grouping enhances the power of regular expressions by letting you focus on specific parts rather than handling entire strings.

The "`BASH_REMATCH`" array complements this functionality by storing the matched portions of a string. When you perform a regular expression match in Bash using "`[[ ... =~ ... ]]`", any subpatterns captured by parentheses are stored in the "`BASH_REMATCH`" array, where "`BASH_REMATCH[0]`" holds the entire matched string, and subsequent indices ("`BASH_REMATCH[1]`", "`BASH_REMATCH[2]`", etc.) store the corresponding captured groups. This feature makes it easy to extract and work with multiple pieces of data from a single string. For instance, when dealing with file paths, you can use parentheses to capture the directory, filename, and extension separately, making string manipulation tasks more efficient and structured.

Understanding how to leverage parentheses and "`BASH_REMATCH`" provides a powerful toolset for text parsing and processing tasks in Bash. By mastering these, you can reduce complexity in your scripts, avoid cumbersome manual string handling, and significantly improve performance when working with large datasets or log files. This skill also translates into cleaner, more maintainable code, especially in scenarios where precision in pattern matching is crucial.

In the next section we will learn about the POSIX character classes.

## POSIX Character Classes

POSIX<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a> character classes in Bash are special constructs used within regular expressions to match specific sets of characters based on categories like digit, alphanumeric, or punctuation. These classes are enclosed in "`[:class:]`" and are often used in the context of pattern matching, allowing for more readable and flexible matching of character types. Unlike wildcards or simple characters, POSIX character classes provide a more comprehensive way to match predefined character groups, improving the power and clarity of your scripts.

By using POSIX character classes, you can write more portable and readable scripts, especially when working across different systems or locales. This is because the classes are part of the POSIX standard, ensuring they work consistently across compliant Unix-like systems.

The following table contains the POSIX classes available to Bash

| POSIX Character Class | Description |
| :-----: | :----- |
| `[:alnum:]` | Matches alphabetic or numeric characters. This is equivalent to "`A-Za-z0-9`" (for example: `hello123`) |
| `[:alpha:]` | Matches alphabetic characters. This is equivalent to "`A-Za-z`" (for example: `hElLo`) |
| `[:ascii:]` | Matches ASCII characters. This is equivalent to "`\x00-\x7F`" (for example: `Hello!`) |
| `[:blank:]` | Matches a space or a tab (for example: "<code>  </code>" ) |
| `[:cntrl:]` | Matches control characters. This is equivalent to "`\x00-\x1F\x7F`" (for example: `\n`) |
| `[:digit:]` | Matches (decimal) digits. This is equivalent to "`0-9`" (for example: `12345`) |
| `[:graph:]` | (graphic printable characters). Matches characters in the range of ASCII 33 - 126. This is the same as "`[:print:]`", below, but excluding the space character (for example: `hello!`) |
| `[:lower:]` | Matches lowercase alphabetic characters. This is equivalent to "`a-z`" (for example: `hello`) |
| `[:print:]` | (printable characters). Matches characters in the range of ASCII 32 - 126. This is the same as "`[:graph:]`", above, but adding the space character (for example: `hello world`) |
| `[:punct:]` | Matches all punctuation characters (all graphic characters except letters and digits). This is equivalent to `-!"#$%&'()*+,./:;<=>?@[]^_{|}~` (for example: `!?.,`) |
| `[:space:]` | Matches whitespace characters (space and horizontal tab) (for example: "` `" or "`\t`") |
| `[:upper:]` | Matches uppercase alphabetic characters. This is equivalent to "`A-Z`" (for example: `HELLO`) |
| `[:xdigit:]` | Matches hexadecimal digits. This is equivalent to "`0-9A-Fa-f`" (for example: `A1F2`) |


In Bash, you need to use "`[[:class:]]`" instead of "`[:class:]`" because "`[:class:]`" is a POSIX character class and **must be enclosed within square brackets to be recognized as a pattern by the regular expression engine**. Without the surrounding brackets, "`[:class:]`" would be interpreted as a literal string, not as a character class.

We are going to rewrite the script "`regexp-0004.sh`" to use POSIX character classes instead.

```bash
#!/usr/bin/env bash
#Script: regexp-0005.sh
date="2024-10-17"
if [[ $date =~ ([[:digit:]]{4})-([[:digit:]]{2})-([[:digit:]]{2}) ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"  # Full date
    echo "Year: ${BASH_REMATCH[1]}"    # 2024
    echo "Month: ${BASH_REMATCH[2]}"   # 10
    echo "Day: ${BASH_REMATCH[3]}"     # 17
fi
```

Now, if you run this last script you will get the exact same result as the script "`regexp-0004.sh`".

```txt
$ ./regexp-0005.sh
Full match: 2024-10-17
Year: 2024
Month: 10
Day: 17
```

Mastering regular expressions empowers your scripts and command-line work, giving you a significant boost in efficiency and capability. These patterns aren't just limited to the "`=~`" operator within an if clause; they can be leveraged in any control structure that evaluates a boolean condition, such as "`if`", "`elif`", "`for`", "`while`", and "`case`". Beyond script logic, regular expressions seamlessly integrate with many commands you've already learned, such as "`ls`", "`find`", "`grep`", and "`cp`", as well as countless others you may encounter. This versatility makes regular expressions an essential skill for simplifying complex tasks and improving your overall workflow.

In the next section we will learn about **Globbing**.

## Globbing

As mentioned before, “Globbing” (also known as “*pathname expansion*”) is a Bash mechanism (it’s not done by the Linux Kernel) for matching file and directory names using “*wildcards*”.

A *Wildcard* is a character that can be used to substitute for another character or a set of characters. As we saw already in the section dedicated to [Wildcard Character and Patterns]({{ site.url }}//bash-in-depth/0018-Regular-Expressions-and-Globbing.html#wildcard-character-and-patterns).

### GLOBIGNORE

"`GLOBIGNORE`" is a special environment variable in Bash that allows you to exclude certain files or patterns from being expanded by globbing. It's a colon-separated list of **patterns** defining the set of filenames to be ignored by the pathname expansion. Globbing is the process by which Bash expands wildcard patterns like "`*`" or "`?`" to match filenames in the current directory. By setting "`GLOBIGNORE`", you can tell Bash to ignore certain files or directories when expanding these patterns.

When "`GLOBIGNORE`" is set, any patterns or filenames listed within it will be excluded from globbing results. This is particularly useful when you want to ignore specific files (like hidden files or backup files) while using globbing patterns like "`*`" to list or work with files in a directory.

In the following script we are going to print the contents of the current directory and we will setup the "`GLOBIGNORE`" to ignore the files that have the "`.sh`" extension, then we will print again the contents of the current directory.

```bash
#!/usr/bin/env bash
#Script: regexp-0006.sh
echo "Printing the files in the current directory"
ls *
echo "Setting GLOBIGNORE to ignore '*.sh' files"
GLOBIGNORE="*.sh"
echo "Printing the files in the current directory"
ls *
echo "End of program"
```

When you run the previous script you will get the following output.

```txt
$ ./regexp-0006.sh
Printing the files in the current directory
regexp-0001.sh  regexp-0002.sh  regexp-0003.sh  regexp-0004.sh  regexp-0005.sh  regexp-0006.sh
Setting GLOBIGNORE to ignore '*.sh' files
Printing the files in the current directory
ls: cannot access '*': No such file or directory
End of program
```

As you will notice in the execution of the previous script on line 4, the files of the current directory are displayed. Then on line 6 we set the environment variable "`GLOBIGNORE`" to ignore the files with extension "`.sh`". Then on line 8 we try to display, again, the files of the current directory but we get the error "`ls: cannot access '*': No such file or directory`". 

Why do we get the error in the second execution of the command "`ls`"? The reason is that when "`GLOBIGNORE`" is set in Bash, it triggers a feature where Bash will automatically exclude the ignored files from the result of globbing patterns (like "`*`"). However, it also triggers a side effect where only non-hidden files are matched by "`*`", unless there are no files left after filtering. If, after applying the "`GLOBIGNORE`" filter, all the remaining files are hidden (like dotfiles), or if no files match, Bash treats the result as an empty list, and hence "`*`" is treated **literally as a filename** (which does not exist). This is why ls "`*`" fails and outputs the "`No such file or directory`" error.

## Summary

Bash regular expressions and globbing are crucial for pattern matching and file manipulation. The "`=~`" operator allows you to match strings against regular expressions in conditionals like "`if`" and "`while`", offering flexibility in validating inputs or filtering patterns. Parentheses in regular expressions create capture groups that can be accessed using the "`BASH_REMATCH`" array, making it useful for extracting specific parts of a string, such as breaking a date into components like year, month, and day. POSIX character classes, such as "`[:digit:]`" and "`[:alpha:]`", are another feature that enhances the precision of regular expressions, ensuring easier and more readable string matching.

In contrast, globbing is used for filename expansion, enabling file matching with wildcard characters like "`*`" and "`?`". Although simpler than regex, it is powerful for tasks such as listing or deleting files. By using the "`GLOBIGNORE`" variable, Bash can exclude specific patterns from file expansions, making file management more streamlined. Mastering these tools allows for increased automation and flexibility in Bash scripting, leading to more efficient workflows for parsing data and managing files.

In the world of Bash scripting, regular expressions are a superpower. Harness them to make your code not just functional, but exceptional.

## References

1. <https://kodekloud.com/blog/regex-shell-script/>
2. <https://mywiki.wooledge.org/BashGuide/Patterns>
3. <https://stackoverflow.com/questions/1891797/capturing-groups-from-a-grep-regex>
4. <https://www.baeldung.com/linux/regex-inside-if-clause>
5. <https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html>
6. <https://www.linuxjournal.com/content/pattern-matching-bash>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">
<p id="footnote-1" style="font-size:10pt">
1. More on wildcard characters later in this chapter.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. <a href="https://en.wikipedia.org/wiki/POSIX">https://en.wikipedia.org/wiki/POSIX</a>.<a href="#footnote-2-ref">&#8617;</a>
</p>

