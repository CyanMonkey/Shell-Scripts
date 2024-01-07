#!/bin/bash
set -xv

# Greetings this script was made to sync tasks from calcure to a email client Maildir
# So that you can have your calcure task list update seemlessly between computers

# Please update the two path variables below before running

mail_tasks_dir="${XDG_DATA_HOME:-$HOME/.local/share}/mail/david@computerisms.ca/Tasks/cur"
calcure_task_file="${XDG_CONFIG_HOME:-$HOME/.config}/calcure/tasks.csv"

# For the script to work properly it expects the input emails to be in calcure's
# task.csv file format. I may update it to be more accommodating in the future
# but for now it is good enough. I have setup this in conjunction to a email
# filter such that if I send myself an email from my work account and it has the string "TASK" in
# the subject line then it will automatically filter the mail into the tasks
# email folder. Furthermore I have saved the below format to a email template so I
# only need to edit the template as new message copy paste new tasks as I need them.
# The script needs to have the start/end tags to run properly.

# Currently the script is limited in only being able to update changes in deadlines or
# importance if you need to change the task name or delete tasks then It is easiest
# to edit/delete the email directly and use the -r switch to regenerate the tasks.csv file.
# You can group tasks into into different emails to make it easier to manage but it isn't
# mandatory

#Please follow the below template in your email:

#start
#0,0,0,"task1",default
#0,0,0,"task2",default
#end

###################################################
######### Leave everything else below #############
###################################################

if ! command -v inotifywait &> /dev/null
then
    echo "please install inotify-tools to use this script"
    exit 1
fi


[ ! -d $mail_tasks_dir ] && { echo "invalid directory path. please update the: mail_tasks_dir variable";exit 1; }
[ ! -f $calcure_task_file ] && { echo "invalid file path. please update the: calcure_task_file variable";exit 1; }

temp=$(mktemp)
trap 'rm -fr $temp' 0 2 3 15

HelpMenu() {
echo "please use one of the following:

-r    overwrite your calcure tasks file from your email tasks directory
-d    run the task_sync.sh script as a daemon: bash task_sync.sh -d &
"
exit
}

RefreshTask() {
mv $calcure_task_file $calcure_task_file.backup
truncate -s 0 $calcure_task_file

for mail in $mail_tasks_dir/*
do
    # awk '/start/{p=1;next}/end/{p=0}p' $mail | sed '/^$/d'| sed 's/\t/--/g' | sed "s/\([[:alnum:] \-]*\)/$deadline,\"\1\",$importance/g" >> $calcure_task_file
    awk '/^start$/{p=1;next}/^end$/{p=0}p' $mail | sed '/^[[:space:]]$/d' >> $calcure_task_file
done
}

RunDaemon() {
cat $calcure_task_file > $temp
while inotifywait -q -q -e delete_self "$calcure_task_file"
do
    new_entry=$( diff -e $temp $calcure_task_file | awk -F , 'NR==2{print $0}' | tr -d '\n' )
    new_entry_number=$( diff -e $temp  $calcure_task_file | awk -F , 'NR==1{print $0}'| tr -d 'c' )
    check_calcure_task_file=$( sed -n "$new_entry_number"p $calcure_task_file | awk -F , '{print $4}' | tr -d '\n' )
    check_temp=$( sed -n "$new_entry_number"p $temp | awk -F , '{print $4}' | tr -d '\n' )

    if [ "$check_calcure_task_file" = "$check_temp" ]
    then
        task_email=$( grep -Rl "$check_calcure_task_file" $mail_tasks_dir/* )
        sed -i "/$check_calcure_task_file/c$new_entry" $task_email
    else
      RefreshTask
    fi
done
}


[ -z "$1" ] && HelpMenu
[ -z "$2" ] || { echo "You can only use one option at a time" ; HelpMenu; }

case "$1" in
    -r)
        RefreshTask;;
    -d)
        RunDaemon;;
    *)
        echo "Option $1 not recognized"
        HelpMenu;;
esac
