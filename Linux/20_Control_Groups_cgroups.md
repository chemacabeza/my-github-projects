# 20: Control Groups (cgroups) - Resource Mastery

<p align="center">
  <img src="images/container_internals.png" alt="Linux Cgroup Architecture" width="800"/>
</p>

Namespaces (Ch 19) handle **Isolation**—making sure residents don't see each other.
**Control Groups (cgroups)** handle **Governance**—making sure a single resident doesn't eat everyone else's food or hog the electricity.

Think of it as putting a process on a **Resource Leash**. You allow it to roam the skyscraper, but it can only go as far as the leash allows.

---

## 1. The Power of "Everything is a File"

One of the most elegant parts of Linux is that you don't need a heavy GUI to manage hardware limits. You just need to talk to a special directory: `/sys/fs/cgroup`.

Inside this folder, there are sub-folders for every resource:
- **`memory`**: RAM limits.
- **`cpu`**: CPU cycle shares.
- **`pids`**: Limit the number of sub-processes (Fork Bomb protection).

---

## 2. Guided Exercise: Creating a RAM Jail

Let's manually cap a process so it can never use more than a tiny amount of memory.

### Step 1: Create a Sub-Group
Simply making a directory in `/sys` tells the Kernel to spawn a new security team.
```bash
sudo mkdir /sys/fs/cgroup/memory/lab-jail
```

### Step 2: Set the "Hard Limit"
We will limit this group to roughly 50MB. If any process inside tries to use more, the Kernel will instantly kill it.
```bash
echo 50000000 | sudo tee /sys/fs/cgroup/memory/lab-jail/memory.limit_in_bytes
```

### Step 3: Imprison a Process
We add our current shell to the jail by writing its PID (`$$`) to the `tasks` file.
```bash
echo $$ | sudo tee /sys/fs/cgroup/memory/lab-jail/tasks
```

**Verification:** Run any command. Your shell is now "leashed." If you try to run a memory-heavy app, it will vanish before it can damage the host system.

---

## 3. Cgroup v1 vs v2: The Evolution

- **v1 (Old):** Resources were separated into different "hierarchies." It was messy.
- **v2 (Modern):** One single tree managing everything (`/sys/fs/cgroup`). This is what Docker and Kubernetes use natively today.

---

## 4. Why This Matters for Architects

Without cgroups, "Cloud Computing" could not exist. 

When you pay for a "Medium Instance," the provider isn't giving you a whole computer; they are simply adding your process to a **Control Group** that limits you to 2 CPUs and 4GB of RAM.

*In Chapter 21, we will merge Isolation and Governance to build a complete container from scratch.*
