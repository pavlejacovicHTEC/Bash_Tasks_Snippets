#!/bin/bash

#put git folder and ignore file as positional parameters where git_folder is first and ignore file is second
git_folder=$1
ignore=$2

#reads a ignore file into an array ignore_list
#-t flag is ?
readarray -t ignore_list < $ignore

#prints Excluding folders
echo "Excluding folders:"

#loop through ignored folders array
for i in "${ignore_list[@]}";
 do
   #prints ignore element
   echo "$i";
   # ???????????????????????????????
   #! ----> negation
   # -path flag ?????
   #*/$i -----> regex for anything/element_in_ignore_list
   exclusion="${exclusion} ! -path */$i";
 done

# if $exclusion variable is empty print "No exclusion"
# else variable exclude will be equal to above variable exclusion
[ -z "$exclusion" ] && echo "No exclusion" || exclude="$exclusion"

#finds the git folder ($git_folder) that is provided as parameter that is directory type (type -d)
#min depth and max depth are self explanatory (-mindepth 1 -maxdepth 1)
#$exclude ----- >

find $git_folder -mindepth 1 -maxdepth 1 -type d $exclude -exec bash -c 'for dir in {};do cd ${dir};git status >/dev/null 2>&1;[ $(echo $?) -eq 0 ] && echo "Updating ${dir%*/}..." && git pull;done' \;

#COMMAND#
#*************************************************************************#
#this command section executes bash command that is in single qutes ()
#Command iterates through directories ---------> for dir in {};  ({} ------> what does this mean ??????????????????)
#Changes location to directories one by one -----------> cd ${dir};
#Redirects stdout to /dev/null which discards it ----------> git status >/dev/null
#Redirects stder to stdout which then discards it because of the previous command -------------> 2>&1;
#If echo $? returns 0 then print Updating... with directory name, and then run git pull --------- > [ $(echo $?) -eq 0 ] && echo "Updating ${dir%*/}..." && git pull;
#$? is the exist status of the last executed command --------> 0 means success and non 0 means failure