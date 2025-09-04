# Chapter 12: Arrays and loops

## Introduction

Bash scripting introduces arrays and loops as essential constructs, facilitating the manipulation and processing of data within scripts. Arrays, the cornerstone of structured data storage in Bash, come in two main types: indexed arrays and associative arrays. Indexed arrays employ numerical indices to represent elements, starting from zero, while associative arrays use user-defined keys for a more versatile and human-readable approach to data organization. This diversity enables scriptwriters to choose the array type that best fits the nature of their data, making Bash scripts adaptable to various scenarios.

In tandem with arrays, Bash incorporates different types of loops, providing the means to iterate over arrays and perform repetitive tasks efficiently. The "`for`" loop, a fundamental iteration construct, facilitates the sequential processing of elements within an array or a predefined range of values. Meanwhile, the "`while`" and "`until`" loops offer conditional iteration, allowing scripts to execute code repeatedly based on specified conditions. This mixture of arrays and loops empowers Bash scripts with the ability to automate complex tasks, process large datasets, and implement dynamic solutions.

As we delve into the intricacies of Bash scripting, we will explore the syntax, usage, and best practices for working with arrays and loops. From basic array declarations to advanced loop structures, understanding these core concepts unlocks the full potential of Bash scripting, enabling scriptwriters to create robust and versatile solutions for various computing tasks and automation scenarios.

Let’s dive in!


## Indexed Arrays

An **Indexed Array** is a data structure that associates values to indices (0, 1, 2, etc) and allows you to access those values via indices.

Let’s take a look at a visualization for this kind of array.

<p align="center">
    <img src="chapters/0012-Arrays-and-loops/images/Indexed-array.png" width="500px"/>
</p>

How do we declare this kind of array? Well there are 2 ways to declare an indexed array.

The first way is by using initialization declaration, which is assigning a value directly to a variable, like the following.

```bash
    MY_ARRAY=("value1" "value2" "value3")
```

The second one is by using the “`declare`” builtin command that we saw previously with the option “`-a`”.

```bash
    declare -a MY_ARRAY=("value1" "value2" "value3")
```

In the next section we are going to learn about associative arrays.

### How do you access items of an indexed array?

The way you select an item from an indexed array is as follows.

```bash
    echo "My item: ${MY_ARRAY[$index]}"
```

Where "`$index`" is a whole number (for example `0`, `1`, `2`, ...).

## Associative Arrays (a.k.a. Hashes/Maps)

An **Associative Array** is a data structure that associates values to “*keys*”. A key can be any random string or number.

<p align="center">
    <img src="chapters/0012-Arrays-and-loops/images/Associative-array.png" width="500px"/>
</p>

So, how do we declare an associative array? We use the option “`-A`” of the “`declare`” builtin command.

```bash
    declare -A MY_MAP=( [Madrid]="Spanish" [London]="English" [Paris]="French")
```

This is **the only valid way** to declare an associative array.

If you try to declare the previous associative array without “`declare -A`” you will be surprised. Let’s see it with an example.

```bash
#!/usr/bin/env bash
#Script: bad_associative_array.sh
MY_MAP=( [Madrid]="Spanish" [London]="English" [Paris]="French")
declare -p MY_MAP
```

When you run the previous script you will the following result in your terminal.

```txt
$ ./bad_associative_array.sh
declare -a MY_MAP=([0]="French")
```

As you can see without using “`declare -A`” the variable “`MY_MAP`” is treated like an indexed array. This is because the keys “`Madrid`”, “`London`” and “`Paris`” are treated as variables and as they do not exist, Bash assumes the value “`0`” for all of them. 

This means that the values “`Spanish`”, “`English`” and “`French`” are associated to the same key/index (“`0`” in our case) which will cause that the different values will be overriding the previous value, leaving the value “`French`” as the last value overriding the content of the key/index “`0`”.

Now, if we declare one of the keys as a variable and assign a whole number (0, 1, 2, etc) the result will change. Let’s see it with an example.

```bash
#!/usr/bin/env bash
#Script: bad_associative_array_2.sh
Madrid=20
MY_MAP=( [Madrid]="Spanish" [London]="English" [Paris]="French")
declare -p MY_MAP
```

When you run the previous script you will have now the following result.

```txt
$ ./bad_associative_array_2.sh
declare -a MY_MAP=([0]="French" [20]="Spanish")
```

Now, rather than having one single element in the array there are **two**. One associated with index “`0`” and another one associated with index “`20`”.

### How do you access items of an associative array?

The way you select an item from an associative array is as follows.

```bash
    echo "My item: ${MY_MAP[$key]}"
```

Where "`$key`" is one of the keys stores in the associative array (something like "`Madrid`", "`London`" or "`Paris`" from the previous example).

## Associative Arrays as Sets

In the previous sections we learnt that an associative array is used to map a string of characters to some value. This is known in software engineering as a “*Map*”, “*Dictionary*” or (as is known in Bash) “*Associative arrays*”.

In software engineering there is another data structure called “*Set*”. A set is a data structure that contains unique values without a particular order.

Bash, technically, does not provide the data structure “Set” but we can use an associative array to simulate the same behavior.

The idea is to create an associative array that has as keys the unique information you want to store and “`1`” as value. That’s it!

Let's see how it works with an example script.

```bash
#!/usr/bin/env bash
#Script: array_as_set.sh
# Declaring set with 3 cities
declare -A CITIES=(
 [London]=1
 [Paris]=1
 [Madrid]=1
)
# Checking for a city inside the Set
if [[ -n "${CITIES[London]}" ]]; then
    echo "London is in the set" # This will be printed
else
    echo "London is NOT in the set"
fi
# Checking for a city that is not in the Set
if [[ -n "${CITIES[Seville]}" ]]; then
    echo "Seville is in the set"
else
    echo "Seville is NOT in the set" # This will be printed
fi
```

In this simple case we are using the option “`-n`” of test which will return true if the string is not empty. When we run the previous script we get the following result.

```txt
$ ./array_as_set.sh
London is in the set
Seville is NOT in the set
```

Now that we have learnt how to declare indexed and associative arrays we are going to dive on the operations we can do on them in the next section.

## Operations with arrays

In this section we are going to assume that we have declared an array called “`MY_ARRAY`”.

Once the array is declared, what can we do with it? In the next subsections we will have a short view of what we can do with some examples.

### First element of the array

In the case of an indexed array referring to the variable “`$MY_ARRAY`” will show the first element of the array itself. 

```bash
#!/usr/bin/env bash
#Script: array_index_first.sh
MY_ARRAY=("value1" "value2" "value3")
echo "First item: $MY_ARRAY"
```

When we execute the previous script, you will get the following in your terminal.

```txt
$ ./array_index_first.sh
First item: value1
```

In the case of an associative array referring to the variable “`$MY_ARRAY`” will not show anything as associative arrays are not sorted.

```bash
#!/usr/bin/env bash
#Script: array_associative_first.sh
declare -A MY_ARRAY=(
    [key1]="value1"
    [key2]="value2"
    [key3]="value3"
)
echo "First item: $MY_ARRAY"
```

As you will see in the following execution of the script, “`$MY_ARRAY`” returns empty.

```txt
$ ./array_associative_first.sh
First item:
```

It returns empty **because Bash does not directly support printing an entire associative array by just referencing its name** like you would with a regular variable. Associative arrays in Bash require you to access individual elements or loop through the keys.

In the next section we will see how to get the whole content of the array.

### Get the whole content of the array

There are two ways to get the whole content of an indexed array or the values of an associative array. Which are “`${MY_ARRAY[*]}`” and “`${MY_ARRAY[@]}`”.

The difference is that “`${MY_ARRAY[*]}`” will display the elements of the indexed array (or the values of the associative array) as **a single string**, while “`${MY_ARRAY[@]}`” will display the same ones quoted separately.

```bash
#!/usr/bin/env bash
#Script: index_array_content.sh
MY_ARRAY=("value1" "value2" "value3")
echo "Content 1: ${MY_ARRAY[*]}"
echo "Content 2: ${MY_ARRAY[@]}"
```

When we execute the previous script we get the following result in the terminal.

```txt
$ ./index_array_content.sh
Content 1: value1 value2 value3
Content 2: value1 value2 value3
```
The execution does not show us the difference between “`${MY_ARRAY[*]}`” and “`${MY_ARRAY[@]}`” but don’t worry we will see it more clearly when we get into the different kinds of loops, just keep this in mind.

Something similar happens when we try to use “`${MY_ARRAY[*]}`” and “`${MY_ARRAY[@]}`” with associative arrays.

```bash
#!/usr/bin/env bash
#Script: associative_array_content.sh
declare -A MY_ARRAY=(
    [key1]="value1"
    [key2]="value2"
    [key3]="value3"
)
echo "Content-1: ${MY_ARRAY[*]}"
echo "Content-2: ${MY_ARRAY[@]}"
```

When you run the previous script you will get the following result in your terminal.

```txt
$ ./associative_array_content.sh
Content-1: value2 value3 value1
Content-2: value2 value3 value1
```

Same as with indexed arrays, we will come back to this when we will talk about loops.

In the next section we will see how to get the list of indices for both indexed and associative arrays.

### Get the list of indices

The way to get the indices of both indexed and associative arrays is by using “`${!MY_ARRAY[@]}`”.

If you use it with an indexed array it will return the indices that contain a value. 

```bash
#!/usr/bin/env bash
#Script: index_array_indices.sh
MY_ARRAY=("value1" "value2" "value3")
echo "Indices: ${!MY_ARRAY[@]}"
```

When you execute the previous script you will get the following result in your terminal.

```txt
$ ./index_array_indices.sh
Indices: 0 1 2
```

If you use it with an associative array it will return the keys.

```bash
#!/usr/bin/env bash
#Script: associative_array_indices.sh
declare -A MY_ARRAY=(
    [key1]="value1"
    [key2]="value2"
    [key3]="value3"
)
echo "Indices: ${!MY_ARRAY[@]}"
```

When you execute the previous script you will get the list of keys unsorted.

```txt
$ ./associative_array_indices.sh
Indices: key2 key3 key1
```

In the next section we will learn how to get the length of the array.

### Get the length of the array

To be able get the length of an array (both indexed and associative) you can use either “`${#MY_ARRAY[*]}`” or “`${#MY_ARRAY[@]}`”, **both expressions are equivalent**.

Let’s see it with a couple of examples.

```bash
#!/usr/bin/env bash
#Script: index_array_length.sh
MY_ARRAY=("value1" "value2" "value3")
echo "Length-1: ${#MY_ARRAY[*]}"
echo "Length-2: ${#MY_ARRAY[@]}"
```

When you run the previous script for indexed arrays you will the following result in your terminal.

```txt
$ ./index_array_length.sh
Length-1: 3
Length-2: 3
```

And now an example for associative arrays.

```bash
#!/usr/bin/env bash
#Script: associative_array_length.sh
declare -A MY_ARRAY=(
    [key1]="value1"
    [key2]="value2"
    [key3]="value3"
)
echo "Length-1: ${#MY_ARRAY[*]}"
echo "Length-2: ${#MY_ARRAY[@]}"
```

When you execute the previous script you get the following in your terminal.

```txt
$ ./associative_array_length.sh
Length-1: 3
Length-2: 3
```

In the next section we are going to see how to add an element to an array.


### Adding an element to an array

In order to add an additional element to an array we can do it by using the following form.

<p align="center">
    <img src="chapters/0012-Arrays-and-loops/images/Add-Item-To-Array.png" width="550px"/>
</div>

As you can see the only difference on adding a new element to an indexed array or an associative array is including the key in the associative array.

For example, for an indexed array we would proceed as follows.

```bash
#!/usr/bin/env bash
#Script: index_array_add.sh
MY_ARRAY=("value1" "value2" "value3")
echo "Elements: ${MY_ARRAY[@]}"
MY_ARRAY+=("value4")
echo "Elements: ${MY_ARRAY[@]}"
```

When you run the previous script you will get the following in the terminal.

```txt
$ ./index_array_add.sh
Elements: value1 value2 value3
Elements: value1 value2 value3 value4
```

Where you can see the new value (“`value4`”) added to the end of the array.

In the case of an associative array we would do the following.

```bash
#!/usr/bin/env bash
#Script: associative_array_add.sh
declare -A MY_ARRAY=(
    [key1]="value1"
    [key2]="value2"
    [key3]="value3"
)
MY_ARRAY+=([key4]="value4")
declare -p MY_ARRAY
```

When you run the previous script you will get the following result in your terminal.

```txt
$ ./associative_array_add.sh
declare -A MY_ARRAY=([key4]="value4" [key2]="value2" [key3]="value3" [key1]="value1" )
```

In the result you can cleary see that the a new value was added to the associative array with key "`key4`" and value "`value4`".

Something to notice is that for associative arrays you can add elements by using “`MY_ARRAY[Key]=Value`”. This means that we could rewrite the last script as the following and we would get the exact same result.


```bash
#!/usr/bin/env bash
#Script: associative_array_add.sh
declare -A MY_ARRAY=(
    [key1]="value1"
    [key2]="value2"
    [key3]="value3"
)
MY_ARRAY["key4"]="value4"
declare -p MY_ARRAY
```

In the next section we are going to learn how to delete specific elements from arrays.

### Delete element from a given index

There are a couple of ways to delete elements from an array (either indexed or associative). The one we are exploring in this section is by using the index of the element we want to delete.

If you remember the indices are different in both indexed and associative arrays.

In indexed arrays the indices are whole numbers (0, 1, 2, etc) while in associative arrays the indices are the keys (“`key1`”, “`key2`”, “`key3`” in our previous examples).

In both types of array we will have to use the following to delete elements.

<p align="center">
<img src="chapters/0012-Arrays-and-loops/images/Unset-Item-From-Array.png" width="550px"/>
</p>

In the following example we are deleting the second element (index “`1`”) of the array.

```bash
#!/usr/bin/env bash
#Script: index_array_delete.sh
MY_ARRAY=("value1" "value2" "value3")
# Deleting second item of the array
unset MY_ARRAY[1]
# Printing the whole content of the array
echo "Content: ${MY_ARRAY[@]}"
```

When we execute the previous script you will see that “`value2`” is no longer in the array.

```txt
$ ./index_array_delete.sh
Content: value1 value3
```

In the case of an associative array, as it was mentioned before, we need to use the key of the entry we want to delete. In the following example we will remove the entry whose key is “`key2`”.

```bash
#!/usr/bin/env bash
#Script: associative_array_delete.sh
declare -A MY_ARRAY=(
    [key1]="value1"
    [key2]="value2"
    [key3]="value3"
)
unset MY_ARRAY[key2]
declare -p MY_ARRAY
```

When we execute the previous script you will see that the element whose key is “`key2`” is no longer in the associative array.

```txt
$ ./associative_array_delete.sh
declare -A MY_ARRAY=([key3]="value3" [key1]="value1" )
```

In the next section we will learn how to delete elements based on a pattern.

### Delete element from a given pattern

In the previous section we learnt how to delete elements from an array, but we needed to know beforehand what the index/key of the element was.

In this section we are going to learn how to delete elements based on a “*pattern*”. It will be like saying “*Please delete the elements that look like this pattern*”.

The generic form that we will use is as follows.

<p align="center">
    <img src="chapters/0012-Arrays-and-loops/images/Generic-Form-Delete-From-Pattern.png" width="450px"/>
</p>

Those 4 dots will be replaced with some syntax that will do pattern matching to find the elements before removing them. There are several ways to remove an element from an array and are the following:
* Shortest match from the front of the string
* Longest match from the front of the string
* Shortest match from the back of the string
* Longest match from the back of the string

#### <b>Shortest match from the front of the string</b>

The first approach is by using “`${MY_ARRAY[@]#<pattern>}`”. This way is going to search for the elements in the array that match the pattern given the **shortest** starting from the **front of the string**.

The previous statement means that once you provide the pattern, Bash will go element by element and, for each element, will try to match the pattern provided starting from the beginning of the string. Then it will remove the pattern found once it finds the shortest match.

Let’s see an example to better understand how it works.

```bash
#!/usr/bin/env bash
#Script: index_array_delete_pattern_front_shortest.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Shortest match from front of string
echo "\${MY_ARRAY[@]#t*}: ${MY_ARRAY[@]#t*}"
echo "\${MY_ARRAY[@]#t*ee}: ${MY_ARRAY[@]#t*ee}"
```

On line 3 we declare an array with six elements. On line 4 we display the content of the array. Then (the interesting part) on lines 6 and 7 we use two different patterns.

The first pattern (“`t*`”) means that there is a need to match the shortest string that starts with the character “`t`” and has zero or more characters after it. In our case, there are two strings of “`MY_ARRAY`” that start with the character “`t`”, which are the second and the third element whose values are “`two`” and “`three`”, respectively. And the shortest string matching that pattern is “`t`”.

This means that Bash will remove just the character “`t`” from both elements of the array.

The second pattern (“`t*ee`”) means that there is a need to match the shortest string that starts with the character “`t`”, has zero or more characters after it and ends with the characters “`ee`”. Same as in the previous patterns, the only string of “`MY_ARRAY`” that matches that pattern is the third element. In this case the pattern will match the whole string.

This means that Bash will remove the whole element of the array.

When we run the previous script you will see the following output in your terminal.

```txt
$ ./index_array_delete_pattern.sh
Content: one two three four five six
${MY_ARRAY[@]#t*}: one wo hree four five six
${MY_ARRAY[@]#t*ee}: one two  four five six
```

As you can see in the execution of the script, the first pattern removes only one character of a couple of elements of the array, while the first pattern removes a whole element that matches the pattern.

In the next section we will match the longest pattern starting from the front.

#### <b>Longest match from the front of the string</b>

The second approach is by using “`${MY_ARRAY[@]##<pattern>}`”. This way is going to search for the elements in the array that match the pattern given the **longest** starting from the **front of the string**.

The previous statement means that once you provide the pattern, Bash will go element by element and, for each element, will try to match the pattern provided starting from the beginning of the string. Then it will remove the pattern found once it finds the longest match.

Let’s write another script to see how it works. In the next script we left the content of the previous script and added the new things of this section.

```bash
#!/usr/bin/env bash
#Script: index_array_delete_pattern.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Shortest match from front of string
echo "\${MY_ARRAY[@]#t*}: ${MY_ARRAY[@]#t*}"
echo "\${MY_ARRAY[@]#t*ee}: ${MY_ARRAY[@]#t*ee}"
# Longest match from the front of string
echo -e "\n\${MY_ARRAY[@]##t*}: ${MY_ARRAY[@]##t*}"
echo "\${MY_ARRAY[@]##t*ee}: ${MY_ARRAY[@]##t*ee}"
```

In this case we have added from line 8 to line 10. Let’s see what happens when we run the script.

```txt
$ ./index_array_delete_pattern.sh
Content: one two three four five six
${MY_ARRAY[@]#t*}: one wo hree four five six
${MY_ARRAY[@]#t*ee}: one two  four five six

${MY_ARRAY[@]##t*}: one   four five six
${MY_ARRAY[@]##t*ee}: one two  four five six
```

As you can see from the new execution, the first pattern (“`t*`”) will match the longest string of characters that contain the pattern, which happens to be elements with values “`two`” and “`three`”. Bash will remove those two elements from the array.

The second pattern (“`t*ee`”), however, as it’s more specific than the previous one will only match the element with value "`three`". In this case, Bash will remove one single element from the array.

In the next section we will match the shortest pattern starting from the back.


#### <b>Shortest match from the back of the string</b>

The third approach is by using “`${MY_ARRAY[@]%<pattern>}`”. This way is going to search for the elements in the array that match the pattern given the **shortest** starting from the **back of the string**.

The previous statement means that once you provide the pattern, Bash will go element by element and, for each element, will try to match the pattern provided starting from the end of the string. Then it will remove the pattern found once it finds the shortest match.

Let's write another script that shows this way of removing parts of the items and that is comparing them to the previous ways that we saw.

```bash
#!/usr/bin/env bash
#Script: index_array_delete_pattern_back_shortest.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Shortest match from front of string
echo "\${MY_ARRAY[@]#t*}: ${MY_ARRAY[@]#t*}"
echo "\${MY_ARRAY[@]#t*ee}: ${MY_ARRAY[@]#t*ee}"
# Longest match from the front of string
echo -e "\n\${MY_ARRAY[@]##t*}: ${MY_ARRAY[@]##t*}"
echo "\${MY_ARRAY[@]##t*ee}: ${MY_ARRAY[@]##t*ee}"
# Shortest match from the back of string
echo -e "\n\${MY_ARRAY[@]%*ee}: ${MY_ARRAY[@]%*ee}"
echo "\${MY_ARRAY[@]%t*ee}: ${MY_ARRAY[@]%t*ee}"
```

We added lines 11 to 13. When we run the script the following appears in your terminal window.

```txt
$ ./index_array_delete_pattern_back_shortest.sh
Content: one two three four five six
${MY_ARRAY[@]#t*}: one wo hree four five six
${MY_ARRAY[@]#t*ee}: one two  four five six

${MY_ARRAY[@]##t*}: one   four five six
${MY_ARRAY[@]##t*ee}: one two  four five six

${MY_ARRAY[@]%*ee}: one two thr four five six
${MY_ARRAY[@]%t*ee}: one two  four five six
```

In the execution you can see that the first pattern (“`*ee`”) matches the shortest string ending in “`ee`” which happens to be the last two letters of the third element of the array (with value “`three`”).

In the case of the second pattern (“`t*ee`”) the pattern will match the whole string of the third element. The result will be that the element in question will be removed.

In the next section we will match the longest pattern starting from the back.

#### <b>Longest match from the back of the string</b>

The third approach is by using “`${MY_ARRAY[@]%%<pattern>}`”. This way is going to search for the elements in the array that match the pattern given the **longest** starting from the **back of the string**.

The previous statement means that once you provide the pattern, Bash will go element by element and, for each element, will try to match the pattern provided starting from the end of the string. Then it will remove the pattern found once it finds the longest match.

Same as in the previous cases we will write a new script comparing this way of deleting items (or parts of items) of arrays to the previous ones.

```bash
#!/usr/bin/env bash
#Script: index_array_delete_pattern_back_longest.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Shortest match from front of string
echo "\${MY_ARRAY[@]#t*}: ${MY_ARRAY[@]#t*}"
echo "\${MY_ARRAY[@]#t*ee}: ${MY_ARRAY[@]#t*ee}"
# Longest match from the front of string
echo -e "\n\${MY_ARRAY[@]##t*}: ${MY_ARRAY[@]##t*}"
echo "\${MY_ARRAY[@]##t*ee}: ${MY_ARRAY[@]##t*ee}"
# Shortest match from the back of string
echo -e "\n\${MY_ARRAY[@]%*ee}: ${MY_ARRAY[@]%*ee}"
echo "\${MY_ARRAY[@]%t*ee}: ${MY_ARRAY[@]%t*ee}"
# Longest match from the back of string
echo -e "\n\${MY_ARRAY[@]%%*e}: ${MY_ARRAY[@]%%*e}"
echo "\${MY_ARRAY[@]%%f*e}: ${MY_ARRAY[@]%%f*e}"
```

We added lines 13 to 16. When we run the script the following appears in your terminal window.

```txt
$ ./index_array_delete_pattern_back_longest.sh
Content: one two three four five six
${MY_ARRAY[@]#t*}: one wo hree four five six
${MY_ARRAY[@]#t*ee}: one two  four five six

${MY_ARRAY[@]##t*}: one   four five six
${MY_ARRAY[@]##t*ee}: one two  four five six

${MY_ARRAY[@]%*ee}: one two thr four five six
${MY_ARRAY[@]%t*ee}: one two  four five six

${MY_ARRAY[@]%%*e}:  two  four  six
${MY_ARRAY[@]%%f*e}: one two three four  six
```

In the execution you can see that with the first pattern (“`*e`”), half of the elements in the array were removed. This is because the elements “`on`**e**”, “`thre`**e**” and “`fiv`**e**” match the pattern of having one single character “`e`” at the very end of the string.

In the case of the second pattern (“`f*e`”), there is only one element that starts with the “`f`” character, has zero or more characters after it and ends with the character “`e`”.

Although in the previous sections we have been using indexed arrays, this way to delete elements can be applied as well to the values of an associative array<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>.


### Substring replacement with regular expressions

In the previous section we learnt several ways to delete elements from an array using regular expressions. We also learnt that in some cases we could remove part of the string.

In this section we are going to learn how to replace parts of the string (and even delete it) based on a regular expression.

Same as in the previous section we will be focused on indexed arrays, but the same can be applied to the values of associative arrays.

There are 4 ways to replace with regular expressions, which are:
* Replace first occurrence
* Replace all occurrences
* Replace beginning occurrences of string
* Replace ending occurrences of string

#### <b>Replace first occurrence</b>

To be able to replace the **first occurrence** of a pattern in a string element of an array we need to use the following syntax: “`${MY_ARRAY[@]/<pattern>/<replacement>}`”.

Let's give it a try with the following script.

```bash
#!/usr/bin/env bash
#Script: index_array_replace_pattern_first.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Replace first occurrence
echo -e "\nReplace first occurrence"
echo "\${MY_ARRAY[@]/e/X}: ${MY_ARRAY[@]/e/X}"
echo "\${MY_ARRAY[@]/e*/X}: ${MY_ARRAY[@]/e*/X}"
```

In the previous script we are using two different patterns. When we run the script the following is printed in the terminal window.

```txt
$ ./index_array_replace_pattern_first.sh
Content: one two three four five six

Replace first occurrence
${MY_ARRAY[@]/e/X}: onX two thrXe four fivX six
${MY_ARRAY[@]/e*/X}: onX two thrX four fivX six
```

The first pattern (“`e`”), which is in line 7 of the script, will replace the first occurrence of the character “`e`” with the character “`X`” starting from the beginning of the string (from the left). This will affect one single character in several elements of the array.

The second pattern (“`e*`”), found in line 8 of the script, will replace the first occurrence of the pattern with the character “`X`” starting from the beginning of the string. In this case, as the pattern contains the character “`*`” it will match the rest of the string starting from the first character “`e`”. This will affect more than a single character in several elements of the array.

In the next section we will learn how to replace all occurrences given a pattern.


#### <b>Replace all occurrences</b>

To be able to replace **all occurrences** of a pattern in a string element of an array we need to use the following syntax: “`${MY_ARRAY[@]/<pattern>/<replacement>}`”.

Let's write another script so that we can see how this way of replacement is different from the previous one.

```bash
#!/usr/bin/env bash
#Script: index_array_replace_pattern_all.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Replace first occurrence
echo -e "\nReplace first occurrence"
echo "\${MY_ARRAY[@]/e/X}: ${MY_ARRAY[@]/e/X}"
echo "\${MY_ARRAY[@]/e*/X}: ${MY_ARRAY[@]/e*/X}"
# Replace all occurrences
echo -e "\nReplace all occurrences"
echo "\${MY_ARRAY[@]//e/X}: ${MY_ARRAY[@]//e/X}"
echo "\${MY_ARRAY[@]//e*/X}: ${MY_ARRAY[@]//e*/X}"
```

We added lines 9 to 12 to our script. We are using the same two patterns as before.

With the first pattern (“`e`”) on line 11, Bash will replace every single instance of the pattern with the character “`X`”. This means every single character “`e`” will be replaced with the character “`X`”.

With the second pattern (“`e*`”) on line 12, Bash will replace every single instance of the pattern with the character “`X`”. In this case, every sequence of characters that starts with the character “`e`” will be replaced with a single character “`X`”.

When you run the previous script you will get the following result in your terminal window.

```txt
$ ./index_array_replace_pattern_all.sh
Content: one two three four five six

Replace first occurrence
${MY_ARRAY[@]/e/X}: onX two thrXe four fivX six
${MY_ARRAY[@]/e*/X}: onX two thrX four fivX six

Replace all occurrences
${MY_ARRAY[@]//e/X}: onX two thrXX four fivX six
${MY_ARRAY[@]//e*/X}: onX two thrX four fivX six
```

A special use case of this syntax is that we can use it to remove elements from the array as well. To be able to do this we need to adjust the pattern to match the elements we want to remove and use an empty string as replacement.

Let's see how it is done with the following script.

```bash
#!/usr/bin/env bash
#Script: index_array_replace_pattern_all_delete.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Replace first occurrence
echo -e "\nReplace first occurrence"
echo "\${MY_ARRAY[@]/e/X}: ${MY_ARRAY[@]/e/X}"
echo "\${MY_ARRAY[@]/e*/X}: ${MY_ARRAY[@]/e*/X}"
# Replace all occurrences
echo -e "\nReplace all occurrences"
echo "\${MY_ARRAY[@]//e/X}: ${MY_ARRAY[@]//e/X}"
echo "\${MY_ARRAY[@]//e*/X}: ${MY_ARRAY[@]//e*/X}"
# Removal of elements
echo -e "\nRemoval of elements"
echo "\${MY_ARRAY[@]//e/}: ${MY_ARRAY[@]//e/}"
echo "\${MY_ARRAY[@]//f*/}: ${MY_ARRAY[@]//f*/}"
```

If you pay attention, this script is the same as before but we added lines from 13 to 16.

The first pattern (“`e`”) in line 15 will remove individual characters of the elements in the array, while the second pattern (“`f*`”) in line 16 will remove two elements of the array.

If you run the previous script you will see the following result in your terminal window.

```txt
$ ./index_array_replace_pattern_all_delete.sh
Content: one two three four five six

Replace first occurrence
${MY_ARRAY[@]/e/X}: onX two thrXe four fivX six
${MY_ARRAY[@]/e*/X}: onX two thrX four fivX six

Replace all occurrences
${MY_ARRAY[@]//e/X}: onX two thrXX four fivX six
${MY_ARRAY[@]//e*/X}: onX two thrX four fivX six

Removal of elements
${MY_ARRAY[@]//e/}: on two thr four fiv six
${MY_ARRAY[@]//f*/}: one two three   six
```

In the next two sections we will learn how to do replacements targeting specifically the beginning and the ending of the string.


#### <b>Replace beginning occurrences of string</b>

To be able to replace occurrences at the beginning of a string we need to use the following syntax: “`${MY_ARRAY[@]/#<pattern>/<replacement>}`”.

What will happen is that Bash will go element by element and will replace the substring that matches the pattern provided, that is **at the beginning of the string**, with the replacement provided.

Let’s see how it works with an example by modifying our previous script.

```bash
#!/usr/bin/env bash
#Script: index_array_replace_pattern_front_beginning.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Replace first occurrence
echo -e "\nReplace first occurrence"
echo "\${MY_ARRAY[@]/e/X}: ${MY_ARRAY[@]/e/X}"
echo "\${MY_ARRAY[@]/e*/X}: ${MY_ARRAY[@]/e*/X}"
# Replace all occurrences
echo -e "\nReplace all occurrences"
echo "\${MY_ARRAY[@]//e/X}: ${MY_ARRAY[@]//e/X}"
echo "\${MY_ARRAY[@]//e*/X}: ${MY_ARRAY[@]//e*/X}"
# Removal of elements
echo -e "\nRemoval of elements"
echo "\${MY_ARRAY[@]//e/}: ${MY_ARRAY[@]//e/}"
echo "\${MY_ARRAY[@]//f*/}: ${MY_ARRAY[@]//f*/}"
# Replace front-end occurrences of string
echo -e "\nReplace front-end occurrences of string"
echo "\${MY_ARRAY[@]/#e/XY}: ${MY_ARRAY[@]/#e/XY}"
echo "\${MY_ARRAY[@]/#f/XY}: ${MY_ARRAY[@]/#f/XY}"
```

In this case we have added lines 17 to 20 to our script. In line 19 we are trying to replace the character “`e`” at the beginning of the string with “`XY`”. In line 20 we are trying to replace the character “`f`” at the beginning of the string with “`XY`”.

When you run the previous script you will see the following output in the terminal window.

```txt
$ ./index_array_replace_pattern_front_beginning.sh
Content: one two three four five six

Replace first occurrence
${MY_ARRAY[@]/e/X}: onX two thrXe four fivX six
${MY_ARRAY[@]/e*/X}: onX two thrX four fivX six

Replace all occurrences
${MY_ARRAY[@]//e/X}: onX two thrXX four fivX six
${MY_ARRAY[@]//e*/X}: onX two thrX four fivX six

Removal of elements
${MY_ARRAY[@]//e/}: on two thr four fiv six
${MY_ARRAY[@]//f*/}: one two three   six

Replace front-end occurrences of string
${MY_ARRAY[@]/#e/XY}: one two three four five six
${MY_ARRAY[@]/#f/XY}: one two three XYour XYive six
```

As you can see from the execution the line 19 from our script will have no effect at all as there is not a single element in the array that begins with the character “`e`”. Line 20, however, will affect a couple of elements in the array (elements with values “`four`” and “`five`”) because they start with the character “`f`”.

In the next section we will learn how to replace occurrences of a pattern at the end of a string.

#### <b>Replace ending occurrences of string</b>

To be able to replace occurrences at the beginning of a string we need to use the following syntax: “`${MY_ARRAY[@]/%<pattern>/<replacement>}`”.

What will happen is that Bash will go element by element and will replace the substring that matches the pattern provided, that is **at the end of the string**, with the replacement provided.

Let’s see how it works with an example by modifying our previous script.

```bash
#!/usr/bin/env bash
#Script: index_array_replace_pattern_back_ending.sh
MY_ARRAY=( one two three four five six )
echo "Content: ${MY_ARRAY[@]}"
# Replace first occurrence
echo -e "\nReplace first occurrence"
echo "\${MY_ARRAY[@]/e/X}: ${MY_ARRAY[@]/e/X}"
echo "\${MY_ARRAY[@]/e*/X}: ${MY_ARRAY[@]/e*/X}"
# Replace all occurrences
echo -e "\nReplace all occurrences"
echo "\${MY_ARRAY[@]//e/X}: ${MY_ARRAY[@]//e/X}"
echo "\${MY_ARRAY[@]//e*/X}: ${MY_ARRAY[@]//e*/X}"
# Removal of elements
echo -e "\nRemoval of elements"
echo "\${MY_ARRAY[@]//e/}: ${MY_ARRAY[@]//e/}"
echo "\${MY_ARRAY[@]//f*/}: ${MY_ARRAY[@]//f*/}"
# Replace front-end occurrences of string
echo -e "\nReplace front-end occurrences of string"
echo "\${MY_ARRAY[@]/#e/XY}: ${MY_ARRAY[@]/#e/XY}"
echo "\${MY_ARRAY[@]/#f/XY}: ${MY_ARRAY[@]/#f/XY}"
# Replace back-end occurrences of string
echo -e "\nReplace back-end occurrences of string"
echo "\${MY_ARRAY[@]/%e/XY}: ${MY_ARRAY[@]/%e/XY}"
echo "\${MY_ARRAY[@]/%our/XY}: ${MY_ARRAY[@]/%our/XY}"
echo "\${MY_ARRAY[@]/%y/XY}: ${MY_ARRAY[@]/%y/XY}"
```

In this case we have added lines 21 to 25 to our script. In line 23 we are trying to replace the character “`e`” at the end of the string with “`XY`”. In line 24 we are trying to replace the substring “`our`” at the end of the string with “`XY`”. In line 25 we are trying to replace the character “`y`” at the end of the string with “`XY`”.

When you run the script you will the following output in your terminal window.

```txt
$ ./index_array_replace_pattern_back_ending.sh
Content: one two three four five six

Replace first occurrence
${MY_ARRAY[@]/e/X}: onX two thrXe four fivX six
${MY_ARRAY[@]/e*/X}: onX two thrX four fivX six

Replace all occurrences
${MY_ARRAY[@]//e/X}: onX two thrXX four fivX six
${MY_ARRAY[@]//e*/X}: onX two thrX four fivX six

Removal of elements
${MY_ARRAY[@]//e/}: on two thr four fiv six
${MY_ARRAY[@]//f*/}: one two three   six

Replace front-end occurrences of string
${MY_ARRAY[@]/#e/XY}: one two three four five six
${MY_ARRAY[@]/#f/XY}: one two three XYour XYive six

Replace back-end occurrences of string
${MY_ARRAY[@]/%e/XY}: onXY two threXY four fivXY six
${MY_ARRAY[@]/%our/XY}: one two three fXY five six
${MY_ARRAY[@]/%y/XY}: one two three four five six
```

As you can see from the execution the line 23 from our script will affect several elements of the array (the ones with values “`one`”, “`three`” and “`five`” as they all end with the character “`e`”). 

The line 24 from our script will affect one single element (element with value “`four`” as is the only one that ends with the substring “`our`”).

Line 25 from our script will not impact any element (as there is no element ending with the character “`y`”), leaving the array untouched.

Once that we have seen all the possible ways to do a replacement on an array we will learn how to delete an entire array in the next section.

### Delete an entire array

In order to delete a whole array we need to use the built-in command “`unset`” and the name of the array variable without the dollar sign.

Let’s see it in action with an example.

```bash
#!/usr/bin/env bash
#Script: delete_array.sh
MY_ARRAY=( one two three four five six )
echo "Content: '${MY_ARRAY[@]}'"
# Deleting the array
unset MY_ARRAY
echo "Content after deletion: '${MY_ARRAY[@]}'"
```

In the previous script we are declaring an array named “`MY_ARRAY`” on line 3 with 6 elements. Then, on line 6 we are using “`unset`” to remove the contents of the whole array. Last, on line 7, the script shows the content of the array after deleting it.

When you run the previous script you will get the following output in your terminal window.

```txt
$ ./delete_array.sh
Content: 'one two three four five six'
Content after deletion: ''
```

What is basically happening with the deletion is that the variable “`MY_ARRAY`” ceases to exist. 

It’s happening the same thing we saw back in Chapter 4 in the section “[How to delete declared variables?]({{ site.url }}/bash-in-depth/0004-Variables.html#how-to-delete-declared-variables)”.

In the next section we are going to learn how to consult the length of a specific element of the array.

### Consult the length of the i-th element of the array

In a very similar way as we saw on Chapter 5 section “[String length]({{ site.url }}/bash-in-depth/0005-Working-with-Strings.html#string-length)” where we used the syntax “`${#myVariable}`” to get the length of the string inside the variable named “`myVariable`”, for the case of elements of arrays is exactly the same with the difference that we need to provide the position of the element in the array.

This means that we will need to use the syntax “

```bash
    ${#MY_ARRAY[<index>]}
```

To get the length of the element with index “`<index>`”.

Let's see how it works with a simple example script.

```bash
#!/usr/bin/env bash
#Script: array_length_ith_element.sh
MY_ARRAY=( one two three four five six )
echo "Length of \${MY_ARRAY[0]}: ${#MY_ARRAY[0]}"
echo "Length of \${MY_ARRAY[1]}: ${#MY_ARRAY[1]}"
echo "Length of \${MY_ARRAY[2]}: ${#MY_ARRAY[2]}"
echo "Length of \${MY_ARRAY[3]}: ${#MY_ARRAY[3]}"
echo "Length of \${MY_ARRAY[4]}: ${#MY_ARRAY[4]}"
echo "Length of \${MY_ARRAY[5]}: ${#MY_ARRAY[5]}"
```

In the previous script you will see that on line 3 an array named “`MY_ARRAY`” is declared with six items in it.

The code from line 4 until line 9 will print the length of those items.

When you run the previous script you will see the following output in the terminal window.

```txt
$ ./array_length_ith_element.sh
Length of ${MY_ARRAY[0]}: 3
Length of ${MY_ARRAY[1]}: 3
Length of ${MY_ARRAY[2]}: 5
Length of ${MY_ARRAY[3]}: 4
Length of ${MY_ARRAY[4]}: 4
Length of ${MY_ARRAY[5]}: 3
```

As you can see from the running of the script, each single line from line 4 to line 9 prints the length of one of the elements in the array.

This works the same way for associative arrays with **the only difference that you will have to use the keys instead of the indices**.

In the next section we are going to learn how to copy arrays.

### How to copy an array

In order to copy an array to another variable you need to use the syntax “`(${MY_ARRAY[@]})`” and assign it to a variable. Like the following snippet of code.

```bash
    MY_ARRAY_COPY=(${MY_ARRAY[@]})
```

Let's see how it works with a simple example script.

```bash
#!/usr/bin/env bash
#Script: array_copy.sh
MY_ARRAY=( one two three four five six )
declare -p MY_ARRAY
echo -e "\nCopying MY_ARRAY to MY_ARRAY_COPY\n"
MY_ARRAY_COPY=(${MY_ARRAY[@]})
MY_ARRAY_COPY+=("seven")
echo "Original array: "
declare -p MY_ARRAY
echo "Copy array:"
declare -p MY_ARRAY_COPY
```

In the previous script we are declaring an array on line 3 with name “`MY_ARRAY`”, then we copy it to the new variable “`MY_ARRAY_COPY`” on line 6. After copying the array to the new variable, we add a new element on line 7 to the copied array and we show them both to prove that a modification in one of the arrays will not affect the other one.

When you run the previous script you will see the following on your terminal.

```txt
$ ./array_copy.sh
declare -a MY_ARRAY=([0]="one" [1]="two" [2]="three" [3]="four" [4]="five" [5]="six")

Copying MY_ARRAY to MY_ARRAY_COPY

Original array: 
declare -a MY_ARRAY=([0]="one" [1]="two" [2]="three" [3]="four" [4]="five" [5]="six")
Copy array:
declare -a MY_ARRAY_COPY=([0]="one" [1]="two" [2]="three" [3]="four" [4]="five" [5]="six" [6]="seven")
```

As you can see from the execution the variables “`MY_ARRAY`” and “`MY_ARRAY_COPY`” are independent.

In the next section we are going to learn how to take a slice of an array.

### Slice of an array

If we wanted to take a few elements of the array that are in consecutive positions (this is typically called a “*slice*”) we need to use the syntax “`${MY_ARRAY[@]:begin:amount}`”.

What the previous syntax means is “*Starting from the element whose index is `<begin>` grab `<amount>` elements*”.

The values of both “`begin`” and “`amount`” should be whole non-negative numbers (0, 1, 2, etc). If the value of “`amount`” is bigger than the number of elements that remain in the array then only the remaining elements will be selected.

Let's see how it works with simple example script.

```bash
#!/usr/bin/env bash
#Script: array_slice.sh
MY_ARRAY=( one two three four five six )
# Original content
echo "Content: ${MY_ARRAY[@]}"
# Slice of three elements
echo "\${MY_ARRAY[@]:2:3} : ${MY_ARRAY[@]:2:3}"
echo "\${MY_ARRAY[@]:2:30} : ${MY_ARRAY[@]:2:30}"
```

When you run the previous script you will get the following in your terminal window.

```txt
$ ./array_slice.sh
Content: one two three four five six
${MY_ARRAY[@]:2:3} : three four five
${MY_ARRAY[@]:2:30} : three four five six
```

Here you can see that first (on line 5 of the script) the full content of the array is printed. Then (on lines 7 and 8 of the script) there are two slices printed.

The first slice begins at the element with index 2 (whose value is “`three`”) and grabs 3 elements (the first one included), which results in printing elements with values “`three`”, “`four`” and “`five`”.

The second slice begins at the same element (index 2 with value “`three`”). But in this case it tries to grab the next 29 elements as well. As you can see, there are not that many elements in the array and Bash will only show the rest of the elements which are till the last one (element with value “`six`”).

In the next section we are going to learn how to concatenate two arrays.

### Concatenate arrays

To concatenate two different arrays we need to use the following syntax.

```bash
    MY_ARRAY=( ... )
    MY_ARRAY2=( ... )

    MERGED=( "${MY_ARRAY[@]}" "${MY_ARRAY2[@]}")
```

What is happening in the previous syntax? A new array (“`MERGED`”) is being declared that contains the elements of the first array (“`MY_ARRAY`”) followed by the elements of the second array (“`MY_ARRAY2`”).

Although the previous example is using two different arrays, you can use as many arrays as you want.

Let’s see how it works with a simple example script.

```bash
#!/usr/bin/env bash
#Script: array_concatenate.sh
# Declare three different arrays
MY_ARRAY=( one two three four five six )
MY_ARRAY2=( seven eight nine ten eleven twelve )
MY_ARRAY3=( thirteen fourteen fifteen )
# Merge the previous three arrays into one
MERGED=("${MY_ARRAY[@]}" "${MY_ARRAY2[@]}" "${MY_ARRAY3[@]}")
# Print the content of the new array
echo "MERGED: ${MERGED[@]}"
```

In the previous script we are declaring three different arrays that contain different elements. Then we are merging them into a single array (called “`MERGED`”) that contains all of the elements.

When you run the script you get the following.

```txt
$ ./array_concatenate.sh
MERGED: one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen
```

Once we have seen how to declare arrays and what operations we can do on them, we need to take a look at the next step, which is iterating the arrays, and for this we are going to learn the following types of loop:
* For-Loop
* For-Loop (C-style)
* While-Loop
* Until-Loop

## For-Loop

The “`for-loop`“ is a kind of loop that is used to perform actions, a priori, to ALL elements of an array. Its syntax is as follows.

<p align="center">
    <img src="chapters/0012-Arrays-and-loops/images/For-Loop.png" width="450px"/>
</p>

A priori, this seems to be easy enough, but there are some details that we need to be aware of, which is how the loop is executed. Once the script is running, Bash will execute the loop in two steps:
1. Expansion of the `<array>` provided
2. Execution of the commands with the `<array>` expanded

Let's see how to use this for loop with a simple example.

```bash
#!/usr/bin/env bash
#Script: loop-001.sh
# Declaration of the array
declare -a MY_ARRAY=("Item1" "Item2" "Item3")
# Using the for loop to iterate through the array
for item in ${MY_ARRAY[@]}; do
    echo "Item: $item"
done
```

Right before the loop executes, the expansion will replace the syntax referencing the array, meaning `${MY_ARRAY[@]}`, with the actual content of the array resulting in the following.

```bash
    for item in Item1 Item2 Item3; do
        echo "Item: $item"
    done
```

When you run the previous script, the following will appear in your terminal window.

```txt
$ ./loop-001.sh
Item: Item1
Item: Item2
Item: Item3
```

The array expansion has a limitation. What would happen if we have items in the array that contain spaces. Something like the following script.

```bash
#!/usr/bin/env bash
#Script: loop-002.sh
# Declaration of the array
declare -a MY_ARRAY=("Item 1" "Item 2" "Item 3")
# Using the for loop to iterate through the array
for item in ${MY_ARRAY[@]}; do
    echo "Item: $item"
done
```

Following the same reasoning as before the for loop would be expanded as the following.

```bash
    for item in Item 1 Item 2 Item 3; do
        echo "Item: $item"
    done
```

And will generate the following output in the terminal window.

```txt
$ ./loop-002.sh
Item: Item
Item: 1
Item: Item
Item: 2
Item: Item
Item: 3
```

How do we tackle this limitation? There are two ways to do it.

The first one (the easiest one) is to wrap the array with double quotes. Resulting in the following script.

```bash
#!/usr/bin/env bash
#Script: loop-003.sh
# Declaration of the array
declare -a MY_ARRAY=("Item 1" "Item 2" "Item 3")
# Using the for loop to iterate through the array
for item in "${MY_ARRAY[@]}"; do
    echo "Item: $item"
done
```

Please notice how, on line 6, the array “`MY_ARRAY`” is wrapped between double quotes. Now when you run the previous script you will get the following result.

```txt
$ ./loop-003.sh
Item: Item 1
Item: Item 2
Item: Item 3
```

The second way is by using the C-style for loop which we will learn in the next section.

But right before going to the next section I would like to come back to what we discussed back in section “[Get the whole content of the array](#get-the-whole-content-of-the-array)”. In that section we talked about the two ways to get the contents of the array being “`${MY_ARRAY[*]}`” and “`${MY_ARRAY[@]}`”.

We are already very familiar with the second way (“`${MY_ARRAY[@]}`”). What happens if we use one of the previous scripts and use “`${MY_ARRAY[*]}`” instead of “`${MY_ARRAY[@]}`”?

```bash
#!/usr/bin/env bash
#Script: loop-004.sh
# Declaration of the array
declare -a MY_ARRAY=("Item 1" "Item 2" "Item 3")
# Using the for loop to iterate through the array
for item in "${MY_ARRAY[*]}"; do
    echo "Item: $item"
done
```

As you can see in the previous script the only change that was done is on line 6. When you run the previous script you will get the following result.

```txt
$ ./loop-004.sh
Item: Item 1 Item 2 Item 3
```

As you can see from the execution of the script only one single item was printed. The reason for this is because with “`${MY_ARRAY[*]}`” the whole content of the array will be printed as a single string. As it’s one single string the for-loop will interpret it as an array of a single element.

Now that we have wrapped this topic we will proceed to the next section to learn about C-style For-loops.

## For-Loop (C-style)

In this case, we are going to work mainly with indices (integer numbers) and the length of the array.<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a> This kind of loop has the following structure.

<div style="text-align:center">
    <img src="chapters/0012-Arrays-and-loops/images/For-Loop-C-Style.png" width="700px"/>
</div>

Notice the double parenthesis `((...))`, which allows us to work with integer numbers as we saw previously in [Chapter 6](https://github.com/chemacabeza/my-github-projects/blob/master/bash/0006-Working-with-Numbers-Integers.md#compound-command-).

The way it works is as follows:
1. “`<init>`” is executed setting the needed variables
2. “`<stop-condition>`“ is evaluated to check whether the execution of commands has to be done or not. If the result of the condition is “`true`” it will go to step 3. Otherwise, it will go to step 6.
3. “`<commands>`“ are executed. This is the actual logic of the loop and can contain any of the statements we have already seen (variable declarations, other loops, if-else statements, etc)
4. “`<next-step>`“ is executed, preparing the execution for the next iteration of the loop. Typically what happens in this step is that the index that was created in step 1 gets incremented.
5. Go to step 2.
6. End of loop.

Let's see how this kind of loop works with a simple example.

```bash
#!/usr/bin/env bash
#Script: loop-005.sh
# Declaration of an array
declare -a MY_ARRAY=("Item 1" "Item 2" "Item 3")
# Loop iterating through elements of the array
for ((i = 0; i < ${#MY_ARRAY[@]}; i++))
do
    echo "MY_ARRAY[$i]: ${MY_ARRAY[$i]}"
done
```

When you run the previous script you will get the following result in the terminal window.

```txt
$ ./loop-005.sh
MY_ARRAY[0]: Item 1
MY_ARRAY[1]: Item 2
MY_ARRAY[2]: Item 3
```

In the following section we will learn about the “`while`” loop.

## While loop

This kind of loop will execute a list of commands as long as a condition evaluates to true. The shape of this loop is as follows.

<p align="center">
    <img src="chapters/0012-Arrays-and-loops/images/While-Loop.png" width="550px"/>
</p>

As you can imagine, the “`condition`” is an expression like we saw in the [Chapter dedicated to IF-ELSE](https://github.com/chemacabeza/my-github-projects/blob/master/bash/0010-If-statement.md#how-to-test-stuff), so we can use “`test`”, “`[...]`” or “`[[...]]`”. Let’s see some examples in the following script.

```bash
#!/usr/bin/env bash
#Script: loop-006.sh
# Init a counter
i=0
# Single bracket operator
while [ $i -lt 4 ]; do
    echo "Line#$i"
    i=$(($i+1))
done
# Separation and reset counter
echo "----------"
i=0
# test operator
while test $i -lt 5; do
    echo "Line#$i"
    i=$(($i+1))
done
# Separation and reset counter
echo "----------"
i=0
# Double bracket
while [[ $i < 6 ]]; do
    echo "Line#$i"
    i=$(($i+1))
done
```

When you run the previous script you will see the following output in your terminal window.

```txt
$ ./loop-006.sh
Line#0
Line#1
Line#2
Line#3
----------
Line#0
Line#1
Line#2
Line#3
Line#4
----------
Line#0
Line#1
Line#2
Line#3
Line#4
Line#5
```

In the following section we will learn about the “`until`” loop.

## Until loop

This kind of loop will execute a list of commands as long as a condition evaluates to false. The shape of this loop is as follows.

<p align="center">
    <img src="chapters/0012-Arrays-and-loops/images/Until-Loop.png" width="550px"/>
</p>

This kind of loop is similar to the previous “`while`” loop in the sense that it will execute the commands in its body as long as the condition has a specific value.

In the previous “`while`” loop, the execution continued **while the condition was true**. At the moment of having the condition evaluated to false, the loop would stop.

In this “`until`” loop, the execution of the commands in its body will continue **until the condition evaluates to true** (so the condition **must be FALSE for this loop to execute**). At the moment of having the condition evaluated to true, the loop will stop.

Let's see how it works with the following example script.

```bash
#!/usr/bin/env bash
#Script: loop-007.sh
# Initialize counter
i=0
# Using the single bracket operator
until [ $i -gt 4 ]; do
    echo "Line#$i"
    i=$(($i+1))
done
# Separator and re-initialize the counter
echo "----------"
i=0
# Using the test operator
until test $i -gt 5; do
    echo "Line#$i"
    i=$(($i+1))
done
# Separator and re-initialize the counter
echo "----------"
i=0
# Using the double bracket operator
until [[ $i > 6 ]]; do
    echo "Line#$i"
    i=$(($i+1))
done
```

When you run the previous script you will see the following output in the terminal window.

```txt
$ ./loop-007.sh
Line#0
Line#1
Line#2
Line#3
Line#4
----------
Line#0
Line#1
Line#2
Line#3
Line#4
Line#5
----------
Line#0
Line#1
Line#2
Line#3
Line#4
Line#5
Line#6
```

We have learnt how to create loops in different ways. There are times on which we will want to control the execution of the loop to either skip the current iteration and go to the following one, or just end the execution of the loop.

This control is done with the keywords “`continue`” and “`break`”. Those are what we are going to learn next… :) 

## `continue` and `break`

There are times on which we will need to modify the execution of the current loop being executed to either stop it or just cut it short. For that we do have the following keywords that will help us:
* `break`
* `continue`

“`break`” is used to stop the execution of the current loop and to continue with the program.

Let's see how it works with the following example script.

```bash
#!/usr/bin/env bash
#Script: loop-008.sh
# Declaration of array
declare -a MY_ARRAY=(1 2 3 4 5 6 7 8 9 10)
# For-loop that iterates through the array
for item in ${MY_ARRAY[@]}; do
		# Condition to exit on item with value 5
    if [ $item -eq 5 ]; then
        echo "Exiting loop on item '$item'"
        break
    fi
    echo "Current item: $item"
done
```

This was a very basic example. In this case, the loop will iterate over the items of “`MY_ARRAY`” until the condition matches, in that case it will break the current loop.

When you execute the previous script you get the following result.

```txt
$ ./loop-008.sh
Current item: 1
Current item: 2
Current item: 3
Current item: 4
Exiting loop on item '5'
```

But “`break`” can also be invoked with an argument (“`break n`”, being “`n`” an integer bigger or equal to 1). If this extra parameter is included, it will stop the execution of the “`n`” enclosing loops.

Let’s see how it works with an example.

```bash
#!/usr/bin/env bash
#Script: loop-009.sh
# Declaring a couple of arrays
MY_ARRAY1=( 1 2 3 4 5 6 7 8 9 10 )
MY_ARRAY2=( a b c e f g h i j k )
# For-loops iterating through both arrays
for item1 in ${MY_ARRAY1[@]}; do # loop-1
    echo "Item1: $item1"
    for item2 in ${MY_ARRAY2[@]}; do # loop-2
        echo "Item2: $item2"
		   # Exiting both loops when item1 is 5 and item2 is e
        if [ $item1 -eq 5 ] && [ $item2 = 'e' ]; then
            echo "Exiting both loops on items '$item1' and '$item2'"
            break 2 # Exiting both loop-1 and loop-2
        fi
    done
    echo "Ending execution of loop-1"
done
```

When you execute the previous script you will the following in the terminal window.

```txt
$ ./loop-009.sh
Item1: 1
Item2: a
Item2: b
Item2: c
Item2: e
Item2: f
Item2: g
Item2: h
Item2: i
Item2: j
Item2: k
Ending execution of loop-1
Item1: 2
Item2: a
Item2: b
Item2: c
Item2: e
Item2: f
Item2: g
Item2: h
Item2: i
Item2: j
Item2: k
Ending execution of loop-1
Item1: 3
Item2: a
Item2: b
Item2: c
Item2: e
Item2: f
Item2: g
Item2: h
Item2: i
Item2: j
Item2: k
Ending execution of loop-1
Item1: 4
Item2: a
Item2: b
Item2: c
Item2: e
Item2: f
Item2: g
Item2: h
Item2: i
Item2: j
Item2: k
Ending execution of loop-1
Item1: 5
Item2: a
Item2: b
Item2: c
Item2: e
Exiting both loops on items '5' and 'e'
```

If the number specified as an extra parameter is bigger than the number of levels of loop, it will just stop the execution of the maximum number of loops and nothing will break.

“`continue`”  is the other keyword to know to operate in the loops. This keyword is used for when you want to stop the current iteration of the loop and jump to the next one.

Let’s see an example to better understand how it works.

```bash
#!/usr/bin/env bash
#Script: loop-010.sh
# Declaring a couple of arrays
MY_ARRAY1=( 1 2 3 4 5 6 7 8 9 10 )
MY_ARRAY2=( a b c d e f g h i j )
# For-loop iterating through both arrays
for item1 in ${MY_ARRAY1[@]}; do # loop-1
    echo "Item1: $item1"
    for item2 in ${MY_ARRAY2[@]}; do # loop-2
        echo "Item2: $item2"
        # Jumping to the next iteration of inner loop
        if [ $item2 = "d" ] && [ $item1 -eq 5 ]; then
            echo "Jumping on 'd' and '5'"
            continue
        fi
        echo "End Item2"
    done
    echo "End Item1"
done
```

When you run the previous script you will get the following result in the terminal window.

```txt
$ ./loop-010.sh
Item1: 1
Item2: a
End Item2
Item2: b
End Item2
Item2: c
End Item2
Item2: d
End Item2
Item2: e
End Item2
Item2: f
End Item2
Item2: g
End Item2
...
End Item2
Item2: b
End Item2
Item2: c
End Item2
Item2: d
Jumping on 'd' and '5'
Item2: e
End Item2
...
End Item2
Item2: e
End Item2
Item2: f
End Item2
Item2: g
End Item2
Item2: h
End Item2
Item2: i
End Item2
Item2: j
End Item2
End Item1
```

Similar to “`break`”, “`continue`” is able to accept an extra parameter which will skip the execution of the loop “`n`” levels above. Let’s see how it works with the following script as an example.

```bash
#!/usr/bin/env bash
#Script: loop-011.sh
# Declaring a couple of arrays
MY_ARRAY1=( 1 2 3 4 5 6 7 8 9 10 )
MY_ARRAY2=( a b c d e f g h i j )
# For-loops iterating through the arrays
for item1 in ${MY_ARRAY1[@]}; do # loop-1
    echo "Item1: $item1"
    for item2 in ${MY_ARRAY2[@]}; do # loop-2
        echo "Item2: $item2"
        # Continue to next iteration of the outer loop
				# when item1 is 5 and item2 is d
        if [ $item2 = "d" ] && [ $item1 -eq 5 ]; then
            echo "Jumping on 'd' and '5'"
            continue 2 # go to next iteration of loop-1
        fi
        echo "End Item2"
    done
    echo "End Item1"
done
```

When you run the previous script you get the following result.

```txt
$ ./loop-011.sh
Item1: 1
Item2: a
End Item2
Item2: b
End Item2
Item2: c
End Item2
Item2: d
End Item2
Item2: e
End Item2
...
End Item1
Item1: 5
Item2: a
End Item2
Item2: b
End Item2
Item2: c
End Item2
Item2: d
Jumping on 'd' and '5'
Item1: 6
Item2: a
End Item2
...
End Item2
Item2: h
End Item2
Item2: i
End Item2
Item2: j
End Item2
End Item1
```

Same as with “`break`” you should provide an integer number that is bigger or equal to 1. If the number provided is larger than the level of loops, the outer loop will be skipped.

## Summary

In this chapter we learnt a lot about the different kinds of arrays and how to iterate them.

We learnt what indexed and associative arrays are and the differences between them.

We learnt what are the different operations that can be applied to the arrays (like adding elements, getting slices of the arrays, adding new elements, removing elements knowing the index or the pattern and so much more).

Then we learnt how to iterate through the arrays with different kinds of loops like the for-loops, the for-loops with C-style, while-loops and until-loops.

After the loops we learnt how to control the flow within the loops by using the “`continue`” and “`break`” key words.

Last, but not least, we learnt how to use associative arrays to be used as sets.

This was a lot of content. My recommendation for you is to practice to test the limits of your understanding.


## References
1. <https://linuxhint.com/associative_arrays_bash_examples/>
2. <https://ostechnix.com/bash-indexed-array/>
3. <https://ryanstutorials.net/bash-scripting-tutorial/bash-loops.php>
4. <https://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-7.html>
5. <https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_05.html>
6. <https://unix.stackexchange.com/questions/417292/bash-for-loop-without-a-in-foo-bar-part>
7. <https://unix.stackexchange.com/questions/746480/what-is-difference-between-these-two-declarations-of-associative-arrays-in-bash/>
8. <https://www.gnu.org/software/bash/manual/html_node/Arrays.html>
9. <https://www.shell-tips.com/bash/arrays/#gsc.tab=0>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

<p id="footnote-1" style="font-size:10pt">
1. Up to thre reader to give it a try.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. <code>${#MY_ARRAY}</code>.<a href="#footnote-2-ref">&#8617;</a>
</p>

