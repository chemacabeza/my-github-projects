# 61: The Sed Stream Editor

<p align="center">
  <img src="images/linux_sed_editor.png" alt="Sed Stream Editor" width="800"/>
</p>

`sed` (Stream EDitor) is a non-interactive text editor that processes text line-by-line. Unlike Vim, you don't open files in sed — you build transformation pipelines that flow from input through pattern matching to output.

---

## 1. How Sed Works

```
Input Stream → [Read line into Pattern Space] → [Apply commands] → [Output] → [Next line]
```

| Buffer | Purpose |
| :--- | :--- |
| **Pattern Space** | The "workspace" — holds the current line being processed |
| **Hold Space** | A secondary buffer for storing/recalling text across lines |

---

## 2. Basic Syntax

```bash
sed [options] 'COMMAND' file
sed [options] -e 'CMD1' -e 'CMD2' file
sed [options] -f script.sed file
```

### Key Options:
| Option | Effect |
| :--- | :--- |
| `-n` | Suppress automatic printing (only print when told) |
| `-i` | Edit file in-place (modify the original) |
| `-i.bak` | In-place edit with backup |
| `-E` / `-r` | Extended regex (ERE) |

---

## 3. Addressing (Selecting Lines)

| Address | Meaning | Example |
| :--- | :--- | :--- |
| `3` | Line 3 only | `sed '3d' file` |
| `$` | Last line | `sed '$d' file` |
| `1,5` | Lines 1 through 5 | `sed '1,5s/a/b/g' file` |
| `/pattern/` | Lines matching regex | `sed '/ERROR/d' file` |
| `1~2` | Every 2nd line starting at 1 (odd lines) | `sed '1~2d' file` |
| `/start/,/end/` | Range between patterns | `sed '/BEGIN/,/END/d' file` |

---

## 4. Essential Commands

### Substitution (`s`):
```bash
sed 's/old/new/'          # Replace first occurrence per line
sed 's/old/new/g'         # Replace ALL occurrences per line
sed 's/old/new/3'         # Replace only the 3rd occurrence
sed 's/old/new/gi'        # Case-insensitive replace all
sed 's|/usr/bin|/opt/bin|g'   # Use | as delimiter (when / is in the pattern)
```

### Delete (`d`):
```bash
sed '/^#/d'               # Delete comment lines
sed '/^$/d'               # Delete blank lines
sed '1,10d'               # Delete first 10 lines
```

### Print (`p`):
```bash
sed -n '/ERROR/p'         # Print only lines containing ERROR
sed -n '5,10p'            # Print lines 5-10
```

### Insert/Append/Change:
```bash
sed '3i\New line before 3'    # Insert before line 3
sed '3a\New line after 3'     # Append after line 3
sed '3c\Replace line 3'       # Change (replace) line 3
```

---

## 5. Advanced Sed: The Hold Space

The hold space lets you store and recall text across processing cycles:

| Command | Effect |
| :--- | :--- |
| `h` | Copy pattern space → hold space |
| `H` | Append pattern space → hold space |
| `g` | Copy hold space → pattern space |
| `G` | Append hold space → pattern space |
| `x` | Exchange pattern space ↔ hold space |

### Example: Reverse Line Order
```bash
sed -n '1!G;h;$p' file    # Reverse all lines (like tac)
```

### Example: Join Every Two Lines
```bash
sed 'N;s/\n/ /' file       # Join pairs of lines with a space
```

---

## 6. Multi-Command Scripts

```bash
# Using a sed script file
cat > transform.sed << 'EOF'
/^#/d                      # Delete comments
/^$/d                      # Delete blank lines
s/\t/    /g                # Replace tabs with 4 spaces
s/[[:space:]]*$//          # Strip trailing whitespace
EOF

sed -f transform.sed messy_file.txt > clean_file.txt
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
cat > /tmp/data.txt << 'EOF'
# Configuration File
server_name = old-server
port = 8080

# Database settings
db_host = localhost
db_port = 5432
db_name = myapp

# End of config
EOF
```

### Exercise 1: Substitution
> **Goal:** Replace values in a config file.
```bash
sed 's/old-server/new-server/' /tmp/data.txt
sed 's/8080/9090/' /tmp/data.txt
```
✅ **Expected:** `server_name` and `port` values are updated in the output.

### Exercise 2: Delete and Filter
> **Goal:** Remove comments and blank lines.
```bash
sed '/^#/d; /^$/d' /tmp/data.txt
```
✅ **Expected:** Only the key=value lines remain — clean config output.

### Exercise 3: In-Place Editing
> **Goal:** Modify a file directly with a backup.
```bash
cp /tmp/data.txt /tmp/data_backup.txt
sed -i 's/localhost/db.production.com/g' /tmp/data.txt
diff /tmp/data_backup.txt /tmp/data.txt
```
✅ **Expected:** `diff` shows `localhost` changed to `db.production.com` in the original file.

---

[<< Previous: Troubleshooting](./60_Troubleshooting.md) | [Home: Curriculum Map](./README.md) | [Next: Awk Programming >>](./62_Awk_Programming.md)
