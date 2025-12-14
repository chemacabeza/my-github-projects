#!/usr/bin/env bash
#Script: select-0001.sh

echo "Select a value from the list down here"

select var in option1 option2 option3; do
		case $var in
				option1)
						echo "You selected option1"
						;;
				option2)
						echo "You selected option2"
						;;
				option3)
						echo "You selected option3"
						;;
				*)
						echo "Invalid selection"
						;;
		esac
done
