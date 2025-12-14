#!/usr/bin/env bash
#Script: io-redirections-0021.sh
INPUT_FILE=input_file
OUTPUT_FILE=/tmp/output.txt
if [ true ]; then
    while read MY_LINE; do
        echo "[if] LINE READ WAS '$MY_LINE'"
    done
fi <$INPUT_FILE >$OUTPUT_FILE
# ^^^          ^^^
