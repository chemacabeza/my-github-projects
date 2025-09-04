# Chapter 11: `case-esac` statement

In Bash scripting, the “`case-esac`” statement is a powerful and flexible construct that facilitates the implementation of conditional branching and decision-making logic. It's particularly useful when you need to evaluate a variable or expression against multiple possible values and execute different code blocks based on the matching conditions. Think of the “`case-esac`” statement as a versatile alternative to a series of “`if-elif-else`” statements, designed to simplify and enhance the readability of your scripts.

The “`case-esac`” statement simplifies the process of handling multiple conditional cases in a Bash script. With “`case`”, you can efficiently compare a variable or expression to a list of patterns and execute a code block corresponding to the first match. This is especially handy when you have a variable that can take on various values, and you want to perform different actions based on those values.

One of the standout features of “`case-esac`” is its support for pattern matching. You can specify patterns, often using wildcards, to match a range of possible values. This means you can create complex and expressive conditions, making it a valuable tool for tasks like parsing user input, handling different file types, or managing options in a script.

The “`case-esac`” statement can significantly enhance the readability of your scripts. It's a cleaner and more concise way to manage multiple conditions compared to long sequences of “`if-elif-else`” statements. Each condition is presented in a structured and easy-to-follow format, making your code more maintainable and comprehensible.


## Syntax for `case-esac`

Once we are familiar with `IF-ELSE` clauses, we need to take a look at an alternative to this one, which is the “`case-esac`” clause. So, what is the “*shape*” of this clause? It’s as follows.

```bash
    case "$variable" in
        pattern1)
            # Code to execute if $variable matches pattern1
            ;;
        pattern2)
            # Code to execute if $variable matches pattern2
            ;;
        *)
            # Code to execute if none of the patterns match
            ;;
    esac
```

The idea is that the value of “`$variable`” will be checked against each “*pattern*” (from top to bottom) and it will execute the code of the first pattern that matches. This is done via “word pattern matching” which is via Regular Expressions (we will take a look later at this).

Each pattern in the “`case-esac`” can either be a **literal string**, **wildcards** or a **variable**. We will see examples of both in the coming sections.

You might have noticed that after every block of code that will be executed depending on the pattern there are the following characters “`;;`”. That combination of characters are telling Bash where it needs to stop executing code for the pattern detected<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>.


## How does it work?

We already saw in the previous section that the syntax of the “`case-esac`” statement has different branches that will match a specific pattern.

For example, in the example script shown in the previous section you will see that there are 3 branches. The first branch will match “`pattern1`”, the second branch will match “`pattern2`” and the last branch, with the pattern “`*`”, will match everything that is not matching the other branches. The last branch is optional

The way it works is that Bash will take the value of the variable provided in the case statement and will match it against the different patterns in the different branches from top to bottom and will execute the code of the first pattern that matches the string provided. This means that the order of the different branches does matter.

In the following section we will learn about the different patterns that we can use in the branches of this “`case-esac`” statement.


## Case patterns

As we saw in the previous section the “`case-esac`” statement allows to have different “*cases*” to match the variable. These cases allow different pattern types which are described in the following paragraphs.

### Literal Matching

The first type is **literal matching** where the variable of the “case-esac” statement will be matched against **exact text strings** like “`pattern1`” or “`Burkina Faso`”. Let’s see an example for literal matching with the following script.

```bash
#!/usr/bin/env bash
#Script: case_literal_matching.sh
# Asking the user to enter a country name
echo -n "Enter the name of a country: "
read COUNTRY
# Printing the result
echo -n "The official language of $COUNTRY is "
# Selecting the language of the country
case $COUNTRY in
  Lithuania)
    echo -n "Lithuanian"
    ;;
  Romania | Moldova)
    echo -n "Romanian"
    ;;
  Italy | "San Marino" | Switzerland | "Vatican City")
    echo -n "Italian"
    ;;
  "Burkina Faso")
		echo -n "Bissa / Dyula / Fula"
		;;
  *)
    echo -n "unknown"
    ;;
esac
echo ""
```

What the previous script is doing is to first ask the user to introduce a country, then it reads the country storing it in the variable “`COUNTRY`”. It will then use the variable in the “`case-esac`” statement to determine what is the language spoken in the given country which will be printed to the screen. This is what happens when you run the script and provide “`Romania`” as the country.

```txt
$ ./literal_matching.sh
Enter the name of a country: Romania
The official language of Romania is Romanian
```

You might have noticed that literal strings that are composed of more than a single word (like “`San Marino`” or “`Vatican City`”) need to be enclosed within either single quotes or double quotes so that Bash can detect it as a single string.

In the following section we will take a look at the second pattern that we can use. Which is known as “**Wildcard Matching**”.

### Wildcard Matching

The second type is **wildcard matching** where the variable of the “`case-esac`” statement will be matched against **pattern string** that contain wildcard characters (such as “`*`” and “`?`”). In this case you could have a pattern string like “`*.txt`” that would match any file whose extension is “`txt`”. 

Let’s see how it works with the following script.

```bash
#!/usr/bin/env bash
#Script: case_wildcard_matching.sh
# Asking the user to enter the name of a file
echo -n "Enter the name of a file: "
read FILENAME
# Printing the result
echo -n "The file $FILENAME is a "
# Selecting the right type
case $FILENAME in
    *.txt)
	echo -n "Text file"
	;;
    *.jpg | *.png)
	echo -n "Image file"
	;;
    *.mp3)
	echo -n "Audio file"
	;;
    *)
	echo -n "Unknown file"
	;;
esac
echo ""
```

This script is very similar to the previous one. It first asks the user for some input, then it runs the input through the different options inside the “`case-esac`” statement and then it provides a result. This is what happens when you run the script and provide “`description.txt`” as input.

```txt
$ ./case_wildcard_matching.sh
Enter the name of a file: description.txt
The file description.txt is a Text file
```

The third type is using **character classes** where the variable of the “`case-esac`” statement will be matched against strings that represent groups of characters. For example “`[[:lower:]]`” would represent lower case letters<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a>. Let’s see how it works with the following script.

```bash
#!/usr/bin/env bash
#Script: case_class_matching.sh
# Asking the user for input
echo -n "Enter a single character: "
read INPUT_CHAR
# Making sure than only one character is entered
if [[ ${#INPUT_CHAR} > 1 ]]; then
    echo "You entered more than 1 character";
    exit
fi
# Printing the result
echo -n "The character '$INPUT_CHAR' "
# Selecting the correct input
case $INPUT_CHAR in
    [[:lower:]])
	echo "is a lowercase letter"
	;;
    [[:upper:]])
	echo "is an uppercase letter"
	;;
    [[:digit:]])
	echo "is a digit"
	;;
    *)
	echo "is unknown"
	;;
esac
```

In the previous script we ask the user to introduce a single character then, in lines 7 to 10, the script validates that only a single character has been introduced. After the validation succeeds it checks what kind of character has been introduced by matching it against the different class characters sequences.

Let’s see how it behaves by running the script a few times.

```txt
$ ./case_class_matching.sh
Enter a single character: 1
The character '1' is a digit

$ ./case_class_matching.sh
Enter a single character: w
The character 'w' is a lowercase letter

$ ./case_class_matching.sh
Enter a single character: W
The character 'W' is an uppercase letter

$ ./case_class_matching.sh
Enter a single character: *
The character '*' is unknown
```

In the following section we are going to learn about one of the most powerful matchings that we have in this “`case-esac`” statement, the regular expression matching.


### Regular Expression Matching

Last, but not least, you can use **regular expressions** where the variable of the “`case-esac`” statement will be matched against a string that is a regular expression. For example, the sequence of characters “`pattern*`” would match any string that starts with the word “`pattern`”.

Let’s see a simple example where we are going to define a few different regular expressions that we will use in the “`case-esac`” statement.

Please notice that the regular expressions are stored in different variables that will be used in the different branches of the “`case-esac`” statement. We are using the variables so that you can see a different approach<a id="footnote-3-ref" href="#footnote-3" style="font-size:x-small">[3]</a>.

The example script is as follows.

```bash
#!/usr/bin/env bash
#Script: case_pattern_matching.sh
# Regular expression pattern for basic email validation
email_pattern="[A-Za-z0-9.+-]*@[A-Za-z0-9.-]*.[A-Za-z]*"
# Regular expression pattern that matches
# strings starting with number
starts_with_number_pattern="[0-9]*"
# Regular expression pattern that matches
# strings starting with a letter
starts_with_letter_pattern="[a-zA-Z]*"
# Regular expression pattern that matches
# strings starting with a special character
starts_with_special_character="[^0-9a-zA-Z]*"
# Asking the user for input
read -p "Enter a random string: " STRING
# Printing the beginning of the result
echo -n "The string '$STRING' "
# Selecting the end of the result
case $STRING in
    $email_pattern)
        echo "matches the email pattern"
        ;;
    $starts_with_number_pattern)
        echo "starts with a number"
        ;;
    $starts_with_letter_pattern)
        echo "starts with a letter"
        ;;
    $starts_with_special_character)
        echo "starts with a special character"
        ;;
    *)
        echo "does not match any pattern"
        ;;
esac
```

In the previous script you see that we defined 4 different regular expressions.

The first regular expression, defined on line 4, is a very simple regular expression to validate strings that contain emails.

The second regular expression, defined on line 7, will match those strings that do not match emails and start with a number.

The third regular expression, defined on line 10, will match those strings that do not match emails nor those that start with numbers.

The fourth and last regular expression, defined on line 13, will match those strings that do not contain numbers nor letters<a id="footnote-4-ref" href="#footnote-4" style="font-size:x-small">[4]</a>.

Then we have the fifth branch that will match anything that was not matched in the previous branches.

Let's run the script a few times.

```txt
$ ./case_pattern_matching.sh
Enter a random string: test@email.com
The string 'test@email.com' matches the email pattern

$ ./case_pattern_matching.sh
Enter a random string: 12something
The string '12something' starts with a number
```

## Summary

The "`case-esac`" statement in Bash is a powerful tool for implementing conditional branching and decision-making logic. It offers a more concise and readable alternative to lengthy "`if-elif-else`" statements, especially when evaluating a variable against multiple possible values. The construct enhances script readability and maintainability by presenting conditions in a structured format, facilitating the execution of specific code blocks based on matching conditions.

The "`case-esac`" statement streamlines the handling of various conditional cases in Bash scripting. It efficiently compares a variable or expression against a list of patterns, executing the code block corresponding to the first matching condition. This proves particularly useful when dealing with variables that can have diverse values, enabling different actions based on these values. Additionally, the statement supports pattern matching, allowing the use of wildcards and regular expressions, making it versatile for tasks such as parsing user input, managing file types, or handling script options.

The syntax of the "`case-esac`" statement involves checking the value of a variable against different patterns, each representing a potential branch. The order of the branches is significant, as the first matching pattern determines the executed code. The script can utilize various pattern types, including literal matching, wildcard matching, character classes, and regular expression matching. This flexibility contributes to the script's robustness and adaptability, making it a valuable tool in Bash scripting for handling different scenarios and improving code organization.

As always this chapter contained a lot of information. Please give it a try and write Bash scripts so that you are able to practice what you learnt here.


## References
1. <https://bash-hackers.gabe565.com/syntax/ccmd/case/>
2. <https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_09_04_05>
3. <https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_03.html>
4. <https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html#index-case>



<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">
<p id="footnote-1" style="font-size:10pt">
1. In other programming languages (such as C, C++ or Java) that sequence is called “break”.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. More on this in the chapter dedicated to regular expressions.<a href="#footnote-2-ref">&#8617;</a>
</p>
<p id="footnote-3" style="font-size:10pt">
3. For the record, this could be done by using the regular expressions inside the different branches of the “case-esac” statement. I just want to show you different ways to do the same thing. It’s up to you to decide the approach you prefer.<a href="#footnote-3-ref">&#8617;</a>
</p>
<p id="footnote-4" style="font-size:10pt">
4. The symbol “^” inside the square brackets is to tell Bash that it should match strings that DO NOT contain the characters within the square brackets.<a href="#footnote-4-ref">&#8617;</a>
</p>

