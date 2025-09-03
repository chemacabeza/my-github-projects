#!/usr/bin/env bash
#Script: date_custom_format_2.sh
# Date of today
echo -n "Today: "
date
# Date of last Friday
echo -n "Last Friday: "
date -d 'last Friday'
# Date of next month
echo -n "Next Month: "
date -d 'next month'
# Date of March 2nd, 2022 plus 1 year
echo -n "Date +1 year: "
date -d 'March 2, 2022 +1 year'
# Date of March 2nd, 2022 plus a random time
echo -n "Date + random time: "
date -d 'March 2, 2022 +1 year +2 days +16 hours +17 minutes +12 seconds'
# Date of March 2nd, 2022 minus a random time
echo -n "Date - random time: "
date -d 'March 2, 2022 -1 year -2 days -16 hours -17 minutes -12 seconds'
