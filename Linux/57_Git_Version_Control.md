# 57: Git Version Control

<p align="center">
  <img src="images/linux_git_version_ctrl.png" alt="Git Version Control" width="800"/>
</p>

Git is the universal version control system for software development and infrastructure management. Every Linux sysadmin, developer, and DevOps engineer must understand branching, merging, and collaborative workflows.

---

## 1. Core Concepts

| Concept | Description |
| :--- | :--- |
| **Repository** | A directory tracked by Git (contains `.git/` folder) |
| **Commit** | A snapshot of all tracked files at a point in time |
| **Branch** | An independent line of development |
| **Remote** | A server-hosted copy of the repo (GitHub, GitLab, etc.) |
| **HEAD** | Pointer to the current commit/branch |
| **Staging Area** | "Index" where changes are prepared before committing |

### The Three Areas:
```
Working Directory  →  Staging Area (Index)  →  Repository (.git/)
    git add              git commit
```

---

## 2. Essential Commands

### Setup:
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

### Creating & Cloning:
```bash
git init                           # New repo in current directory
git clone https://github.com/user/repo.git   # Clone existing
```

### The Daily Workflow:
```bash
git status                         # What's changed?
git add file.txt                   # Stage a specific file
git add .                          # Stage all changes
git commit -m "feat: add login"    # Commit with message
git push origin main               # Push to remote
git pull origin main               # Get latest changes
```

### Viewing History:
```bash
git log                            # Full history
git log --oneline --graph          # Visual branch graph
git log -5                         # Last 5 commits
git show abc1234                   # View a specific commit
git diff                           # Changes not yet staged
git diff --staged                  # Changes staged for commit
```

---

## 3. Branching & Merging

```bash
# Create and switch to a new branch
git checkout -b feature/login
# OR (modern syntax):
git switch -c feature/login

# List branches
git branch                         # Local
git branch -r                      # Remote
git branch -a                      # All

# Merge a branch into main
git switch main
git merge feature/login

# Delete a branch (after merging)
git branch -d feature/login
```

### Merge vs Rebase:
| Approach | When to Use |
| :--- | :--- |
| `git merge` | Preserves history, creates merge commit. Safe for shared branches. |
| `git rebase` | Rewrites history for a linear timeline. Use on private feature branches. |

```bash
# Rebase: move your branch to the tip of main
git switch feature/login
git rebase main
```

---

## 4. Undoing Mistakes

```bash
# Unstage a file
git reset HEAD file.txt

# Discard changes in working directory
git checkout -- file.txt
# OR:
git restore file.txt

# Amend the last commit message
git commit --amend -m "Better message"

# Revert a commit (creates a new undo commit)
git revert abc1234

# Hard reset (DANGEROUS — erases commits)
git reset --hard HEAD~3            # Go back 3 commits
```

---

## 5. `.gitignore`

```gitignore
# .gitignore
*.log                 # All log files
node_modules/         # Dependencies
.env                  # Secrets
__pycache__/          # Python cache
*.pyc
build/                # Build artifacts
.DS_Store             # macOS metadata
```

---

## 6. Tags

```bash
git tag v1.0.0                     # Lightweight tag
git tag -a v1.0.0 -m "Release 1"  # Annotated tag
git push origin v1.0.0             # Push a specific tag
git push origin --tags             # Push all tags
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm ubuntu:latest bash
apt-get update > /dev/null 2>&1 && apt-get install -y git > /dev/null 2>&1
git config --global user.name "Lab User"
git config --global user.email "lab@example.com"
```

### Exercise 1: Create a Repository and Make Commits
> **Goal:** Initialize a repo and build history.
```bash
mkdir /root/myproject && cd /root/myproject
git init
echo "# My Project" > README.md
git add README.md
git commit -m "Initial commit"
echo "Hello World" > app.py
git add app.py
git commit -m "Add application"
git log --oneline
```
✅ **Expected:** Two commits in the log with their short hashes and messages.

### Exercise 2: Branching and Merging
> **Goal:** Create a feature branch and merge it back.
```bash
git checkout -b feature/greeting
echo "print('Hi!')" >> app.py
git add app.py
git commit -m "Add greeting feature"
git switch main
git merge feature/greeting
git log --oneline --graph
```
✅ **Expected:** The merge creates a linear history. The feature commit appears on main.

### Exercise 3: Revert a Mistake
> **Goal:** Undo a commit without losing history.
```bash
echo "BUG!" >> app.py
git add . && git commit -m "Introduce bug"
git log --oneline
git revert HEAD --no-edit
git log --oneline
cat app.py
```
✅ **Expected:** The revert creates a new commit that undoes the "bug" commit. `app.py` is clean.

---

[<< Previous: Virtualization](./56_Virtualization.md) | [Home: Curriculum Map](./README.md) | [Next: Regular Expressions >>](./58_Regular_Expressions.md)
