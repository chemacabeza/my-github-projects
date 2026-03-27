# 05: Process and Resource Management

Drawing heavily from the *UNIX and Linux System Administration Handbook*, a system administrator must have complete visibility over memory, CPU execution, and the lifecycles of processes. 

---

## 1. Top, Htop, and ps

Every program executing on the operating system is tracked via a **Process ID (PID)**.

- **`top`**: The built-in dynamic, real-time view of a running system.
- **`htop`**: An enhanced, colorful version of `top` allowing scrolling and native process hunting.
- **`ps`**: Takes a static snapshot of currently active processes.

### Mastering `ps`
Because `ps` is static, we pipe it into `grep` to hunt down rogue software.

```bash
# Snapshot every single process running on the OS continuously (`e` = everywhere, `f` = full format)
ps -ef 

# Find the exact hidden PID of the "nginx" master process
ps -ef | grep "nginx" 
```

The output contains standard columns: `UID` (Under which user? usually `root`), `PID` (The ID), `PPID` (Parent Process ID - who started it?), and the exact command executed.

---

## 2. Fork and `exec()` Interfaces

Linux rarely creates processes from scratch. It uses `fork()`.
When a process (like the Bash terminal) is told to run a command (like `ls`), Bash invokes the kernel function `fork()`.

1. **Fork**: The kernel perfectly clones the Bash process in memory, creating a Child Process.
2. **Exec**: The Child Process immediately calls `exec()`, replacing its own copied memory entirely with the actual binary code of `/bin/ls`.
3. **Wait**: The original Bash Parent goes to sleep (Waiting) until the Child completes its task and sends an Exit Code back up automatically!

### The Zombie Process Danger
If a Child Process finishes, but the Parent Process is frozen/crashed and never calls `wait()` to collect the Exit Code, the Child becomes a **Zombie**. It is dead, it is not using CPU, but it permanently occupies a slot in the Linux Process Table. If you get 32,000 Zombies, the kernel physically cannot accept new programs and catastrophically crashes (`Resource temporarily unavailable`).

---

## 3. Process Signals (`kill`)

You do not "delete" a process in Linux. You send it a POSIX IPC Signal using the `kill` command. The process is then expected to react.

| Signal Number | Signal Name | Behavior |
| :--- | :--- | :--- |
| `15` | `SIGTERM` | **Terminate**. This is the default. It politely asks the process to save its data and die (Graceful Shutdown). |
| `9` | `SIGKILL` | **Kill**. The kernel instantly rips the process permanently out of RAM. The process gets zero warning. Data corruption is highly likely. |
| `1` | `SIGHUP` | **Hangup**. Originally for modems. Now used to tell daemons (like `nginx`) to silently reload their configuration files without dropping connections! |

```bash
# Politely ask Nginx to shut down (sends 15)
sudo kill 3452

# Nginx is frozen and won't respond to 15. The nuclear option.
sudo kill -9 3452

# Tell nginx to refresh its config without dropping users
sudo kill -1 `cat /run/nginx.pid`
```

---

## 4. Virtual Filesystems (`/proc`)

The `/proc` directory is a complete illusion. It doesn't exist on your hard drive. It is a portal projected directly into your RAM by the Linux Kernel.

Inside `/proc`, you will see a folder matching every active `PID` running on the machine.

```bash
# Peer directly into the raw memory allocation of the machine!
cat /proc/meminfo

# See the direct CPU hardware topology mapped by the Kernel!
cat /proc/cpuinfo

# What is process 1234 exactly running? Look into its namespace!
ls -l /proc/1234/exe  # Points to the exact binary executing
cat /proc/1234/environ # Prints all hidden environment variables belonging to the app
cat /proc/1234/status  # RAM usage exclusively for that PID
```

---

## 5. Cgroups and Namespaces (The Docker Illusion)

Historically, all processes shared the same view of the network (`ip a`) and the same filesystem (`/`). 

In modern Linux, the Kernel provides two ultimate isolation mechanics:
1. **Control Groups (cgroups):** Limits *how much* a process can use. You constrain process 5001 to an absolute maximum of 256MB of RAM and 1 CPU core natively. If it exceeds 256MB, the Kernel invokes the OOM Killer and instantly executes the process.
2. **Namespaces:** Limits *what* a process can see. You execute a process inside an isolated Network Namespace. It literally looks at the network and believes it is the only process on earth. It cannot see port 80 being used by the host.

**This is what Docker is.**
Docker is not virtualization (like VirtualBox). Docker is simply an elegant Go CLI wrapper that downloads a `.tar.gz` filesystem, calls `clone()` to put a process inside a Namespace, and applies a `cgroup` limit.

### Summary
To manage Linux is to intimately manage processes via PIDs, analyze `/proc` files, and gracefully orchestrate their lifecycles through SIGTERM communications and cgroup constraints.

---

## 6. Containerized Execution (MacBook / Linux)
Because Docker natively utilizes cgroups and Namespaces, running `htop` inside a container literally proves the namespace illusion! You will not see your host's processes.

**`Dockerfile`**
```dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y htop procps stress
WORKDIR /root
CMD ["/bin/bash"]
```

**`docker-compose.yml`**
```yaml
services:
  process-sandbox:
    build: .
    stdin_open: true
    tty: true
```

**To Run:**
```bash
docker compose run process-sandbox

# 1. Spawn a background CPU stress process
stress --cpu 4 &

# 2. Open htop and find the PIDs!
htop

# 3. Kill the stress processes using the PID you found
kill -9 <PID>
```


## 🧪 Hands-On Lab: Understanding Processes

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update && apt-get install -y procps stress
```

### Exercise 1: The Process Tree
> **Goal:** Visualize parent-child relationships.
```bash
ps -ef --forest
```
✅ **Expected:** A hierarchical view where you can see `bash` (PID 1) running the `ps` command.

### Exercise 2: Background Jobs
> **Goal:** Push a process to the background.
```bash
sleep 100 > /dev/null &
jobs
```
✅ **Expected:** The terminal returns immediately, and `jobs` shows `[1]+ Running sleep 100 &`.

### Exercise 3: Process Substitution
> **Goal:** Compare the output of two commands without making temporary files.
```bash
echo -e "A
B
C" > list1.txt
echo -e "A
C
D" > list2.txt
diff <(sort list1.txt) <(sort list2.txt)
```
✅ **Expected:** Uses `<()` to pipe output directly into `diff`. It shows `< B` and `> D`.

---
[<< Previous: Bash Scripting Mastery](./04_Bash_Scripting_Mastery.md) | [Home: Curriculum Map](./README.md) | [Next: Networking & Security >>](./06_Networking_and_Security.md)