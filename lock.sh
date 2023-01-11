#!/bin/bash
#encrypts and decrypts folder with gpg keys

path="$HOME/private"
gpg_lock="$HOME/vault.gpg"
email="youremail@domain.com"

[ -n "$1" ] && opt="$1" || opt="-l"
[ $2 ] && { echo "you can only have 1 option submitted at a time";exit; }

while [ -n "$opt" ];
do
	case "$opt" in

	-u)
		#unlock
		cd /
		gpg --decrypt $gpg_lock | tar xfz - && \
		rm $gpg_lock
		exit
		;;
	-l)
		#archive and lock
		tar -czf $path.tar.gz $path && \
		gpg --encrypt --recipient $email --output $gpg_lock $path.tar.gz && \
		rm -r $path.tar.gz $path
		#backup lock file before changes
		cp -f $gpg_lock $HOME/backup
		exit
		;;
	*)
		echo "Option $1 not recognized" exit;;
	esac
done
