# 58: Regular Expressions

<p align="center">
  <img src="images/linux_regex.png" alt="Regular Expressions" width="800"/>
</p>

Regular expressions (regex) are the universal search language of the Linux command line. Every tool — `grep`, `sed`, `awk`, `find`, `vim` — speaks regex. Mastering them means you can find, match, and transform any text pattern instantly.

---

## 1. Basic vs Extended Regex

| Feature | BRE (Basic) | ERE (Extended) |
| :--- | :--- | :--- |
| **Tool Default** | `grep`, `sed` | `grep -E` / `egrep`, `awk` |
| `+`, `?`, `{}` | Require escaping: `\+` | Work directly: `+` |
| `()`, `|` | Require escaping: `\(\)` | Work directly: `()` |
| **Best Practice** | Use `-E` everywhere | ✅ Recommended |

```bash
# Always prefer extended regex
grep -E "pattern" file             # Extended regex
```

---

## 2. Character Classes

| Pattern | Matches | Example |
| :--- | :--- | :--- |
| `.` | Any single character | `h.t` → hat, hot, hit |
| `[abc]` | Any of a, b, c | `[ch]at` → cat, hat |
| `[^abc]` | NOT a, b, or c | `[^c]at` → hat, bat (not cat) |
| `[a-z]` | Any lowercase letter | `[a-z]+` → hello |
| `[0-9]` | Any digit | `[0-9]{3}` → 123 |
| `\d` | Digit (Perl-style) | `grep -P "\d+"` |
| `\w` | Word char (letter/digit/_) | `\w+` → hello_world |
| `\s` | Whitespace | `\s+` → spaces, tabs |

---

## 3. Quantifiers

| Quantifier | Meaning | Example |
| :--- | :--- | :--- |
| `*` | 0 or more | `ab*c` → ac, abc, abbc |
| `+` | 1 or more | `ab+c` → abc, abbc (not ac) |
| `?` | 0 or 1 (optional) | `colou?r` → color, colour |
| `{n}` | Exactly n | `\d{4}` → 2024 |
| `{n,}` | n or more | `\d{2,}` → 10, 100, 1000 |
| `{n,m}` | Between n and m | `\d{1,3}` → 1, 42, 255 |

---

## 4. Anchors and Boundaries

| Anchor | Meaning | Example |
| :--- | :--- | :--- |
| `^` | Start of line | `^Error` → lines starting with Error |
| `$` | End of line | `\.log$` → lines ending with .log |
| `\b` | Word boundary | `\bcat\b` → "the cat sat" (not "catalog") |

---

## 5. Groups and Alternation

```bash
# Groups — capture parts of the match
echo "2024-01-15" | grep -oP "(\d{4})-(\d{2})-(\d{2})"

# Alternation — match either pattern
grep -E "error|warning|critical" logfile.txt

# Backreferences — refer to captured groups
echo "hello hello" | grep -E "(\w+) \1"    # Finds repeated words
```

---

## 6. Practical Examples

```bash
# Find all IP addresses in a file
grep -oE "\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b" access.log

# Find all email addresses
grep -oP "[\w.+-]+@[\w-]+\.[\w.]+" contacts.txt

# Find lines with exactly 3 digits
grep -E "^[0-9]{3}$" data.txt

# Remove blank lines
sed '/^$/d' file.txt

# Extract the domain from URLs
echo "https://www.example.com/page" | grep -oP "(?<=://)[^/]+"

# Replace date format: MM/DD/YYYY → YYYY-MM-DD
sed -E 's|([0-9]{2})/([0-9]{2})/([0-9]{4})|\3-\1-\2|g' dates.txt
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
mkdir -p /root/lab58 && cd /root/lab58
# Create sample data
cat > server.log << 'EOF'
2024-01-15 10:23:45 ERROR Failed to connect to 192.168.1.50
2024-01-15 10:24:01 INFO Connection established to 10.0.0.1
2024-01-15 10:24:15 WARNING Disk usage at 85%
2024-01-15 10:25:00 ERROR Timeout reading from 172.16.0.100
2024-01-15 10:25:30 INFO User admin@company.com logged in
2024-01-15 10:26:00 CRITICAL Database unreachable at 192.168.1.200
EOF
```

### Exercise 1: Extract All IP Addresses
> **Goal:** Use regex to find every IP in the log.
```bash
grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" server.log
```
✅ **Expected:** Four IP addresses extracted from the log entries.

### Exercise 2: Filter by Severity
> **Goal:** Show only ERROR and CRITICAL lines.
```bash
grep -E "ERROR|CRITICAL" server.log
```
✅ **Expected:** Three lines matching those severity levels.

### Exercise 3: Extract Email Addresses
> **Goal:** Pull out email addresses from the log.
```bash
grep -oE "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" server.log
```
✅ **Expected:** `admin@company.com`

---

[<< Previous: Git Version Control](./57_Git_Version_Control.md) | [Home: Curriculum Map](./README.md) | [Next: Linux Hardening >>](./59_Linux_Hardening.md)
