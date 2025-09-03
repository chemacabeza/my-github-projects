---
layout: chapter
title: "Chapter 17: The select statement"
---
# Chapter 17: The select statement

## Index
* [Syntax]({{ site.url }}//bash-in-depth/0017-Select-Statement.html#syntax)
* [The `PS3` environment variable]({{ site.url }}//bash-in-depth/0017-Select-Statement.html#the-ps3-environment-variable)
* [Summary]({{ site.url }}//bash-in-depth/0017-Select-Statement.html#summary)
* [References]({{ site.url }}//bash-in-depth/0017-Select-Statement.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

The "`select`" statement in Bash is a powerful feature for creating simple interactive menus within scripts. It allows you to present a list of choices to the user, and based on their input, the script can execute different commands. The syntax is similar to a "`for`" loop, but instead of looping through a range of values, it loops through the options you define and waits for user input.

## Syntax

Here’s a basic structure of how the "`select`" statement works.

```bash
    select var in option1 option2 option3
    do
      # Commands to be executed based on the selected option
      case $var in
        option1)
          echo "You selected option1"
          ;;
        option2)
          echo "You selected option2"
          ;;
        option3)
          echo "You selected option3"
          ;;
        *)
          echo "Invalid selection"
          ;;
      esac
    done
```

When this script runs, it will present the user with a numbered list of options ("`option1`", "`option2`", "`option3`"), and prompt them to choose one by entering the corresponding number. The value of the selected option is stored in the variable "`var`", which can then be used within a "`case`" statement to determine what action to take based on the user’s choice.

Let's give it a try with the following example script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: select-0001.sh
 3 echo "Select a value from the list down here"
 4 select var in option1 option2 option3; do
 5    case $var in
 6        option1)
 7            echo "You selected option1"
 8            ;;
 9        option2)
10            echo "You selected option2"
11            ;;
12        option3)
13            echo "You selected option3"
14            ;;
15        *)
16            echo "Invalid selection"
17            ;;
18    esac
19 done
```

When you execute the previous script you will see something like the following.

```txt
$ ./select-0001.sh
Select a value from the list down here
1) option1
2) option2
3) option3
#? 2
You selected option2
#? 3
You selected option3
#? 4
Invalid selection
#? 6
Invalid selection
#? 
```

As you can see you are kind of "*trapped*" in a loop where you need to select an option every single time. As we mentioned before the "`select`" statement works like a loop. This means that you can use the keywords "`continue`" and "`break`" that we learnt [back in Chapter 12]({{ site.url }}/bash-in-depth/0012-Arrays-and-loops.html#continue-and-break).

Let's see an example with both of the keywords.

```bash
 1 #!/usr/bin/env bash
 2 #Script: select-0002.sh
 3 echo "Select a value from the list down here"
 4 select var in option1 option2 option3 next getout; do
 5     case $var in
 6         option1)
 7             echo "You selected option1"
 8             ;;
 9         option2)
10             echo "You selected option2"
11             ;;
12         option3)
13             echo "You selected option3"
14              ;;
15         next)
16             echo "You selected next"
17             continue
18             ;;
19         getout)
20             echo "you selected to get out of the select statement"
21             break
22             ;;
23         *)
24             echo "Invalid selection"
25             ;;
26     esac
27 done
28 echo "We got out of the select stament"
```

If you pay attention to the previous script you will notice that on line 4 we added two additional options which are "`next`" and "`getout`". 

If you check lines 15 to 18 you will see that we "*mapped*" the option "`next`" to the keyword "`continue`". **This is the default behavior** of the "`select`" statement so adding a "`continue`" keyword does not change anything in the "`select`" statement.

Now if you check lines 19 to 22 you will see that we "*mapped*" the option "`getout`" to the keyword "`break`". When this option is selected the "loop" will break and you will get out of the "`select`" statement.

Let's run the previous script and see what happens.

```txt
$ ./select-0002.sh
Select a value from the list down here
1) option1
2) option2
3) option3
4) next
5) getout
#? 1
You selected option1
#? 2
You selected option2
#? 3
You selected option3
#? 4
You selected next
#? 5
you selected to get out of the select statement
We got out of the select stament
```

As you can see from the execution of the script selecting the option "`next`" has no impact at all in the "`select`" statement. The option "`getout`", however, gets you out of the "`select`" statement and continues the execution of the script.

Something to take into account of the "`select`" statement is that it simplifies the process of building menus compared to using multiple "`read`" commands and "`if-else`" statements or a "`case`" statement.

For example, if you wanted to give users the option to select between several file operations (view, edit, delete), the select statement would allow for a clean and intuitive user interface.

In the next section we will learn how to use the environment variable "`PS3`" to be able to customize the prompt offered to the user.

## The `PS3` environment variable

The "`PS3`" environment variable in Bash is used to customize the prompt displayed when using the "`select`" statement. The "`select`" statement is a feature in Bash that allows users to create simple menus. By default, when the "`select`" statement is used, the prompt is set to "`#?`". However, you can modify this prompt by assigning a custom value to the "`PS3`" variable. This makes it easier for the user to know what kind of input is expected.

Let's see an example where we will write a script to select your favorite fruit.

```bash
 1 #!/usr/bin/env bash
 2 #Script: select-0003.sh
 3 PS3="Select your favorite fruit from the list: "
 4 select var in "Apple" "Banana" "Cherry" "Grapes" "Pear"; do
 5   case $var in
 6     Apple)
 7         echo "You picked '$var' as your favorite fruit"
 8         ;;
 9     Banana)
10         echo "You picked '$var' as your favorite fruit"
11         ;;
12     Cherry)
13         echo "You picked '$var' as your favorite fruit"
14         ;;
15     Grapes)
16         echo "You picked '$var' as your favorite fruit"
17         ;;
18     Pear)
19         echo "You picked '$var' as your favorite fruit"
20         ;;
21     *)
22         echo "Invalid choice. Please try again."
23         ;;
24   esac
25 done
```

When you run the previous script you will see the following in your terminal window.

```txt
$ ./select-0003.sh
1) Apple
2) Banana
3) Cherry
4) Grapes
5) Pear
Select your favorite fruit from the list: 1
You picked 'Apple' as your favorite fruit
Select your favorite fruit from the list: 2
You picked 'Banana' as your favorite fruit
Select your favorite fruit from the list: 3
You picked 'Cherry' as your favorite fruit
Select your favorite fruit from the list: 4
You picked 'Grapes' as your favorite fruit
Select your favorite fruit from the list: 5
You picked 'Pear' as your favorite fruit
Select your favorite fruit from the list: 6
Invalid choice. Please try again.
Select your favorite fruit from the list:
1) Apple
2) Banana
3) Cherry
4) Grapes
5) Pear
Select your favorite fruit from the list: ^C
```

As you can see from the execution of the script we are using all the options and all of the work without problems. When we try to select an option that is not in the list "`6`" it will print the message "`Invalid choice. Please try again.`".

If you hit enter and don't select an option the list of options will appear again.

The last character that you see in the terminal window is "`^C`" which is the "Control+C" command so that we can end the execution of the script.

Something you should know is that you can pass an array so that it contains all the options you can select from. Let's rewrite the script "`select-0003.sh`" so that all the options are in an array. The result is like the following.

```bash
 1 #!/usr/bin/env bash
 2 #Script: select-0004.sh
 3 PS3="Select your favorite fruit from the list: "
 4 OPTIONS=("Apple" "Banana" "Cherry" "Grapes" "Pear")
 5 select var in "${OPTIONS[@]}"; do
 6    case $var in
 7        Apple)
 8            echo "You picked '$var' as your favorite fruit"
 9            ;;
10        Banana)
11            echo "You picked '$var' as your favorite fruit"
12            ;;
13        Cherry)
14            echo "You picked '$var' as your favorite fruit"
15            ;;
16        Grapes)
17            echo "You picked '$var' as your favorite fruit"
18            ;;
19        Pear)
20            echo "You picked '$var' as your favorite fruit"
21            ;;
22        *)
23            echo "Invalid choice. Please try again."
24            ;;
25    esac
26 done
```

If you run the previous "`select-0004.sh`" script you will that it works exactly as the script "`select-0003.sh`".

## Summary

The "`select`" statement in Bash is a useful tool for creating interactive menus that allow users to choose from a list of options. It works similarly to a "`for`" loop, but instead of iterating over values, it presents them as a numbered list to the user and waits for their input. Once a choice is made, the value of the selected option is stored in a variable, which can then be used to execute different actions depending on the choice.

For example, in a basic script using "`select`", you can define a set of options, and based on the user's selection, a corresponding action will be executed using a "`case`" statement. This simplifies menu creation in Bash scripts, making it more intuitive for users to interact with different choices.

The "`PS3`" environment variable is used to customize the prompt shown when the "`select`" statement is waiting for user input. By default, it prompts with "`#?`", but you can modify this to provide a more descriptive message, guiding the user on what they should input next.

Mastery comes from repetition—every time you use the "`select`" statement, you’re sharpening your Bash skills for more efficient scripting!

## References

1. <https://linux.die.net/Bash-Beginners-Guide/sect_09_06.html>
2. <https://linuxize.com/post/bash-select/>
3. <https://ostechnix.com/bash-select-loop/>
4. <https://rednafi.com/misc/dynamic_menu_with_select_in_bash/>
5. <https://ss64.com/bash/select.html>
6. <https://superuser.com/questions/858086/bash-how-to-use-a-quoted-argument-in-select>
7. <https://unix.stackexchange.com/questions/20698/using-select-command-to-print-a-menu-in-bash>
8. <https://www.baeldung.com/linux/shell-script-simple-select-menu>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

