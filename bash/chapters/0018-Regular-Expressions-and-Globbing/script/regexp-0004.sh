#!/usr/bin/env bash
#Script: regexp-0004.sh
date="2024-10-17"
if [[ $date =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]; then
    echo "Full match: ${BASH_REMATCH[0]}"  # Full date
    echo "Year: ${BASH_REMATCH[1]}"    # 2024
    echo "Month: ${BASH_REMATCH[2]}"   # 10
    echo "Day: ${BASH_REMATCH[3]}"     # 17
fi
