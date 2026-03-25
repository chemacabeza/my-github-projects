# 19: Linux Namespaces - The Illusion of Isolation

<p align="center">
  <img src="images/container_internals.png" alt="Linux Container Architecture" width="800"/>
</p>

Imagine your computer is a massive skyscraper. Every process is a resident. Normally, everyone shares the same hallways, the same water pipes, and can see each other in the lobby.

**Namespaces** allow the Kernel to put certain residents into a **Parallel Universe**. From their perspective, the skyscraper is empty, and they are the only ones living there.

---

## 1. The Virtualized View

A Namespace isn't a "box"—it's a **filter** on what a process can see. There are 6 main types of "Parallel Universes" we can create:

| Namespace Type | The Analogy | The Technical Reality |
| :--- | :--- | :--- |
| **Mount (mnt)** | A private floor with its own rooms. | The process has its own unique list of mount points (`/`, `/tmp`). |
| **UTS** | A private mailbox with a custom name. | The process has its own hostname (e.g., `container-alpha`). |
| **PID** | Thinking you're the first person on Earth. | The process thinks its ID is `1`. It cannot see the host's processes. |
| **Network (net)** | Having your own private internet line. | The process has its own IP address and routing table. |
| **User (user)** | Thinking you're the landlord. | A regular user on the host becomes `root` inside the namespace. |
| **IPC** | A private soundproof room. | Isolation of System V IPC and POSIX message queues. |

---

## 2. Guided Experiment: Creating a Ghost Universe

Let's prove the "Parallel Universe" theory. We will use the `unshare` command to create a shell that thinks it's alone on the machine.

### Step 1: The "Loneliness" Command
Run this in your terminal. It detaches your PID list from the rest of the computer.

```bash
# -p: New PID Namespace
# -f: Fork a new shell
# --mount-proc: Create a private /proc for 'ps' to read from
sudo unshare -p -f --mount-proc /bin/sh
```

### Step 2: Observe the Ghost Town
Now run the command to list processes:
```bash
ps aux
```

**What you will see:**
- You only see **two** processes. 
- You are **PID 1**. 
- The hundreds of other processes on your computer have "vanished."

---

## 3. Behind the Scenes: The `/proc` Links

How does Linux keep track of these universes? Every process has a directory in `/proc` that defines its reality.

```bash
# Look at your current shell's universe IDs:
ls -l /proc/self/ns/
```
Each entry (net, pid, mnt) points to a unique inode number. If two processes have the same inode for `net`, they can "hear" each other on the network. If they differ, they are in different worlds.

---

## 4. Summary: The Mind-Shift
A container **is not a thing**. A container is just a standard Linux process where the Kernel is lying to it about what the rest of the system looks like.

*In Chapter 20, we will learn how to put these "world-weary" processes on a resource leash using Cgroups.*

---
[<< Previous: Linux Firewalls](./18_Linux_Firewalls_iptables.md) | [Home: Curriculum Map](./README.md) | [Next: Control Groups (cgroups) >>](./20_Control_Groups_cgroups.md)
