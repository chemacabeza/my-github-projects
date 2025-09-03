# Chapter 9: Environment Variables

**Environment Variables** are a fundamental concept in operating systems and software development. They are dynamic values that provide essential information about the system environment or influence how processes behave. In Bash, environment variables are used to store configuration settings, system information, and user-defined values. These variables can be accessed by processes and programs to retrieve information or modify behavior.

In this chapter we are going to learn about the commands “`env`”, “`export`” and will revisit the “`declare`” command.

## Command “`env`”

The “`env`” command in Bash is used to display a list of all environment variables. When you run “`env`” in the terminal, it will show a list of key-value pairs representing the current environment variables. For example, you might see variables like “`PATH`”, which defines where the system should look for executable files, and “`HOME`”, which points to the current user's home directory.

The purpose of this command is either:
* Print environment information
* Set/modify environment and execute a command

To print the environment of your current Bash session just invoke it without any arguments.
You will see that it will produce a result similar to the following.

```txt
$ env
SHELL=/bin/bash
LSCOLORS=Gxfxcxdxbxegedabagacad
SESSION_MANAGER=local/prometeus:@/tmp/.ICE-unix/3579,unix/prometeus:/tmp/.ICE-unix/3579
QT_ACCESSIBILITY=1
COLORTERM=truecolor
XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
LESS=-R
XDG_MENU_PREFIX=gnome-
TERM_PROGRAM_VERSION=3.4
GNOME_DESKTOP_SESSION_ID=this-is-deprecated
TMUX=/tmp/tmux-1000/default,9002,0
JAVA_HOME=/usr/lib/jvm/current
GNOME_SHELL_SESSION_MODE=ubuntu
SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
MEMORY_PRESSURE_WRITE=c29tZSAyMDAwMDAgMjAwMDAwMAA=
XMODIFIERS=@im=ibus
DESKTOP_SESSION=ubuntu
GTK_MODULES=gail:atk-bridge
...
TERM_PROGRAM=tmux
_=/usr/bin/env
```

Which are the environment variables of your current session in Bash.

This command comes with some options that allows you to:
* Add new environment variables temporarily
* Override environment variables temporarily
* Delete environment variables temporarily
* Ignore environment variables temporarily

For all of these cases, if a command is provided it will be executed with the environment variables resulting from the behavior specified. Let’s take a look at examples for all the cases mentioned before.

But first we are going to write a script that prints a few variables (with the “`echo`” command) and to print the full list of environment variables (with the “`env`” command).

```bash
 1 #!/bin/bash
 2 #Script: env_command.sh
 3 echo "User name : $USER"
 4 echo "Home : $HOME"
 5 echo "Path : $PATH"
 6 echo "These are the environment variables"
 7 echo "#####################"
 8 env
 9 echo "#####################"
```

In the previous script you will see that on line 3, 4 and 5 the values of the environment variables “`USER`”, “`HOME`” and “`PATH`” are printed. Then on lines 7 to 9 the environment variables available to your script are printed.

We will use the previous script to play with the previous four options that we mentioned before.

In the next subsections we will explore everything we can do with the “`env`” command.

### Adding a variable

The “`env`” command can be used to add variables to the environment of a script. For this we need to use the following syntax.

```bash 
    env MY_VAR=”<Value>” ./my_script.sh
```

With the previous syntax the “`env`” command will execute the script or command provided with a new environment variable (in our case “`MY_VAR`”).

We are going to use the previous script "`env_command.sh`" to show you how it is done.

```txt
$ env MY_VAR="Some Value" ./env_command.sh
User name : username
Home : /home/username
Path : /home/username/gems/bin:/home/username/gems/bin:/home/username/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:/opt/WebDriver/bin:/home/username/.fzf/bin:/opt/WebDriver/bin
These are the environment variables
#####################
SHELL=/bin/bash
...
HOME=/home/username
USERNAME=username
LANG=en_US.UTF-8
MY_VAR=Some Value
...
#####################
```

As you can see from the execution of the previous example, the variable that was passed as the first argument to the “`env`” command is added to the rest of environment variables that the script “`env_command.sh`” can see.

In the next section we will use the “`env`” command to override the value of existing environment variables.

### Overriding a variable

With the “`env`” command you can as well override the value of an existing variable. You can use the same syntax as in the previous section but you only need to make sure that you are using the name of a variable that already exists.

Let’s take a look at the following example where we are going to override the value of the environment variable “`USER`” that exists already.

```txt
User name : Overwritten_User
Home : /home/username
Path : /home/username/gems/bin:/home/username/gems/bin:/home/username/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:/opt/WebDriver/bin:/home/username/.fzf/bin:/opt/WebDriver/bin
These are the environment variables
#####################
SHELL=/bin/bash
...
USER=Overwritten_User
TMUX_PANE=%8
GNOME_TERMINAL_SERVICE=:1.116
SDKMAN_DIR=/home/username/.sdkman
DISPLAY=:1
...
#####################
```

As you can see from the execution of the previous example, the variable “`USER`” got its value overridden from the previous value of “`username`” to the new value of “`Overwritten_User`”.

In the next section we will learn how to use the “`env`” command to delete an environment variable.


### Deleting a variable

With the “`env`” command you are able to delete an environment variable so that the script that you run does not have any value for the specified variable. To be able to have this behavior you have to use the following syntax.

```bash
    env -u MY_VAR ./my_script.sh
```

With the previous syntax you are removing the environment variable “MY_VAR” from the set of environment variables that the script (or command) is able to see.

```txt
$ env -u USER ./env_command.sh
User name :
Home : /home/username
Path : /home/username/gems/bin:/home/username/gems/bin:/home/username/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:/opt/WebDriver/bin:/home/username/.fzf/bin:/opt/WebDriver/bin
These are the environment variables
#####################
SHELL=/bin/bash
LSCOLORS=Gxfxcxdxbxegedabagacad
...
HOME=/home/username
USERNAME=username
LANG=en_US.UTF-8
...
GDMSESSION=ubuntu
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
OLDPWD=/home/username/Repositories/username.github.io.git/_bash-in-depth/chapters/0009-Environment-Variables
TERM_PROGRAM=tmux
_=/usr/bin/env
#####################
```

In the result of the execution of this option you see that the environment variable “`USER`” is no longer available to the script.

Last but not least we are going to learn how to temporarily ignore environment variables that the script will have access to.

### Empty environment
The “`env`” command comes with an option called “`--ignore-environment`” (or “`-i`”) that provides an empty environment (meaning with no environment variables) where a script or a command will run.

Let’s see an example where we will run the script that we created with an empty environment.

```txt
$ env -i ./env_command.sh
User name :
Home :
Path : /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
These are the environment variables
#####################
PWD=/home/username/current-tests
SHLVL=1
_=/usr/bin/env
#####################
```

I am pretty sure you expected an empty environment. The variables “`PATH`”, “`PWD`”, “`SHLVL`” and “`_`” have a value because they are set by the shell itself.

Apart from the previous 4 variables, the environment is completely empty.

There are several benefits of using the flag “`-i`” of the “`env`” command.

By running a command in a clean environment, you ensure that the command's behavior is not affected by any environment variables that might be set. This provides a high level of **predictability and isolation**, making it easier to debug and reproduce issues.

Clearing the environment can enhance **security**. It prevents potentially malicious environment variables from influencing the behavior of a command. This is particularly important in scenarios where commands are executed with untrusted input.

When writing scripts or automation, you may want to ensure that a command or script is executed without any interference from existing environment variables.

Sometimes, you might want to run a command with specific environment variable values that differ from the current ones.

While “`env -i`” has its benefits, use it with caution, as clearing the environment can potentially disrupt the normal operation of commands that rely on specific environment variables. It's particularly useful in controlled scenarios where you need to ensure a clean, isolated environment for a specific task.

### “`env`” in the Shebang (`#!`)
The shebang (`#!`) at the start of a script tells the system which interpreter to use to execute the file. For Bash scripts, you commonly see:
* `#!/bin/bash`
* `#!/usr/bin/env bash`

These specify different ways to invoke the Bash shell.

1. `/bin/bash`
    * This is an absolute path to the bash binary.
    * When you use `#!/bin/bash`, the system looks for the bash interpreter directly in the `/bin` directory.
    * **Limitation**: It assumes that `bash` is installed specifically in `/bin`, which might not always be the case on systems like macOS, BSD, or systems with custom Bash installations.
2. `/usr/bin/env bash`
    * The command `env` is a utility that looks for `bash` in the system's `PATH` environment variable and executes it.
    * When you use `#!/usr/bin/env bash`, the system first runs `env`, which searches for `bash` in all the directories listed in the `PATH` variable.
    * **Advantage**: It is more portable because it doesn't rely on bash being in `/bin`. If bash is installed in a custom location or the user is using a different version of `bash`, `env` will locate it based on the system's `PATH`.

Using `#!/usr/bin/env bash` is **more portable** because it works on systems where `bash` might not be located in `/bin`. Using `#!/bin/bash` is **less flexible** (less portable) and assumes `bash` is always in `/bin`, which is true for most Linux distributions but not for all operating systems.

On performance `#!/bin/bash` directly invokes Bash, so there's no intermediate step. `#!/usr/bin/env bash` first invokes the `env` command to find `bash`, which can be slightly slower due to this extra step, though this difference is negligible in most cases.

Alright! Up until now we have seen the use of “`env`” to create an environment that is temporary. We also learnt why is more portable using it in the Shebang of the script. 

Now, what if we wanted to create a new variable that is not that temporary? The answer to this is the “`export`” command.


## Command “`export`”

So, in the previous section we learnt how to create temporary variables that could be used by a script (if provided a command). The limitation of that approach was that the environment variables were bound to an execution of a script within a bash session. Once it was executed, the variable would disappear. If we wanted to continue using that variable again, we would need to do the same trick. In this section we will learn how to specify a variable **once** to be reused several times in the same session. 

The “`export`” command in Bash is used to mark a variable as an environment variable, making it accessible to child processes spawned from the current shell. So, once we execute this command setting a variable, every script/program triggered within the current script (or shell) will be able to use the variable.

We are going to see how it works using two scripts.

The first script will just use the “`export`” command with a variable called “`MY_VAR`” that will have a dummy value (the actual value of the variable does not matter). Once the export is done this script will run a second script that will print the environment variables.

The first script is as follows.

```bash
 1 #!/usr/bin/env bash
 2 #Script: export_command.sh
 3 # Declare new environment variable
 4 export MY_VAR="My Value"
 5 # Invoke secondary script
 6 ./secondary.sh
```

As you can see in the previous script it just exports a variable and calls the “`secondary.sh`” script, which looks as follows.

```bash
 1 #!/usr/bin/env bash
 2 #Script: secondary.sh
 3
 4 echo "##########"
 5 env
 6 echo "##########"
```

Now, if you execute the “`export_command.sh`” script you will see something like the following.

```txt
$ ./export_command.sh
##########
SHELL=/bin/bash
LSCOLORS=Gxfxcxdxbxegedabagacad
...
LOGNAME=username
XDG_SESSION_DESKTOP=ubuntu
XDG_SESSION_TYPE=x11
GPG_AGENT_INFO=/run/user/1000/gnupg/S.gpg-agent:0:1
SYSTEMD_EXEC_PID=3612
XAUTHORITY=/run/user/1000/gdm/Xauthority
WINDOWPATH=2
HOME=/home/username
USERNAME=username
...
MY_VAR=My Value
...
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
OLDPWD=/home/username/Repositories/username.github.io.git/_bash-in-depth/chapters/0009-Environment-Variables
TERM_PROGRAM=tmux
_=/usr/bin/env
##########
```

In the previous execution you see that the variable “`MY_VAR`” was inherited by the “`secondary.sh`” script from the “`export_command.sh`” script. You might be thinking that the “`MY_VAR`” variable was added to the current shell, but that is not the case.

If you run the command “`env`” in your current shell you will notice that the variable “`MY_VAR`” does not appear. The reason for this is that Bash will create a new process<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a> with the environment variables that already exist plus the variable “`MY_VAR`”. Once the script is done running the memory allocated for the environment variables for the “`command_export.sh`” script and “`secondary.sh`” script will be deallocated leaving the environment variables of the current shell untouched.

Once we are familiar with the “`export`” command we are going to revisit the “`declare`” command.

## Revisiting “`declare`”

As we already mentioned, the “`declare`” builtin command is used to give the variables some specific attributes. In this section we are going to take a look at how to declare variables in the same way as the “`export`” command.

To be able to do this, we will use the option “`-x`” of “`declare`”. There are two ways to use the command.

The first way is to use it without any arguments, as follows.

```bash
    declare -x
```

When invoked like that it will display all the variables that have been exported in the current Bash session.

The second way to use this command is by using it to actually declare and export a variable. This can be done using the following syntax.

```bash
    declare -x NAME=VALUE
```

When invoked in this way it will have the same effect as the “`export`” command meaning that the variable will be visible by other scripts/programs that are launched in the same script or shell where the “`declare -x`” command was run.

Let’s see how it works with the following script as an example.

```bash
 1 #!/usr/bin/env bash
 2 #Script: declare_export.sh
 3 declare -x MY_VAR="My Value"
 4 ./secondary.sh
```

The previous script is similar to the “`export_command.sh`” script that we saw before. On line 3 the variable “`MY_VAR`” is declared with the command “`declare -x`” to have it exported so that the “`secondary.sh`” script is able to see it.

If you execute the “`declare_export.sh`” script you will see that it works exactly the same as the script “`export_command.sh`”. Just give it a try and execute it.

## Summary

Very well done!

In this chapter you learnt about how to play with environment variables and how to export them so that other programs or scripts can use them.

With the “`env`” command we learnt how to add, override and delete variables (temporarily). With the same command we learnt how to provide an environment that is (more or less) empty for other scripts and programs to run.

We also learnt why using the “`env`” in the Shebang of the script is more portable than using the absolute path to the `bash` program.

We learnt how to make variables available to other scripts and programs by “*exporting*” them using the new command “`export`” and the command “`declare`” that we already knew.

Now that you are done with this chapter, keep practicing. Remember… practice makes perfect.

## References

1. <https://phoenixnap.com/kb/bash-declare>
2. <https://tldp.org/LDP/abs/html/declareref.html>
3. <https://www.computerhope.com/unix/uenv.htm>
4. <https://www.cyberciti.biz/faq/linux-unix-shell-export-command/>
5. <https://www.digitalocean.com/community/tutorials/export-command-linux>
6. <https://www.shell-tips.com/bash/environment-variables/#gsc.tab=0>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

<p id="footnote-1" style="font-size:10pt">
1. More on this at a later chapter.<a href="#footnote-1-ref">&#8617;</a>
</p>

