#!/usr/bin/env bash
#Script: io-redirections-0020.sh
INPUT_FILE=input_file
OUTPUT_FILE=/tmp/output.txt
for i in {1..10}; do
    read MY_LINE
    echo "[for] LINE READ WAS '$MY_LINE'"
done <$INPUT_FILE >$OUTPUT_FILE
#   ^^^          ^^^
