#!/usr/bin/env bash
#Script: io-redirections-0023.sh
regex="File_([0-9a-zA-Z])"
ls test_dir | while read line; do
    if [[ $line =~ $regex ]]; then
        echo ${BASH_REMATCH[1]}
    else
        echo "Error"
    fi
done | {
    RESULT="_"
    while read line; do
        RESULT+="${line}_"
    done
    echo $RESULT
}
