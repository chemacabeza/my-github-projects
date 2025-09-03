#!/usr/bin/env bash
#Script: declare_readonly.sh

readonly myReadOnlyVariable="Constant Value"
echo "Value of first constant is: $myReadOnlyVariable"

myReadOnlyVariable="Another constant value"  # this will fail

declare -r myOtherReadOnlyVariable="Other Constant Value"
echo "Value of second constant is: $myOtherReadOnlyVariable"

myOtherReadOnlyVariable="Another Constant Value" # this will fail as well

