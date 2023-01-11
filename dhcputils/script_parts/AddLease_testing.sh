#!/bin/bash
set -xv

path_dhcp="../dhcpd.conf"
path_index="../computer_master_index.sc"

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

	#no report, print row output space separated list of items
	for column in $( AwkTable -q -s )
	do
		read -p "Please enter the $Column value: " value
		lease_new+=( $value )
	done

	IpManipulate add

	lease_new+=( "$ip_addr" )
	lease_template=$( echo -e "host $cpu_name {\n\thardware\tethernet\t$mac_addr;\n\tfixed-address\t\t\t$ip_addr;\n}" )

	BackupConfig backup

	AwkTable ${lease_new[@]}
	echo "$lease_template">>$path_dhcp

	echo "/etc/init.d/isc-dhcp-server restart" && echo "Successfully added Lease entry!" || BackupConfig restore
	exit 0
