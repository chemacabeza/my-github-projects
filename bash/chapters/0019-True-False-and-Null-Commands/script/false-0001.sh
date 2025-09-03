#!/usr/bin/env bash
#Script: false-0001.sh
if false; then
    echo "This line will NOT be printed"
else
    echo "This is the line that will be printed"
fi
