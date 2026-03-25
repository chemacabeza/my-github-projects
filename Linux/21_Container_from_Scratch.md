# 21: Creating a Container from Scratch

You have mastered the primitives. You understand **Namespaces** (Isolation) and **Cgroups** (Resource Limits). 

Now, we will stop talking about theory and start **engineering**. We are going to build a "Docker-like" container runner using only raw Bash and the Linux Kernel.

---

## 1. The Container Recipe

A modern container is just a "Happy Meal" made of three specific ingredients:
1.  **Isolation (Namespaces):** Making the process think it's alone.
2.  **Imprisonment (chroot):** Giving the process its own private filesystem.
3.  **Governance (Cgroups):** Making sure it stays within its RAM/CPU budget.

---

## 2. Lab Setup: The Tiny OS

A process needs a home. We will create a root directory that contains only what is absolutely necessary: **Busybox**.

```bash
mkdir -p my-container/bin

# Copy the multi-tool 'busybox' into our project
cp /bin/busybox my-container/bin/

# Create the links for the OS to function
ln -s busybox my-container/bin/ls
ln -s busybox my-container/bin/ps
ln -s busybox my-container/bin/sh
```

---

## 3. The "God Mode" Command

We will use the `unshare` utility. This command is the terminal interface for the `clone()` and `unshare()` kernel system calls.

### Launching the Jailbird:
```bash
sudo unshare --map-root-user --push-root \
             --mount --uts --ipc --net --pid --fork \
             /bin/sh -c "
             mount -t proc proc /proc;
             hostname expert-container;
             chroot . /bin/sh
             "
```

**Breaking it down pedagogically:**
- `unshare`: "Kernel, please stop sharing these parts of the system with me."
- `--pid --fork`: "Give me a private process list."
- `chroot .`: "Make this folder my entire universe."
- `mount -t proc`: "Fill my universe with its own heartbeat (the /proc list)."

---

## 4. Why Experts Don't Use Docker (Always)

By building this, you now understand that **Docker is just a manager**. It doesn't actually "run" containers; the Linux Kernel does. 

Docker's job is simply to automate the commands you just ran. When you understand this, you stop being a "User" and start being a "System Architect."

---

## 5. Summary of Phase 7

- **Namespaces** = Perception (Virtual Reality).
- **Cgroups** = Limitation (Governor).
- **Union FS / chroot** = Location (Filesystem).

*Phase 7 complete. You now possess the keys to the most important technology in the modern cloud.*

---
[<< Previous: Control Groups (cgroups)](./20_Control_Groups_cgroups.md) | [Home: Curriculum Map](./README.md)
