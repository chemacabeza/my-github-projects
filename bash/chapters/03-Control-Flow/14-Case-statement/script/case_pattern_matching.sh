#!/usr/bin/env bash
#Script: case_pattern_matching.sh
# Regular expression pattern for basic email validation
email_pattern="[A-Za-z0-9.+-]*@[A-Za-z0-9.-]*.[A-Za-z]*"
# Regular expression pattern that matches 
# strings starting with number
starts_with_number_pattern="[0-9]*"
# Regular expression pattern that matches 
# strings starting with a letter
starts_with_letter_pattern="[a-zA-Z]*"
# Regular expression pattern that matches 
# strings starting with a special character
starts_with_special_character="[^0-9a-zA-Z]*"
# Asking the user for input
read -p "Enter a random string: " STRING
# Printing the beginning of the result
echo -n "The string '$STRING' "
# Selecting the end of the result
case $STRING in
    $email_pattern)
        echo "matches the email pattern"
        ;;
    $starts_with_number_pattern)
        echo "starts with a number"
        ;;
    $starts_with_letter_pattern)
        echo "starts with a letter"
        ;;
    $starts_with_special_character)
        echo "starts with a special character"
        ;;
    *)
        echo "does not match any pattern"
        ;;
esac

