#!/usr/bin/env bash
#Script: io-redirections-0010.sh
# Redirection of stderr to a file
exec &>combined_file
# Echoing to standard output
for (( i = 0 ; i < 10 ; i++ )); do
		echo "Line_$i";
done
# Echoing to standard error
for dir in /fake_1 /fake_2 /fake_3; do
		ls $dir
done
# Close the Standard Output file descriptor
exec 1>&-
# Close the Standard Error file descriptor
exec 2>&-
