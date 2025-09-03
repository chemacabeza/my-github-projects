#!/usr/bin/env bash
#Script: evil-0004-safe.sh
# Code used with privileges
some_important_function() {
    _array=$1
    # DANGER?
    local type_signature=$(declare -p "$_array" 2>/dev/null)
    if [[ $type_signature =~ "declare -a" ]]; then
        eval echo "\"The third element is \${$_array[2]}\""
    else
        echo "WRONG INPUT TYPE. ARRAY EXPECTED."
    fi
}
a=(zero one two three four five)
some_important_function a
some_important_function 'x}"; date; #'
