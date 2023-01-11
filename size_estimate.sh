#!/bin/bash

set -xv
#this will estimate the total size taken by each folder in a directory
#and output into a nice report

[[ $2 ]] && { echo "you can only have 1 folder submitted at a time";exit; }

[[ -z $1 ]] && read -p "please enter a folder to scan: " path || path=$1
[ -d $path ] || { echo "error that is not a folder"; exit; }

for dir in $path*
do
	total="$(du -ch $dir |grep total)"
	printf "%s\t%s\n\n" "$dir: $total"
done
