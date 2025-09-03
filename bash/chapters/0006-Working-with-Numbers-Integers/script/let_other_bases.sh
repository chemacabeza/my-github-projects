#!/usr/bin/env bash
#Script: let_other_bases.sh
# Binary
let "bin = 2#111100111001101"
echo "binary number = $bin"    # 31181
# Base 32
let "b32 = 32#77"
echo "base-32 number = $b32"   # 231
# Base 64
# This notation only works for a limited range (2 - 64) of ASCII characters.
# 10 digits + 
# 26 lowercase characters + 
# 26 uppercase characters + 
# @ + _
let "b64 = 64#@_"
echo "base-64 number = $b64"   # 4031
