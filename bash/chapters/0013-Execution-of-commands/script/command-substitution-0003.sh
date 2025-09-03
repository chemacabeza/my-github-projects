#!/usr/bin/env bash
#Script: command-substitution-0003.sh
echo "Saving the result of ls"
RESULT=($(ls))
echo "Number of file: ${#RESULT[@]}"
for file in ${RESULT[@]}; do
    echo "File: $file"
done
echo "End of script"

