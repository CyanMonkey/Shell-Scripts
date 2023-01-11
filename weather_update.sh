#!/bin/bash

# This script is used for downloading hobolink's public weather
#feed and outputing the important info into a blank html page
#for a custom webpage design.

###############
#Configuration#
###############

#output html file
weather_filtered="/home/bubbles/Documents/sandbox/weatherstation/filtered.html"

##############################
#leave everything else below!#
##############################


weather_raw=$( mktemp temp.XXX )
raw_names=( "Temperature:" "RH:" "Dew Point:" "Wind Speed:" "Gust Speed:" "Wind Direction:" "Pressure:" "Rain:" "Accumulated Rain (Accumulated Daily Rainfall):" )
id_names=( "Temp" "RH" "Dew" "Wspd" "Gspd" "Wdir" "Press" "Rain" "TOT_Rain" )


html_template_start='
<!DOCTYPE html>\n
<html>\n
\t<meta content="text/html;charset=utf-8" http-equiv="Content-Type">\n
\t<meta content="utf-8" http-equiv="encoding">\n
\t<body>\n
'

html_template_end='
\t</body>\n
</html>
'

curl --silent -k "https://www.hobolink.com/p/device_key" > $weather_raw

for (( i=0;i<${#raw_names[@]};++i ));
do
  #retrieving weather info from source
  value="$( grep "${raw_names[$i]}" $weather_raw | awk -F'[<>]' '{print $11 " " $17}' )"
  [ $i -eq 5 ] && value="$( grep "${raw_names[$i]}" $weather_raw | awk -F'[<>]' '{print $9 " " $13}' )"

  #adding new html weather item
  h1_item="\t\t<h1 id=${id_names[$i]}>${raw_names[$i]} $value</h1>\n"
  html_template_start+=$h1_item
done

html_template_start+=$html_template_end

echo -e $html_template_start > $weather_filtered

#remove temp file
[ -e $weather_raw ] && trap 'rm -fr $weather_raw' 0
