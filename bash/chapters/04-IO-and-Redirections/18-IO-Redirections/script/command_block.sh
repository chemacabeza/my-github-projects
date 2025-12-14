#!/usr/bin/env bash
#Script: command_block.sh
{
    RESULT="_"
    while read line; do
        RESULT+="${line}_"
    done
    echo $RESULT
}
