#!/bin/bash

#put git folder and ignore file as positional parameters where git_folder is first and ignore file is second
git_folder=$1
ignore=$2

#cd -- is same as cd and it changes wd
#dirname gives path of the provided argument
#BASH_SOURCE is an array of source file pathnames
#${BASH_SOURCE[0]} will resolve to the script name as it was called from the command line
#Redirects stdout to the /dev/null which discards it -----> $> /dev/null
#pwd ---> prints working directory
scriptpath=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#changes wd to $git_folder
cd $git_folder

#loops through everything in provided $git_folder since we changed wd
for each_folder in $(ls -d */); do
  #prints each folder and appends results to tmp.txt
  #deletes the longest match of // in each_folder variable, prints it and writes it into tmp.txt
    echo ${each_folder%%//} >> tmp.txt
done

#variable update will be created based on excluding lines of $ignore in the tmp.txt
update=$(grep -vf $ignore tmp.txt)
#removes tmp.txt temporary folder
rm tmp.txt

#iterates through update which is basically list of folders
for i in $update; do
  #changes wd to one folder at a time
    cd $i
    #if .git folder exists then
    if [ -d .git ]; then
      #print updating directory/folder and run git pull and then change the folder back to git folder
        echo "Updating $i..." && git pull && cd $git_folder
    else
      #if folder is not git change the folder to git folder
        cd $git_folder
    fi
done

#change wd back to scriptpath
cd $scriptpath