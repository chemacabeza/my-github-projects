#!/usr/bin/env bash
#Script: case_wildcard_matching.sh
# Asking the user to enter the name of a file
echo -n "Enter the name of a file: "
read FILENAME
# Printing the result
echo -n "The file $FILENAME is a "
# Selecting the right type
case $FILENAME in
    *.txt)
	echo -n "Text file"
	;;
    *.jpg | *.png)
	echo -n "Image file"
	;;
    *.mp3)
	echo -n "Audio file"
	;;
    *)
	echo -n "Unknown file"
	;;
esac
echo ""
