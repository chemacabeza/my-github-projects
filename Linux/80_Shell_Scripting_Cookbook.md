# 80: Shell Scripting Cookbook

<p align="center">
  <img src="images/linux_shell_cookbook.png" alt="Shell Scripting Cookbook" width="800"/>
</p>

## 🎯 The Big Goal

> **After this chapter, you will transition from writing basic shell scripts to architecting robust, creative, and production-ready automation solutions for web scraping, system maintenance, and data extraction.**

While earlier chapters covered bash theory and POSIX compliance, this cookbook supplies the real-world patterns that engineers utilize to replace Python scripts with 5-line shell abstractions cleanly.

---

## 1. The Bulletproof Script Template

Never start a production script with just `#!/bin/bash`. 

```bash
#!/usr/bin/env bash
#
# Description: Automate weekly DB dumps safely.
# Options: Strict error handling enabled.

# Strict Mode
set -euo pipefail
IFS=$'\n\t'

# Logging function
log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] $*"
}

# Cleanup on exit or disruption
cleanup() {
    log "Terminating script and cleaning temporary workspace..."
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT ERR INT TERM

TMP_DIR=$(mktemp -d)
log "Script initiated. Workspace: $TMP_DIR"

# Main logic here...
```
- `set -e`: Exit immediately on any sub-command failure.
- `set -u`: Error heavily if referencing an unbound (undefined) variable.
- `set -o pipefail`: Ensure pipelines explicitly fail if any internal piped command fails.
- `trap`: Guarantee the `TMP_DIR` disappears even if the script is sent a `SIGINT` (Ctrl+C).

---

## 2. Recipe: Headless Web Scraping via cURL and jq

Parsing an API directly without a heavy library.

```bash
#!/usr/bin/env bash
set -euo pipefail

API_URL="https://api.github.com/repos/torvalds/linux/commits"

# Fetch JSON and stream perfectly into jq
curl -s "$API_URL" | jq -r '.[0:5] | .[] | "\(.commit.author.date) | \(.commit.author.name) | \(.sha | truncate(8))"'

# Output:
# 2024-03-29T10:15:00Z | Linus Torvalds | a1b2c3d4
```
- `jq -r`: Output raw strings natively without JSON quotes.
- `curl -s`: Silent mode to suppress transfer progress bars.

---

## 3. Recipe: Parallel Processing with xargs

Loops are exceptionally slow. Pushing workloads onto all CPU cores simultaneously is critical.

```bash
#!/usr/bin/env bash
# Convert 500 PNG images to JPEG in parallel utilizing all CPU cores.

find ./images -name "*.png" -print0 | \
    xargs -0 -I {} -P $(nproc) \
    bash -c 'convert "$1" "${1%.png}.jpg" && echo "Processed: $1"' _ {}
```
- `-print0` paired with `-0` correctly manages files featuring whitespace.
- `-P $(nproc)` launches as many simultaneous conversions as your physical CPU has threads.

---

## 4. Recipe: The Heartbeat Monitor

A poor-man's persistent daemon that checks a service and restarts it seamlessly if it dies.

```bash
#!/usr/bin/env bash
while true; do
    if ! pgrep -x "nginx" > /dev/null; then
        echo "[CRITICAL] Nginx dead. Restarting..."
        systemctl restart nginx
        # (Optional) Curl a Discord or Slack Webhook here natively
    fi
    sleep 10
done
```

---

## 🤔 Reflection Questions

1. **Why is `set -o pipefail` so crucial when utilizing the `curl | grep` pattern?** What is the exit code of `curl (fail) | grep (success)` natively?
2. **If a script handles tens of thousands of files**, why does `find -exec` process files slower than piping into `xargs`?
3. **What vulnerabilities present themselves if you ignore using \`$'\n\t'\` for your IFS (Internal Field Separator)?** 

---

## 📝 Key Interview Talking Points

- Demonstrate the exact meaning and rationale behind `set -euo pipefail`.
- Understand the function of a `trap EXIT` line for cleaning up environments upon failure or crash.
- Leverage `xargs` to convert standard linear O(n) bash operations into CPU-maximized parallel workflows.

---

[<< Previous: Digital Forensics & IR](./79_Digital_Forensics_IR.md) | [Home: Curriculum Map](./README.md) | [Next: Developer Environment Mastery >>](./81_Developer_Environment.md)
