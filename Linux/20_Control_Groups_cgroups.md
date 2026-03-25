# 20: Control Groups (cgroups) - Resource Mastery

<p align="center">
  <img src="images/container_internals.png" alt="Linux Cgroup Architecture" width="800"/>
</p>

Namespaces (Ch 19) handle **Isolation** (what a process can see). 
**Control Groups (cgroups)** handle **Resource Governance** (how much a process can use).

Without cgroups, a single process could leak memory or hog the CPU, crashing your entire server. cgroups prevent this "noisy neighbor" effect.

---

## 1. Everything is a File: `/sys/fs/cgroup`

In Linux, cgroups are managed through a virtual filesystem. You don't use a database; you create directories and write numbers to files.

- **CPU Controller:** Limits CPU cycles.
- **Memory Controller:** Limits RAM usage.
- **PIDs Controller:** Limits the number of processes (preventing Fork Bombs).

---

## 2. Hands-on: Throttling a Process

Let's manually limit the memory of a shell to 50MB.

### Step 1: Create a Group
```bash
sudo mkdir /sys/fs/cgroup/memory/my-lab
```
Linux automatically populates this folder with control files.

### Step 2: Set the Limit
```bash
# Limit to 50,000,000 bytes (~50MB)
echo 50000000 | sudo tee /sys/fs/cgroup/memory/my-lab/memory.limit_in_bytes
```

### Step 3: Put yourself in the Jail
```bash
# Add your current shell's PID to the 'tasks' file
echo $$ | sudo tee /sys/fs/cgroup/memory/my-lab/tasks
```

**Testing:** If you try to run a program that needs 100MB of RAM now, the kernel will instantly trigger the **OOM Killer** and kill the process to protect the system.

---

## 3. The Modern Era: Cgroup v2

The example above uses v1 (distributed). Modern Linux (Ubuntu 22.04+) uses **Cgroup v2**, which uses a unified hierarchy. 

**V2 Path:** `/sys/fs/cgroup/cgroup.controllers`

In Cgroup v2, controllers are enabled by writing to `cgroup.subtree_control`. This architecture is more efficient and is what modern Kubernetes uses to manage pods.

---

## 4. Why this matters for Docker

When you run:
`docker run --memory="500m" --cpus="2.0" nginx`

Docker is simply:
1.  Creating a directory in `/sys/fs/cgroup`.
2.  Writing the limits to the files.
3.  Launching the process inside that group.

*In the final module of Phase 7, we will combine Namespaces and Cgroups to build a container from scratch.*
