#!/usr/bin/env bash
#Script: coprocess-0001.sh
# Creating the coprocess
coproc MY_BASH { bash; }
echo "ls -l coprocess; echo \"-END-\"" >&"${MY_BASH[1]}"
is_done=false
while [[ "$is_done" != "true" ]]; do
    read var <&"${MY_BASH[0]}"
    if [[ "$var" == "-END-" ]]; then
	is_done="true"
    else
	echo $var
    fi
done
echo "DONE"
