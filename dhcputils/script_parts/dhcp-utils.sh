#!/bin/bash
set -xv
#TODO
#finish each of the menu functions
#add switches to controll directly from command line

#This is a script used to edit the dhcpd.conf file for reserved leases.


#FIXME
#add another path for program README.txt
#and automatically add supplied text
# Make a check for duplicates in addlease

debug() {
	echo "#############|	Entering DEBUG mode	|####################";
	cmd=""
	while [[ $cmd != "exit" ]]; do
		read -p "> " cmd
		case "$cmd" in
			vars ) ( set -o posix ; set );;
			exit ) ;;
			* ) eval $cmd;;
		esac
	done
	echo "#############|	End of DEBUG mode |####################";
}


#"${XDG_CONFIG_HOME:-$HOME/.config}/dhcputils"
config_file="/home/bubbles/Davids_wiki/programming/bash_scripts/dhcputils/config"


unknown=$(cat $config_file | grep -Evi "^(#.*|[a-z0-9_]*='[a-z0-9\.\/\-_]*')$")
if [ -n "$unknown" ]; then
	echo "Error in config file. Not allowed lines:"
	echo $unknown
	exit 1
fi
source $config_file
echo "File Loaded"

#Setting Default paths


#clear
path=( "$dhcp_config" "$computer_index_master" )
path_name=( "dhcp config" "Computer_Index_Master" )
#This checks for the needed files

for (( i=0;i<${#path[@]};++i ));
do
	if [ ! -e "${path[$i]}" ] && { echo -e "Dang, looks like you don't have file: ${path[$i]} \n\n would you like to create one [y/n]? "; }
	then
		read -n 1 option
		case "$option" in
			[yY])
				#clear
				touch ${path[$i]}
				if [ ${path[$i]} = $path_index ]
				then
					read -p "Supply the user account subnet: " usr_subnet
					echo "usr_subnet:$usr_subnet" >> ${path[$i]}
				fi
				echo "I created the file: ${path[$i]} "
				echo "Hit any key to continue"
				read -n 1 option ;;

			[nN])
				#clear
				echo "ok, Goodbye!"
				exit 0 ;;

			*)
				#clear
				echo "Oops sorry, that is not a valid choice"
				echo -en "\n\n\t\t\tHit any key to continue"
				read -n 1 option
				(( i-- )) ;;

		esac
	fi
done


AddLease() {
	echo "this will add a lease"
}

RmvLease() {
	echo "this will remove a lease"
}

Srch() {
	echo "this will search the database"
}
ReadMe() {
	echo "this will be the readme for the script"
}

BackupConfig() {
	echo "this will be the backup for the script"
}

CreateDB(){

}

MainMenu() {
	#extract a given page subnet from the sc database
	subnet=$( sed -n "/^movetosheet \"$sc_page\"/,/^goto/p" $path_index | sed -En 's/^#(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$)/\1/p' )
	subnet_cut=$( echo "$subnet"|sed 's/..$//' )

	blacklist_col=$( sed -n "/^movetosheet \"$sc_page\"/,/^goto/p" $path_index | sed -En 's/^#blacklist_col:([A-Z] ){1}/\1/p' )
	static_DB=$( sed -n "/^movetosheet \"$sc_page\"/,/^goto/p" $path_index | sed static? )
	#clear
	echo
	echo -e \
		"\tdhcp-utils menu \n" \
		"\t\t-----------------------\n\n" \
		"\t1. Add lease entry\n" \
		"\t2. Remove lease entry\n" \
		"\t3. Search\n" \
		"\t4. Read Me\n" \
		"\t5. Create new database page\n" \
		 "\t0. Exit\n\n" \

	echo -en "\t\tSelect option: "
	read -n 1 option
}

while :
do
	MainMenu
	case "$option" in

		1)
			AddLease ;;
		2)
			RmvLease ;;
		3)
			Srch ;;
		4)
			ReadMe;;
		5)
			CreateDB;;
		0)
			break ;;
		*)
			#clear
			echo "oops sorry, that is not a valid choice"
			echo -en "\n\n\t\t\tHit any key to continue"
			read -n 1 option ;;
	esac
done
