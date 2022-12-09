#!/bin/bash

#load arguments into variables
while getopts d:i: flag
do
    case "${flag}" in
        d) directory_location=${OPTARG};;
        i) ignore_file=${OPTARG};;
    esac
done

DIRECTORY_LOCATION="$directory_location"
IGNORE_FILE="$ignore_file"

if [[ ! -d $DIRECTORY_LOCATION ]];
then
  echo ">>>> Please provide the valid directory location (-dl <directory_location>) <<<<"
  exit 0;
fi

if [[ ! -f $IGNORE_FILE ]];
then
  echo ">>>> Please provide the valid ignore file (-i <ignore_file>)! <<<<"
  exit 0;
fi

if [[ $DIRECTORY_LOCATION == *".."* || $IGNORE_FILE == *".."* ]];
then
  echo ">>>> Please use absolute paths! <<<<"
  exit 0;
fi

#load ignored files into a variable, ignore non existant files

# Save current IFS (Internal Field Separator)
SAVEIFS=$IFS
# Change IFS to newline char
IFS=$'\n'

#put every line in an array and then check if the folder is not in that array
while read -r line; do

  # / --> linux
  # \ --> windows
  DIRECTORIES_PATH="$DIRECTORY_LOCATION$line"
  DIRECTORIES_PATH=${DIRECTORIES_PATH::-1}

  if [[ -d "$DIRECTORIES_PATH" && -d "$DIRECTORIES_PATH/.git" ]];
  then
      ignored_directories_array+=($DIRECTORIES_PATH)
  fi

done <$IGNORE_FILE

#Iterate through folders and pull changes for every folder that is not excluded in the ignore file
for dir in $DIRECTORY_LOCATION*; do

  if [[ -d $dir && ! ${ignored_directories_array[*]} =~ ${dir} ]];
  then
    echo ""

    echo "Changing directory to $dir ....."
    cd $dir

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "Pulling changes from $current_branch branch ....."
    git pull

    cd $DIRECTORY_LOCATION
  fi

done

