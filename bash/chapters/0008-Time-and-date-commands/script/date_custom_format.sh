#!/usr/bin/env bash
#Script: date_custom_format.sh
echo -n "Date without arguments> "
date
echo -n "American Date Format  > "
date +"%m-%d-%Y"
echo -n "American Date Format 2> "
date +"%B-%d-%Y"
echo -n "Custom Format> "
date +"Year: %Y, Month: %B, Day of month:%d, Week of year:%U"
