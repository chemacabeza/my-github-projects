#!/usr/bin/env bash
#Script: date_span.sh
# Declare a start date
startDate="March 2 2015 10:08:33"
# Declare an end date
endDate="April 1 2022 12:12:45"
# Calculate the timestamp for the start date
epochStartDate=$(date --date="$startDate" '+%s')
# Calculate the timestamp for the end date
epochEndDate=$(date --date="$endDate" '+%s')
# Calculate the number of seconds in a day
secondsInADay=$(( 24*3600 ))
# Calculate the number of days between the two dates
spanInDays=$(( (epochEndDate - epochStartDate) / secondsInADay ))
# Print the end result
echo "There are $spanInDays days between '$startDate' and '$endDate'"
