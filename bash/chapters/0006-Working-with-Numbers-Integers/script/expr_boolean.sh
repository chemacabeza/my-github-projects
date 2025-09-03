#!/usr/bin/env bash
#Script: expr_boolean.sh
NUM1=8
NUM2=3
echo -n "Result of $NUM1 > $NUM2 & $NUM2 >= 3 is "
expr  $NUM1 \> $NUM2 "&" $NUM2 \>= 3
