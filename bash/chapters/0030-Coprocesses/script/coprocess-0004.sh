#!/usr/bin/env bash
#Script: coprocess-0004.sh
# Creating the coprocess
coproc MY_LS { ls -l coprocess; }
# Copy stdout to file descriptor 5
exec 5<&${MY_LS[0]}
# Print Process ID of the coprocess
echo "Coprocess PID: $MY_LS_PID"
# Read from file descriptor 5
while read -u 5 var; do
    echo $var
done
# Close file descriptor 5
exec 5<&-
