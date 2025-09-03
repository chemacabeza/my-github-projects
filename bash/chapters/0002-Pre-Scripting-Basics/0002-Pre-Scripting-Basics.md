# Pre-Scripting Basics

If you noticed, the "Hello World!" script that we wrote in the previous chapter the very first line looks like this.

```bash
 1 #!/bin/bash  <<<<<<<<<<<<<<<
 2 #Script: hello_world.sh
 3 echo "Hello World!"
```

That very first line is called "`Shebang`" or "`Hashbang`". This line is used by the Linux Kernel (and not the interpreter) to know how to execute it.

When you set the executable bit on a script file and then try to execute the file, the filename is passed directly to the kernel; the shell has nothing to do with interpreting the first line in the script. The first two characters in the file (the hash and the bang (exclamation mark)) are often referred to (when combined into a single word) as the "*magic number*" of a script file. 

With this "*magic number*", the kernel is able to identify the file as a script, and it (the kernel) then reads the first line of the file and starts the script interpreter that's specified in the first line and passes the script filename to the interpreter.

What are the steps that the Kernel follows?
1. Once the script is executed, the file name of the script is passed directly to the Kernel
2. The Kernel will read the first two characters (referred as “magic number”) and match against the list of possible “magic number”s that have registered. 
3. If the Kernel is not able to find magic number in its list, it will return an error to the caller
4. If this execution fails because the file is not in executable format, and the file is not a directory, it is assumed to be a shell script, a file containing shell commands.

On the scripts that you will see in this book we are going to always write the hasbang at the beginning of the script as is considered a good practice.

## References
* https://www.linuxjournal.com/content/what-heck-hash-bang-thingy-my-bash-script

