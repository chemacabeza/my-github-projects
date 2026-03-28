# 48: Help & Reference

<p align="center">
  <img src="images/linux_help_reference.png" alt="Help & Reference" width="600"/>
</p>

Linux has a built-in documentation system that is more comprehensive than most online resources. Learn to use it.

---

## 1. `man` — Manual Pages

The definitive documentation for every command, syscall, and config file.

```bash
man ls                                     # Manual for 'ls'
man 5 passwd                               # Section 5 (file formats) for passwd
man 2 open                                 # Section 2 (system calls) for open()
man -k "copy files"                        # Search manual descriptions
man -f printf                              # Show all sections for 'printf'
```

### Manual Sections

| Section | Content |
| :--- | :--- |
| 1 | User commands (`ls`, `grep`, `cat`) |
| 2 | System calls (`open`, `read`, `fork`) |
| 3 | C library functions (`printf`, `malloc`) |
| 4 | Special files (`/dev/null`, `/dev/sda`) |
| 5 | File formats (`/etc/passwd`, `/etc/fstab`) |
| 7 | Miscellaneous (protocols, conventions) |
| 8 | System administration (`mount`, `iptables`) |

### Navigation Inside `man`

| Key | Action |
| :--- | :--- |
| `Space` | Forward one page |
| `b` | Back one page |
| `/pattern` | Search forward |
| `n` | Next match |
| `q` | Quit |

---

## 2. `info` — GNU Info Pages

More detailed than `man` pages for GNU tools (like `coreutils`).

```bash
info coreutils                             # GNU core utilities documentation
info grep                                  # Detailed grep manual
info bash                                  # Comprehensive bash manual
```

---

## 3. `--help` — Quick Usage

Almost every command supports `--help` for a quick summary.

```bash
ls --help                                  # Short usage for ls
grep --help                                # Short usage for grep
tar --help                                 # Short usage for tar
docker --help                              # Docker subcommands
```

> Some commands use `-h` instead of `--help`:
> ```bash
> df -h                                    # Note: -h here means "human-readable", not "help"!
> ```

---

## 4. `whatis` — One-Line Description

```bash
whatis ls                                  # ls (1) - list directory contents
whatis passwd                              # passwd (1) - change user password
                                           # passwd (5) - the password file
whatis curl grep sed                       # Multiple commands at once
```

---

## 5. `apropos` — Search Manual by Keyword

Find commands when you don't know the name.

```bash
apropos "copy files"                       # Search for file-copying commands
apropos "network interface"                # Find networking commands
apropos "disk usage"                       # Find disk-related commands
apropos "compress"                         # Find compression tools
```

Same as `man -k`:
```bash
man -k "compress"
```

---

## 6. `type` — Command Classification

```bash
type ls                                    # ls is aliased to `ls --color=auto`
type cd                                    # cd is a shell builtin
type python3                               # python3 is /usr/bin/python3
type -a python3                            # Show ALL locations
```

---

## 7. `which` — Find Executable Path

```bash
which python3                              # /usr/bin/python3
which -a python3                           # All matching paths in $PATH
which gcc                                  # Find compiler
```

---

## 8. `whereis` — Locate Binary, Source, and Manual

```bash
whereis python3                            # Binary + man page locations
whereis -b gcc                             # Binary only
whereis -m ls                              # Man page only
```

---

## 9. `alias` — Create Shortcuts

```bash
alias ll='ls -alFh'                        # Create alias
alias gs='git status'                      # Git shortcut
alias ..='cd ..'                           # Quick parent directory
alias rm='rm -i'                           # Safety: always confirm deletions
unalias ll                                 # Remove alias
alias                                      # List all aliases
```

### Making Aliases Permanent

Add them to your shell config file:

```bash
# For Bash:
echo "alias ll='ls -alFh'" >> ~/.bashrc
source ~/.bashrc

# For Zsh:
echo "alias ll='ls -alFh'" >> ~/.zshrc
source ~/.zshrc
```

---

## 10. `history` — Command History

```bash
history                                    # Show command history
history 20                                 # Last 20 commands
!42                                        # Re-run command #42
!!                                         # Re-run last command
!grep                                      # Re-run last command starting with "grep"
history -c                                 # Clear history
```

### History Search

Press `Ctrl+R` in the terminal to search history interactively:
```
(reverse-i-search)`grep': grep -r "TODO" ./src/
```

---

## 11. Quick Reference Table

| Command | Purpose | Example |
| :--- | :--- | :--- |
| `man` | Full manual | `man ls`, `man 5 passwd` |
| `info` | GNU documentation | `info coreutils` |
| `--help` | Quick usage | `grep --help` |
| `whatis` | One-line description | `whatis curl` |
| `apropos` | Search by keyword | `apropos "compress"` |
| `type` | Classify command | `type ls` |
| `which` | Find executable | `which python3` |
| `whereis` | Find binary + man | `whereis gcc` |
| `alias` | Create shortcut | `alias ll='ls -alFh'` |
| `history` | Command history | `Ctrl+R` (search) |

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox

```bash
docker run -it --rm ubuntu:latest bash
```

Install man pages:

```bash
apt-get update > /dev/null 2>&1
apt-get install -y man-db manpages > /dev/null 2>&1
```

---

### Exercise 1: Read a Man Page
> **Goal:** Open and navigate the manual for `ls`.

```bash
man ls
```
✅ **Try these:** `Space` (next page), `/SORT` (search for "SORT"), `n` (next match), `q` (quit).

---

### Exercise 2: Access Different Manual Sections
> **Goal:** See that `passwd` has entries in multiple sections.

```bash
man 1 passwd                       # The command
man 5 passwd                       # The file format
```
✅ **Key insight:** Section 1 describes *how to use* `passwd`. Section 5 describes the *file structure* of `/etc/passwd`.

---

### Exercise 3: One-Line Descriptions with `whatis`
> **Goal:** Quickly find out what a command does.

```bash
whatis ls
whatis grep
whatis mount
whatis bash
```
✅ **Expected:** One-line summaries with the manual section in parentheses.

---

### Exercise 4: Search by Keyword with `apropos`
> **Goal:** Find commands when you don't know the name.

```bash
apropos "list directory"
apropos "copy file"
apropos "network interface"
```
✅ **Expected:** Matching man pages for each keyword. This is invaluable when you know *what* you want but not *which tool* does it.

---

### Exercise 5: Classify Commands with `type`
> **Goal:** Understand what kind of thing each command is.

```bash
type cd                            # Shell builtin
type ls                            # Often aliased
type echo                          # Shell builtin
type /usr/bin/env                  # External executable
type type                          # Shell builtin (meta!)
```
✅ **Expected:** Each command classified as builtin, alias, or file path.

---

### Exercise 6: Find Executable Paths
> **Goal:** Locate where binaries live.

```bash
which bash
which ls
which cat
whereis bash                       # Binary + man page locations
```
✅ **Expected:** Absolute paths to each binary, and `whereis` additionally shows man page locations.

---

### Exercise 7: Create and Use Aliases
> **Goal:** Build your own command shortcuts.

```bash
alias ll='ls -alFh'
alias cls='clear'
alias ..='cd ..'

ll /etc/                           # Uses your alias
alias                              # List all aliases
unalias ll                         # Remove one alias
```
✅ **Expected:** `ll` shows detailed listings; `alias` displays all active shortcuts.

---

### Exercise 8: Search Command History
> **Goal:** Navigate and reuse past commands.

```bash
# Run some commands first:
echo "Hello World"
ls /etc
date
cat /etc/hostname

# Now explore history:
history                            # Full history
history 5                          # Last 5 commands
!!                                 # Re-run the last command
!echo                              # Re-run the last command starting with "echo"
```
✅ **Expected:** History shows all commands with numbers. `!!` and `!echo` replay previous commands.

**Bonus:** Press `Ctrl+R` and type to search history interactively!

---

[<< Previous: System Control](./47_System_Control.md) | [Home: Curriculum Map](./README.md) | [Next: Boot Process & GRUB >>](./49_Boot_Process_and_GRUB.md)
