#!/bin/bash
#this will automatically archive old user accounts from the server
#accepts only 1 user account

[[ $2 ]] && { echo "you can only have 1 user account submitted at a time";exit; }

[[ -z $1 ]] && read -p "please enter a user to archive: " usr_accnt || usr_accnt=$1
[[ $usr_accnt =~ //$ ]] && { echo "Path error, too many / ";exit; } || usr_accnt=${usr_accnt%/}

echo "PLEASE BE CAREFULL!!!! there are not any checks to prevent you from archiving the wrong phone voicemail"
echo "so double check your work and prevent mistakes"
echo ""
echo "enter nothing to skip "
echo ""
read -p "include phone ext to archive voicemail: " ext
[ ! -z $ext ] && ( [[ $ext =~ [0-9]{4} ]] || { echo "Invalid Extension ";kill $$; } )

mail="/dir/mail/$usr_accnt"
people="/dir/accounts/$usr_accnt"
voicemail="/voicemail/$ext"
archive_dir="/archives/$usr_accnt"

if [ ! -z "$ext" ]
then
	echo "Do you want to archive user: $usr_accnt\n and ext: $ext"
else
	echo "Do you want to archive user: $usr_accnt"
fi
read -p "(CONTINUE)" check

ArchiveUsr() {
	#archive files
	[[ ! -d $archive_dir ]] && { mkdir -p $archive_dir; }
	echo "Archiving Mail ..."
	tar -czf $archive_dir/$usr_accnt.mail.tar.gz $mail && \
	echo "Archiving P Drive ..."
	tar -czf $archive_dir/$usr_accnt.tar.gz $people && \

	if [ ! -z $ext ]
	then
		#ssh to phone server
		echo "Archiving Voicemail ..."
		scp -pr root@111.111.111.111:$voicemail $archive_dir && \
		tar -czf $archive_dir/$ext.tar.gz $archive_dir/$ext && \
		#delete old files
		ssh root@111.111.111.111 "rm -r $voicemail"
		rm -r $archive_dir/$ext
	fi

	rm -r $mail $people
}

[ $check = "CONTINUE" ] && [[ -d $mail ]] && [[ -d $people ]] && ArchiveUsr || { echo "error in either mail or p: drive paths, archive manually"; exit; }
