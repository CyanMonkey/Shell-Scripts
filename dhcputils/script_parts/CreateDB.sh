#!/bin/bash

#static_DB
# This means that dhcputils will not edit the dhcpd.conf file on the firewall.

CreateDB(){
	BackupConfig backup
	trap 'BackupConfig restore' 0 1 2 3
	zero=0
	read -p "please supply a name for the new DB Page: " sheet_name
	read -p "please supply a subnet for the new DB Page: " sheet_subnet

	sed -i "1s/^/newsheet \"$sheet_name\"\n/" $computer_index_master
	echo -e "movetosheet \"$sheet_name\"\n#$sheet_subnet\n#blacklist:" >> $computer_index_master

	for letter in {A..Z};
	do
		read -p "Please supply a Column name for $letter: " column
		#had to assign 0 to variable to prevent it from being joined to $letter
		echo -e "label $letter$zero = \"$column\"" >> $computer_index_master
		read -p "Do you want to add another column? [Y/N]" check
		[[ $check =~ [Nn] ]] && break
	done

	echo "goto A0" >> $computer_index_master

}
