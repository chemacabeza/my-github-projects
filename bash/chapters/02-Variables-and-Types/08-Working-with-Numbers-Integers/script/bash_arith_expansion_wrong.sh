#!/usr/bin/env bash
#Script: bash_arith_expansion_wrong.sh
$((x=4,y=5,z=x*y,u=z/2)) ; # 10: command not found
echo $x $y $z $u

