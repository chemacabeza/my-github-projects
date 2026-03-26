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

[<< Previous: System Control](./47_System_Control.md) | [Home: Curriculum Map](./README.md)
