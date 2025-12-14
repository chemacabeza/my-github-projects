#!/usr/bin/env bash
#Script: io-redirections-0012.sh
# Redirect FD 4. Appending it to file
exec 4>>output_file.txt
# Printing to the output file
for i in {1..5}; do
    # Print line to FD 4
    printf "Line_$i\n" >&4
done
printf "#######\n" >&4
# Close file descriptor
exec 4>&-
