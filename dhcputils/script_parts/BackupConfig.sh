#!/bin/bash
set -xv

BackupConfig() {
	tempdir=$( mktemp -d temp_dhcputils.XXX )
	index_tmp=$(mktemp "$tempdir"/index.XXX)
	dhcp_tmp=$(mktemp "$tempdir"/dhcpd.XXX)
	[ -d $tempdir ]	&& trap 'rm -fr $tempdir' 0 2 3 15
	case "$1" in

		backup)
			cat $path_index > $index_tmp
			cat $path_dhcp > $dhcp_tmp
			cp $path_ods $tempdir/ods_tmp
			;;
		restore)
			cat $index_tmp > $path_index
			cat $dhcp_tmp > $path_dhcp
			cp -f ./$tempdir/ods_tmp $path_ods
			echo "/etc/init.d/isc-dhcp-server restart" && echo "successfully restored"||echo "something is wrong please check dhcpd.conf file";exit
			;;
	esac
}
