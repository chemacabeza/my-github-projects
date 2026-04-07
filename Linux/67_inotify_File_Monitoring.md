<div align="center">
  <img src="./images/linux_ch67_inotify.png" alt="Linux inotify Cover" width="800"/>
</div>

# 67: inotify File Monitoring

> 🧠 **The Feynman Hook:** If you want to know when a specific file is changed by a hacker, you could write a script that checks the file's modified date every 5 seconds. This is called Polling, and it is terribly inefficient—like asking a child "Are we there yet?" every 5 seconds. `inotify` is fundamentally different. It is a highly trained ninja standing directly on top of the file in the Kernel. The ninja does nothing and burns zero CPU until the exact microsecond the file is touched. Then, it instantly strikes, triggering an alarm asynchronously.

**🎯 The Big Goal:** Master Kernel-level event monitoring using `inotify-tools` to build real-time reactive infrastructure without polling loops.

---

## 1. The Real-Time Waiter (`inotifywait`)

To use the ninja, you use the `inotifywait` command. It literally pauses your script entirely, consuming zero CPU cycles, until a physical filesystem event matches your strict criteria.

```bash
# Block the terminal completely until someone explicitly modifies or deletes the target file
inotifywait -e modify -e delete /etc/passwd

# Once a hacker touches the file, the command finishes, and you can trigger a subsequent action:
echo "CRITICAL EVENT: Target file compromised!"
```

### Event Types
You can instruct the ninja to watch for very specific actions:
- `access` : The file was merely read.
- `modify` : The file's internal data was altered.
- `attrib` : The file's metadata or permissions were fundamentally changed.
- `delete` : The file was violently purged.

---

## 2. Watching Entire Directories

If you have an FTP server where clients upload files, you do not know the filenames in advance. You must station the ninja at the door of the directory itself.

```bash
# Watch an 'incoming' folder permanently, and print a continuous feed of all structural events
inotifywait -m -r -e create -e moved_to /var/ftp/incoming/
```

- `-m` : Monitor. Do not exit after the first event. Stay there forever.
- `-r` : Recursive. Watch all nested subdirectories structurally.

---

## 3. Real-Time Automation Synthesis

You can pipe the continuous output of the ninja directly into a `while` loop, creating a fully autonomous, event-driven engine.

```bash
#!/bin/bash
WATCH_DIR="/var/ftp/incoming"
TARGET_DIR="/var/www/processed_images"

# Every time a file lands in the folder, instantly compress it without waiting
inotifywait -m -e create --format '%f' "$WATCH_DIR" | while read NEW_FILE
do
    echo "Instant processing triggered for: $NEW_FILE"
    convert "$WATCH_DIR/$NEW_FILE" -resize 800x600 "$TARGET_DIR/$NEW_FILE"
done
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe why utilizing 'inotify' is mathematically vastly superior to writing a cron job that checks for new files every minute.</summary>
A cron job checking for files every 60 seconds has a fundamental architectural lag time. If a user uploads a file at 12:00:01, they must sit blindly for 59 seconds before the processor finally awakens to compress their file. Furthermore, if zero files are uploaded all week, the cron job uselessly executes 10,080 times, burning CPU blindly. `inotify` resolves both violently. Because it is tied inherently to the exact Kernel VFS (Virtual File System) interrupt, it triggers the absolute millisecond the hard drive stops spinning, providing latency-free event resolution while consuming absolutely zero idle CPU overhead natively.
</details>

---
[<< Previous: Reconnaissance & Forensics](./66_Reconnaissance_Forensics.md) | [Home: Curriculum Map](./README.md) | [Next: ACLs & Extended Attributes >>](./68_ACLs_Extended_Attributes.md)
