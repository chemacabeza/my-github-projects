# 21: Creating a Container from Scratch

You have mastered the primitives. Now, let’s stop using Docker and **build it ourselves**. 

A container is just a **Namespace** + **Cgroup** + **Layered Filesystem**.

---

## 1. The Ingredients

To build our minimal "Antigravity Container," we need:
1.  **Isolation (PID/MNT Namespaces):** To hide the host.
2.  **Imprisonment (chroot/pivot_root):** To give it a private filesystem.
3.  **Governance (Cgroups):** To limit its power.

---

## 2. Lab Setup: The Root Filesystem

We need a directory that looks like a real OS.

```bash
mkdir -p container-root/bin
# Copy the minimal shell 'busybox'
cp /bin/busybox container-root/bin/
# Create symlink for common tools
ln -s busybox container-root/bin/ls
ln -s busybox container-root/bin/ps
ln -s busybox container-root/bin/sh
```

---

## 3. Creating the Container (C / Bash approach)

We will use the `unshare` command to simulate the complex C `clone()` system call.

### The Magic Command:
```bash
sudo unshare --map-root-user --push-root \
             --mount --uts --ipc --net --pid --fork \
             /bin/sh -c "
             mount -t proc proc /proc;
             hostname antigravity-jail;
             chroot . /bin/sh
             "
```

**What just happened?**
1.  `--map-root-user`: You are root inside! But a nobody outside.
2.  `--mount --uts --ipc --net --pid`: Full isolation.
3.  `mount -t proc proc /proc`: We mount a *private* process list.
4.  `chroot . /bin/sh`: We switch the world to our `container-root` folder.

---

## 4. Final Project: The "Hardcore" C-Runner

If you want to do this like a true kernel engineer, you use the `clone()` flag `CLONE_NEWPID`.

```c
#define _GNU_SOURCE
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

static int child_fn(void* arg) {
    printf("Child PID: %d\n", getpid());
    sethostname("expert-jail", 11);
    // Add chroot here to finalize isolation
    system("sh");
    return 0;
}

int main() {
    char stack[1024 * 1024]; // 1MB Stack
    pid_t child_pid = clone(child_fn, stack + sizeof(stack), 
                            CLONE_NEWPID | CLONE_NEWNET | SIGCHLD, NULL);
    waitpid(child_pid, NULL, 0);
    return 0;
}
```

---

## 5. Summary of Phase 7

You have deconstructed one of the most complex technologies in modern computing into its raw components. You now understand that **there are no containers**, only isolated and resource-constrained processes.

*In Phase 8, we will explore the Linux Kernel's Virtual File System (VFS).*
