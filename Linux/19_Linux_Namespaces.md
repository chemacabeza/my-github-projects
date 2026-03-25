# 19: Linux Namespaces - The Illusion of Isolation

<p align="center">
  <img src="images/container_internals.png" alt="Linux Container Architecture" width="800"/>
</p>

If you've used Docker, you know that a container feels like a separate computer. But it's not. It's just a regular Linux process that is **hallucinating**. 

**Namespaces** are the kernel feature that provides this hallucination by restricting what a process can "see."

---

## 1. The Six Core Namespaces

Linux allows us to virtualize almost every aspect of the system view.

| Namespace | What it Isolates | The "Hallucination" |
| :--- | :--- | :--- |
| **Mount (mnt)** | Filesystem Mount Points | Process sees a unique directory structure. |
| **UTS** | Hostname and Domain Name | Process thinks it has its own computer name. |
| **IPC** | Interprocess Communication | Process cannot see shared memory of others. |
| **PID** | Process IDs | Process thinks it is PID 1 (The King). |
| **Network (net)** | IP Addresses, Ports, Routes | Process has its own virtual network card. |
| **User (user)** | User and Group IDs | Process thinks it is 'root' (UID 0). |

---

## 2. Hands-on: Building a PID Jail

Let's prove it. Normally, if you ran `ps aux`, you'd see hundreds of processes. Let's create an environment where you can only see yourself.

### The `unshare` command
`unshare` allows you to start a new process with its own namespaces.

```bash
# -p: New PID Namespace
# -f: Fork a new process
# --mount-proc: Mount a new /proc filesystem (needed for 'ps' to work)
sudo unshare -p -f --mount-proc /bin/sh
```

**Inside the new shell:**
```bash
ps aux
```
**Results:** You will only see two processes: `ps aux` and your shell. You have officially isolated your process list from the host.

---

## 3. The `setns` and `nsenter` Mechanics

How does `docker exec` work? It uses the `setns()` system call to join an existing namespace.

```bash
# See which namespaces your current shell belongs to:
ls -l /proc/self/ns/
```
Each file listed (ipc, mnt, net, pid) is a symlink to a unique ID. If two processes have the same IDs, they are in the same "room."

---

## 4. The "Root" of the Matter: Mount Namespaces

The most common container trick is `chroot`. It changes the root directory for a process. Combined with a Mount Namespace, it creates a private filesystem.

```bash
# 1. Create a dummy root
mkdir /tmp/fake-root
cp -r /bin /lib /lib64 /tmp/fake-root/ # Minimal tools

# 2. Enter the jail
sudo chroot /tmp/fake-root /bin/sh
```

*In the next module, we will learn how to put this "isolated" process on a leash using Cgroups.*
