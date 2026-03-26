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

[Home: Curriculum Map](./README.md) | [Next: Text Processing >>](./38_Text_Processing.md)
