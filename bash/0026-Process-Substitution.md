# Chapter 26: Process Substitution

## Introduction

Process substitution is a powerful redirection technique that allows the input or output of a command (or set of commands) to be treated as if it were a temporary file.

This method can be employed in two distinct forms:
* "`main_command <(commands)`"
* "`main_command >(commands)`"

In both cases, the substitution syntax is replaced by the absolute path of a temporary file. However, the way this temporary file is utilized depends on the specific substitution format.

## Reading from a Process Substitution

The first form of process substitution, "`<(commands)`", is replaced by a path like "`/proc/self/fd/12`" (or a similar system-dependent path). When this syntax is used, the commands within the parentheses are executed, and their standard output is redirected to the temporary file represented by the path. Conceptually, it works as if you had written:

```bash
    commands > /proc/self/fd/12
```

After this step, the temporary file serves as input for the primary command you wish to run. For example:

```txt
    echo <(ls)
```

This outputs something like "`/proc/self/fd/11`"<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a>.

This operation is equivalent to:

```txt
$ ls > /proc/self/fd/11
$ echo /proc/self/fd/11
```

In this example, the path to the temporary file is simply printed. A more practical use of this substitution might involve utilizing the output directly:

```txt
$ wc -l <(ls)
```

This command outputs:

```txt
25 /proc/self/fd/11
```

or something similar

Essentially, this compact operation is the shorthand for:

```txt
$ ls > /proc/self/fd/11
$ wc -l /proc/self/fd/11
```

By using process substitution, the commands are seamlessly integrated, streamlining complex workflows.

Let's play with this process substitution in the following Bash script.

```bash
#!/usr/bin/env bash
#Script: process-substitution-0001.sh
while read line; do
		echo "Processing: $line"
done < <(ls /tmp)
```

When you execute the previous script you will have an output like the following.

```txt
$ ./process-substitution-0001.sh
Processing: gdm3-config-err-fVCCRF
Processing: hsperfdata_chemacabeza
Processing: kotlin-idea-6632521335503499986-is-running
Processing: qtsingleapp-FoxitR-e4d5-3e8
Processing: qtsingleapp-FoxitR-e4d5-3e8-lockfile
Processing: snap-private-tmp
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-bluetooth.service-c2ZBdf
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-bolt.service-uQ2JIU
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-colord.service-TJHt0g
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-fwupd.service-4LQO6m
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-ModemManager.service-ToNwKx
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-polkit.service-RDuixc
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-power-profiles-daemon.service-HDhFTG
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-switcheroo-control.service-VdgSCe
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-systemd-logind.service-NhbgXw
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-systemd-oomd.service-HZo4aw
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-systemd-resolved.service-sv79hy
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-systemd-timesyncd.service-uXHWTz
Processing: systemd-private-07773a8f89ce4667a3c8af364e9b59d7-upower.service-3nuIYI
Processing: tmux-1000
Processing: v8-compile-cache-1000
Processing: veD1Lkc

$ 
```

The beauty of process substitution "`<(...)`" lies in its flexibility—you can incorporate redirections, pipes, and all the concepts we've explored so far. This makes it an incredibly powerful tool, readily available at your fingertips.


## Writing to a Process Substitution

The second form, "`>(commands)`", is also replaced with a path like "`/proc/self/fd/12`" (or another system-specific path). In this case, the output of the main command is redirected to a temporary file, which is then connected as the standard input for the specified "`commands`".

Here’s an example:

```bash
$ ls > >(while read -r file; do echo "FILE: $file"; done)
```

In this example, the output of the "`ls`" command is stored in a temporary file (e.g., "`/proc/self/fd/12`") and used as the standard input for the script inside the parentheses. The script processes each line, prepending "`FILE:`" to the filenames.

If you're curious about the temporary file being used, you can reveal it with the built-in echo command, just as before:

```bash
$ echo >(while read -r file; do echo "FILE: $file"; done)
/proc/self/fd/15

$
```

## Summary

Process substitution is a powerful feature in Bash that enables commands to exchange data through temporary files, providing a seamless mechanism for integrating complex workflows. This feature allows the output of one command to be used as input for another, bypassing the need for intermediate files or manual redirection. There are two primary forms of process substitution: "`<(commands)`" and "`>(commands)`", each serving distinct purposes while simplifying tasks that involve inter-process communication.

The first form, "`<(commands)`", executes the specified commands and connects their output to a temporary file, which can then be accessed by other commands. This allows users to treat the output of a command as if it were a static file, enabling streamlined integration with commands that expect file inputs. For instance, it is particularly useful when comparing the output of multiple commands or processing dynamic data sets without the need for intermediate storage.

The second form, "`>(commands)`", operates in reverse, redirecting the output of a main command into a temporary file, which is subsequently provided as standard input to the specified commands. This approach is ideal for scenarios where the output of one command needs to be processed or modified before being used elsewhere. It extends the flexibility of pipelines by allowing the processed data to flow dynamically without creating unnecessary files.

One of the standout advantages of process substitution is its compatibility with other Bash features, including pipes, redirection, and loops. This versatility makes it an invaluable tool for automating tasks and managing complex operations. By leveraging process substitution, users can construct efficient, elegant solutions that enhance productivity and minimize manual intervention in data processing workflows.

*"The beauty of process substitution lies in its simplicity and power—proof that elegance in scripting is always within reach."*

## References
1. <https://en.wikipedia.org/wiki/Process_substitution>
2. <https://linuxhandbook.com/bash-process-substitution/>
3. <https://medium.com/factualopinions/process-substitution-in-bash-739096a2f66d>
4. <https://mywiki.wooledge.org/ProcessSubstitution>
5. <https://sysxplore.com/process-substitution-in-bash/>
6. <https://tldp.org/LDP/abs/html/process-sub.html>
7. <https://unix.stackexchange.com/questions/17107/process-substitution-and-pipe>
8. <https://unix.stackexchange.com/questions/324167/meaning-of-2-command-redirection-in-bash>
9. <https://wiki.bash-hackers.org/syntax/expansion/proc_subst>
10. <https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html>
11. <https://www.linuxjournal.com/content/shell-process-redirection>
12. <https://www.linuxtopia.org/online_books/advanced_bash_scripting_guide/process-sub.html>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">
<p id="footnote-1" style="font-size:10pt">
1. This path <b>is system-dependent</b> it could be "<code style="font-size:9pt">/proc/self/fd/12</code>" or "<code style="font-size:9pt">/dev/fd/63</code>" or something different.<a href="#footnote-1-ref">&#8617;</a>
</p>

