#!/usr/bin/env bash
#Script: select-0002.sh

echo "Select a value from the list down here"

select var in option1 option2 option3 next getout; do
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
				next)
						echo "You selected next"
						continue
						;;
				getout)
						echo "you selected to get out of the select statement"
						break
						;;
				*)
						echo "Invalid selection"
						;;
		esac
done

echo "We got out of the select stament"
