#!/usr/bin/env bash
#Script: io-redirections-0017.sh
INPUT_FILE=input_file
OUTPUT_FILE=/tmp/output.txt
echo "Block reading from '$INPUT_FILE'"
{
    while read line; do
        echo "Line read: '$line'"
    done
} <$INPUT_FILE >$OUTPUT_FILE # <<<<<< Redirections
echo "End of program"
