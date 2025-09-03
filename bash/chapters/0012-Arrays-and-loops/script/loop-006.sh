#!/usr/bin/env bash
#Script: loop-006.sh
# Init a counter
i=0
# Single bracket operator
while [ $i -lt 4 ]; do
    echo "Line#$i"
    i=$(($i+1))
done
# Separation and reset counter
echo "----------"
i=0
# test operator
while test $i -lt 5; do
    echo "Line#$i"
    i=$(($i+1))
done
# Separation and reset counter
echo "----------"
i=0
# Double bracket
while [[ $i < 6 ]]; do
    echo "Line#$i"
    i=$(($i+1))
done

