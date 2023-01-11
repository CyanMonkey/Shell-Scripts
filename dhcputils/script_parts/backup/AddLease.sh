#!/bin/bash
set -xv
subnet=192.168.121.0
path_dhcp="../dhcpd.conf"
path_index="../index.txt"

	#Decided on a naming convention. I confirmed that computer names should
	#always start with a letter and be 15 characters or less and no special
	#characters.

	#Dvce;last4 digets serial ;manufacturer;device#

	#Manufacturer: Lnvo, Dell, Msft, Aple, Tshb.	#Device:
	#D[Desktop]-01000, L[Laptop]-02000

	#L83p2Msft02001

	#This will only really be used for devices joined to the domain but i
	#figures that ill use it for other things also.
	#C[Camera]-03000,P[Phone]-04000

	#The database information is only good if you keep it accurate!

	#clear
	read -p "Please enter User's name: " user_name
	#clear
	read -p "Please enter User's Department: " dept_name
	#clear
	read -p "Please enter User's Phone Ext: " phone_ext
	#clear
	echo -e "Follow your organization's naming convention!\n\n"
	#clear
	read -p "Please enter Computer's name: " cpu_name
	#clear
	read -p "Please enter Computer Mac Address: " mac_addr
	#clear
	read -p "Please enter Computer form factor: " form_factor
	#clear
	read -p "Please enter physical location: " location
	#clear
	read -p " Additional notes about device? : " notes
	#clear

	 lease_info=( "$user_name" "$cpu_name" "$dept_name" "$mac_addr" "$phone_ext" "$form_factor" "$location" "$notes" )


	ChkInfoMenu() {
		IFS_OLD=$IFS
		IFS=$''
		echo -e \
			"\tUser's Name: ${lease_info[0]}\n\n" \
			"\tComputer's Name: ${lease_info[1]}\n\n" \
			"\tUser's Department: ${lease_info[2]}\n\n" \
			"\tMac Address: ${lease_info[3]}\n\n" \
			"\tPhone Ext: ${lease_info[4]}\n\n" \
			"\tForm Factor: ${lease_info[5]}\n\n" \
			"\tLocation: ${lease_info[6]}\n\n" \
			"\tNotes: ${lease_info[7]}\n\n" \
			"Is everything correct? [y/n] " \

		read -n 1 option
	}
	while :
	do
		ChkInfoMenu
		case "$option" in
			[yY])
				#%ChkDuplicate
				break
				;;
			[nN])
				#%clear
				for (( i=0;i<${#lease_info[@]};++i ));
				do
					read -n 1 -p "Do you want to keep[k] or edit[e] ${lease_info[$i]}? " option
					case "$option" in
						[kK])
							#clear
							;;
						[eE])
							#clear
							read -p "Please Enter a new value: " lease_update
							lease_info[$i]="$lease_update" ;;
						*)
							#clear
							echo "Oops sorry, that is not a valid choice"
							echo -en "\n\n\t\t\tHit any key to continue"
							read -n 1 option
							(( i-- ));;
					esac
				done ;;
			*)
				#clear
				echo "Oops sorry, that is not a valid choice"
				echo -en "\n\n\t\t\tHit any key to continue"
				read -n 1 option ;;
		esac
	done

	IFS=$IFS_OLD

	if [[ -z $(grep $subnet $path_dhcp) ]];
	then
		ip_addr=$subnet
	else
		IFS_OLD=$IFS
		IFS=$'.'
		ip_dirty=$(tac "$path_dhcp"|grep -o -m 1 "$subnet_cut.*")
		ip_clean=(${ip_dirty%;})
		(( ip_clean[3]++ ))
		IFS=$IFS_OLD
		ip_addr=""
		for (( i=0;i < ${#ip_clean[@]}; ++i ));
		do
			[ $i -lt 3 ] && ip_addr+="${ip_clean[$i]}." || ip_addr+="${ip_clean[$i]}"
		done
		index_template+=$ip_addr
	fi
	index_template=""
	for i in ${lease_info[@]}
	do
		[ -z "$i" ] || index_template+="$i,"
	done
	lease_template=$(echo -e "host $cpu_name {\n\thardware\tethernet\t$mac_addr;\n\tfixed-address\t\t\t$ip_addr;\n}
")
	BackupConfig backup
	echo "$lease_template">>$path_dhcp
	echo "{$index_template}">>$path_index

	echo "/etc/init.d/isc-dhcp-server restart" && echo "Successfully added Lease entry!" || BackupConfig restore
	exit 0
