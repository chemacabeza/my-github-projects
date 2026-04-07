<div align="center">
  <img src="./images/linux_ch58_regex.png" alt="Linux Regex Cover" width="800"/>
</div>

# 58: Regular Expressions

> 🧠 **The Feynman Hook:** Searching a 10 GB log file for a specific word like "Error" is easy. But what if you need to extract every single valid Phone Number? Or every uniquely formatted IPv4 address? You cannot search for a static word. You must search for a "shape." Regular Expressions (Regex) are an incredibly dense, mathematical Sieve. You define the precise shape of the data (e.g., three digits, a dash, four digits), pour the 10 GB file through the sieve, and only the mathematically matching shapes organically pass through.

**🎯 The Big Goal:** Master Regex syntax anchors, character classes, and quantifiers to effortlessly extract complex data structures from raw text streams.

---

## 1. The Anchors (Defining the Edges)

The most rudimentary regex defines exactly where a pattern must physically occur on a line.

- `^` : The Caret anchors the pattern to the absolute **START** of the line.
- `$` : The Dollar Sign anchors the pattern to the absolute **END** of the line.

```bash
# Find lines that begin exactly with the word "Root"
grep "^Root" /var/log/syslog

# Find lines that end exactly with the word "Denied"
grep "Denied$" /var/log/auth.log

# Find lines that are completely, totally empty (Start of line immediately followed by End of line)
grep "^$" file.txt
```

---

## 2. Character Classes (Defining the Shape)

Instead of searching for a literal `A`, you search for a category of characters.

- `.`  : The Period matches exactly **ONE of ANY character** (except a newline).
- `\d` : Matches exactly one **NUMBER** (0-9).
- `\w` : Matches exactly one **WORD CHARACTER** (a-z, A-Z, 0-9, and underscore).
- `[ ]`: Defines a custom list of allowed characters.

```bash
# Match exactly "b", followed by ANY one vowel, followed by "t" (Matches: bat, bet, bit, bot, but)
grep "b[aeiou]t" document.txt

# Match any three-digit number sequence
grep "[0-9][0-9][0-9]" data.log
```

---

## 3. Quantifiers (Defining the Volume)

Once you define a shape, you use Quantifiers to declare exactly how many times that shape is allowed to repeat sequentially.

- `*` : Matches the preceding character **Zero or More** times.
- `+` : Matches the preceding character **One or More** times (Must exist at least once).
- `?` : Matches the preceding character **Zero or One** time (Makes the character optional).
- `{3}` : Matches the preceding character exactly **3** times.

```bash
# The '.*' combination is the most famous in computing. It means: "Match absolutely anything, of absolutely any length."
grep "Error.*Database" server.log
```
*Translation: Find "Error", followed by an infinite stream of random garbage, followed eventually by "Database".*

---

## 🤔 Reflection Questions

<details>
<summary>💡 View Answer: Write the Regex pattern that uniquely perfectly identifies a standard United States Zip Code (5 digits, optionally followed by a dash and 4 more digits).</summary>
The pattern is: `^[0-9]{5}(-[0-9]{4})?$`. 
- `^` asserts the start.
- `[0-9]{5}` precisely demands exactly five numerical digits.
- `(-[0-9]{4})?` wraps the secondary section in parentheses and ends it with a Question Mark `?`, rendering the entire dashed 4-digit block mathematically optional.
- `$` asserts the end of the line, preventing "123456789" from illegitimately passing through the sieve.
</details>

---
[<< Previous: Git Version Control](./57_Git_Version_Control.md) | [Home: Curriculum Map](./README.md) | [Next: Linux Hardening >>](./59_Linux_Hardening.md)
