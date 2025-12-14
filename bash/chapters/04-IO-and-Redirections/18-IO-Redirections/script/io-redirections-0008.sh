#!/usr/bin/env bash
#Script: io-redirections-0008.sh
# Redirection of stdout to a file
exec 1>output_file
# Echoing to standard output
for (( i = 0 ; i < 10 ; i++ )); do
		echo "Line_$i";
done
# Close the file descriptor
exec 1>&-
