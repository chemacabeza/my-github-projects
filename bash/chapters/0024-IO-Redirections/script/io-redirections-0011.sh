#!/usr/bin/env bash
#Script: io-redirections-0011.sh
# FD 3 associated to reading file
exec 3<lorem.txt
((i=0))
# Read from file descriptor 3
while read -u 3 line; do
    printf "LINE_CONTENT[$i]: $line\n"
    # Increment counter
    ((i++))
done
# Close file descriptor
exec 3<&-
