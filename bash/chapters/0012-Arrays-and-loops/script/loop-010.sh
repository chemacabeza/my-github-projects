#!/usr/bin/env bash
#Script: loop-010.sh
# Declaring a couple of arrays
MY_ARRAY1=( 1 2 3 4 5 6 7 8 9 10 )
MY_ARRAY2=( a b c d e f g h i j )
# For-loop iterating through both arrays
for item1 in ${MY_ARRAY1[@]}; do # loop-1
    echo "Item1: $item1"
    for item2 in ${MY_ARRAY2[@]}; do # loop-2
        echo "Item2: $item2"
        # Jumping to the next iteration of inner loop
        if [ $item2 = "d" ] && [ $item1 -eq 5 ]; then
            echo "Jumping on 'd' and '5'"
            continue
        fi
        echo "End Item2"
    done
    echo "End Item1"
done

