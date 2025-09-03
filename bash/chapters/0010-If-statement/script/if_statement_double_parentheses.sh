#!/usr/bin/env bash
#Script: if_statement_double_parentheses.sh
# Declaring some variables
FILE_PATH="/etc/profile"
NUMBER_1=3
NUMBER_2=4
# Combined test
if (( $NUMBER_1 < $NUMBER_2 )) && [[ $FILE_PATH != "boo" ]]; then
    echo "Condition is true"
fi
# Test less than
if (( 3 < 7 )); then
    echo "3 is less than 7"
fi
# Test less than or equal
if (( 7 <= 7 )); then
    echo "7 is less than or equal to 7"
fi
# Test equality
if (( 7 == 7 )); then
    echo "7 is equal to 7"
fi
# Test inequality
if (( a = 3, 8 != 7 && 7 < 10 )); then
    echo "8 is not equal to 7 and 7 is less than 10"
fi
# Remove a file that does not exist
rm /tmp/does_not_exist
echo "Result: $?"
(( b = 4 ))
echo "Result: $?"
