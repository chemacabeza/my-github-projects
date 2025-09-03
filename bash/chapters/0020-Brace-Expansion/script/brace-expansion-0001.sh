#!/usr/bin/env zsh
#Script: brace-expansion-0001.sh
# Numeric range
echo "Numbers from 1 to 23: "
echo {1..23}
# Integer start and Character ending
echo "Characters from '6' to 'a': "
echo {6..a}
# Character start and Integer ending
echo "Characters from '0' to 'Q': "
echo {0..Q}
# Character range
echo "Characters from 'Q' to 'q': "
echo {Q..q}
