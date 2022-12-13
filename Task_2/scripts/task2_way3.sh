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

# loop & print a folder recusively,
function1() {
    for i in "$1"/*;do
        number_of_slashes_subpath=$(echo $i | awk -F"/" '{print NF-1}')
        dash_numbers=$(($2+$3))

        if [[ -d "$i" && $number_of_slashes_subpath -le $dash_numbers ]];
        then
            if [[ -d "$i/.git" ]];
            then
              target_folders_array+=($i)
            fi
            function1 $i $2 $3
        fi

    done
}

number_of_slashes_path=$(echo $DIRECTORY_LOCATION | awk -F"/" '{print NF-1}')
DIRECTORY_LOCATION=${DIRECTORY_LOCATION::-1}

function1 $DIRECTORY_LOCATION $DEPTH_LEVEL $number_of_slashes_path

for element in "${target_folders_array[@]}"
do
  temp0=$(echo $element | awk -F/ '{print $NF}')
  temp1=$(cat $IGNORE_FILE | grep $temp0)

  if [[ $temp1 == "" ]];
  then
    echo "Changing directory to $element ....."
    cd $element

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo "Running the command git $COMMAND on branch $current_branch on repo $temp0"
    git $COMMAND

    cd $DIRECTORY_LOCATION/
    echo ""
  fi

done