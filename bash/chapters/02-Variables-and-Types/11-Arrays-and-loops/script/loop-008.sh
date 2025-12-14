#!/usr/bin/env bash
#Script: loop-008.sh
# Declaration of array
declare -a MY_ARRAY=(1 2 3 4 5 6 7 8 9 10)
# For-loop that iterates through the array
for item in ${MY_ARRAY[@]}; do
		# Condition to exit on item with value 5
    if [ $item -eq 5 ]; then
        echo "Exiting loop on item '$item'"
        break
    fi
    echo "Current item: $item"
done
