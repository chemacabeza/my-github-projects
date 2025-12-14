#!/usr/bin/env bash
#Script: function-0012.sh
# Declaring a function
my_ok_function() {
    echo "This function returns zero"
    return 0 
}
# Invoking the function
my_ok_function
# Printing the result of the function
echo "Result: $?"
