# 38: Text Processing

<p align="center">
  <img src="images/linux_text_processing.png" alt="Text Processing" width="600"/>
</p>

The UNIX philosophy is built on text streams. These commands are the backbone of every shell pipeline.

---

## 1. `grep` — Pattern Matching

Search for patterns in files or piped input.

```bash
grep "error" /var/log/syslog             # Find lines containing "error"
grep -i "warning" /var/log/syslog        # Case-insensitive
grep -r "TODO" ./src/                    # Recursive search in directory
grep -n "main" program.c                 # Show line numbers
grep -c "404" access.log                 # Count matching lines
grep -v "DEBUG" app.log                  # Invert: show lines WITHOUT "DEBUG"
grep -E "error|warning|critical" log.txt # Extended regex (OR)
grep -l "password" /etc/*               # List filenames only
```

### Regex Examples

```bash
grep "^root" /etc/passwd                 # Lines starting with "root"
grep "bash$" /etc/passwd                 # Lines ending with "bash"
grep -E "[0-9]{1,3}\.[0-9]{1,3}" log    # Match IP-like patterns
```

---

## 2. `sed` — Stream Editor

Transform text line by line without opening a file.

```bash
sed 's/old/new/' file.txt                # Replace first occurrence per line
sed 's/old/new/g' file.txt               # Replace ALL occurrences per line
sed -i 's/old/new/g' file.txt            # In-place edit (modifies the file)
sed -n '5,10p' file.txt                  # Print lines 5–10 only
sed '3d' file.txt                        # Delete line 3
sed '/^#/d' config.conf                  # Delete all comment lines
sed 's/^/    /' file.txt                 # Indent every line by 4 spaces
```

### Multiple Operations

```bash
sed -e 's/foo/bar/g' -e 's/baz/qux/g' file.txt
```

---

## 3. `awk` — Column Processing

`awk` treats each line as a sequence of fields separated by whitespace (default).

```bash
awk '{print $1}' file.txt                # Print first column
awk '{print $1, $3}' file.txt            # Print columns 1 and 3
awk -F: '{print $1}' /etc/passwd         # Use ":" as delimiter
awk '$3 > 1000' /etc/passwd              # Filter: third field > 1000
awk '{sum += $1} END {print sum}' data   # Sum first column
awk 'NR==5,NR==10' file.txt             # Print lines 5 to 10
awk '{print NR": "$0}' file.txt          # Add line numbers
```

### Real-World Example: Disk Usage

```bash
df -h | awk 'NR>1 {print $5, $6}'       # Print usage% and mount point
```

---

## 4. `cut` — Extract Columns

Faster than `awk` for simple column extraction.

```bash
cut -d: -f1 /etc/passwd                 # Field 1, delimiter ":"
cut -d, -f2,4 data.csv                  # Fields 2 and 4 from CSV
cut -c1-10 file.txt                     # First 10 characters per line
```

---

## 5. `sort` — Order Lines

```bash
sort file.txt                            # Alphabetical sort
sort -n numbers.txt                      # Numeric sort
sort -r file.txt                         # Reverse sort
sort -t: -k3 -n /etc/passwd             # Sort by 3rd field (numeric), delimiter ":"
sort -u file.txt                         # Sort and remove duplicates
```

---

## 6. `uniq` — Deduplicate

**Important:** `uniq` only removes *adjacent* duplicates. Always `sort` first!

```bash
sort access.log | uniq                   # Remove duplicates
sort access.log | uniq -c               # Count occurrences
sort access.log | uniq -d               # Show only duplicates
```

---

## 7. `tr` — Translate Characters

```bash
echo "hello" | tr 'a-z' 'A-Z'           # Convert to uppercase
echo "hello   world" | tr -s ' '        # Squeeze repeated spaces
cat file.txt | tr -d '\r'               # Remove Windows carriage returns
echo "abc123" | tr -d '0-9'             # Delete all digits → "abc"
```

---

## 8. `wc` — Word Count

```bash
wc file.txt                             # Lines, words, bytes
wc -l file.txt                          # Line count only
wc -w file.txt                          # Word count only
wc -c file.txt                          # Byte count only
ls /etc | wc -l                         # Count files in /etc
```

---

## 9. Pipeline Masterclass

Combine these tools to solve real problems:

```bash
# Top 10 most frequent IP addresses in an access log
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Find all unique error types
grep "ERROR" app.log | awk -F: '{print $4}' | sort -u

# Count lines of code in a project (excluding blanks)
find ./src -name "*.py" | xargs cat | grep -v "^$" | wc -l

# Replace tabs with 4 spaces in all .conf files
find /etc -name "*.conf" -exec sed -i 's/\t/    /g' {} \;
```

---

## 10. Quick Reference Table

| Command | Purpose | Key Flag |
| :--- | :--- | :--- |
| `grep` | Pattern search | `-r` (recursive), `-i` (insensitive) |
| `sed` | Stream substitution | `s/old/new/g`, `-i` (in-place) |
| `awk` | Column processing | `-F` (delimiter) |
| `cut` | Extract fields | `-d` (delimiter), `-f` (fields) |
| `sort` | Order lines | `-n` (numeric), `-r` (reverse) |
| `uniq` | Remove duplicates | `-c` (count) |
| `tr` | Character translation | `-d` (delete), `-s` (squeeze) |
| `wc` | Count lines/words/bytes | `-l` (lines) |

---

[<< Previous: File Viewing](./37_File_Viewing.md) | [Home: Curriculum Map](./README.md) | [Next: Permissions >>](./39_Permissions.md)
