#!/usr/bin/env bash
#Script: io-redirections-0002.sh
# Define the file to store standard error
ERROR_FILE="/tmp/error_log.txt"
echo "Beginning of Error Log file" > $ERROR_FILE
echo "Demonstrating Standard Error Redirection"
echo "---------------------------------------"
# Intentionally cause an error by trying to list a nonexistent directory
echo "Attempting to list a nonexistent directory..."
ls /nonexistent_directory 2>> "$ERROR_FILE"
# Check the content of the error log
echo "Content of $ERROR_FILE:"
cat "$ERROR_FILE"
