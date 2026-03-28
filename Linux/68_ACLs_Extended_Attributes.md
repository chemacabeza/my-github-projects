# 68: ACLs & Extended Attributes

<p align="center">
  <img src="images/linux_acls_xattr.png" alt="ACLs and Extended Attributes" width="800"/>
</p>

Standard Unix permissions (`rwx` for owner/group/others) are binary: you either have access or you don't. **POSIX Access Control Lists (ACLs)** add fine-grained, per-user and per-group permissions beyond the traditional model, while **Extended Attributes (xattrs)** let you attach arbitrary metadata to files.

---

## 1. Why ACLs?

### The Problem:
```
-rw-r----- 1 alice engineers report.pdf
```
Only `alice` (owner) and `engineers` (group) can access this file. But what if you need:
- `bob` (from marketing) to read it?
- The `auditors` group to read it?
- `carol` to read AND write it?

**Without ACLs:** You'd need to create a new group for every combination — impractical.
**With ACLs:** You add per-user and per-group entries directly.

---

## 2. ACL Commands

### View ACLs:
```bash
getfacl file.txt
```
Output:
```
# file: file.txt
# owner: alice
# group: engineers
user::rw-
user:bob:r--         # Bob can read
user:carol:rw-       # Carol can read and write
group::r--
group:auditors:r--   # Auditors group can read
mask::rw-
other::---
```

### Set ACLs:
```bash
# Grant read to a specific user
setfacl -m u:bob:r file.txt

# Grant read+write to a specific user
setfacl -m u:carol:rw file.txt

# Grant read to a specific group
setfacl -m g:auditors:r file.txt

# Set default ACL on a directory (inherited by new files)
setfacl -d -m u:bob:rx /shared/docs/

# Remove a specific ACL entry
setfacl -x u:bob file.txt

# Remove all ACLs
setfacl -b file.txt
```

---

## 3. The ACL Mask

The **mask** limits the maximum effective permissions for named users and groups:

```bash
# Set the mask (caps effective permissions)
setfacl -m m::r file.txt    # Even if carol has rw, effective is r only

# View effective permissions
getfacl file.txt
# user:carol:rw-    #effective:r--
```

> [!TIP]
> The mask is automatically recalculated when you add/modify ACL entries. Use `setfacl -n` to prevent this.

---

## 4. Default ACLs (Inheritance)

Directories can have **default ACLs** that are automatically applied to new files created inside:

```bash
# Set default ACLs on a shared directory
mkdir /project
setfacl -d -m u::rwx /project      # Owner: full access
setfacl -d -m g::rx /project       # Group: read+execute
setfacl -d -m u:bob:rwx /project   # Bob: full access on new files
setfacl -d -m o::--- /project      # Others: no access

# Verify
getfacl /project

# New files inherit these ACLs
touch /project/newfile.txt
getfacl /project/newfile.txt        # Bob has rwx automatically
```

---

## 5. Extended Attributes (xattr)

Extended attributes store arbitrary key-value metadata on files, in **namespaces**:

| Namespace | Purpose | Access |
| :--- | :--- | :--- |
| `user.*` | User-defined metadata | Any user (with write permission) |
| `security.*` | SELinux labels, capabilities | Root only |
| `system.*` | ACL data | Kernel-managed |
| `trusted.*` | Trusted metadata | Root only |

### Commands:
```bash
# Set an extended attribute
setfattr -n user.description -v "Q4 Sales Report" file.txt
setfattr -n user.author -v "Alice" file.txt

# Get a specific attribute
getfattr -n user.description file.txt

# List all user attributes
getfattr -d file.txt

# Remove an attribute
setfattr -x user.description file.txt
```

### Use Cases:
- **File tagging:** `user.tags="confidential,finance"`
- **Origin tracking:** `user.source="https://internal-wiki.com/report"`
- **Custom metadata:** `user.expiry_date="2025-12-31"`

---

## 6. Filesystem Requirements

Not all filesystems support ACLs and xattrs. Ensure your filesystem is mounted with the right options:

```bash
# Check current mount options
mount | grep acl

# Mount with ACL support
sudo mount -o acl /dev/sda1 /mnt

# Or add to /etc/fstab:
# /dev/sda1  /mnt  ext4  defaults,acl  0  2

# Supported filesystems: ext2/3/4, XFS, Btrfs, ZFS
# XFS and Btrfs enable ACLs by default
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update > /dev/null 2>&1 && apt-get install -y acl attr > /dev/null 2>&1
```

### Exercise 1: Set and View ACLs
> **Goal:** Grant file access to a specific user.
```bash
useradd -m testuser 2>/dev/null
echo "Confidential data" > /tmp/secret.txt
chmod 600 /tmp/secret.txt
setfacl -m u:testuser:r /tmp/secret.txt
getfacl /tmp/secret.txt
ls -l /tmp/secret.txt
```
✅ **Expected:** `getfacl` shows `testuser` with read permission. `ls -l` shows a `+` at the end of the permission string, indicating ACLs.

### Exercise 2: Default ACLs on a Directory
> **Goal:** Make new files automatically inherit permissions.
```bash
mkdir /tmp/shared
setfacl -d -m u:testuser:rw /tmp/shared
touch /tmp/shared/auto_created.txt
getfacl /tmp/shared/auto_created.txt
```
✅ **Expected:** The new file has `testuser:rw-` in its ACL — inherited from the directory default.

### Exercise 3: Extended Attributes
> **Goal:** Attach custom metadata to a file.
```bash
echo "Report contents" > /tmp/report.txt
setfattr -n user.author -v "Alice Johnson" /tmp/report.txt
setfattr -n user.department -v "Engineering" /tmp/report.txt
getfattr -d /tmp/report.txt
```
✅ **Expected:** Both `user.author` and `user.department` are listed with their values.

---

[<< Previous: inotify & File Monitoring](./67_inotify_File_Monitoring.md) | [Home: Curriculum Map](./README.md)
