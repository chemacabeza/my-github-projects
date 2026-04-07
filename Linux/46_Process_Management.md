<div align="center">
  <img src="./images/linux_ch46_process.png" alt="Linux Process Management Cover" width="800"/>
</div>

# 46: Process Management

> 🧠 **The Feynman Hook:** If your CPU is a chef in a kitchen, a "Program" is a recipe sitting safely in a cookbook. A "Process" is when the chef actually starts actively cooking the recipe. The CPU can only slice one onion at a time. The CPU is constantly swapping between cooking the soup, baking the bread, and chopping the onions millions of times per second. Linux Process Management commands are the Kitchen Manager, allowing you to see exactly what the chef is doing, pause a recipe, or throw a recipe in the trash entirely.

**🎯 The Big Goal:** Master `ps`, `top`, `kill`, and `bg`/`fg` to supervise, prioritize, and terminate actively running programs.

---

## 1. The Kitchen Snapshot (`ps`)

The `ps` command takes an instantaneous, frozen snapshot of the CPU.

```bash
# View every single active process on the system
ps aux

# Find exactly where the 'nginx' web server is running
ps aux | grep nginx
```

**Understanding the Output:**
- **PID:** The Process ID. This is the unique tracking number assigned to the running recipe.
- **%CPU / %MEM:** Exactly how much hardware resources the recipe is actively burning.
- **STAT:** Is the recipe actively cooking (`R`), or is it sleeping waiting for an oven timer (`S`)?

---

## 2. The Kitchen Live Monitor (`top` & `htop`)

While `ps` is a static photograph, `top` is a live video feed. It refreshes every 3 seconds to show you dynamically what is straining the CPU the most.

```bash
# Run the built-in monitor
top

# Run the modern, colorful equivalent (Install via apt)
htop
```

> **Pro Tip:** Inside `top`, press `M` to sort the list by RAM usage, or `P` to sort by CPU usage.

---

## 3. Controlling the Chef (`kill`)

The `kill` command does not inherently "kill". It sends numerical signals to a running process, like a manager tapping the chef on the shoulder.

```bash
# Send Signal 15 (SIGTERM): Ask the process politely to clean up and shut down.
kill 1234

# Send Signal 9 (SIGKILL): Pull the plug from the wall. The process dies instantly.
kill -9 1234

# Send Signal 1 (SIGHUP): Tell the process to re-read its configuration file without dying.
kill -HUP 1234
```

---

## 4. Background and Foreground Jobs

If you run a script that takes 5 hours to calculate pi, your terminal is completely frozen. You cannot type anything else.

```bash
# Start a script but hurl it instantly into the Background using the '&' symbol
./calculate_pi.sh &
```

Once a script is in the background, you can use job control.
```bash
# List all processes currently running in the background of your terminal
jobs

# Bring process #1 back into the foreground so you can interact with it
fg 1
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: What happens to a running process if you accidentally close your SSH terminal window?</summary>
When you log into a Linux server via SSH, the system creates a `bash` shell process. Any command you run inside it (like `python script.py`) is technically a "Child Process" of that shell. If you disconnect, the server destroys the parent shell. Instantly, all child processes are also destroyed. To prevent this, you must run the command using `nohup` (No Hang Up), which physically decouples the child process from the parent shell.
</details>

---
[<< Previous: Disk & System Info](./45_Disk_and_System_Info.md) | [Home: Curriculum Map](./README.md) | [Next: System Control >>](./47_System_Control.md)
