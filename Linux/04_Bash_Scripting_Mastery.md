<div align="center">
  <img src="./images/linux_ch04_bash.png" alt="Bash Scripting Cover" width="800"/>
</div>

# 04: Bash Scripting Mastery

> 🧠 **The Feynman Hook:** A chef who can only cook by standing at the stove, making ad-hoc decisions, is limited. But a chef who writes down their best recipes — with exact measurements, checked conditions, and repeatable steps — can delegate that work to a kitchen assistant who will execute it flawlessly every night without supervision. **Bash scripting** is writing those recipes. Instead of typing commands interactively (ad-hoc cooking), you encode logic into a reproducible file: "If user count exceeds 1000, compress the old logs. Always exit with a non-zero code if any step fails. Run this every night at 2 AM via cron." The Bash script is your kitchen automation.

**🎯 The Big Goal:** Write production-grade Bash scripts with strict error handling, exit code awareness, and scheduled execution — moving from interactive typing to reliable automation.

---

## 1. The Anatomy of a Bash Script

> **Feynman Insight:** The **shebang** (`#!/bin/bash`) on line 1 is not a comment — it tells the kernel which interpreter to use when this file is executed. Without it, the kernel guesses (usually incorrectly). `chmod +x script.sh` flips the execute bit, making the file a runnable program. `./script.sh` runs it from the current directory (the `./` is required because the current directory is intentionally not in `$PATH` for security reasons).

```bash
#!/bin/bash
# My first production script

# === CONFIGURATION ===
LOG_DIR="/var/log/myapp"
BACKUP_DIR="/backup"

echo "Starting backup at $(date)"

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Copy logs to backup
cp -r "$LOG_DIR" "$BACKUP_DIR/logs_$(date +%Y%m%d)"

echo "Backup completed."
```

```bash
# Make executable and run
chmod +x backup.sh
./backup.sh
```

---

## 2. Strict Mode — The Safety Helmet (`set -euo pipefail`)

> **Feynman Insight:** By default, Bash is dangerously permissive. If a command in the middle of your script fails (exit code non-zero), Bash merrily continues executing the next command. You might silently delete your database table, then continue "successfully" processing the now-empty table. **Strict mode** prevents this catastrophe: `-e` exits the entire script immediately on any error. `-u` exits if you reference an undefined variable (typo protection). `-o pipefail` makes a pipeline fail if *any* command in the pipeline fails (not just the last one).

```bash
#!/bin/bash
set -euo pipefail   # The safety helmet — put it on before anything else

# -e: If any command fails, stop immediately
# -u: If you use $UNDFINED_VAR (typo), stop immediately
# -o pipefail: If cmd1 | cmd2 fails at cmd1, the pipe fails

echo "Connecting to database..."
psql -U admin -d myapp -c "SELECT count(*) FROM users;"  # If THIS fails, script stops here

echo "This line only runs if the DB query succeeded."
```

---

## 3. Variables, Substitution, and Exit Codes

> **Feynman Insight:** In Bash, `$?` is the **crystal ball** of the previous command: it contains the exit code of the last command that ran. Exit code `0` means success (the POSIX convention: zero errors). Exit code `1`–`255` means something went wrong. Checking `$?` is how scripts make decisions: "Did the database connect? If exit code was non-zero, alert and exit." `$()` is command substitution — it runs a command and captures its stdout as a string value.

```bash
#!/bin/bash
set -euo pipefail

# Variables — NO spaces around the = sign!
USERNAME="alice"
HOME_DIR="/home/${USERNAME}"   # Curly braces for clarity in complex strings

# Command substitution — capture command output
CURRENT_DATE=$(date +%Y-%m-%d)
FILE_COUNT=$(ls /var/log | wc -l)

echo "Date: $CURRENT_DATE, Log files: $FILE_COUNT"

# Exit code check (before using set -e)
if ! ping -c 1 google.com &>/dev/null; then
    echo "ERROR: No internet connectivity." >&2
    exit 1
fi

echo "Internet is up."
```

---

## 4. Loops, Conditionals, and Functions

```bash
#!/bin/bash
set -euo pipefail

# IF-THEN-ELSE
if [ -f "/etc/nginx/nginx.conf" ]; then
    echo "Nginx is installed."
else
    echo "Nginx not found."
fi

# FOR loop over a list
for SERVICE in nginx postgresql redis; do
    STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null || echo "inactive")
    echo "$SERVICE: $STATUS"
done

# WHILE loop with counter
COUNTER=1
while [ "$COUNTER" -le 5 ]; do
    echo "Attempt $COUNTER..."
    COUNTER=$((COUNTER + 1))
done

# Functions
check_service() {
    local SERVICE_NAME="$1"    # local = function-scoped variable
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "[OK] $SERVICE_NAME is running."
    else
        echo "[WARN] $SERVICE_NAME is NOT running."
    fi
}

check_service nginx
check_service postgresql
```

---

## 5. Crontab — The Scheduler

> **Feynman Insight:** Cron is an always-running daemon that wakes up every minute, reads the crontab schedule file, and executes any command whose time expression matches the current minute. The 5-field cron expression looks cryptic but follows a simple order: **Minute Hour Day-of-Month Month Day-of-Week Command**. Think of it as reading "at [minute] past [hour] on [day] of [month] on [weekday]".

```bash
# Edit your crontab
crontab -e

# Format: Minute  Hour  Day  Month  Weekday  Command
# ┌──── minute (0-59)
# │  ┌─ hour (0-23)
# │  │  ┌── day of month (1-31)
# │  │  │  ┌─── month (1-12)
# │  │  │  │  ┌──── day of week (0-7, 0 and 7 = Sunday)
# │  │  │  │  │
  0  2  *  *  *  /opt/scripts/backup.sh >> /var/log/backup.log 2>&1
# ^ At 02:00 every day, run backup.sh, log all output

30 */4  *  *  *  /opt/scripts/check_disk.sh
# ^ At minute 30, every 4 hours

@reboot  /opt/scripts/init.sh
# ^ Run once, immediately at system boot
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Why does 'set -o pipefail' matter for pipelines?</summary>

Without `pipefail`, a pipeline like `broken_command | grep "result"` uses the exit code of the *last* command (`grep`) — which succeeds (exit 0) even if `broken_command` failed. So `-e` never triggers. With `pipefail`, Bash uses the exit code of the *rightmost command that failed* in the pipeline. If `broken_command` exits with code 1, the entire pipeline exit code is 1, and `-e` stops the script. This is critical for data pipelines where the source command failing silently would cause the rest of the script to process empty/corrupt data and report success.
</details>

<details>
<summary>💡 View Answer: Why must you quote all variable references as "$VAR" instead of $VAR?</summary>

**Word splitting and globbing.** Unquoted `$VAR` in Bash undergoes two dangerous transformations before use: (1) **Word splitting**: if `VAR="hello world"`, then `$VAR` becomes two words `hello` and `world`, potentially passing two arguments where one was intended. (2) **Glob expansion**: if `VAR="file.*"`, then `$VAR` expands to all matching filenames in the current directory. Both happen silently, causing subtle, hard-to-debug bugs. Quoting `"$VAR"` prevents both. The rule: **always double-quote variable references, without exception**.
</details>

---

## 🐳 Hands-On Lab: Bash Scripting

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
```

### Exercise 1: Strict Mode Script
> **Goal:** Observe what strict mode catches.
```bash
cat <<'EOF' > /tmp/test.sh
#!/bin/bash
set -euo pipefail
echo "Referencing undefined: $UNDEFINED_VAR"
echo "This should never print."
EOF
bash /tmp/test.sh
```
✅ **Expected:** Script exits with error on the undefined variable line — never prints the second echo.

### Exercise 2: Loop with Exit Code Check
> **Goal:** Build a service health checker.
```bash
cat <<'EOF' > /tmp/health.sh
#!/bin/bash
set -euo pipefail
for CMD in bash grep awk nonexistent_command_xyz; do
    if command -v "$CMD" &>/dev/null; then
        echo "[OK]   $CMD found"
    else
        echo "[MISS] $CMD NOT found"
    fi
done
EOF
bash /tmp/health.sh
```
✅ **Expected:** OK for bash/grep/awk, MISS for the nonexistent command.

---

## 📝 Key Interview Talking Points

- **`set -euo pipefail`**: The professional standard opening for every production Bash script. Explain what each flag does.
- **Exit code `0` = success** (POSIX standard). Any non-zero = failure. `$?` holds the previous command's exit code.
- **Always quote variables**: Prevents word-splitting and glob-expansion bugs. Use `"${VAR}"` for safety.
- **`local` keyword in functions**: Variables declared with `local` are scoped to the function — prevents namespace pollution in large scripts.
- **Crontab gotcha**: Cron runs with a minimal environment (`$PATH` is very limited). Always use absolute paths for all commands in crontab entries.

---
[<< Previous: Package & Service Mgmt](./03_Package_and_Service_Mgmt.md) | [Home: Curriculum Map](./README.md) | [Next: Process & Resource Management >>](./05_Process_and_Resource_Management.md)