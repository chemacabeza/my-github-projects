#!/usr/bin/env bash
#Script: io-redirections-0022.sh
INPUT_FILE=input_file
OUTPUT_FILE=/tmp/output.txt
if false; then
    read MY_LINE
		echo "[if-then] LINE READ WAS '$MY_LINE'"
else
    while read MY_LINE; do
        echo "[else] LINE READ WAS '$MY_LINE'"
    done
fi <$INPUT_FILE >$OUTPUT_FILE
# ^^^          ^^^
