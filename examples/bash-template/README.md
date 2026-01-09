# Bash Script Templates

Production-ready Bash script templates demonstrating best practices from the [Bash In Depth](../../bash/) guide.

## Files

### 📝 script-template.sh
Complete production-ready script template with:
- ✅ Strict error handling (`set -euo pipefail`)
- ✅ Argument parsing with options and flags
- ✅ Logging utilities (info, warn, error, debug)
- ✅ Help documentation
- ✅ Cleanup on exit
- ✅ Dry-run mode
- ✅ Verbose mode

**Usage:**
```bash
./script-template.sh --help
./script-template.sh --verbose input.txt
./script-template.sh --dry-run --output result.txt input.txt
```

## Quick Start

1. Copy the template:
```bash
cp script-template.sh your-script.sh
```

2. Modify the main logic in the `process_task()` function

3. Update the documentation in the `usage()` function

4. Run your script:
```bash
chmod +x your-script.sh
./your-script.sh --help
```

## Features Demonstrated

### Error Handling
```bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
trap cleanup EXIT  # Cleanup on exit
```

### Logging
```bash
info "Starting process..."
warn "This is a warning"
error "Fatal error occurred"  # Exits with code 1
debug "Debug info"            # Only shown with --verbose
```

### Argument Parsing
```bash
# Supports both short and long options
-h, --help
-v, --verbose
-d, --dry-run
-o, --output FILE
```

### Best Practices
- **Strict mode**: Catches errors early
- **Readonly variables**: Prevents accidental modification
- **Proper quoting**: Prevents word splitting
- **Function organization**: Clean, modular code
- **Exit traps**: Ensures cleanup
- **Logging levels**: Structured output

## Customization

### Adding New Options
```bash
# In parse_arguments() function
--your-option)
    YOUR_VAR="$2"
    shift 2
    ;;
```

### Adding New Functions
```bash
your_function() {
    local param="$1"
    info "Processing ${param}"
    # Your logic here
}
```

### Environment Variables
```bash
# Set DEBUG to enable verbose + trace mode
DEBUG=1 ./script-template.sh input.txt

# Set VERBOSE programmatically
export VERBOSE=true
./script-template.sh input.txt
```

## Related Resources

- [Bash In Depth - Chapter 24: Functions](../../bash/chapters/05-Functions-and-Execution/24-Functions/)
- [Bash In Depth - Chapter 13: If Statement](../../bash/chapters/03-Control-Flow/13-If-statement/)
- [Bash In Depth - Chapter 18: I/O Redirections](../../bash/chapters/04-IO-and-Redirections/18-IO-Redirections/)

## Common Patterns

### File Processing
```bash
while IFS= read -r line; do
    process_line "${line}"
done < "${input_file}"
```

### Array Iteration
```bash
local files=("file1.txt" "file2.txt" "file3.txt")
for file in "${files[@]}"; do
    process_file "${file}"
done
```

### Command Existence Check
```bash
if ! command -v git &> /dev/null; then
    error "git command not found"
fi
```

## Tips

1. **Always quote variables**: `"${var}"` not `$var`
2. **Use local variables**: `local var="value"`
3. **Check return codes**: `if command; then ... fi`
4. **Use arrays for lists**: Not space-separated strings
5. **Enable ShellCheck**: `shellcheck script-template.sh`

---

*These templates save hours of boilerplate and ensure consistency across your scripts!*
