#!/usr/bin/env bash
#Script: io-redirections-0015.sh
# Reading from Standard Input
while read -r INPUT_LINE; do
    printf "Line content: \"$INPUT_LINE\"\n"
done
