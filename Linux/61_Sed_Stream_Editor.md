<div align="center">
  <img src="./images/linux_ch61_sed.png" alt="Linux Sed Cover" width="800"/>
</div>

# 61: Sed Stream Editor

> 🧠 **The Feynman Hook:** If you want to change the word "apple" to "orange" in a text file, you usually open the file in a text editor, press Ctrl+F, type the word, and hit replace. This requires human hands and a graphical interface. `sed` (Stream Editor) is a high-speed, automated industrial conveyor belt. You feed a 10-Gigabyte text file onto the belt, write a mathematical substitution rule, and `sed` instantly slices and replaces the exact words in mid-air as the data streams past, without ever actually "opening" the file.

**🎯 The Big Goal:** Master text substitution architectures using `sed`, chaining regular expressions, and performing in-place file modifications flawlessly.

---

## 1. The Core Substitution Syntax

The vast majority of `sed` commands rely on the `s` (Substitute) command. It uses a rigid, mathematical syntax framed by forward slashes `/`.

```bash
# Syntax: s/FIND/REPLACE/
echo "I love apples" | sed 's/apples/oranges/'
# Output: I love oranges
```

### The Global Flag (`g`)
By default, `sed` only replaces the **very first** occurrence on a given line and then stops. If a line has three apples, the last two are ignored. You must explicitly activate the `g` (Global) flag at the end of the statement to replace every occurrence on the entire line.

```bash
echo "apples are green, apples are red" | sed 's/apples/oranges/g'
# Output: oranges are green, oranges are red
```

---

## 2. In-Place File Editing

Normally, `sed` takes data from a file, edits it on the conveyor belt, and prints it strictly to your monitor. The original file remains completely untouched and safe. 

If you want `sed` to actually overwrite the physical file on the hard drive permanently, you must pass the `-i` (In-place) flag.

```bash
# Physically overwrite the config file, replacing port 8080 with 80
sed -i 's/8080/80/g' /etc/nginx/nginx.conf
```

> **Warning:** Running `-i` is permanent hardware destruction of the previous data. Always test your `sed` command without `-i` first to verify the output on your monitor is absolutely correct.

---

## 3. Advanced Slicing (Deletion & Extraction)

`sed` is not just for replacing words. It can mathematically drop specific lines off the conveyor belt into the trash.

```bash
# Delete exactly the 5th line of the document
sed '5d' manuscript.txt

# Delete lines 10 through 20 inclusively
sed '10,20d' manuscript.txt

# Delete any line that happens to begin with a hashtag (Removing comments)
sed '/^#/d' config.ini
```

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Describe the conflict that occurs when attempting to use 'sed' to replace file paths (e.g., replacing '/var/www' with '/opt/app'), and exactly how to resolve it mathematically.</summary>
`sed` universally uses the forward slash `/` to demarcate the FIND and REPLACE blocks (`s/FIND/REPLACE/`). File paths in Linux also inherently use forward slashes (e.g., `/var/www`). If you write `s//var/www//opt/app/`, the `sed` parser instantly crashes because it cannot distinguish between the syntactical delimiters and the literal path characters. The solution is that `sed` elegantly allows you to use *any* character as the delimiter. By switching to the pipe character `|`, you perfectly isolate the data: `s|/var/www|/opt/app|g`.
</details>

---
[<< Previous: Troubleshooting](./60_Troubleshooting.md) | [Home: Curriculum Map](./README.md) | [Next: Awk Programming >>](./62_Awk_Programming.md)
