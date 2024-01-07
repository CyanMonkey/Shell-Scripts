#!/bin/bash
set -xv
read -p "Please supply a path for video concatination: " path
# for day in 26
for day in 26 27 28 29 30 31
do
	name=$(echo $path/$day | awk -F '/' '{print $5"_day"$6}')
	[[ -d $path ]] || exit

	for file in $path/$day/*.mp4
		do echo file \'$file\' >> temp_ffmpeg
	done

	ffmpeg -f concat -safe 0 -i ~/Documents/sandbox/temp_ffmpeg ~/Documents/sandbox/$name.mp4
	rm ~/Documents/sandbox/temp_ffmpeg
	notify-send -u critical -t 0 "Hay look! the audio conversion for $name is finished!!!!"
done
