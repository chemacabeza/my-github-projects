# 37: File Viewing

<p align="center">
  <img src="images/linux_file_viewing.png" alt="File Viewing" width="600"/>
</p>

Master the essential commands for inspecting file contents without opening a text editor.

---

## 1. `cat` — Concatenate and Print

The simplest file viewer. Dumps the entire file to stdout.

```bash
cat /etc/hostname                  # Print file contents
cat file1.txt file2.txt            # Concatenate multiple files
cat -n script.sh                   # Show line numbers
cat -A config.txt                  # Show hidden characters (tabs as ^I, EOL as $)
```

### Creating Files with `cat`

```bash
cat > notes.txt << EOF
Line 1: This is my note.
Line 2: Created with cat.
EOF
```

---

## 2. `less` — The Pager King

Unlike `cat`, `less` does not load the entire file into memory. It is the standard pager for large files and `man` pages.

```bash
less /var/log/syslog
```

**Navigation inside `less`:**

| Key | Action |
| :--- | :--- |
| `Space` / `f` | Forward one page |
| `b` | Back one page |
| `g` | Go to beginning |
| `G` | Go to end |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next search match |
| `N` | Previous search match |
| `q` | Quit |

**Pro tip:** Pipe any command into `less`:
```bash
dmesg | less
ps aux | less
```

---

## 3. `more` — The Legacy Pager

Older and simpler than `less`. Can only scroll forward.

```bash
more /etc/services
```

> **Rule of thumb:** Always prefer `less` over `more`. `less` can scroll backward and supports regex searching.

---

## 4. `head` — View the Top

Print the first N lines (default: 10).

```bash
head /etc/passwd                   # First 10 lines
head -n 5 /etc/passwd              # First 5 lines
head -c 100 /var/log/syslog        # First 100 bytes
```

---

## 5. `tail` — View the Bottom

Print the last N lines (default: 10).

```bash
tail /var/log/syslog               # Last 10 lines
tail -n 20 /var/log/auth.log       # Last 20 lines
tail -f /var/log/syslog            # FOLLOW mode: live stream new lines
tail -F /var/log/nginx/access.log  # Follow + retry if file is recreated
```

### The `-f` Flag (Follow)
This is one of the most important flags in all of Linux. It keeps the terminal open and streams new lines as they are written to the file.

```bash
# Monitor a log file in real-time
tail -f /var/log/syslog &
# Kill later with: kill %1
```

---

## 6. `tac` — Reverse `cat`

Prints a file in reverse line order (last line first).

```bash
tac /var/log/syslog | head -20     # Last 20 log entries, newest first
```

---

## 7. `nl` — Number Lines

Adds line numbers to output (more configurable than `cat -n`).

```bash
nl script.sh                      # Number non-empty lines
nl -ba script.sh                   # Number ALL lines (including blank)
nl -s '. ' script.sh               # Custom separator: "1. line content"
```

---

## 8. Quick Reference Table

| Command | Purpose | Key Flag |
| :--- | :--- | :--- |
| `cat` | Print entire file | `-n` (line numbers) |
| `less` | Page through large files | `/` (search) |
| `more` | Simple forward pager | *(legacy)* |
| `head` | First N lines | `-n N` |
| `tail` | Last N lines | `-f` (follow) |
| `tac` | Reverse print | — |
| `nl` | Number lines | `-ba` (all lines) |

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox

```bash
docker run -it --rm ubuntu:latest bash
```

Once inside the container, create the practice environment:

```bash
# Create sample files
mkdir -p /root/lab37 && cd /root/lab37

# A system log
for i in $(seq 1 100); do echo "$(date -u +%Y-%m-%dT%H:%M:%S) [INFO] Processing request $i - status=200" >> server.log; done
echo "$(date -u +%Y-%m-%dT%H:%M:%S) [ERROR] Connection refused to database" >> server.log
for i in $(seq 102 200); do echo "$(date -u +%Y-%m-%dT%H:%M:%S) [INFO] Processing request $i - status=200" >> server.log; done

# A short config file
cat > app.conf << 'EOF'
# Application Settings
app.name=MyService
app.port=8080
app.debug=true
# Database
db.host=localhost
db.port=5432
db.name=production
EOF

# A script file
cat > deploy.sh << 'SCRIPT'
#!/bin/bash
set -euo pipefail
echo "Starting deployment..."
echo "Pulling latest code..."
echo "Running migrations..."
echo "Restarting services..."
echo "Deployment complete!"
SCRIPT
chmod +x deploy.sh
```

---

### Exercise 1: Display a Whole File
> **Goal:** Use `cat` to display the entire config file.

```bash
cat app.conf
```
✅ **Expected:** You see all lines including comments and key-value pairs.

---

### Exercise 2: Show Line Numbers
> **Goal:** Display the config file with line numbers.

```bash
cat -n app.conf
```
✅ **Expected:** Each line is prefixed with its number (1–10).

---

### Exercise 3: View the First 5 Lines of a Log
> **Goal:** Peek at the top of a large log file.

```bash
head -n 5 server.log
```
✅ **Expected:** Only the first 5 log entries appear.

---

### Exercise 4: View the Last 10 Lines
> **Goal:** See the most recent log entries.

```bash
tail server.log
```
✅ **Expected:** The last 10 lines of the log are shown (including the ERROR entry near the end of the first batch).

---

### Exercise 5: Follow a Live Log
> **Goal:** Simulate real-time log monitoring.

Open a second tab by running:
```bash
# In the current shell, start tail in follow mode
tail -f server.log &

# Now append a new line and watch it appear
echo "$(date -u +%Y-%m-%dT%H:%M:%S) [WARN] Disk space at 90%" >> server.log
```
✅ **Expected:** The new `WARN` line appears automatically after you append it.

Stop the follow with: `kill %1`

---

### Exercise 6: Page Through a Long File
> **Goal:** Use `less` to navigate a long file.

```bash
apt-get update > /dev/null 2>&1 && apt-get install -y less > /dev/null 2>&1
less server.log
```
✅ **Try these keys:** `Space` (next page), `b` (back), `/ERROR` (search), `n` (next match), `q` (quit).

---

### Exercise 7: Reverse a File
> **Goal:** View the log newest-first using `tac`.

```bash
tac server.log | head -5
```
✅ **Expected:** The 5 most recently appended lines appear first.

---

### Exercise 8: Number Only Non-Empty Lines
> **Goal:** Use `nl` to number lines, skipping blanks.

```bash
# Add blank lines to test
echo -e "Line A\n\nLine B\n\nLine C" > spaced.txt
nl spaced.txt
nl -ba spaced.txt
```
✅ **Expected:** First `nl` numbers only "Line A/B/C". With `-ba`, blanks get numbers too.

---

[Home: Curriculum Map](./README.md) | [Next: Text Processing >>](./38_Text_Processing.md)
