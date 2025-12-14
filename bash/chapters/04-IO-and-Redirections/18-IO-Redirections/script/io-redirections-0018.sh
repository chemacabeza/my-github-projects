#!/usr/bin/env bash
#Script: io-redirections-0018.sh
INPUT_FILE=input_file
OUTPUT_FILE=/tmp/output.txt
while read line; do
		echo "[while] LINE READ WAS '$line'"
done <$INPUT_FILE >$OUTPUT_FILE
#   ^^^          ^^^
