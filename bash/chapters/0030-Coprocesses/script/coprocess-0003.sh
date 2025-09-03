#!/usr/bin/env bash
#Script: coprocess-0003.sh
# Creating the coprocess
coproc MY_LS { ls -l coprocess; }
echo "Coprocess PID: $MY_LS_PID"
while read var <&"${MY_LS[0]}"; do
    echo $var
done
