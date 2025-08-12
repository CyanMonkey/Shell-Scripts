#!/bin/bash
#
#This Script is used to scan a windows file system for files & directories that are past the windows 256 character limit
#It generates 2 files, one for unfiltered filesystem output and another for the paths over the character limit


read -p "please supply a directory path: " directory_root

[ -d "$directory_root" ] && cd $directory_root || { echo "not valid path please try again"; exit; }

tempfile=$(mktemp)
tempfile2=$(mktemp)
max_depth=256
output="$HOME/path_output.txt"
problem_files="$HOME/path_problem_files.txt"

[ -f $output ] && { rm -f $output; }
[ -f $problem_files ] && { rm -f $problem_files; }


du -ch . | sed 's/ /_/g'| awk '{print $2}' >> $tempfile2
cat $tempfile2 | while read path; do echo "$path" | wc -c ; done >> $tempfile
cat $tempfile2 | paste $tempfile - > $output

sed -i 's/_/ /g' $output

while read line
do
        length=$(echo $line | awk '{print $1}')
        if [ "$length" -gt "$max_depth" ]
        then
                echo "$line" >> $problem_files
        fi
done < $output

rm -f $tempfile $tempfile2

echo "view the reports under $HOME"
