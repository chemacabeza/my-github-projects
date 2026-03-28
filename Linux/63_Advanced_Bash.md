# 63: Advanced Bash

<p align="center">
  <img src="images/linux_advanced_bash.png" alt="Advanced Bash Scripting" width="800"/>
</p>

You've written `if` statements and `for` loops. Now it's time to master the features that separate beginners from experts: **traps, arrays, parameter expansion, process substitution, here-documents, and debugging.**

---

## 1. Trap — Signal Handling in Scripts

`trap` lets your script intercept signals and run cleanup code:

```bash
#!/bin/bash
# Cleanup temporary files on exit, error, or Ctrl+C
TMPFILE=$(mktemp)

cleanup() {
    echo "Cleaning up..."
    rm -f "$TMPFILE"
}

trap cleanup EXIT          # Always run on exit
trap cleanup ERR           # Run on any error
trap 'echo "Interrupted!"; cleanup; exit 1' INT TERM

echo "Working with $TMPFILE ..."
# ... your script logic ...
```

### Common Signals:
| Signal | Number | Trap Name | Trigger |
| :--- | :--- | :--- | :--- |
| `EXIT` | — | Script exits normally | `trap cmd EXIT` |
| `ERR` | — | Any command returns non-zero | `trap cmd ERR` |
| `INT` | 2 | Ctrl+C | `trap cmd INT` |
| `TERM` | 15 | `kill PID` | `trap cmd TERM` |
| `HUP` | 1 | Terminal closed | `trap cmd HUP` |

---

## 2. Arrays

### Indexed Arrays:
```bash
# Declaration
fruits=("apple" "banana" "cherry")
fruits[3]="date"

# Access
echo "${fruits[0]}"            # apple
echo "${fruits[@]}"            # All elements
echo "${#fruits[@]}"           # Count: 4
echo "${!fruits[@]}"           # All indices: 0 1 2 3

# Iteration
for fruit in "${fruits[@]}"; do
    echo "Fruit: $fruit"
done

# Slicing
echo "${fruits[@]:1:2}"       # banana cherry (2 elements from index 1)
```

### Associative Arrays (Bash 4+):
```bash
declare -A capitals
capitals[France]="Paris"
capitals[Germany]="Berlin"
capitals[Spain]="Madrid"

echo "${capitals[France]}"
for country in "${!capitals[@]}"; do
    echo "$country → ${capitals[$country]}"
done
```

---

## 3. Parameter Expansion

The Swiss Army knife of Bash string manipulation — **no external commands needed**:

| Syntax | Effect | Example |
| :--- | :--- | :--- |
| `${var:-default}` | Use default if unset | `${name:-Guest}` |
| `${var:=default}` | Set default if unset | `${name:=Guest}` |
| `${var:?error}` | Error if unset | `${DB_HOST:?Required!}` |
| `${#var}` | String length | `${#name}` → 5 |
| `${var%pattern}` | Remove shortest suffix | `${file%.txt}` |
| `${var%%pattern}` | Remove longest suffix | `${path%%/*}` |
| `${var#pattern}` | Remove shortest prefix | `${file#*/}` |
| `${var##pattern}` | Remove longest prefix | `${path##*/}` → basename |
| `${var/old/new}` | Replace first match | `${str/foo/bar}` |
| `${var//old/new}` | Replace all matches | `${str//foo/bar}` |
| `${var^}` | Uppercase first char | `${name^}` |
| `${var^^}` | Uppercase all | `${name^^}` |
| `${var,}` | Lowercase first char | `${NAME,}` |
| `${var,,}` | Lowercase all | `${NAME,,}` |

---

## 4. Process Substitution

Feed a command's output as a "file" to another command:

```bash
# Compare outputs of two commands
diff <(ls dir1/) <(ls dir2/)

# Feed process output to a command that expects a file
paste <(cut -f1 data.csv) <(cut -f3 data.csv)

# Process multiple inputs simultaneously
while read -u3 line1 && read -u4 line2; do
    echo "$line1 | $line2"
done 3< file1.txt 4< file2.txt
```

---

## 5. Here-Documents and Here-Strings

```bash
# Here-document: multi-line input to a command
cat << 'EOF'
This text is passed as stdin.
Variables are NOT expanded when quotes surround EOF.
EOF

# Here-string: single-line input
grep "pattern" <<< "This is a here-string to search in"

# Useful for SQL, SSH commands, etc.
ssh user@server << REMOTE
    hostname
    uptime
    df -h
REMOTE
```

---

## 6. Debugging

```bash
# Trace mode: shows every command before execution
set -x                     # Enable tracing
# ... commands ...
set +x                     # Disable tracing

# Run script with tracing
bash -x script.sh

# Strict mode (recommended for all scripts):
set -euo pipefail
# -e : Exit on any error
# -u : Error on undefined variables
# -o pipefail : Pipe fails if any command fails

# Custom debug output
PS4='+ ${BASH_SOURCE}:${LINENO}: '    # Show file:line in trace
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
```

### Exercise 1: Traps and Cleanup
> **Goal:** Write a script that cleans up on exit.
```bash
cat > /tmp/trap_demo.sh << 'SCRIPT'
#!/bin/bash
TMPFILE=$(mktemp)
trap 'echo "Cleanup: removing $TMPFILE"; rm -f "$TMPFILE"' EXIT
echo "Created $TMPFILE"
echo "data" > "$TMPFILE"
cat "$TMPFILE"
echo "Script ending normally..."
SCRIPT
bash /tmp/trap_demo.sh
ls /tmp/tmp.* 2>/dev/null || echo "Temp file cleaned up!"
```
✅ **Expected:** The temp file is created, used, and automatically removed on exit.

### Exercise 2: Parameter Expansion
> **Goal:** Manipulate strings without external commands.
```bash
filepath="/home/user/documents/report.final.txt"
echo "Full path: $filepath"
echo "Basename: ${filepath##*/}"
echo "Directory: ${filepath%/*}"
echo "Extension: ${filepath##*.}"
echo "No extension: ${filepath%.*}"
echo "Uppercase: ${filepath^^}"
```
✅ **Expected:** Each expansion extracts or transforms a different part of the path.

### Exercise 3: Associative Arrays
> **Goal:** Use a hash map in Bash.
```bash
declare -A scores
scores[Alice]=95
scores[Bob]=82
scores[Carol]=91
for name in "${!scores[@]}"; do
    echo "$name: ${scores[$name]}"
done
```
✅ **Expected:** Each name-score pair is printed (order may vary — associative arrays are unordered).

---

[<< Previous: Awk Programming](./62_Awk_Programming.md) | [Home: Curriculum Map](./README.md) | [Next: Shell Environment >>](./64_Shell_Environment.md)
