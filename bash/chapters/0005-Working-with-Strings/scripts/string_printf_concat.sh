#!/usr/bin/env bash
#Script: string_printf_concat.sh
# Declare First Name
firstName="John"
# Declare Last Name
lastName="Doe"
# Declare Age
age=26
# Declare summary using printf command and command substitution
summary=$(printf "\nFull name -> %s %s\nAge -> %d" $firstName $lastName $age)
# Print Summary
echo "Summary: $summary"

