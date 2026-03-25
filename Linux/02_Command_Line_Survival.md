# 02: Command Line Survival (Pipes, Grep, SED, AWK)

Based on *Learn Enough Developer Tools to Be Dangerous*, this module transitions you from pointing-and-clicking to using the keyboard as an extension of your mind. 

In Linux, tools are designed to do *one thing* exceptionally well. To perform complex logic, we chain these small tools together using **Pipes**.

---

## 1. Standard Output (stdout), Input (stdin), and Redirection

Every command in Linux possesses three invisible data streams:
0. `stdin` (Standard Input) - What goes into the command (usually your keyboard).
1. `stdout` (Standard Output) - The successful text printed to the terminal.
2. `stderr` (Standard Error) - The error messages printed to the terminal.

We can **redirect** these streams using brackets.

### Writing to Files (`>`)
Instead of printing to the screen, send it directly into a file.
```bash
# Overwrite the file entirely.
echo "System initialized." > boot.log 

# Append to the bottom of the file (DO NOT use single '>', or you will delete the file contents!)
echo "User login successful." >> boot.log 
```

### Redirecting Errors (`2>`)
Sometimes a command prints hundreds of permission errors. We can discard them by throwing `stderr` (stream 2) into the Linux black hole: `/dev/null`.
```bash
# Suppresses all "Permission denied" errors completely!
find / -name "passwords.txt" 2> /dev/null
```

---

## 2. The Mighty Pipe (`|`)

The Pipe connects the `stdout` of the left command directly into the `stdin` of the right command.

```bash
# Print the entire gigantic system log, but pipe it into 'less', 
# which transforms it into a scrollable, searchable document.
cat /var/log/syslog | less
```

---

## 3. Filtering Data: `grep`

`grep` stands for *Global Regular Expression Print*. It searches text line-by-line for a specific word or pattern.

```bash
# Find all lines containing "ERROR" in the syslog
grep "ERROR" /var/log/syslog

# Find all lines NOT containing "DEBUG" (-v means invert)
grep -v "DEBUG" /var/log/syslog

# View active SSH connections by piping the network tool 'ss' into grep
ss -tulpen | grep ":22"
```

---

## 4. Text Transformation: `awk`

`awk` is actually an entire programming language, but it is primarily used as a columnar text extractor. By default, it splits lines into columns based on whitespace.

```bash
# Print just the 1st and 3rd columns from a text file
awk '{print $1, $3}' server_data.txt
```

**Real World Example: Finding your IP Address**
If you run `ip addr`, it outputs a massive block of heavy text. Let's extract just the IP address using Pipes, Grep, and Awk.

```bash
# 1. Get networking data
# 2. Filter for lines containing "inet " (the IP lines)
# 3. Filter OUT the internal localhost "127.0.0.1" address
# 4. Use awk to print just the 2nd column (the actual IP)
# 5. Use awk again to split that IP using the '/' delimiter and take the first half!
ip addr | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | awk -F'/' '{print $1}'
```

---

## 5. Text Substitution: `sed`

`sed` (Stream Editor) performs massive find-and-replace operations instantly across gigabytes of text without ever opening the file in a text editor.

```bash
# Syntax: s/FIND/REPLACE/g (g means global, otherwise it only replaces the first match per line)

# Replace the word 'apache' with 'nginx' in the config, and output to screen
sed 's/apache/nginx/g' config.txt

# IN-PLACE EDITING (-i): DANGER! This modifies the file permanently and instantly.
sed -i 's/ENABLE_LOGS=false/ENABLE_LOGS=true/g' myapp.env
```

---

## 6. Archiving and Compression (`tar`)

Linux heavily relies on Tarballs (`.tar.gz`) for packaging source code and backups. 

- `tar` bundles lots of files together into one big file (an Archive).
- `gzip` compresses that big file to save space.

You almost always invoke them together.

### Compressing (Creating an Archive)
*Mnemonic: **C**reate **Z**ip **V**erbose **F**ile*
```bash
# Compress the '/etc' folder into a file named 'backup.tar.gz'
tar -czvf backup.tar.gz /etc
```

### Extracting
*Mnemonic: e**X**tract **Z**ip **V**erbose **F**ile*
```bash
# Unzip and extract exactly here
tar -xzvf backup.tar.gz
```

### Summary
The Linux command line is an exercise in composition. You don't learn a massive monolithic tool that does everything. You learn 20 tiny tools (`ls`, `grep`, `awk`, `sed`, `sort`, `uniq`) and pipe them together to achieve infinite programmatic possibilities.

---

## 7. Containerized Execution (MacBook / Linux)
Practice your piping and filtering inside a completely disposable, isolated sandbox. 

**`Dockerfile`**
```dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y iproute2 net-tools
WORKDIR /root
# Create a dummy syslog file for grep practice
RUN echo "May 14 12:00:00 server NGINX: Connection established\nMay 14 12:01:00 server NGINX: ERROR: Process Out of Memory!\nMay 14 12:02:00 server SSH: User login successful" > /var/log/dummy_syslog.log
CMD ["/bin/bash"]
```

**`docker-compose.yml`**
```yaml
services:
  cli-sandbox:
    build: .
    stdin_open: true
    tty: true
```

**To Run:**
```bash
docker compose run cli-sandbox
# Test your sed pipes!
sed 's/ERROR/WARNING/g' /var/log/dummy_syslog.log
```

---
[<< Previous: The Linux Philosophy](./01_The_Linux_Philosophy.md) | [Home: Curriculum Map](./README.md) | [Next: Package & Service Mgmt >>](./03_Package_and_Service_Mgmt.md)
