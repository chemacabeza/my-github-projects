#!/usr/bin/env bash
#Script: io-redirections-0005.sh
# Define log file
COMBINED_FILE="/tmp/combined_log.txt"
echo "Beginning of Combined file" > $COMBINED_FILE
# Attempt to list multiple directories
for dir in /home /non_existent_dir /tmp /fake_dir; do
    ls "$dir" &>> "$COMBINED_FILE"
done
# Display the contents of the Combined file file
echo "Contents of $COMBINED_FILE (Standard Output & Standard Error):"
cat "$COMBINED_FILE"
