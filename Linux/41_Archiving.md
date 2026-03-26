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

[<< Previous: Networking](./40_Networking.md) | [Home: Curriculum Map](./README.md) | [Next: Package Management >>](./42_Package_Management.md)
