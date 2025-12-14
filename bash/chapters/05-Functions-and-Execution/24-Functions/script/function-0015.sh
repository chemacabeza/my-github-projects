#!/usr/bin/env bash
#Script: function-0015.sh
nthTerm=$1
if [ $nthTerm -eq 0 ]; then # F(0)
    echo 0
elif [ $nthTerm -eq 1 ]; then # F(1)
    echo 1
else # F(N-1) + F(N-2)
    n1=$(($nthTerm - 1))
    fn1=$($0 $n1) # script calling itself
    n2=$(($nthTerm - 2))
    fn2=$($0 $n2) # script calling itself
    echo $(($fn1 + $fn2))
fi
