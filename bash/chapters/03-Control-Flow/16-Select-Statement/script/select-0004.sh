#!/usr/bin/env bash
#Script: select-0004.sh

PS3="Select your favorite fruit from the list: "
OPTIONS=("Apple" "Banana" "Cherry" "Grapes" "Pear")

select var in "${OPTIONS[@]}"; do
		case $var in
				Apple)
						echo "You picked '$var' as your favorite fruit"
						;;
				Banana)
						echo "You picked '$var' as your favorite fruit"
						;;
				Cherry)
						echo "You picked '$var' as your favorite fruit"
						;;
				Grapes)
						echo "You picked '$var' as your favorite fruit"
						;;
				Pear)
						echo "You picked '$var' as your favorite fruit"
						;;
				*)
						echo "Invalid choice. Please try again."
						;;
		esac
done

