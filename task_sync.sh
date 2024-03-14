#!/bin/bash

# Greetings this script was made to sync tasks from calcure to a email client Maildir
# So that you can have your calcure task list update seemlessly between computers

# Please update the three variables below before running

email="david@computerisms.ca"
mail_tasks_dir="${XDG_DATA_HOME:-$HOME/.local/share}/mail/$email/Tasks"
calcure_task_file="${XDG_CONFIG_HOME:-$HOME/.config}/calcure/tasks.csv"
temp_mail_task=$(mktemp)
temp_calcure_task=$(mktemp)

#checks for a trailing / and deletes it
[[ "$mail_tasks_dir" =~ .*"/"$ ]] && mail_tasks_dir=${mail_tasks_dir%/}

# For the script to work properly it expects the input emails to be in
# calcure's task.csv file format. I may update it to be more accommodating in
# the future but for now it is good enough. I have setup this in conjunction to
# a email filter such that if I send myself an email from my work account and
# it has the string "TASK" in the subject line then it will automatically
# filter the mail into the tasks email folder. Furthermore I have saved the
# below format to a email template so I only need to edit the template as new
# message copy paste new tasks as I need them. The script needs to have the
# start/end tags to run properly.

#Please follow the below template in your email (without the comment of course):

#start
#0,0,0,"task1",normal
#0,0,0,"task2",normal
#end

###################################################
######### Leave everything else below #############
###################################################

[ ! -d $mail_tasks_dir ] && { echo "invalid directory path. please update the: mail_tasks_dir variable";exit 1; }
[ ! -f $calcure_task_file ] && { echo "invalid file path. please update the: calcure_task_file variable";exit 1; }

RefreshTask() {
#matches maildir's cur,new,tmp folders
for mail in $mail_tasks_dir/???/*
do

	# awk '/start/{p=1;next}/end/{p=0}p' $mail | sed '/^$/d'| sed 's/\t/--/g' | sed "s/\([[:alnum:] \-]*\)/$deadline,\"\1\",$importance/g" >> $calcure_task_file

	awk '/^start$/{p=1;next}/^end$/{p=0}p' $mail | sed '/^[[:space:]]*$/d' >> $temp_mail_task
done

cat $calcure_task_file > $temp_calcure_task
truncate -s 0 $calcure_task_file

if diff -q $temp_mail_task $temp_calcure_task
then
	echo "no changes"
	cat $temp_calcure_task > $calcure_task_file
	exit
else
	echo -e "\t===Mail_Tasks===\t\t\t\t\t\t===Local_Tasks===\n"
	sdiff -s $temp_mail_task $temp_calcure_task -o $calcure_task_file

fi

}

MergNewTasks() {
pass $email 2>&1 > /dev/null || { echo "Please unlock GPG keyring to sync";exit; }
RefreshTask
for mail in $mail_tasks_dir/???/*
do
	rm -f $mail
done

cat $calcure_task_file | awk 'BEGIN{print "start"}{print $0} END{print "end"}' | neomutt -s "TASK" $email
sleep 5
mbsync -q $email
}

MergNewTasks
