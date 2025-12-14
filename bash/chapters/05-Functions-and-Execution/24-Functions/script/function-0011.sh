#!/usr/bin/env bash
#Script: function-0011.sh
args=($@)
echo "Printing original list of arguments"
for((index=0; index <= ${#args[@]}; index++)) {
    echo "Arg[$index]: ${!index}"
}
shift 4
args=($@)
echo "Printing list after shifting"
for((index=0; index <= ${#args[@]}; index++)) {
    echo "Arg[$index]: ${!index}"
}
