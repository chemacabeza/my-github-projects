<div align="center">
  <img src="./images/linux_ch02_cli.png" alt="CLI Pipeline Cover" width="800"/>
</div>

# 02: Command Line Survival (Pipes, Grep, Sed, Awk)

> 🧠 **The Feynman Hook:** Think of a factory assembly line where each workstation performs exactly one specialised task. The first worker sorts raw materials (`grep`), the second extracts specific parts (`awk`), the third re-labels them (`sed`), and the fourth counts the output (`wc`). No worker knows what the next one will do with their output — they just pass the product down the line. In Linux, the **Pipe** (`|`) is the conveyor belt connecting these specialist tools — and the philosophy is that every tool does exactly one thing, perfectly. By composing tiny, focused tools, you can build infinitely powerful data-processing pipelines without ever writing a program.

**🎯 The Big Goal:** Master the Linux pipe — the composable data processing philosophy that turns 20 simple tools into an infinite toolbox.

---

## 1. Standard Streams — The Three Data Rivers

> **Feynman Insight:** Every Linux process is born with three invisible data pipes already connected. **stdin** is your program's ear — where input comes from (usually the keyboard). **stdout** is its mouth — successful output goes here (usually the terminal). **stderr** is its alarm — error messages go here, separately from normal output. The key insight: these pipes can be **redirected**. You can redirect stdout away from the screen and into a file. You can redirect stderr into the digital void (`/dev/null`) to silence it completely.

```bash
# > overwrites a file; >> appends
echo "Server started" > server.log
echo "Connection accepted" >> server.log

# Silencing error noise: send stderr (stream 2) to /dev/null
find / -name "secrets.txt" 2>/dev/null   # Permission denied errors vanish

# Sending BOTH stdout and stderr to a log file
./script.sh > all_output.log 2>&1
```

---

## 2. The Mighty Pipe (`|`)

> **Feynman Insight:** The pipe connects the stdout of one command directly to the stdin of the next — without writing anything to disk. Data flows *in memory*, from left to right, at the speed of the kernel's buffer. This is the fundamental composability principle of UNIX: instead of one giant program that does everything (`showMe --filter --sort --count --format`), you compose small specialists: `cat file | grep ERROR | sort | uniq -c | sort -rn`. Each tool does one thing. The combination does everything.

```bash
# Classic: display syslog entries but make it scrollable
cat /var/log/syslog | less

# Chain: count occurrences of each log level
grep "level=" access.log | awk -F'level=' '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -rn

# Find your external IP without a browser
ip addr | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -d'/' -f1
```

---

## 3. Filtering Data with `grep`

> **Feynman Insight:** `grep` is the bouncer at a club door who checks every visitor against a single rule. Lines that match: **in**. Lines that don't: **rejected**. The `-v` flag inverts the logic — keep everything that *doesn't* match. `-i` makes the matching case-insensitive. `grep -E` enables regex for complex pattern rules. `grep -r` recurses through entire directory trees.

```bash
# Find errors in the log
grep "ERROR" /var/log/syslog

# Find lines NOT containing "DEBUG"
grep -v "DEBUG" /var/log/syslog

# Case-insensitive search
grep -i "warning" /var/log/syslog

# Find all .py files that import subprocess (security audit)
grep -r "import subprocess" /opt/myapp/ --include="*.py"

# Check what's listening on port 22
ss -tulpen | grep ":22"
```

---

## 4. Column Extraction with `awk`

> **Feynman Insight:** `awk` is a line-by-line spreadsheet: it splits each line into **columns** (`$1`, `$2`, `$3`...) using whitespace (or a custom delimiter with `-F`). It's primarily a column extractor, but is actually a complete programming language with conditionals, loops, and associative arrays. `BEGIN{}` runs before processing any lines (setup). `END{}` runs after all lines are processed (report). Between them: the per-line processing rule.

```bash
# Print columns 1 and 3 from a space-separated file
awk '{print $1, $3}' data.txt

# Custom delimiter: extract username (field 1) from /etc/passwd
awk -F':' '{print $1}' /etc/passwd

# Sum column 4 (e.g., file sizes)
awk '{sum += $4} END {print "Total:", sum}' file_list.txt

# Print lines where column 3 is greater than 100
awk '$3 > 100 {print $0}' metrics.txt
```

---

## 5. Text Substitution with `sed`

> **Feynman Insight:** `sed` (Stream Editor) is a find-and-replace that processes a file or stream line by line without ever opening it in a text editor — making it viable for multi-gigabyte files where a text editor would crash. The core operation is `s/FIND/REPLACE/g` — `s` for substitution, `g` for global (all occurrences on each line). The `-i` flag edits **in-place** — the original file is modified immediately. With no `-i`, it just prints the result without touching the file.

```bash
# Preview the change (no -i = no modification)
sed 's/apache/nginx/g' webserver.conf

# In-place substitution: flip a feature flag
sed -i 's/FEATURE_DARK_MODE=false/FEATURE_DARK_MODE=true/g' .env

# Delete all blank lines  
sed '/^$/d' messy.txt

# Print only lines 5-10 of a file  
sed -n '5,10p' large_file.txt
```

---

## 6. Archiving and Compression with `tar`

> **Feynman Insight:** `tar` is the packer who bundles 10,000 files into one suitcase. `gzip`/`bzip2`/`xz` are the vacuum-seal bags that compress that suitcase. They are almost always used together. The **mnemonic** for `tar`: think of the flags as a recipe: **c**reate/**x**tract, **z**ip, **v**erbose, **f**ile.

```bash
# Create: pack /etc into a compressed tarball  
tar -czvf backup.tar.gz /etc

# Extract: unpack the tarball here  
tar -xzvf backup.tar.gz

# View contents without extracting  
tar -tzvf backup.tar.gz
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Why does 'find / -name "secrets.txt" 2>/dev/null' use 2>/dev/null?</summary>

The `find` command, when run without root permissions, will encounter thousands of directories it cannot read (`/proc/tty/driver`, `/root`, various system dirs). Each of these generates a `"Permission denied"` error message. These are all **stderr** (stream 2) messages — not the answer you're looking for. Redirecting `2>/dev/null` sends stream 2 to the digital void, killing all error messages, leaving only the actual search results on **stdout** (stream 1). Without it, the terminal floods with thousands of error lines that drown out any actual match found.
</details>

<details>
<summary>💡 View Answer: What is the difference between > and >> for file redirection?</summary>

`>` **truncates then writes**: it opens the file, immediately deletes all existing content, then writes the new output. If the file doesn't exist, it creates it. If it does exist, all previous content is lost — irrecoverably, without any prompt. `>>` **appends**: it seeks to the end of the existing file and adds the new content after it, preserving everything already there. If the file doesn't exist, it behaves the same as `>` and creates it. The safe rule: use `>` only when you intentionally want to replace the file. Use `>>` for log-style accumulation.
</details>

---

## 🐳 Hands-On Lab: CLI Pipeline Survival

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update -qq && apt-get install -y -qq iproute2 net-tools curl
```

### Exercise 1: I/O Redirection Fundamentals
> **Goal:** Build a multi-line log file entry by entry.
```bash
echo "Line 1" > output.txt
echo "Line 2" >> output.txt
date >> output.txt
cat output.txt
```
✅ **Expected:** Three lines — proving `>` creates and `>>` appends.

### Exercise 2: Grep Pipeline
> **Goal:** Extract specific lines from a simulated log.
```bash
echo -e "INFO: Start\nERROR: Disk full\nINFO: Retrying\nERROR: Connection refused" > app.log
grep "ERROR" app.log
grep -v "ERROR" app.log
grep -c "ERROR" app.log  # Count matching lines
```
✅ **Expected:** Error lines only, then info-only lines, then count: 2.

### Exercise 3: Awk Column Extraction
> **Goal:** Extract fields from structured text.
```bash
echo -e "alice 35 developer\nbob 28 manager\ncarol 42 architect" > staff.txt
awk '{print $1, $3}' staff.txt      # Print name and role
awk '$2 > 30 {print $1}' staff.txt  # Print names of people over 30
```
✅ **Expected:** Names with roles, then just alice and carol.

---

## 📝 Key Interview Talking Points

- **Pipes use in-memory buffers** — no disk I/O between commands. This makes long chains fast.
- **`awk` BEGIN/END blocks** are the go-to for report generation: `awk 'BEGIN{sum=0} {sum+=$3} END{print sum}'`.
- **`sed -i` is immediate and irreversible** — always test your sed expression without `-i` first.
- **`2>&1`** redirects stderr *into* stdout (both go to the same destination). Essential for capturing complete output of commands that print errors separately.
- **`grep -P`** enables Perl-compatible regular expressions — the most powerful grep mode for complex patterns.

---
[<< Previous: The Linux Philosophy](./01_The_Linux_Philosophy.md) | [Home: Curriculum Map](./README.md) | [Next: Package & Service Mgmt >>](./03_Package_and_Service_Mgmt.md)