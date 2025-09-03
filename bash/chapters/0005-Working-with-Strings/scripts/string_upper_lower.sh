#!/usr/bin/env bash
#Script: string_upper_lower.sh
myStringVariable="This is the message that I want to test"
# Original String
echo "Original : $myStringVariable"
# UPPERCASE STRING
echo "UPPERCASE: ${myStringVariable^^}"
# lowercase string
echo "lowercase: ${myStringVariable,,}"
