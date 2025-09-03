#!/usr/bin/env bash
#Script: loop-009.sh
# Declaring a couple of arrays
MY_ARRAY1=( 1 2 3 4 5 6 7 8 9 10 )
MY_ARRAY2=( a b c e f g h i j k )
# For-loops iterating through both arrays
for item1 in ${MY_ARRAY1[@]}; do # loop-1
    echo "Item1: $item1"
    for item2 in ${MY_ARRAY2[@]}; do # loop-2
        echo "Item2: $item2"
				# Exiting both loops when item1 is 5 and item2 is e
        if [ $item1 -eq 5 ] && [ $item2 = 'e' ]; then
            echo "Exiting both loops on items '$item1' and '$item2'"
            break 2 # Exiting both loop-1 and loop-2
        fi
    done
    echo "Ending execution of loop-1"
done
