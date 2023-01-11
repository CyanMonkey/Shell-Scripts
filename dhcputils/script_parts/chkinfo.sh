#!/bin/bash
set -xv

ChkInfo() {
	while :
	do
		clear
		echo -e \
			"0)\t\tUser's Name: ${lease_info[0]}\n\n" \
			"1)\t\tComputer's Name: ${lease_info[1]}\n\n" \
			"2)\t\tUser's Department: ${lease_info[2]}\n\n" \
			"3)\t\tMac Address: ${lease_info[3]}\n\n" \
			"4)\t\tPhone Ext: ${lease_info[4]}\n\n" \
			"5)\t\tForm Factor: ${lease_info[5]}\n\n" \
			"6)\t\tLocation: ${lease_info[6]}\n\n" \
			"7)\t\tNotes: ${lease_info[7]}\n\n" \
			"Is everything correct? [y/n] "

		read -n 1 option

		case "$option" in
			[yY])
				clear
				#ChkDuplicate
				break
				;;
			[nN])
				clear
				read -p "please select a number to update: " i
				clear
				[[ $i =~ [0-7] ]] && { read -p "Enter a new value to replace \"${lease_info[$i]}\": " update; } || continue
				lease_info[$i]=$update
				;;

			*)
				clear
				echo "Please Type Y or N"
				echo -en "\n\n\t\t\tHit any key to continue"
				read -n 1 option ;;
		esac
	done
}
