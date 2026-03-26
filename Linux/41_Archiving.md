# 41: Archiving and Compression

<p align="center">
  <img src="images/linux_archiving.png" alt="Archiving" width="600"/>
</p>

Bundling and compressing files is a daily task for backups, deployments, and data transfer.

---

## 1. `tar` — Tape Archive

The universal archiving tool. `tar` bundles files; compression is added with flags.

### Creating Archives

```bash
tar -cvf archive.tar dir/                  # Create verbose tar
tar -czvf archive.tar.gz dir/              # Create + gzip compress
tar -cjvf archive.tar.bz2 dir/             # Create + bzip2 compress
tar -cJvf archive.tar.xz dir/              # Create + xz compress (best ratio)
```

### Extracting Archives

```bash
tar -xvf archive.tar                       # Extract tar
tar -xzvf archive.tar.gz                   # Extract gzip
tar -xjvf archive.tar.bz2                  # Extract bzip2
tar -xJvf archive.tar.xz                   # Extract xz
tar -xvf archive.tar.gz -C /target/dir/    # Extract to specific directory
```

### Listing Contents

```bash
tar -tvf archive.tar.gz                    # List without extracting
```

### Flag Reference

| Flag | Meaning |
| :--- | :--- |
| `-c` | **C**reate archive |
| `-x` | E**x**tract archive |
| `-t` | Lis**t** contents |
| `-v` | **V**erbose output |
| `-f` | **F**ilename (must be last flag) |
| `-z` | gzip compression |
| `-j` | bzip2 compression |
| `-J` | xz compression |

---

## 2. `gzip` / `gunzip` — GNU Zip

```bash
gzip file.txt                              # Compress → file.txt.gz (original deleted)
gzip -k file.txt                           # Keep original file
gzip -d file.txt.gz                        # Decompress (same as gunzip)
gunzip file.txt.gz                         # Decompress
gzip -9 file.txt                           # Maximum compression
gzip -l file.txt.gz                        # Show compression ratio
```

---

## 3. `bzip2` / `bunzip2` — Better Compression

Slower than gzip but better compression ratio.

```bash
bzip2 file.txt                             # Compress → file.txt.bz2
bzip2 -k file.txt                          # Keep original
bzip2 -d file.txt.bz2                      # Decompress
bunzip2 file.txt.bz2                       # Decompress
```

---

## 4. `xz` / `unxz` — Best Compression

Highest compression ratio but slowest.

```bash
xz file.txt                               # Compress → file.txt.xz
xz -k file.txt                            # Keep original
xz -d file.txt.xz                         # Decompress
unxz file.txt.xz                          # Decompress
xz -9 --threads=4 file.txt                # Max compression, multi-threaded
```

---

## 5. `zip` / `unzip` — Cross-Platform

The standard for sharing with Windows users.

```bash
zip archive.zip file1.txt file2.txt        # Create zip
zip -r archive.zip directory/              # Recursive (include directories)
zip -e secure.zip secret.txt               # Encrypt with password
unzip archive.zip                          # Extract
unzip archive.zip -d /target/              # Extract to directory
unzip -l archive.zip                       # List contents
```

---

## 6. `zcat` / `zless` / `zgrep` — Compressed File Utilities

Read compressed files without extracting!

```bash
zcat file.txt.gz                           # Print compressed file
zless file.txt.gz                          # Page through compressed file
zgrep "error" /var/log/syslog.2.gz         # Search in compressed logs
```

---

## 7. `rsync` — Remote Sync

The gold standard for efficient file copying and backups.

```bash
rsync -av source/ dest/                    # Archive mode, verbose
rsync -avz source/ user@remote:/dest/      # Sync to remote over SSH with compression
rsync -av --delete source/ dest/           # Mirror (delete extra files in dest)
rsync -av --exclude='*.log' src/ dst/      # Exclude patterns
rsync -avP large_file remote:/dest/        # Progress bar + partial (resume)
rsync --dry-run -av src/ dst/              # Preview what would change
```

| Flag | Meaning |
| :--- | :--- |
| `-a` | Archive mode (preserves permissions, timestamps, symlinks) |
| `-v` | Verbose |
| `-z` | Compress during transfer |
| `--delete` | Delete extraneous files in destination |
| `-P` | Progress + partial (resume transfers) |
| `--dry-run` | Preview only, no changes |

---

## 8. Compression Comparison

| Tool | Extension | Speed | Ratio | Best For |
| :--- | :--- | :--- | :--- | :--- |
| `gzip` | `.gz` | ⚡ Fast | Good | General use, logs |
| `bzip2` | `.bz2` | 🐢 Slow | Better | Text-heavy data |
| `xz` | `.xz` | 🐌 Slowest | Best | Distribution packages |
| `zip` | `.zip` | ⚡ Fast | Good | Cross-platform sharing |

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox

```bash
docker run -it --rm ubuntu:latest bash
```

Create the practice environment:

```bash
apt-get update > /dev/null 2>&1
apt-get install -y bzip2 xz-utils zip > /dev/null 2>&1
mkdir -p /root/lab41/project/{src,docs,logs} && cd /root/lab41

# Create sample files
echo "def main(): print('hello')" > project/src/app.py
echo "import utils" > project/src/utils.py
echo "# Project Documentation" > project/docs/README.md
for i in $(seq 1 50); do echo "Log entry $i: status=OK" >> project/logs/app.log; done
echo "Large text content repeated" > project/docs/guide.txt
for i in $(seq 1 100); do cat project/docs/guide.txt >> project/docs/guide.txt 2>/dev/null; done
```

---

### Exercise 1: Create a tar Archive
> **Goal:** Bundle a directory into a `.tar` file.

```bash
tar -cvf project.tar project/
ls -lh project.tar
```
✅ **Expected:** A `project.tar` file is created. The `-v` flag shows each file being added.

---

### Exercise 2: Create a Compressed Archive
> **Goal:** Compare gzip, bzip2, and xz compression.

```bash
tar -czvf project.tar.gz project/
tar -cjvf project.tar.bz2 project/
tar -cJvf project.tar.xz project/
ls -lh project.tar project.tar.gz project.tar.bz2 project.tar.xz
```
✅ **Expected:** `.tar.xz` is smallest, `.tar.gz` is fastest. Compare the file sizes!

---

### Exercise 3: List Archive Contents Without Extracting
> **Goal:** Peek inside an archive.

```bash
tar -tvf project.tar.gz
```
✅ **Expected:** A listing of all files with permissions, sizes, and paths.

---

### Exercise 4: Extract to a Specific Directory
> **Goal:** Extract an archive into a chosen location.

```bash
mkdir /tmp/extracted
tar -xzvf project.tar.gz -C /tmp/extracted/
ls /tmp/extracted/project/src/
```
✅ **Expected:** The files appear in `/tmp/extracted/project/`.

---

### Exercise 5: Compress a Single File with gzip
> **Goal:** Compress and decompress a single file.

```bash
cp project/logs/app.log test.log
gzip -k test.log                 # Keep original
ls -lh test.log test.log.gz      # Compare sizes
gunzip test.log.gz               # Decompress
```
✅ **Expected:** The `.gz` file is significantly smaller than the original.

---

### Exercise 6: Create a Password-Protected Zip
> **Goal:** Create a zip file for cross-platform sharing.

```bash
zip -r project.zip project/
ls -lh project.zip
unzip -l project.zip             # List contents
```
✅ **Expected:** A `.zip` archive with all project files listed.

---

### Exercise 7: View Compressed Files Without Extracting
> **Goal:** Read compressed content directly.

```bash
gzip -k project/logs/app.log
zcat project/logs/app.log.gz | head -5
zgrep "entry 25" project/logs/app.log.gz
```
✅ **Expected:** `zcat` shows the first 5 lines; `zgrep` finds the matching entry.

---

### Exercise 8: Efficient Copy with rsync
> **Goal:** Copy files with progress and efficiency.

```bash
apt-get install -y rsync > /dev/null 2>&1
rsync -av project/ /tmp/backup/
# Make a change, then sync again:
echo "new code" >> project/src/app.py
rsync -av project/ /tmp/backup/
```
✅ **Expected:** The second `rsync` only transfers the changed file, not everything.

---

[<< Previous: Networking](./40_Networking.md) | [Home: Curriculum Map](./README.md) | [Next: Package Management >>](./42_Package_Management.md)
