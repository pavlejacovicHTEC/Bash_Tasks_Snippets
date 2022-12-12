#!/bin/bash

#load arguments into variables
while getopts d:i:c:l: flag
do
    case "${flag}" in
        d) directory_location=${OPTARG};;
        i) ignore_file=${OPTARG};;
        c) command=${OPTARG};;
        l) level=${OPTARG};;
    esac
done

DIRECTORY_LOCATION="$directory_location"
IGNORE_FILE="$ignore_file"
COMMAND="$command"
GIT_COMMANDS="pull, branch"
COMMAND_AVAILABLE=$(echo $GIT_COMMANDS | grep $COMMAND)
DEPTH_LEVEL="$level"

if [[ ! -d $DIRECTORY_LOCATION ]];
then
  echo ">>>> Please provide the valid directory location (-d <directory_location>)! <<<<"
  exit 0;
fi

if [[ ${DIRECTORY_LOCATION: -1} != '/' ]];
then
  echo ">>>>directory_location has to end with / symbol ! <<<<"
  exit 0;
fi

if [[ ! -f $IGNORE_FILE ]];
then
  echo ">>>> Please provide the valid ignore file (-i <ignore_file>)! <<<<"
  exit 0;
fi

if [[ $COMMAND == "" ||  $COMMAND_AVAILABLE == "" ]];
then
  echo ">>>> Please use one of these commands: <<<<"
  echo "pull, branch"
  exit 0;
fi

if [[ $DIRECTORY_LOCATION == *".."* || $IGNORE_FILE == *".."* ]];
then
  echo ">>>> Please use absolute paths! <<<<"
  exit 0;
fi

if [[ $DEPTH_LEVEL == "" ]];
then
  echo ">>>> Please provide the valid depth level (-l <level>)! <<<<"
  exit 0;
fi


#Iterate through folders and pull changes for every folder that is not excluded in the ignore file
for dir in $DIRECTORY_LOCATION*;
do

  if [[ -d $dir ]];
  then
    cd "$dir"
  fi

  for (( i=0; i<$DEPTH_LEVEL; i++ ))
  do
    for dir2 in $dir/*; do

      if [[ -d $dir2 ]];
      then
        echo "dir2: $dir2"
      fi

      #if folder has whitespace in name, add escape character so linux understands it
#      if [[ $dir =~ ( |\') ]];
#      then
#        #echo "Directory has spaces: $dir"
#        dir=$(echo $dir | sed 's/ /\\ /g')
#        #echo "Changing to $dir"
#      fi
#
#      if [[ -d $dir && -d "$dir/.git" ]];
#      then
#        temp0=$(echo $dir | awk -F/ '{print $NF}')
#        temp1=$(cat $IGNORE_FILE | grep $temp0)
#
#        if [[ $temp1 == "" ]];
#        then
#          echo ""
#
#          echo "Changing directory to $dir ....."
#          cd $dir
#
#          current_branch=$(git rev-parse --abbrev-ref HEAD)
#          echo "Running the command git $COMMAND on branch $current_branch on repo $temp0"
#          git $COMMAND
#
#          cd $DIRECTORY_LOCATION
#        fi
#
#      fi
    done

  done

done

