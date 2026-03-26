# 43: File Management

<p align="center">
  <img src="images/linux_file_mgmt.png" alt="File Management" width="600"/>
</p>

The fundamental operations for creating, copying, moving, finding, and linking files and directories.

---

## 1. `cp` — Copy Files and Directories

```bash
cp source.txt dest.txt                     # Copy file
cp file.txt /tmp/                          # Copy to directory
cp -r src_dir/ dest_dir/                   # Recursive (copy directories)
cp -i file.txt dest.txt                    # Interactive (prompt before overwrite)
cp -p file.txt backup.txt                  # Preserve permissions and timestamps
cp -a source/ dest/                        # Archive mode (recursive + preserve all)
cp -v *.log /backup/                       # Verbose (show what's being copied)
```

---

## 2. `mv` — Move or Rename

```bash
mv old.txt new.txt                         # Rename file
mv file.txt /tmp/                          # Move to directory
mv dir1/ dir2/                             # Rename directory
mv -i src dest                             # Interactive (prompt before overwrite)
mv -v *.jpg ~/Pictures/                    # Verbose move
```

---

## 3. `rm` — Remove Files and Directories

```bash
rm file.txt                                # Remove file
rm -i file.txt                             # Interactive (confirm each file)
rm -r directory/                           # Remove directory recursively
rm -rf directory/                          # Force recursive remove (DANGEROUS)
rm -v *.tmp                                # Verbose remove
```

> ⚠️ **WARNING:** `rm -rf /` will destroy your entire system. There is no trash can. Deleted files are **gone forever**.

---

## 4. `mkdir` — Create Directories

```bash
mkdir mydir                                # Create directory
mkdir -p path/to/deep/dir                  # Create parent directories as needed
mkdir -m 700 private                       # Create with specific permissions
mkdir dir1 dir2 dir3                       # Create multiple directories
```

---

## 5. `find` — Search the Filesystem

The most powerful file search tool in Linux.

```bash
find / -name "*.log"                       # Find by name (case-sensitive)
find / -iname "readme*"                    # Case-insensitive name search
find . -type f -size +100M                 # Files larger than 100MB
find . -type d -name "cache"               # Find directories only
find . -mtime -7                           # Modified in the last 7 days
find . -mmin -30                           # Modified in the last 30 minutes
find . -user alice                         # Files owned by alice
find . -perm 755                           # Files with exact permissions
find . -empty                              # Empty files and directories
```

### `find` with Actions

```bash
find . -name "*.tmp" -delete               # Delete matching files
find . -name "*.sh" -exec chmod +x {} \;   # Execute command on each match
find . -type f -name "*.log" -exec gzip {} \;  # Compress all log files
find . -name "*.py" | xargs wc -l          # Count lines in all Python files
```

---

## 6. `locate` / `updatedb` — Fast Filename Search

Uses a pre-built database (updated by `updatedb`), so it is much faster than `find`.

```bash
locate filename.txt                        # Instant search
locate -i "readme"                         # Case-insensitive
sudo updatedb                              # Rebuild the database
```

---

## 7. `ln` — Create Links

### Hard Links

```bash
ln original.txt hardlink.txt               # Create hard link
# Both names point to the same inode (same data on disk)
```

### Symbolic Links (Symlinks)

```bash
ln -s /path/to/original symlink            # Create symlink
ln -sf /new/target symlink                 # Force: overwrite existing symlink
ls -l symlink                              # Shows: symlink -> /path/to/original
```

**Key difference:** Hard links share inodes (cannot cross filesystems). Symlinks are pointers (like shortcuts, can break if the target is deleted).

---

## 8. `stat` — Detailed File Information

```bash
stat file.txt
```

Output includes:
- File size in bytes and blocks
- Inode number
- Permissions (octal and symbolic)
- Owner and group
- Access, Modify, and Change timestamps

---

## 9. Other Useful Commands

```bash
touch newfile.txt                          # Create empty file (or update timestamp)
file document.pdf                          # Detect file type
basename /path/to/file.txt                 # Extract filename → "file.txt"
dirname /path/to/file.txt                  # Extract directory → "/path/to"
realpath symlink                           # Resolve symlink to absolute path
tree /var/log                              # Visual directory tree
du -sh directory/                          # Directory size (human-readable)
```

---

## 10. Quick Reference Table

| Command | Purpose | Key Flag |
| :--- | :--- | :--- |
| `cp` | Copy files | `-r` (recursive), `-a` (archive) |
| `mv` | Move / rename | `-i` (interactive) |
| `rm` | Remove files | `-r` (recursive), `-f` (force) |
| `mkdir` | Create directories | `-p` (parents) |
| `find` | Search filesystem | `-name`, `-type`, `-exec` |
| `locate` | Fast filename search | `-i` (case-insensitive) |
| `ln` | Create links | `-s` (symbolic) |
| `stat` | File metadata | — |
| `touch` | Create / update timestamp | — |

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox

```bash
docker run -it --rm ubuntu:latest bash
```

Create the practice environment:

```bash
mkdir -p /root/lab43 && cd /root/lab43
mkdir -p project/{src,docs,tests}
echo "print('hello')" > project/src/main.py
echo "# Utilities" > project/src/utils.py
echo "# API docs" > project/docs/api.md
echo "# User guide" > project/docs/guide.md
echo "test_main()" > project/tests/test_main.py
echo "temp data" > project/cache.tmp
echo "more temp" > project/debug.log
```

---

### Exercise 1: Copy Files and Directories
> **Goal:** Practice copying files with different options.

```bash
cp project/src/main.py backup_main.py         # Copy single file
cp -r project/ project_backup/                 # Copy entire directory
ls project_backup/src/                         # Verify contents
```
✅ **Expected:** `backup_main.py` and a complete `project_backup/` directory are created.

---

### Exercise 2: Move and Rename
> **Goal:** Rename a file and move files between directories.

```bash
mv backup_main.py app.py                       # Rename
mv app.py project/src/                         # Move to directory
ls project/src/
```
✅ **Expected:** `app.py` now appears inside `project/src/`.

---

### Exercise 3: Safe Deletion
> **Goal:** Delete files interactively.

```bash
rm -i project/cache.tmp                        # Confirm before deleting
# Type 'y' to confirm
rm project/debug.log                           # Direct delete
ls project/
```
✅ **Expected:** Both temporary files are removed.

---

### Exercise 4: Create Nested Directories
> **Goal:** Use `mkdir -p` to create a deep path in one command.

```bash
mkdir -p project/deploy/staging/configs
ls -R project/deploy/
```
✅ **Expected:** The entire `deploy/staging/configs/` tree is created.

---

### Exercise 5: Find Files by Name and Type
> **Goal:** Use `find` to locate files matching patterns.

```bash
find project/ -name "*.py"                     # All Python files
find project/ -name "*.md" -type f             # All Markdown files
find project/ -type d                          # All directories
find project/ -empty                           # Empty files/dirs
```
✅ **Expected:** Each `find` returns the matching subset of the project tree.

---

### Exercise 6: Find + Execute
> **Goal:** Use `find -exec` to perform actions on matched files.

```bash
find project/ -name "*.py" -exec wc -l {} \;   # Count lines per Python file
find project/ -name "*.md" -exec cat {} \;      # Print all markdown content
```
✅ **Expected:** Line counts for each `.py` file; contents of each `.md` file.

---

### Exercise 7: Create and Inspect Symbolic Links
> **Goal:** Create a symlink and understand how it works.

```bash
ln -s project/src/main.py link_to_main.py
ls -l link_to_main.py                          # Shows the arrow: -> project/src/main.py
cat link_to_main.py                            # Reads through the symlink
rm project/src/main.py                         # Delete original
cat link_to_main.py                            # Now it's a broken link!
```
✅ **Key insight:** Deleting the target breaks the symlink. It becomes a "dangling" link.

---

### Exercise 8: Inspect File Metadata with `stat`
> **Goal:** Get detailed information about a file.

```bash
echo "hello" > /root/lab43/sample.txt
stat /root/lab43/sample.txt
```
✅ **Observe:** Inode number, permission octal, size, block count, Access/Modify/Change timestamps.

---

[<< Previous: Package Management](./42_Package_Management.md) | [Home: Curriculum Map](./README.md) | [Next: User Management >>](./44_User_Management.md)
