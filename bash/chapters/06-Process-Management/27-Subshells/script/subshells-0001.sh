#!/usr/bin/env bash
#Script: subshells-0001.sh
echo -e "$BASHPID - Before subshell..."
( # <= Beginning of the subshell
    echo ""
    echo "Starting subshell..."
    for i in {1..10}; do
        echo -e "$BASHPID - $i";
    done
    echo "Ending subshell..."
    echo ""
)  # <= Ending of the subshell
echo -e "$BASHPID - After subshell..."
