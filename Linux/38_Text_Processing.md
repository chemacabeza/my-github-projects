<div align="center">
  <img src="./images/linux_ch38_kernel_tuning.png" alt="Text Processing Cover" width="800"/>
</div>

# 38: Text Processing

> 🧠 **The Feynman Hook:** The true magic of UNIX is that every command is a tiny robotic factory designed to do exactly one job perfectly. `grep` sorts boxes on an assembly line. `sed` paints the boxes. `awk` places labels on specific boxes. When you connect these tiny factories together using a pipeline (`|`), you build a fully automated, immensely powerful text processing system. This philosophy allows you to parse millions of rows of data without ever writing a giant C program.

**🎯 The Big Goal:** Master `grep`, `sed`, and `awk` to parse unstructured log files and extract structured intelligence cleanly and efficiently.

---

## 1. `grep` — The Pattern Finder

`grep` acts like a sieve. You pour a massive text file into it, and it only lets lines that match your specific pattern fall through to your screen.

```bash
# Find every line containing the word "error"
grep "error" /var/log/syslog

# Search case-insensitively for "warning"
grep -i "warning" /var/log/syslog

# Find all lines that DO NOT contain the word "DEBUG" (Inverted search)
grep -v "DEBUG" app.log

# Count exactly how many times "404" appears
grep -c "404" access.log
```

---

## 2. `sed` — The Stream Editor

`sed` is a robot that reads a line of text, applies a surgical edit (like search-and-replace), and outputs the new line immediately. It never actually opens the file in an editor.

```bash
# Replace the first occurrence of 'old' with 'new' on every line
sed 's/old/new/' file.txt

# Replace ALL occurrences globally on every line
sed 's/old/new/g' file.txt

# Delete any line that starts with a hash '#' (Useful for cleaning config files)
sed '/^#/d' config.conf
```

> [!CAUTION]
> By default, `sed` only prints the result to your screen. If you want to permanently overwrite the original file with your changes, you must use the `-i` (in-place) flag: `sed -i 's/old/new/g' file.txt`.

---

## 3. `awk` — The Column Master

While `sed` edits raw text, `awk` understands *columns*. It naturally treats any text separated by spaces (or commas) as an indexed field.

```bash
# Print only the 1st and 3rd columns of a file
awk '{print $1, $3}' file.txt

# Tell awk that the file is separated by colons (:), then print column 1
awk -F: '{print $1}' /etc/passwd

# Filtering: Only print the line if the 3rd column is a number greater than 1000
awk '$3 > 1000' /etc/passwd
```

---

## 4. The Masterclass: Building a Pipeline

Individually, these tools are useful. Combined, they are a superpower. 

**Scenario:** Your web server is under attack. You want to extract the top 10 IP addresses making the most requests from your `access.log`.

```bash
# The exact command:
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10
```

1. `awk '{print $1}'`: Extract only the first column (the IP address).
2. `sort`: Organize all IP addresses alphabetically so identical IPs are grouped together.
3. `uniq -c`: Collapse identical adjacent IPs into a single line, prepending a count of how many were found.
4. `sort -rn`: Sort the result numerically in reverse (largest counts at the top).
5. `head -10`: Print only the top 10 worst offenders.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe why you must run 'sort' before running 'uniq' in a pipeline.</summary>
The `uniq` command is highly optimized for memory. It works sequentially by comparing the current line only to the immediately preceding line. It does not remember the entire file. If you have "Apple", then "Banana", then "Apple", `uniq` will not filter the second "Apple" because it is only looking at "Banana". Running `sort` first groups identical items consecutively.
</details>

---
[<< Previous: File Viewing](./37_File_Viewing.md) | [Home: Curriculum Map](./README.md) | [Next: Permissions >>](./39_Permissions.md)
