#!/usr/bin/env bash
#Script: io-redirections-0001.sh
OUTPUT_FILE=/tmp/result.csv
echo "Id,FirstName,FamilyName,Age" > $OUTPUT_FILE
for i in {1..20}; do
		echo "$i,FirstName$i,FamilyName$i,$(($i+10))" >> $OUTPUT_FILE
done
echo "End of script"
