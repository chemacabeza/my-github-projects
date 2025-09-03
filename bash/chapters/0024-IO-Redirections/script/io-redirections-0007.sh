#!/usr/bin/env bash
#Script: io-redirections-0007.sh
# Redirect standard input to read from the file
exec 0<input_file
# Read from standard input line by line
while read -r line; do
    printf "I read '%s' from the file\n" "$line"
done
# Close the file descriptor
exec 0<&-
