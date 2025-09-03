---
layout: chapter
title: "Chapter 8: time and date commands"
---

# Chapter 8: `time` and `date` commands

## Index
* [The `time` command]({{ site.url }}//bash-in-depth/0008-Time-and-date-commands.html#the-time-command)
* [The `date` command]({{ site.url }}//bash-in-depth/0008-Time-and-date-commands.html#the-date-command)
* [Summary]({{ site.url }}//bash-in-depth/0008-Time-and-date-commands.html#summary)
* [References]({{ site.url }}//bash-in-depth/0008-Time-and-date-commands.html#references)

<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px">

The “`time`” and “`date`” commands in Bash are essential utilities that provide valuable information about time, date, and the execution time of commands and scripts. They play crucial roles in scripting, system administration, and various automation tasks, helping users manage time-related data and track the performance of processes.

The “`date`” command allows users to display and manipulate date and time information. It provides a way to retrieve the current date and time, format it according to various preferences, and even perform date arithmetic. With “`date`”, users can generate timestamps for logs, schedule tasks, and create custom date formats for displaying time-related information in scripts or on the command line. Its flexibility makes it a versatile tool for working with time-related data in a Bash environment.

On the other hand, the “`time`” command serves a different but equally important purpose. It is used to measure the execution time of a given command or script. By running a command with “`time`” as a prefix, users can obtain detailed information about the real time elapsed, system time used, and user time consumed during the execution of that command. This is incredibly valuable for performance analysis, profiling, and optimizing scripts and processes. It allows users to identify bottlenecks, measure the impact of optimizations, and gain insights into how efficiently a command or script runs.

Overall, “`time`” and “`date`” are indispensable utilities in your Bash toolbox, enabling users to work effectively with time and to analyze the performance of their scripts and commands.

## The `time` command
As we mentioned already in the introduction of this chapter, the “`time`” command is used to measure the execution time of a given command or script.

When the “`time`” command is executed the following steps happen:
* Step-1: Takes the current time (before executing the command)
* Step-2: Executes the command passed as argument
* Step-3: Takes the current time again (after executing the command)
* Step-4: Calculates the difference between times at steps #1 and #3
* Step-5: Prints the result coming from the “`time`” command with three different durations

Let’s see how it works with the following example where we are going to measure the “`ls`”<a id="footnote-1-ref" href="#footnote-1" style="font-size:x-small">[1]</a> command.

```bash
 1 #!/usr/bin/env bash
 2 #Script: time_ls.sh
 3 echo -e "Beginning\n"
 4 time ls -l
 5 echo -e "\nEnd"
```

When you execute the previous script you will have as result something like the following.

```txt
$ ./time_ls.sh
Beginning

total 4
-rwxrwxr-x 1 username username 89 Sep 20 19:36 time_ls.sh

real	0m0.003s
user	0m0.001s
sys 	0m0.002s

End
```

Right after the command is executed you will see that there are 3 additional lines with “`real`”, “`user`” and “`sys`”. Those are different durations and their meaning is as follows:
* **Real** (“*Real CPU Time*”): Wall clock time, also known as the call's total duration, encompasses all the time elapsed during the entire call's lifecycle. This includes not only the time actively spent executing the call but also any periods during which the process is waiting for input/output operations to conclude or sharing processor time with other processes.
* **User** (“*User CPU Time*”): Represents the quantity of CPU time utilized by a process for executing user-mode code, excluding any time spent inside the kernel. It accounts solely for the actual CPU time actively consumed during the process's execution, without considering time spent by other processes or periods during which the process is blocked.
* **Sys** (“*Kernel CPU Time*”): Represents the duration of CPU time allocated to a process while executing code within the kernel. This accounts for the CPU time expended on system calls within the kernel, distinct from library code that remains in user-space. Similar to "User CPU Time," it signifies exclusively the CPU time directly utilized by the process itself. 

You can find way more information about the “`time`” command in its man page<a id="footnote-2-ref" href="#footnote-2" style="font-size:x-small">[2]</a>. Be curious and read a bit of its man page.

Now that we are familiar with the “`time`” command we will dig into the “`date`” command.


## The `date` command
As we already mentioned in the introduction of this chapter, the “date” command allows users to display and manipulate date and time information and it also provides a way to retrieve the current date and time, format it according to various preferences, and even perform date arithmetic

You can run this command in two different ways: Without arguments and with arguments.

If you run the “date” command **with no arguments**, it will print the current date with the day of the week, the month, the day of the month, the time, the time zone and the year.

Optionally, you are allowed to pass **arguments** to the “`date`” command. What you do is to pass a string with the format “`+<output_format>`” where “`<output_format>`” is a plain string that can contain special string sequences that have a special meaning.

In the following table you will see all the string sequences that are allowed and their description.

| %format String | Description |
| :-----: | :----- |
| `%%` | A literal `%` |
| `%a` | locale’s abbreviated weekday name (e.g., Sun) |
| `%A` | locale’s full weekday name (e.g., Sunday) |
| `%b` | locale’s abbreviated month name (e.g., Jan) |
| `%B` | locale’s full month name (e.g., January) |
| `%c` | locale’s date and time (e.g., Thu Mar 3 23:05:25 2005) |
| `%C` | century; like %Y, except omit last two digits (e.g., 21) |
| `%d` | day of month (e.g, 01) |
| `%D` | date; same as `%m/%d/%y` |
| `%e` | day of month, space padded; same as `%d` |
| `%F` | full date; same as `%Y-%m-%d` |
| `%g` | last two digits of year of ISO week number (see `%G`) |
| `%G` | year of ISO week number (see `%V`); normally useful only with %V |
| `%h` | same as `%b` |
| `%H` | hour (00..23) |
| `%I` | hour (01..12) |
| `%j` | day of year (001..366) |
| `%k` | hour ( 0..23) |
| `%l` | hour ( 1..12) |
| `%m` | month (01..12) |
| `%M` | minute (00..59) |
| `%n` | a newline |
| `%N` | nanoseconds (000000000..999999999) |
| `%p` | locale’s equivalent of either AM or PM; blank if not known |
| `%P` | like `%p`, but lower case |
| `%r` | locale’s 12-hour clock time (e.g., 11:11:04 PM) |
| `%R` | 24-hour hour and minute; same as `%H:%M` |
| `%s` | seconds since 1970-01-01 00:00:00 UTC |
| `%S` | second (00..60) |
| `%t` | a tab |
| `%T` | time; same as `%H:%M:%S` |
| `%u` | day of week (1..7); 1 is Monday |
| `%U` | week number of year, with Sunday as first day of week (00..53) |
| `%V` | ISO week number, with Monday as first day of week (01..53) |
| `%w` | day of week (0..6); 0 is Sunday |
| `%W` | week number of year, with Monday as first day of week (00..53) |
| `%x` | locale’s date representation (e.g., 12/31/99) |
| `%X` | locale’s time representation (e.g., 23:13:48) |
| `%y` | last two digits of year (00..99) |
| `%Y` | year |
| `%z` | `+hhmm` numeric timezone (e.g., -0400) |
| `%:z` | `+hh:mm` numeric timezone (e.g., -04:00) |
| `%::z` | `+hh:mm:ss` numeric time zone (e.g., -04:00:00) |
| `%:::z` | numeric time zone with `:` to necessary precision (e.g., -04, +05:30) |
| `%Z` | alphabetic time zone abbreviation (e.g., EDT) |

Let’s see a few examples in the following script.

```bash
 1 #!/usr/bin/env bash
 2 #Script: date_custom_format.sh
 3 echo -n "Date without arguments> "
 4 date
 5 echo -n "American Date Format  > "
 6 date +"%m-%d-%Y"
 7 echo -n "American Date Format 2> "
 8 date +"%B-%d-%Y"
 9 echo -n "Custom Format> "
10 date +"Year: %Y, Month: %B, Day of month:%d, Week of year:%U"
```

When you run the previous script you will get the following output in your terminal.

```txt
$ ./date_custom_format.sh
Date without arguments> Sat Sep 21 09:29:10 AM CEST 2024
American Date Format  > 09-21-2024
American Date Format 2> September-21-2024
Custom Format> Year: 2024, Month: September, Day of month:21, Week of year:37
```

With the “`date`” command not only we can show different types of format for the current or a given date but we can also do “*date arithmetic*”, meaning that we can get other dates by adding or subtracting minutes, hours, days, months or years to a given date.

The “`date`” command comes with the option “`--date`” (or “`-d`”) where you can pass either a date or a flexible, human-readable date format, offering considerable freedom for specifying date and time.

This format can include expressions like “`Sun, 29 Feb 2004 16:21:42 -0800`”, “`2004-02-29 16:21:42`”, or even more abstract descriptions like “`next Thursday`”. Within this date string, you can incorporate elements that represent calendar dates, times of day, time zones, days of the week, relative times, relative dates, and numeric values. An empty string signifies the start of the day. It's important to note that the date string format is intricate and comprehensive, extending beyond what can be succinctly detailed here; for a comprehensive guide, please refer to the man page of the command.

In the next script we are going to see several examples of a few literal strings we can use to refer to dates with the “`date`” command.

```bash
 1 #!/usr/bin/env bash
 2 #Script: date_custom_format_2.sh
 3 # Date of today
 4 echo -n "Today: "
 5 date
 6 # Date of last Friday
 7 echo -n "Last Friday: "
 8 date -d 'last Friday'
 9 # Date of next month
10 echo -n "Next Month: "
11 date -d 'next month'
12 # Date of March 2nd, 2022 plus 1 year
13 echo -n "Date +1 year: "
14 date -d 'March 2, 2022 +1 year'
15 # Date of March 2nd, 2022 plus a random time
16 echo -n "Date + random time: "
17 date -d 'March 2, 2022 +1 year +2 days +16 hours +17 minutes +12 seconds'
18 # Date of March 2nd, 2022 minus a random time
19 echo -n "Date - random time: "
20 date -d 'March 2, 2022 -1 year -2 days -16 hours -17 minutes -12 seconds'
```

In the previous script you will see that we are using several types of literal strings to specify dates. When you run the previous script you will get something like the following.

```txt
$ ./date_custom_format_2.sh
Today: Sat Sep 21 10:10:33 AM CEST 2024
Last Friday: Fri Sep 20 12:00:00 AM CEST 2024
Next Month: Mon Oct 21 10:10:33 AM CEST 2024
Date +1 year: Thu Mar  2 12:00:00 AM CET 2023
Date + random time: Sat Mar  4 04:17:12 PM CET 2023
Date - random time: Sat Feb 27 07:42:48 AM CET 2021
```

In the previous script and result of execution you can see that you can actually do arithmetic with dates with the “`date`” command. A very clear set of examples are the ones that appear on lines 17 and 20. On those lines you see that we selected a random date (March 2nd 2022) and we added (and subtracted) an arbitrary amount of time from both which gives as result another date.

The last thing we are going to show about the “`date`” command is that you can use it to calculate the time span between two given dates. 

We are going to use the “`date`” command as follows.

<div style="text-align:center">
<img src="/assets/bash-in-depth/0008-Time-and-date-commands/DateCommandFormat.png" width="400px"/>
</div>

With this way of using the command we can provide two different arguments. The first argument is the “`--date`” option where we provide the date we are operating on. The second argument is a string with the format we want to extract from the date provided which, in our case, is the Unix time<a id="footnote-3-ref" href="#footnote-3" style="font-size:x-small">[3]</a> (also known as epoch time).

Let’s see how to use the “`date`” command to calculate time spans with an example.

```bash
 1 #!/usr/bin/env bash
 2 #Script: date_span.sh
 3 # Declare a start date
 4 startDate="March 2 2015 10:08:33"
 5 # Declare an end date
 6 endDate="April 1 2022 12:12:45"
 7 # Calculate the timestamp for the start date
 8 epochStartDate=$(date --date="$startDate" '+%s')
 9 # Calculate the timestamp for the end date
10 epochEndDate=$(date --date="$endDate" '+%s')
11 # Calculate the number of seconds in a day
12 secondsInADay=$(( 24*3600 ))
13 # Calculate the number of days between the two dates
14 spanInDays=$(( (epochEndDate - epochStartDate) / secondsInADay ))
15 # Print the end result
16 echo "There are $spanInDays days between '$startDate' and '$endDate'"
```

What is going on in the previous script? Let’s take a look at it line by line to better understand it.

On lines 4 and 6 we are declaring a couple of dates where we specify the month, the day of the month, the year and the time.

On lines 8 and 10 we use something that in Bash is called “*Command Substitution*”. This is something that we will talk about in a later chapter but, in short, it executes a command in a subshell and stores the result in a variable. In this case we are getting the epoch time from the two dates provided and we store them in a couple of variables that we will use to calculate the time span.

On line 12 we declare a variable that contains the number of seconds that a day has.

On line 14 we calculate the number of days that have passed between the two dates. In this case we calculate the difference, in seconds, between the two dates and we divide the result by the number of seconds in a day. This gives us the number of days that have passed between the two dates.

Finally, on line 16, we do print the result.

When you run the previous script you will get the following result in your terminal.

```txt
$ ./date_span.sh
There are 2587 days between 'March 2 2015 10:08:33' and 'April 1 2022 12:12:45'
```

With this we end this chapter where you learn a lot about the “`time`” and “`date`” commands.

## Summary
Well done!

In this chapter we learnt about two very important and useful commands in Bash.

We learnt how to use the “`time`” command, which is mainly to calculate the time of execution of other commands.

We learnt, as well, how to use the “`date`” command that allows us to pass it the argument “`--date`” to set the base date that we will use to extract information from. With this command we learnt as well to calculate time spans between two given dates.

My recommendation to you is that you give it a try to the different commands that you learnt in this chapter.

Be curious!

## References
1. <https://stackoverflow.com/questions/556405/what-do-real-user-and-sys-mean-in-the-output-of-time1>
2. <https://www.cyberciti.biz/faq/unix-linux-time-command-examples-usage-syntax/>
3. <https://www.gnu.org/software/coreutils/manual/html_node/Date-format-specifiers.html>
4. <https://www.gnu.org/software/coreutils/manual/html_node/Examples-of-date.html>
5. <https://www.gnu.org/software/coreutils/manual/html_node/Options-for-date.html>
6. <https://www.gnu.org/software/coreutils/manual/html_node/date-invocation.html>
7. <https://www.hostinger.com/tutorials/linux-time-command/>
8. <https://www.linuxjournal.com/content/doing-date-math-command-line-part-i>
9. <https://www.linuxjournal.com/content/doing-date-math-command-line-part-ii>


<hr style="width:100%;text-align:center;margin-left:0;margin-bottom:10px;">

<p id="footnote-1" style="font-size:10pt">
1. The “<code>ls</code>” command is used to display (or “<b>list</b>”) the content of a folder. You can learn more about this command by typing “<code>man ls</code>” in your terminal.<a href="#footnote-1-ref">&#8617;</a>
</p>
<p id="footnote-2" style="font-size:10pt">
2. Just type in your terminal “<code>man time</code>”.<a href="#footnote-2-ref">&#8617;</a>
</p>
<p id="footnote-X" style="font-size:10pt">
3. Unix time (or epoch time) is the number of seconds that have elapsed since January 1st 1970 at 00:00:00 UTC.<a href="#footnote-X-ref">&#8617;</a>
</p>

