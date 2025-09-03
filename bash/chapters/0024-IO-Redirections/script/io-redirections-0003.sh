#!/usr/bin/env bash
#Script: io-redirections-0003.sh
# Define log files
OUTPUT_FILE="/tmp/output_log.txt"
ERROR_FILE="/tmp/error_log.txt"
echo "Beginning of Output file" > $OUTPUT_FILE
echo "Beginning of Error file" > $ERROR_FILE
# Attempt to list multiple directories
for dir in /home /non_existent_dir /tmp /fake_dir; do
    ls "$dir" 1>> "$OUTPUT_FILE" 2>> "$ERROR_FILE"
done
# Display the contents of the Output file
echo "Contents of $OUTPUT_FILE (Standard Output):"
cat "$OUTPUT_FILE"
# Display the contents of the Error file
echo -e "\nContents of $ERROR_FILE (Standard Error):"
cat "$ERROR_FILE"
