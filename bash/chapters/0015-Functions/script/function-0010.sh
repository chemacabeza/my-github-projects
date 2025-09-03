#!/usr/bin/env bash
#Script: function-0010.sh
my_custom_function() {
    echo "We are inside the function '$FUNCNAME'"
    echo "Array: ${FUNCNAME[@]}"
    my_custom_function_2
}
my_custom_function_2() {
    echo "Array: ${FUNCNAME[@]}"
    my_custom_function_3
}
my_custom_function_3() {
    echo "Array: ${FUNCNAME[@]}"
}
my_custom_function
echo "End"
