<div align="center">
  <img src="./images/linux_ch63_advanced_bash.png" alt="Linux Advanced Bash Cover" width="800"/>
</div>

# 63: Advanced Bash

> 🧠 **The Feynman Hook:** Basic scripting is just stacking simple commands linearly like dominoes. Advanced Bash is building a Cybernetic Brain. Instead of a script just falling over sequentially, you grant it the intelligence to make decisions (`if/else`), trap failures in real-time, execute complex mathematical loops, and intelligently validate input. You transition from writing simple macro recordings into engineering fully autonomous digital programs.

**🎯 The Big Goal:** Master explicit boolean logic evaluations, array processing, `for/while` loops, and defensive error trapping inherently.

---

## 1. Boolean Logic (The If/Else Gates)

A script must evaluate the environment to execute safely. In Bash, logic is enclosed tightly in square brackets `[ ]`.

```bash
#!/bin/bash

# Check if the user executing the script is the Root Administrator
if [ "$EUID" -ne 0 ]; then
  echo "Error: High-level clearance required. Please run as root."
  exit 1
else
  echo "Access Granted. Initializing deployment."
fi
```

### The Operators
- `-eq` : Exactly Equal to
- `-ne` : Not Equal to
- `-gt` : Greater Than
- `-lt` : Less Than
- `-d`  : Validates if a specific path is physically a Directory
- `-f`  : Validates if a specific path is physically a File

---

## 2. Iteration (Loops)

If you need to ping 50 IP addresses, you do not write 50 linear ping commands. You write one command and loop the brain through an array of data dynamically.

### The For Loop
```bash
#!/bin/bash
# Loop precisely over a predefined list of servers
for server in web01 web02 db01; do
  echo "Deploying updates securely to $server..."
  scp new_config.ini $server:/etc/
done
```

### The While Loop
```bash
#!/bin/bash
# Read a massive text file line by line smoothly
while read line; do
  echo "Processing target IP: $line"
done < targets.txt
```

---

## 3. Strict Mode (Defensive Architecture)

By default, Bash is aggressively permissive. If a script tries to delete `$DIR/logs` but the variable `$DIR` is accidentally empty, Bash translates it instantly to `rm -rf /logs`, violently destroying the root filesystem. You must enforce strict rules.

```bash
#!/bin/bash
set -euo pipefail

# -e : Exit instantly if ANY single command fails. Do not continue blindly.
# -u : Exit instantly if a variable is used but undefined mathematically.
# -o pipefail : If a command fails inside a pipeline (e.g., grep | awk), fail the entire pipeline firmly.
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe why wrapping variables explicitly in double-quotes (e.g., "$FILE") is absolutely critical for defensive Bash engineering.</summary>
If you execute `rm $FILE` without quotes, and the file is named `My Report.txt`, the Bash interpreter inherently parses the space as a command separator. It violently assumes you passed two completely different arguments. It attempts to delete a file named `My` and then completely delete an unrelated folder named `Report.txt`. By explicitly enforcing double quotes (`rm "$FILE"`), you mathematically bind the entire string together, preventing the interpreter from destructively splitting the logic on whitespace boundaries.
</details>

---
[<< Previous: Awk Programming](./62_Awk_Programming.md) | [Home: Curriculum Map](./README.md) | [Next: Shell Environment >>](./64_Shell_Environment.md)
