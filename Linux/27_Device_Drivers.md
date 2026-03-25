# 27: Character Device Drivers

<p align="center">
  <img src="images/container_internals.png" alt="Device Driver Architecture" width="800"/>
</p>

In Linux, **everything is a file**. Your keyboard is `/dev/input/event0`. Your hard drive is `/dev/sda`. Even random numbers come from `/dev/urandom`.

In this chapter, you will create your own device: `/dev/antigravity`. When a user reads from it, it will return a custom message. When they write to it, it will store the data in kernel memory.

---

## 1. The "Post Office Box" Analogy

Think of a device driver as a **P.O. Box**. You register a box number (major/minor number) at the post office (the kernel). Anyone who writes a letter to that box number has their mail delivered to your handler function. Anyone who reads from it gets whatever you placed inside.

---

## 2. The Anatomy of a Character Device

A character device processes data **one character at a time** (as opposed to block devices like disks, which read/write in 512-byte blocks).

Your driver must implement these "file operations":
```c
struct file_operations fops = {
    .owner   = THIS_MODULE,
    .open    = dev_open,     // Called when someone opens /dev/antigravity
    .read    = dev_read,     // Called when someone reads from it
    .write   = dev_write,    // Called when someone writes to it
    .release = dev_release,  // Called when the file is closed
};
```

---

## 3. Building `/dev/antigravity`

```c
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/cdev.h>

#define DEVICE_NAME "antigravity"
#define BUF_SIZE 256

static int major_number;
static char message[BUF_SIZE] = "Welcome to the Kernel.\n";
static int msg_size;

static int dev_open(struct inode *inode, struct file *file) {
    printk(KERN_INFO "antigravity: device opened\n");
    return 0;
}

static ssize_t dev_read(struct file *file, char __user *buf,
                        size_t len, loff_t *offset) {
    int bytes = copy_to_user(buf, message, msg_size);
    if (bytes) return -EFAULT;
    return msg_size;
}

static ssize_t dev_write(struct file *file, const char __user *buf,
                         size_t len, loff_t *offset) {
    if (len > BUF_SIZE - 1) len = BUF_SIZE - 1;
    copy_from_user(message, buf, len);
    message[len] = '\0';
    msg_size = len;
    printk(KERN_INFO "antigravity: received %zu bytes\n", len);
    return len;
}

static int dev_release(struct inode *inode, struct file *file) {
    printk(KERN_INFO "antigravity: device closed\n");
    return 0;
}

static struct file_operations fops = {
    .owner   = THIS_MODULE,
    .open    = dev_open,
    .read    = dev_read,
    .write   = dev_write,
    .release = dev_release,
};

static int __init driver_init(void) {
    major_number = register_chrdev(0, DEVICE_NAME, &fops);
    msg_size = strlen(message);
    printk(KERN_INFO "antigravity: registered with major number %d\n",
           major_number);
    return 0;
}

static void __exit driver_exit(void) {
    unregister_chrdev(major_number, DEVICE_NAME);
    printk(KERN_INFO "antigravity: unregistered\n");
}

module_init(driver_init);
module_exit(driver_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("A simple character device driver");
```

### Build, Load, and Interact:
```bash
# Compile
make -C /lib/modules/$(uname -r)/build M=$(pwd) modules

# Load
sudo insmod antigravity.ko

# Find the major number the kernel assigned
dmesg | grep antigravity
# "antigravity: registered with major number 240"

# Create the device file
sudo mknod /dev/antigravity c 240 0
sudo chmod 666 /dev/antigravity

# READ from it
cat /dev/antigravity
# → "Welcome to the Kernel."

# WRITE to it
echo "I am a kernel engineer" > /dev/antigravity

# READ the new message
cat /dev/antigravity
# → "I am a kernel engineer"

# Cleanup
sudo rmmod antigravity
sudo rm /dev/antigravity
```

> [!IMPORTANT]
> The `copy_to_user()` and `copy_from_user()` functions are essential. You **cannot** directly dereference userspace pointers in kernel mode — doing so causes a kernel panic. These functions safely copy data across the user/kernel boundary.

---

## 4. When to Write a Device Driver

- Custom hardware that has no existing Linux driver.
- Virtual devices for kernel-userspace communication.
- Security monitoring or instrumentation tools.

---

*Phase 9 Complete. You now have the skills to extend the Linux Kernel itself. In Phase 10, we fortify: SELinux, Seccomp, and Linux Capabilities.*

---
---

## 🧪 Sandbox: Device Driver Testing

Device drivers require kernel headers matching the running kernel. Use a **Virtual Machine** for full kernel module testing, or explore `/dev/` devices in the sandbox:

```bash
cd sandbox/kernel-dev-lab
docker compose up -d
docker exec -it kernel-dev-sandbox bash
```

**Safe experiments inside the container:**
```bash
# List existing character devices
ls -la /dev/ | head -20

# Read from a real device
cat /dev/urandom | head -c 16 | xxd

# See device major/minor numbers
cat /proc/devices
```

[<< Previous: Netfilter Hooks in C](./26_Netfilter_Hooks_C.md) | [Home: Curriculum Map](./README.md) | [Next: SELinux & AppArmor >>](./28_SELinux_AppArmor.md)
