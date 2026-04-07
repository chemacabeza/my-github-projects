<div align="center">
  <img src="./images/linux_ch60_troubleshooting.png" alt="Linux Troubleshooting Cover" width="800"/>
</div>

# 60: Troubleshooting

> 🧠 **The Feynman Hook:** When a car breaks down, amateur mechanics open the hood and blindly start replacing spark plugs hoping to get lucky. Expert mechanics isolate the problem systematically: Is it fuel? Is it spark? Is it air? Linux troubleshooting requires the exact same surgical methodology. Never guess. Use high-tier diagnostic logging tools to trap the exact moment of failure structurally, transforming a completely broken black box into a mathematically transparent error string.

**🎯 The Big Goal:** Master the systematic diagnostic pipeline—using `strace`, `lsof`, `systemctl`, and `dmesg` to intercept hidden system errors and isolate root causes cleanly.

---

## 1. The Diagnostic Hierarchy

Do not restart the server immediately. Restarting destroys the evidence in RAM. Follow the isolation pipeline.

### Step 1: Prove the Service is Actually Running
```bash
# Is the process actually dead?
sudo systemctl status nginx
```
*If it says "Failed", immediately check the central vault: `journalctl -xeu nginx`.*

### Step 2: Prove the Port is Binding
```bash
# Is it actually listening on the network, or did it bind to the wrong interface?
sudo ss -tulpn | grep 80
```

### Step 3: Prove the Files exist
```bash
# (l)ist (o)pen (f)iles. What exact files is this process illegally holding onto?
sudo lsof -p 1234
```

---

## 2. The X-Ray Machine (`strace`)

Sometimes an application crashes violently but prints absolutely zero error logs to the screen. It just dies.

`strace` (System Call Trace) is an X-Ray. It forcefully intercepts every single command the broken application attempts to send to the Kernel. 

```bash
# Run the broken python script through the X-Ray machine
strace python3 broken_script.py
```

Instead of guessing, `strace` prints exactly what happened:
`open("/etc/secret_config.json", O_RDONLY) = -1 EACCES (Permission denied)`

You instantly know it crashed because it lacked read permissions to a specific JSON file.

---

## 3. The Hardware Doctor (`dmesg`)

If the hard drive is dying, or RAM sticks are failing, the regular applications will crash randomly and inexplicably. You must interrogate the Hardware logs.

`dmesg` (Diagnostic Messages) reads the direct hardware ring buffer.

```bash
# Show critical hardware errors
dmesg | grep -i error

# Show explicit hard drive detachment failures
dmesg | grep -i sda
```

---

## 4. The Scientific Method of Sysadmin

1. **Observe:** "The website is throwing a 502 Bad Gateway Error."
2. **Formulate Hypothesis:** "Nginx is running, but the backend Python script has died."
3. **Test Hypothesis Structure:** Run `curl -I localhost:8000` to ping the python script directly.
4. **Analyze Data:** If it times out, the script is dead. If it responds rapidly, Nginx is misconfigured.
5. **Implement Fix:** Only change ONE variable at a time. If you alter 3 files and fix the issue, you mathematically cannot know which edit succeeded.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe the critical difference between diagnosing an issue using 'grep' vs diagnosing an issue dynamically using 'tail -f'.</summary>
When you use `grep` on an old log file, you are performing a post-mortem on a frozen corpse. The event happened 6 hours ago. When you use `tail -f /var/log/syslog` while actively attempting to replicate the crash, you are performing live surgery. You see the literal exact microsecond the Kernel throws the segmentation fault dynamically. Live tailing drastically accelerates the feedback loop of the scientific method inherently.
</details>

---
[<< Previous: Linux Hardening](./59_Linux_Hardening.md) | [Home: Curriculum Map](./README.md) | [Next: Sed Stream Editor >>](./61_Sed_Stream_Editor.md)
