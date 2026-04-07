<div align="center">
  <img src="./images/linux_ch68_acls.png" alt="Linux ACLs Cover" width="800"/>
</div>

# 68: ACLs & Extended Attributes

> 🧠 **The Feynman Hook:** Standard Linux file permissions (`rwxr-xr-x`) act like a very basic wooden door. You only have three keys: The Owner, The Group, and Everyone Else. But what if you need exactly Alice and strictly Bob to read a file, but absolutely no one else? The 3-key system fails. Access Control Lists (ACLs) replace the wooden door with a complex biometric laser grid. You can program the laser grid to mathematically identify and explicitly grant exactly 14 different unique individuals varying levels of access to a single file simultaneously.

**🎯 The Big Goal:** Surpass standard User/Group/Other restrictions by deploying granular `setfacl` permissions and rendering files mathematically immutable using `chattr`.

---

## 1. Reading the Biometric Grid (`getfacl`)

If a file has a glowing laser grid attached to it, running a standard `ls -l` will show a subtle `+` sign at the end of the permissions string (e.g., `-rw-r--r--+`).

To actually read exactly who is on the secret list, you interrogate the ACL directly:
```bash
getfacl secret_report.pdf
```

---

## 2. Programming the Grid (`setfacl`)

You use `setfacl` to physically inject a specific user's biometrics into the grid without altering the core Owner or Group of the file.

```bash
# Grant the user 'alice' explicit Read and Write access securely
setfacl -m u:alice:rw secret_report.pdf

# Grant the user 'bob' explicit Read-Only access securely
setfacl -m u:bob:r secret_report.pdf

# Violently revoke Bob's access entirely
setfacl -x u:bob secret_report.pdf
```

### The Default ACL (Automating the Future)
If you apply a "Default ACL" to a directory, any brand new file created entirely natively inside that directory will automatically logically inherit the strict laser grid permissions.
```bash
setfacl -d -m u:alice:rwx /shared_documents/
```

---

## 3. Extended Attributes (Immutable Files)

Beyond granular user permissions, Linux filescales have deep Extended Attributes. The most powerful attribute is the Immutable Flag (`+i`). 

If you make a file Immutable, you essentially enclose the file in solid titanium. Even the absolute omnipotent `root` user cannot delete it, edit it, or rename it.

```bash
# Lock the file unconditionally physically.
sudo chattr +i /etc/resolv.conf

# Attempting to delete it as root violently fails:
sudo rm /etc/resolv.conf
# Output: rm: cannot remove '/etc/resolv.conf': Operation not permitted

# You must unlock the titanium shell before editing is structurally possible
sudo chattr -i /etc/resolv.conf
```

It is highly recommended to render critical static configuration files immutable to prevent rogue automated bash scripts from accidentally corrupting your network configurations natively.

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe the security advantage of using the Immutable flag '+i' on a web server's core 'index.php' file.</summary>
If a hacker exploits a flaw in your Web Server process (like Nginx), they inherit the standard permissions of the `www-data` user. Typically, a hacker's first move is to forcefully inject malicious redirect code directly into the main `index.php` file physically. If that file possesses the Immutable flag `+i`, the underlying Ext4 filesystem driver categorically rejects the Write system call at the deepest Kernel level natively. Even if the hacker compromises the server application perfectly, they are mathematically blocked from physically modifying the file structurally until they successfully escalate privileges to `root` and execute `chattr -i`.
</details>

---
[<< Previous: inotify File Monitoring](./67_inotify_File_Monitoring.md) | [Home: Curriculum Map](./README.md) | [Next: IO Multiplexing epoll >>](./69_IO_Multiplexing_epoll.md)
