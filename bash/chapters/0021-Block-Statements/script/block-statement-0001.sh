#!/usr/bin/env bash
#Script: block-statement-0001.sh
echo "Block reading from Standard Input"
{
    while read line; do
	echo "Line read: '$line'"
    done
}
echo "End of program"

