#!/bin/bash
	#TIP!-- Substituting file paths can be awkward as you need to
	#escape each of the forward slashes ie: sed
	#'s/\/bin/\/bash/\/bin/\/csh/' etc/passwd. Instead you can use "!" marks
	#to separate each of the paths ie: sed 's!/bin/bash!/bin/csh!'
	#etc/passwd.

	#The transform commands works on single characters within the line. The
	#characters that you supply work on a one-to-one mapping of the pattern
	#and the changes. The character at position[0] of the pattern switches
	#only the character at position[0] in the changes.	#ex)sed 'y/123/789/'
	#file.txt

	echo "this will remove leases from dhcpd.conf file"
	read -p "Please enter the Computer name you would like to delete: " lease_delete
	delete_index=$(grep -o "$lease_delete" $path_index)
	delete_conf=`grep -o "$lease_delete" $path_dhcp`
	if [ "$delete_index" == "$delete_conf" ];
	then
		read	-p "This action can't be undone.Type \"DELETE_ITEM\" to continue with the removal: " confirm
		if [ $confirm = DELETE_ITEM ];
		then
			echo "Deleted!"
		else
			echo "Please try again"
			exit 0
		fi
	else
		echo "Error: Database miss-match please use human intervention"
		exit 0
	fi
	exit 0
