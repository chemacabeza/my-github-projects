#!/usr/bin/env bash
#Script: false-0002.sh
process_files() {
    echo "Starting file processing..."
    # Simulate a processing step
    echo "Processing file1.txt..."
    sleep 1
    # Simulate a failure condition
    false
    # Check if the last command failed
    if [ $? -ne 0 ]; then
        echo "Error: Failed to process file1.txt" >&2
        return 1
    fi
    echo "Processing file2.txt..."
    sleep 1
    echo "File processing complete."
    return 0
}
# Error-handling routine
main() {
    if ! process_files; then
        echo "An error occurred during file processing. Triggering error handler..."
        # Trigger cleanup, alert, or other recovery actions here
        echo "Error handler executed."
    else
        echo "All files processed successfully!"
    fi
}
# Execute main function
main

