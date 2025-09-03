#!/usr/bin/env bash
#Script: regexp-0001.sh
# Read input
echo -n "Enter input: "
read input
while [[ "$input" != "exit" ]]; do
		echo "Inside the loop. Input was '$input'"
		if [[ "${#input}" > 1 ]]; then
				echo "Please introduce a single character."
		else
				if [[ "$input" =~ [a..z] ]]; then
						echo "The input is a single lowercase character"
				elif [[ "$input" =~ [A..Z] ]]; then
						echo "The input is a single UPPERCASE character"
				elif [[ "$input" =~ [0-9] ]]; then
						echo "The input is a single number"
				else
						echo "None of the previous regular expressions matched"
				fi
		fi
		echo -n "Enter input: "
		read input
done
echo "Exiting program"
