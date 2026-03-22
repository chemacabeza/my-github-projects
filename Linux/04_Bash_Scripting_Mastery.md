# 04: Bash Scripting Mastery

Based on *Shell Programming in UNIX*, we transition from typing commands interactively to creating highly robust, automated shell scripts. Bash is the default shell for almost all Linux distributions.

---

## 1. The Shebang (`#!/bin/bash`)

A script is merely a text file containing commands. To tell the operating system *which* interpreter to use to run the file, the very first line must be the "shebang".

```bash
#!/bin/bash

# This is a comment.
echo "Initializing the daily backup sequencer..."
```

**Execution:**
You cannot run a script unless you flip the Executable (`x`) bit using `chmod`!
```bash
chmod +x backup.sh
./backup.sh
```

---

## 2. Variables and Environment

Bash variables do not have types. Everything is fundamentally a string.
- You **MUST NOT** use spaces around the equals sign `=`.
- To output the variable, you must prefix it with `$`.

```bash
#!/bin/bash

# 1. Variable Assignment (No spaces!)
SERVER_NAME="database-prod-1"
RETRIES=3

# 2. String Interpolation
echo "Connecting to $SERVER_NAME with $RETRIES retries..."

# 3. Environment Variables using 'export'
# This variable survives outside this script and is passed to child processes!
export GLOBAL_AUTH_TOKEN="12345ABC"

# 4. Built-in Script Variables
echo "Name of this exact script: $0"
echo "First argument passed by user: $1"
echo "Total number of arguments: $#"
```

---

## 3. Exit Codes (`$?`)

Every single command run in Linux produces an invisible integer called an **Exit Code** or **Return Status** when it finishes.
- `0` means ABSOLUTE SUCCESS.
- `1` to `255` means FAILURE.

You can view the exit code of the *very last command run* by inspecting the special variable `$?`.

```bash
#!/bin/bash

# Try to ping google once
ping -c 1 8.8.8.8 > /dev/null

if [ $? -eq 0 ]; then
    echo "Network is absolutely UP!"
else
    echo "Network FATAL ERROR. Could not reach Google."
    exit 1  # We forcefully kill the script right here and broadcast failure
fi
```

### The Unofficial "Strict Mode"
Enterprise Bash scripts should always start with this exact line right below the shebang:
```bash
set -euo pipefail
```
- `-e`: Exit immediately if *any* command returns a non-zero status (so the script doesn't keep running wildly if the database drops).
- `-u`: Treat unset empty variables as an error and exit instantly.
- `-o pipefail`: The return value of a pipeline (`cmd1 | cmd2`) is the status of the last command to exit with a non-zero status.

---

## 4. Automation: The Cron Daemon

Scripts are powerful, but having the server execute them automatically every night at 3:00 AM is Sysadmin mastery. We use `cron`.

Open the `crontab` editor for your current user:
```bash
crontab -e
```

**The Cron Syntax:**
There are exactly 5 asterisks `* * * * *`, representing time, followed by the command to run.
1. Minute (0 - 59)
2. Hour (0 - 23)
3. Day of month (1 - 31)
4. Month (1 - 12)
5. Day of week (0 - 7) (0 or 7 is Sunday)

### Examples

```txt
# Run exactly at 3:00 AM every single day
0 3 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1

# Run every 5 minutes forever
*/5 * * * * /opt/scripts/healthcheck.sh

# Run at Midnight every Sunday continuously
0 0 * * 0 /opt/scripts/weekly_purge.sh
```

### Summary
The transition from entering commands linearly to composing them logically inside a resilient, strict-mode Bash file is the definition of Systems Automation. By combining `set -euo pipefail` with `crontab`, you create background jobs that operate reliably for decades.
