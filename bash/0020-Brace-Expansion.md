---
layout: chapter
title: "Chapter 20: Brace Expansion"
---

# Chapter 20: Brace Expansion

## Index
* [Basic Brace Expansion]({{ site.url }}//bash-in-depth/0020-Brace-Expansion.html#basic-brace-expansion)
* [Combining and Nesting]({{ site.url }}//bash-in-depth/0020-Brace-Expansion.html#combining-and-nesting)
    * [Combining Brace Expansions]({{ site.url }}//bash-in-depth/0020-Brace-Expansion.html#combining-brace-expansions)
    * [Nesting Brace Expansions]({{ site.url }}//bash-in-depth/0020-Brace-Expansion.html#nesting-brace-expansions)
* [Summary]({{ site.url }}//bash-in-depth/0020-Brace-Expansion.html#summary)
* [References]({{ site.url }}//bash-in-depth/0020-Brace-Expansion.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

Brace expansion in Bash is a powerful feature that enables you to generate multiple strings or file paths with minimal typing. By using curly braces "`{}`" and placing a comma-separated list or a sequence inside them, you can create multiple combinations in a single expression, making it a helpful tool for automating repetitive tasks, such as batch renaming files or creating directories.

For example, "`{A,B,C}`" will expand to "`A B C`", while "`{1..3}`" will expand to "`1 2 3`". Combining expansions, such as "`file{1..3}.txt`", results in "`file1.txt file2.txt file3.txt`". You can even nest brace expansions, like "`file{A,B}{1,2}`", to produce combinations such as "`fileA1 fileA2 fileB1 fileB2`".

Brace expansion is processed by the Bash shell before any other expansion, like variable expansion or pathname expansion, which means it can work with a variety of commands, especially those that operate on lists of items. For example, "`mkdir -p /path/to/{dir1,dir2,dir3}`" would create "`dir1`", "`dir2`", and "`dir3`" under "`/path/to/`" with **a single command**. This feature is particularly useful in shell scripting for loops and automating repetitive command sequences efficiently.

## Basic Brace Expansion

Brace expansion in Bash allows for flexible string and sequence generation in various formats.

* String Lists "`{string1,string2,...,stringN}`"
Brace expansion with strings generates a list of N strings from the values within the braces, such as "`{one,two,three}`", producing "`one two three`". This method can also be used for repetitions. For instance, "`command -v -v -v -v -v`" can be simplified to "`command -v{,,,,}`", as each comma indicates an empty value that Bash repeats.

* Ranges "`{<start>..<end>}`"
In range-based expansion, "`<start>`" and "`<end>`" can be numbers or characters. Here are the main patterns and examples:

<table>
  <tr>
    <th>Start</th>
    <th>End</th>
    <th>Example</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>Integer</td>
    <td>Integer</td>
    <td><code>{1..23}</code></td>
    <td>Prints numbers from 1 to 23, inclusive.</td>
  </tr>
  <tr>
    <td>Integer</td>
    <td>Character</td>
    <td><code>{6..a}</code></td>
    <td>Prints characters from 6 to a in ASCII order.</td>
  </tr>
  <tr>
    <td>Character</td>
    <td>Integer</td>
    <td><code>{Q..0}</code></td>
    <td>Prints characters from Q to 0 in ASCII order.</td>
  </tr>
  <tr>
    <td>Character</td>
    <td>Character</td>
    <td><code>{Q..q}</code></td>
    <td>Prints characters from Q to q in ASCII order.</td>
  </tr>
</table>


* Ranges with Increment "`{<start>..<end>..<inc>}`"
Similar to standard ranges, this method adds a "`<step>`" argument, allowing custom intervals. For example, "`{a..z..2}`" will produce every second letter from "`a`" to "`z`". When using "`{<start>..<end>..1}`", it operates the same as a standard range.


* Prefix and Suffix Expansion
Brace expansion can also generate prefixed or suffixed strings. For example, "`<PREFIX>{...}`" like "`Val_{1..3}`" outputs "`Val_1 Val_2 Val_3`". Likewise, "`{...}<SUFFIX>`" such as "`{a..c}_item`" yields "`a_item b_item c_item`". Finally, adding both, "`<PREFIX>{...}<SUFFIX>`" like "`One_{a..c}_Value`", produces "`One_a_Value One_b_Value One_c_Value`".

Let's practice some of the above with an example script<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>.

```bash
 1 #!/usr/bin/env zsh
 2 #Script: brace-expansion-0001.sh
 3 # Numeric range
 4 echo "Numbers from 1 to 23: "
 5 echo {1..23}
 6 # Integer start and Character ending
 7 echo "Characters from '6' to 'a': "
 8 echo {6..a}
 9 # Character start and Integer ending
10 echo "Characters from '0' to 'Q': "
11 echo {0..Q}
12 # Character range
13 echo "Characters from 'Q' to 'q': "
14 echo {Q..q}
```

When you execute the previous script you will receive the following output in your terminal window.

```txt
$ ./brace-expansion-0001.sh
Numbers from 1 to 23:
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
Characters from '6' to 'a':
6 7 8 9 : ; < = > ? @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ] ^ _ ` a
Characters from '0' to 'Q':
0 1 2 3 4 5 6 7 8 9 : ; < = > ? @ A B C D E F G H I J K L M N O P Q
Characters from 'Q' to 'q':
Q R S T U V W X Y Z [ \ ] ^ _ ` a b c d e f g h i j k l m n o p q
```

## Combining and Nesting

In the previous section, we explored the basics of brace expansion, which allows for the efficient generation of patterned strings with minimal keystrokes. In this section, we'll dive into how combining two or more brace expansions can create a wide range of values and how nesting expansions can streamline complex patterns.

### Combining Brace Expansions

When combining multiple brace expansions in a single expression, every possible combination of each expansion is generated. For example.

```bash
{% raw %}
    echo {0..9}{0..9}
{% endraw %}
```

The previous command produces every value from "`00`" to "`99`", totaling 100 possible combinations.

```bash
 1 #!/usr/bin/env bash
 2 #Script: brace-expansion-0002.sh
 3 # All combinations of [0-9][0-9]
 4 echo "All combinations of [0-9][0-9]."
 5 echo {0..9}{0..9}
```

When you run the previous script you will have the following output in your terminal window.

```txt
$ ./brace-expansion-0002.sh
All combinations of [0-9][0-9].
00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99
```

### Nesting Brace Expansions

Nesting brace expansions is a powerful way to concatenate multiple expansions without generating all possible combinations. This approach sums rather than multiplies the generated values. For example.

```bash
{% raw %}
    echo {{A..Z},{0..9}}
{% endraw %}
```

The previous command produces every uppercase letter from "`A`" to "`Z`", followed by each digit from "`0`" to "`9`". This is an efficient way to produce sequential lists without combining all options.

```bash
{% raw %}
 1 #!/usr/bin/env bash
 2 #Script: brace-expansion-0003.sh
 3 # Concatenating 2 lists
 4 echo "All uppercase letters followed by all single digit numbers"
 5 echo {{A..Z},{0..9}}
{% endraw %}
```

When you excute the previous script you will get the following output in your terminal window.

```txt
$ ./brace-expansion-0003.sh
All uppercase letters followed by all single digit numbers
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9
```


## Summary

Brace expansion in Bash is a powerful tool that generates strings that follow specific patterns, simplifying the creation of repetitive or sequential lists with minimal code. Brace expansion can be used to generate lists, such as multiple file names, by specifying a sequence of strings within curly braces. For example, "`{A,B,C}`" would expand to generate "`A`", "`B`", and "`C`". This functionality can be extended for repeating values, such as generating identical flags or parameters in commands, making it highly flexible for various scripting needs.

The feature can also handle numerical and alphabetical ranges, supporting both increments and character spans. By specifying a start and end point, such as "`{1..5}`", brace expansion will generate each value within that range. Additionally, brace expansion supports both prefixes and suffixes, allowing specific patterns to be applied to each generated string. Combining or nesting multiple expansions enables complex patterns: combining multiple braces generates every combination of values, while nesting them sequentially appends multiple groups of values, without multiplying combinations. This allows for the generation of structured lists, sequential numbering, and pattern customization in an efficient and versatile manner.

"*Learning Brace Expansion in Bash is like unlocking a code—it’s the key to faster, more efficient scripts that save you time and energy!*"

## References

1. <https://linuxhandbook.com/brace-expansion/>
2. <https://www.geeksforgeeks.org/bash-brace-expansion-in-linux-with-examples/>
3. <https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html>
4. <https://www.linuxjournal.com/content/bash-brace-expansion>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">
<p id="footnote-1" style="font-size:10pt">
1. For full disclosure I tried to use "<code style="font-size:9pt">bash</code>" in the prompt but it didn't work, so I used "<code style="font-size:9pt">zsh</code>" to make the script work. I will investigate why using Bash didn't work and will put my findings in this chapter.<a href="#footnote-1-ref">&#8617;</a>
</p>

