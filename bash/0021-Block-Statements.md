# Chapter 21: Block Statements

In Bash, block statements enable you to group multiple commands or code structures together for cohesive execution. They serve a range of purposes, such as creating conditional constructs, managing loops, or executing multiple commands as a single unit. Blocks are particularly useful when you want to apply logic like conditionals or loops to more than one command without writing each command individually.

## Types of Block Statements

There are a few primary ways to create blocks in Bash. The most common are:

1. **Curly Braces** "`{ }`": Commands grouped within curly braces are treated as a single compound command. This is useful for bundling several commands and executing them in contexts like conditional checks or function definitions. Commands within "`{ }`" are executed sequentially, separated by semicolons or line breaks. For instance, in an if statement, "`{ }`" can group multiple commands under the same conditional branch.

2. **Parentheses** "`( )`": This syntax groups commands in a **subshell**<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>, meaning the commands execute in a separate process from the main shell. The primary distinction between "`{ }`" and "`( )`" is that the latter's use of a subshell allows for environment isolation, meaning variables or changes within "`( )`" do not affect the main shell environment.

3. "`do`" and "`done`" with loops<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a>: Used in "`for`", "`while`", or "`until`" loops, "`do`" and "`done`" delimit the start and end of the block to be repeated. Commands between these keywords will execute repeatedly according to the loop condition, enabling efficient iteration over items or repeated execution of logic until conditions are met.

Understanding these block statements is key for writing structured and maintainable Bash scripts, as they provide control over the flow and scope of commands, enhancing readability and functionality.

Let's see an example script using the Curly Braces.

```bash
#!/usr/bin/env bash
#Script: block-statement-0001.sh
echo "Block reading from Standard Input"
{
   while read line; do
	      echo "Line read: '$line'"
   done
}
echo "End of program"
```

The previous script will read from the standard input<a id="footnote-3-ref" href="#footnote-3" style="font-size:x-small">[3]</a>, stores the text in a variable named "`line`" (line 5 of the previous script) and prints it back to the screen.

When you execute the previous script you will get the following in your terminal window.

```txt
$ ./block-statement-0001.sh
Block reading from Standard Input
Line1
Line read: 'Line1'
Line2
Line read: 'Line2'
^C
```

As you can see this is a very simple script which would work the same way as not using Curly Braces, at a later chapter you will see how we can take advantage of the Curly Braces combining it with I/O Redirections<a id="footnote-4-ref" href="#footnote-4" style="font-size:x-small">[4]</a>.

## Summary

Block statements in Bash allow multiple commands to be grouped together for cohesive execution in various contexts. They are especially useful for conditional logic (like "`if`" or "`case`" statements) and loops, enabling repeated actions across lists or conditions. With subshells, block statements can create isolated environments where variables or system states don’t affect the main shell. Additionally, they are valuable for error handling, logging, and organizing reusable code into functions or modules. By using block statements, scripts can become more modular, readable, and robust for complex workflows.

*"Take command of your code with block statements; every line becomes a step closer to mastery and clean logic."*

## References

1. <http://mywiki.wooledge.org/BashGuide/CompoundCommands#Command_grouping>
2. <https://unix.stackexchange.com/questions/390329/statement-blocks-mechanism-in-shell-scripting>
3. <https://unix.stackexchange.com/questions/726866/curly-braces-meaning>
4. <https://www.gnu.org/software/bash/manual/bash.html#Command-Grouping>



<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">
<p id="footnote-1" style="font-size:10pt">
1. We will talk about Subshells at a later chapter.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. We already talked about them in <a href="{{ site.url }}/bash-in-depth/0012-Arrays-and-loops.html">Chapter 12</a>.<a href="#footnote-2-ref">&#8617;</a>
</p>
<p id="footnote-3" style="font-size:10pt">
3. Which in our case is the keyboard.<a href="#footnote-3-ref">&#8617;</a>
</p>
<p id="footnote-4" style="font-size:10pt">
4. We will talk about I/O redirections at a later chapter.<a href="#footnote-4-ref">&#8617;</a>
</p>

