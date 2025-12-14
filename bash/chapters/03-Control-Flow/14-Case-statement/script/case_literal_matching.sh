#!/usr/bin/env bash
#Script: literal_matching.sh
# Asking the user to enter a country name
echo -n "Enter the name of a country: "
read COUNTRY
# Printing the result
echo -n "The official language of $COUNTRY is "
# Selecting the language of the country
case $COUNTRY in
  Lithuania)
    echo -n "Lithuanian"
    ;;
  Romania | Moldova)
    echo -n "Romanian"
    ;;
  Italy | "San Marino" | Switzerland | "Vatican City")
    echo -n "Italian"
    ;;
  "Burkina Faso")
		echo -n "Bissa / Dyula / Fula"
		;;
  *)
    echo -n "unknown"
    ;;
esac
echo ""
