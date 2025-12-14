#!/usr/bin/env bash
#Script: evil-0004.sh
eval FILES=($(ls -t))
# Loop iterating through files
for ((I=0; I < ${#FILES[@]}; I++)); do
    echo "FILE: ${FILES[I]}";
done
