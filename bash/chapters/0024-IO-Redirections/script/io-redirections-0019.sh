#!/usr/bin/env bash
#Script: io-redirections-0019.sh
INPUT_FILE=input_file
OUTPUT_FILE=/tmp/output.txt
MY_LINE=
until [ "$MY_LINE" = "Line_10" ]; do
    read MY_LINE
    echo "[until] LINE READ WAS '$MY_LINE'"
done <$INPUT_FILE >$OUTPUT_FILE
#   ^^^          ^^^
