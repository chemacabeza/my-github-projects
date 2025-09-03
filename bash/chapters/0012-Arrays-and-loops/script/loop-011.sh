#!/usr/bin/env bash
#Script: loop-011.sh
# Declaring a couple of arrays
MY_ARRAY1=( 1 2 3 4 5 6 7 8 9 10 )
MY_ARRAY2=( a b c d e f g h i j )
# For-loops iterating through the arrays
for item1 in ${MY_ARRAY1[@]}; do # loop-1
    echo "Item1: $item1"
    for item2 in ${MY_ARRAY2[@]}; do # loop-2
        echo "Item2: $item2"
        # Continue to next iteration of the outer loop
				# when item1 is 5 and item2 is d
        if [ $item2 = "d" ] && [ $item1 -eq 5 ]; then
            echo "Jumping on 'd' and '5'"
            continue 2 # go to next iteration of loop-1
        fi
        echo "End Item2"
    done
    echo "End Item1"
done
