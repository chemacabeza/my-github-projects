#!/usr/bin/env bash
#Script: compound_command.sh
# Post-increment
((myVar = 32))
((myVar++))
echo "myVar: $myVar"
# Shift bits
((myVar2 = 16, myVar3 = 4))
((myVar2 <<= 1, myVar3 >>=1 ))
echo "myVar2: $myVar2, myVar3: $myVar3"
