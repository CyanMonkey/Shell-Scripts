#!/bin/bash

set -xv

Srch() {
	index_file="../computer_master_index.sc"

	if [ ! -z "$1" ]
	then
		cell_number=($(grep -iwE "$1" $index_file | awk '{print substr($2, 2)}'))

		if [ ${#cell_number[@]} -eq 0 ]
		then
			echo "No Matches, try again"
			SrchMenu
		else
			#check for duplicate items from within the same row and delete
			cur=0
			#save original array length value as it is being operated on
			array_length=${#cell_number[@]}
			for (( i=1; i < $array_length; i++ ))
			do
				if [ ${cell_number[$cur]} = ${cell_number[$i]} ]
				then
					unset cell_number[$i]
				else
					cur=$i
				fi
			done
			echo "${cell_number[@]}"
			exit
		fi
	else
		declare -a cell_letter cell_value count

		while read i
		do
			#blacklist columns
			cell_letter=$(echo $i | awk '{print substr($2, 1, 1)}')
			for $cell_letter in $blacklist do; continue; done

			#compare Cell letter to blacklist list.
			#if on list ignore value. If not on list
			#add value to array and increment it's unique
			#count by 1.

			cell_value=($(echo $i | awk -F\" '{print $4}'))
			count=(  )
		done < $index_file
	fi



	#auto complete search item?


	#users with multiple devices under their name?

	#aphabetically sort names in department group
}

SrchMenu () {
while :
do
	echo -e "type ? for more info about search indexing\n"
	read -p "what is your search query? " search_item

	#check for spaces in search_item and replace with underscore
	[[ $search_item =~ ".* " ]] && search_item="${search_item// /_}"

	case $search_item in

		\?)
			echo -e \
				"You can search via string or regular expression.\n" \
				"Here are some recomendations:\n"
				Srch
				"\n\tHit any key to continue"
				read -n 1 option
				clear
				SrchMenu
				;;

		[Ee]xit | [Qq] )
			break ;;

		*)
			Srch $search_item;;

	esac
done
}
