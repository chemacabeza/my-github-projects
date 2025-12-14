#!/usr/bin/env bash
#Script: aliases-0002.sh
# Enable alias expansion
shopt -s expand_aliases
# Source the aliases
source ~/.bash_aliases
echo -e "Calling new alias\n"
llc
echo -e "\nDone calling new alias"
