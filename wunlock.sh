#!/bin/zsh
#unlock bitlocker
#you will need to replace your bitlocker key  ||
#					      \/
#sudo dislocker  -r -V /dev/nvme1n1p1 -p111111-111111-111111-111111-111111-111111-111111-111111 -- /mnt/bitlocker

[ -n "$1" ] && opt="$1" || opt="-r"
[ $2 ] && { echo "you can only have 1 option submitted at a time";exit; }

while [ -n "$opt" ];
do
	case "$opt" in

	-r)
		#read_only
		sudo dislocker  -r -V /dev/nvme1n1p1 -p111111-111111-111111-111111-111111-111111-111111-111111 -- /mnt/bitlocker
		sudo mount -o loop,uid=1000,gid=998,groups=998,umask=0002,ro /mnt/bitlocker/dislocker-file ~/Documents/windows_OS
		break
		;;
	-e)
		#edit
		sudo dislocker  -V /dev/nvme1n1p1 -p111111-111111-111111-111111-111111-111111-111111-111111 -- /mnt/bitlocker
		sudo mount -o loop,uid=1000,gid=998,groups=998,umask=0002 /mnt/bitlocker/dislocker-file ~/Documents/windows_OS
		break
		;;

	-u)
		#unmount
		sudo umount /dev/loop0
		sudo umount /mnt/bitlocker
		break
		;;

	*)
		echo "Option $1 not recognized" exit;;
	esac
done
