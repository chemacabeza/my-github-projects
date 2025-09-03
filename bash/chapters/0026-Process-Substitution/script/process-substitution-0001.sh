#!/usr/bin/env bash
#Script: process-substitution-0001.sh
while read line; do
		echo "Processing: $line"
done < <(ls /tmp)
