#!/usr/bin/env bash
#Script: io-redirections-0009.sh
# Redirection of stderr to a file
exec 2>error_file
# Echoing to standard error
for dir in /fake_1 /fake_2 /fake_3; do
		ls $dir
done
# Close the file descriptor
exec 2>&-
