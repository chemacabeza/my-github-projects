#!/usr/bin/env bash
#Script: subshells-0002.sh
GLOBAL_VAR="GLOBAL_VARIABLE"
my_test() {
    echo "Testing... Testing..."
}
main() {
    local my_var="LOCAL_VARIABLE"
    ( # Beginning of subshell
        echo "MY_VAR: $my_var"
        echo "Global: $GLOBAL_VAR"
        my_test
        subshell_var="Only for subshell"
        echo "Subshell var: $subshell_var"
    ) # Ending of subshell
    echo "main - Subshell var: $subshell_var"
}
echo "Begin"
main
echo "End"

