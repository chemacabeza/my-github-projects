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

[<< Previous: Package Management](./42_Package_Management.md) | [Home: Curriculum Map](./README.md) | [Next: User Management >>](./44_User_Management.md)
