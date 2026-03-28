# 51: Vim Mastery

<p align="center">
  <img src="images/linux_vim_mastery.png" alt="Vim Text Editor" width="800"/>
</p>

Vim is the default text editor on virtually every Linux system. Love it or hate it, knowing Vim is non-negotiable — it's often the only editor available on remote servers, embedded systems, and recovery shells.

---

## 1. The Modal Editing Philosophy

Vim has **three primary modes**:

| Mode | Purpose | Enter with | Exit with |
| :--- | :--- | :--- | :--- |
| **Normal** | Navigate, delete, copy, paste | `Esc` | — |
| **Insert** | Type text like a regular editor | `i`, `a`, `o` | `Esc` |
| **Visual** | Select text for operations | `v`, `V`, `Ctrl+V` | `Esc` |

> [!TIP]
> The golden rule: **When in doubt, press `Esc`** to return to Normal mode.

---

## 2. Essential Navigation (Normal Mode)

### Character/Word Movement:
| Key | Action |
| :--- | :--- |
| `h` `j` `k` `l` | Left, Down, Up, Right |
| `w` | Jump to next word |
| `b` | Jump back one word |
| `e` | Jump to end of word |
| `0` | Jump to beginning of line |
| `$` | Jump to end of line |

### Screen/File Movement:
| Key | Action |
| :--- | :--- |
| `gg` | Go to first line |
| `G` | Go to last line |
| `42G` | Go to line 42 |
| `Ctrl+d` | Scroll down half page |
| `Ctrl+u` | Scroll up half page |
| `H` / `M` / `L` | Top / Middle / Bottom of screen |

---

## 3. Editing Commands (Normal Mode)

### The Verb-Noun Grammar:
Vim commands follow a pattern: **[count] [operator] [motion]**

| Command | Meaning |
| :--- | :--- |
| `dw` | **D**elete a **w**ord |
| `d$` | Delete to end of line |
| `dd` | Delete entire line |
| `3dd` | Delete 3 lines |
| `yy` | Yank (copy) line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `ciw` | **C**hange **I**nner **W**ord (delete word + enter Insert) |
| `.` | Repeat last command |

---

## 4. Search and Replace

```vim
/pattern          " Search forward
?pattern          " Search backward
n                 " Next match
N                 " Previous match

" Replace first occurrence on current line
:s/old/new/

" Replace all occurrences on current line
:s/old/new/g

" Replace all occurrences in entire file
:%s/old/new/g

" Replace with confirmation
:%s/old/new/gc
```

---

## 5. File Operations

```vim
:w                " Save
:q                " Quit
:wq               " Save and quit
:q!               " Quit without saving (force)
:x                " Save and quit (only writes if changed)
ZZ                " Same as :x (Normal mode shortcut)

:e filename       " Open another file
:split filename   " Horizontal split
:vsplit filename  " Vertical split
Ctrl+w w          " Switch between splits
```

---

## 6. Power Features

### Macros:
```vim
qa                " Start recording to register 'a'
... do commands ...
q                 " Stop recording
@a                " Play macro 'a'
10@a              " Play it 10 times
```

### Marks:
```vim
ma                " Set mark 'a' at cursor
'a                " Jump to mark 'a'
```

### The `.vimrc` File:
```vim
" ~/.vimrc — your personal configuration
set number             " Show line numbers
set relativenumber     " Relative line numbers
set tabstop=4          " Tab = 4 spaces
set shiftwidth=4       " Indent = 4 spaces
set expandtab          " Use spaces, not tabs
set hlsearch           " Highlight search results
set incsearch          " Incremental search
syntax on              " Syntax highlighting
set autoindent         " Auto-indent new lines
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update > /dev/null 2>&1 && apt-get install -y vim > /dev/null 2>&1
```

### Exercise 1: Basic Editing
> **Goal:** Create a file, add text, save, and quit.
```bash
vim /tmp/hello.txt
# Press 'i' to enter Insert mode
# Type: "Hello from Vim!"
# Press Esc, then type :wq and press Enter
cat /tmp/hello.txt
```
✅ **Expected:** The file contains "Hello from Vim!".

### Exercise 2: Navigation and Deletion
> **Goal:** Navigate a file and delete lines.
```bash
# Create a test file
seq 1 20 > /tmp/numbers.txt
vim /tmp/numbers.txt
# In Normal mode:  gg (go to top), 3dd (delete 3 lines), G (go to bottom)
# Type :wq to save
wc -l /tmp/numbers.txt
```
✅ **Expected:** The file now has 17 lines (3 were deleted).

### Exercise 3: Search and Replace
> **Goal:** Replace text across an entire file.
```bash
echo -e "foo bar\nfoo baz\nfoo qux" > /tmp/replace.txt
vim /tmp/replace.txt
# In Normal mode type:  :%s/foo/REPLACED/g  then Enter
# Type :wq to save
cat /tmp/replace.txt
```
✅ **Expected:** Every "foo" is replaced with "REPLACED".

---

[<< Previous: System Logging](./50_System_Logging.md) | [Home: Curriculum Map](./README.md) | [Next: Storage Management >>](./52_Storage_Management.md)
