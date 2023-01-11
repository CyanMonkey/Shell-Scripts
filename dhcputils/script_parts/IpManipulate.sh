#!/bin/bash

IpManipulate () {
if [[ -z $(grep $subnet $path_dhcp) ]];
then
	ip_addr=$subnet
else
	IFS_OLD=$IFS
	IFS='.'
	ip_dirty=$(tac "$path_dhcp"|grep -o -m 1 "$subnet_cut.*")
	ip_clean=(${ip_dirty%;})
	case "$1" in
		add) (( ip_clean[3]++ ));;
		sub) (( ip_clean[3]-- ));;
	esac
	IFS=$IFS_OLD
	ip_addr=""
	for (( i=0;i < ${#ip_clean[@]}; ++i ));
	do
		[ $i -lt 3 ] && ip_addr+="${ip_clean[$i]}." || ip_addr+="${ip_clean[$i]}"
	done
fi
}
