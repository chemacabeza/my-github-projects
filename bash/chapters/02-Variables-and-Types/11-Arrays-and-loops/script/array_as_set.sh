#!/usr/bin/env bash
#Script: array_as_set.sh
# Declaring set with 3 cities
declare -A CITIES=(
 [London]=1
 [Paris]=1
 [Madrid]=1
)
# Checking for a city inside the Set
if [[ -n "${CITIES[London]}" ]]; then
    echo "London is in the set" # This will be printed
else
    echo "London is NOT in the set"
fi
# Checking for a city that is not in the Set
if [[ -n "${CITIES[Seville]}" ]]; then
    echo "Seville is in the set"
else
    echo "Seville is NOT in the set" # This will be printed
fi
