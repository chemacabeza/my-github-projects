#!/usr/bin/env bash
# Script: function-0006.sh
my_function_1() {
    echo "Inside my_function_1"
    my_function_2
}
my_function_2() {
    echo "Inside my_function_2"
}
my_function_1
