#!/usr/bin/env bash
#Script: function-0014.sh
# Declaring the Fibonacci function
fibonacci() {
    nthTerm=$1
    if [ $nthTerm -eq 0 ]; then # F(0)
        echo 0
    elif [ $nthTerm -eq 1 ]; then # F(1)
        echo 1
    else # F(N-1) + F(N-2)
        local n1=$(($nthTerm - 1))
        local fn1=$(fibonacci $n1)
        local n2=$(($nthTerm - 2))
        local fn2=$(fibonacci $n2)
        echo $(($fn1 + $fn2))
    fi
}
# Calling the Fibonacci function with the number 10
fibonacci 10
