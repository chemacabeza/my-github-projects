#!/usr/bin/env bash
#Script: regexp-0002.sh
# Read input
echo -n "Enter input: "
read input
while [[ "$input" != "exit" ]]; do
    echo "Inside the loop. Input was '$input'"
    if [[ "$input" =~ ^a{1}$ ]]; then
        echo "The input was a single 'a'"
    elif [[ "$input" =~ ^a{2}$ ]]; then
        echo "The input was a double 'a'"
    elif [[ "$input" =~ ^a{3}$ ]]; then
        echo "The input was a triple 'a'"
    else
        echo "None of the previous regular expressions matched"
    fi
    echo -n "Enter input: "
    read input
done
echo "Exiting program"
