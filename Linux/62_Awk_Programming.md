# 62: Awk Programming

<p align="center">
  <img src="images/linux_awk_programming.png" alt="Awk Programming" width="800"/>
</p>

`awk` is a complete programming language designed for text processing. While `sed` is great for simple find-and-replace, `awk` excels at **structured data** — processing fields, computing statistics, generating reports, and transforming columnar output.

---

## 1. The Awk Paradigm

```
pattern { action }
```

- Awk reads input **line by line**
- Each line is split into **fields** (`$1`, `$2`, ..., `$NF`)
- If a line matches the **pattern**, the **action** is executed
- If no pattern → action runs on every line
- If no action → matching lines are printed

---

## 2. Built-In Variables

| Variable | Meaning |
| :--- | :--- |
| `$0` | Entire current line |
| `$1`, `$2`, ... | Individual fields |
| `NF` | Number of Fields in current line |
| `NR` | Current line (record) Number |
| `FS` | Field Separator (default: whitespace) |
| `OFS` | Output Field Separator (default: space) |
| `RS` | Record Separator (default: newline) |
| `ORS` | Output Record Separator |
| `FILENAME` | Current input filename |

---

## 3. Basic Usage

```bash
# Print specific fields
awk '{print $1, $3}' file.txt

# Print with custom separator
awk -F: '{print $1, $7}' /etc/passwd       # Username and shell

# Print line numbers
awk '{print NR, $0}' file.txt

# Filter by pattern
awk '/ERROR/ {print $0}' logfile.txt

# Field-based filtering
awk '$3 > 100 {print $1, $3}' data.txt     # Column 3 > 100
```

---

## 4. BEGIN and END Blocks

```bash
# BEGIN runs before any input, END runs after all input
awk 'BEGIN {print "Name\tScore"} 
     {print $1, "\t", $2} 
     END {print "---\nTotal lines:", NR}' scores.txt
```

### Computing Statistics:
```bash
# Average of column 2
awk '{sum += $2; count++} END {print "Average:", sum/count}' data.txt

# Min and Max of column 3
awk 'NR==1 {min=max=$3} $3<min {min=$3} $3>max {max=$3} END {print "Min:", min, "Max:", max}' data.txt
```

---

## 5. Associative Arrays

Awk's most powerful feature — arrays indexed by strings:

```bash
# Count occurrences of each word in column 1
awk '{count[$1]++} END {for (word in count) print word, count[word]}' data.txt

# Sum sales by region
awk -F, '{sales[$2] += $3} END {for (region in sales) print region, sales[region]}' sales.csv

# Group and count log entries by severity
awk '{count[$3]++} END {for (sev in count) print sev, count[sev]}' server.log
```

---

## 6. Functions and Formatting

### Built-In String Functions:
| Function | Purpose | Example |
| :--- | :--- | :--- |
| `length(s)` | String length | `length($1)` |
| `substr(s,p,n)` | Substring | `substr($1,1,3)` |
| `index(s,t)` | Find substring | `index($0,"error")` |
| `split(s,a,sep)` | Split string into array | `split($0,parts,",")` |
| `tolower(s)` | Lowercase | `tolower($1)` |
| `toupper(s)` | Uppercase | `toupper($1)` |
| `gsub(r,s,t)` | Global substitution | `gsub(/old/,"new",$0)` |

### Formatted Output with `printf`:
```bash
awk '{printf "%-20s %10.2f\n", $1, $2}' data.txt
```

---

## 7. Conditionals and Loops

```bash
# If/else
awk '{if ($3 > 90) print $1, "PASS"; else print $1, "FAIL"}' grades.txt

# For loop
awk '{for (i=1; i<=NF; i++) print $i}' file.txt    # One word per line

# While loop
awk '{i=1; while (i<=NF) {print $i; i++}}' file.txt
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
cat > /tmp/employees.txt << 'EOF'
Alice Engineering 95000
Bob Marketing 72000
Carol Engineering 105000
Dave Sales 68000
Eve Marketing 78000
Frank Engineering 112000
Grace Sales 71000
EOF
```

### Exercise 1: Field Extraction and Filtering
> **Goal:** Print names and salaries of engineers only.
```bash
awk '$2 == "Engineering" {print $1, "$"$3}' /tmp/employees.txt
```
✅ **Expected:** Alice $95000, Carol $105000, Frank $112000.

### Exercise 2: Compute Department Averages
> **Goal:** Calculate average salary per department.
```bash
awk '{sum[$2]+=$3; count[$2]++} END {for (dept in sum) printf "%s: $%.0f\n", dept, sum[dept]/count[dept]}' /tmp/employees.txt
```
✅ **Expected:** Average salaries for Engineering, Marketing, and Sales.

### Exercise 3: Generate a Formatted Report
> **Goal:** Create a professional report with headers and totals.
```bash
awk 'BEGIN {printf "%-10s %-15s %10s\n", "Name", "Department", "Salary"; print "--------------------------------------"} {printf "%-10s %-15s %10s\n", $1, $2, "$"$3; total+=$3} END {print "--------------------------------------"; printf "%-26s %10s\n", "TOTAL", "$"total}' /tmp/employees.txt
```
✅ **Expected:** A clean aligned table with a total row at the bottom.

---

[<< Previous: Sed Stream Editor](./61_Sed_Stream_Editor.md) | [Home: Curriculum Map](./README.md) | [Next: Advanced Bash >>](./63_Advanced_Bash.md)
