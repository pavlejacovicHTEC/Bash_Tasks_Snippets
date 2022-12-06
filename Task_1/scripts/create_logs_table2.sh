#!/bin/bash

#load arguments into variables
while getopts f: flag
do
    case "${flag}" in
        f) file=${OPTARG};;
    esac
done

#Variables
INPUT_FILE="$file"
OUTPUT_FILE="../example_output_file.md"
STARTING_TEMPLATE="# LOG ENTRIES
| 1.User Address | 2.RFC931       | 3.User auth    | 4.Date/Time    | 5.GMT Offset   | 6.Action       | 7.Return Code  | 8.Size         | 9.Referrer     | 10.APInfo      |
|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|"

#What is the optimal way to check flags and give feedback to the user that is running the script ?
if [[ $INPUT_FILE == "" ]];
then
  echo ">>>> Please provide the valid input file (-f <input_file>) <<<<"
  exit 0;
fi

#Check if the example output file exists
if [ ! -f $OUTPUT_FILE ];
then
  echo "$STARTING_TEMPLATE" >> $OUTPUT_FILE
fi

#Reads output file line by line, filters data, and writes that data to an output file in table format
while read -r line; do
  if [[ $line == *"HOME"* || $line == *"AWAY"* ]];
  then

    #removes all " [ and ] symbols
    line=$(echo $line | tr -d '"')
    line=$(echo $line | tr -d '[')
    line=$(echo $line | tr -d ']')

    user_address=$(echo $line | cut -d " " -f1)
    echo -n "|$user_address|" >> $OUTPUT_FILE

    rfc931=$(echo $line | cut -d " " -f2)
    echo -n "$rfc931|" >> $OUTPUT_FILE

    user_auth=$(echo $line | cut -d " " -f3)
    echo -n "$user_auth|" >> $OUTPUT_FILE

    date_time=$(echo $line | cut -d " " -f4)
    echo -n "$date_time|" >> $OUTPUT_FILE

    gmt_offset=$(echo $line | cut -d " " -f5)
    echo -n "$gmt_offset|" >> $OUTPUT_FILE

    action1=$(echo -n $line | cut -d " " -f6)
    action2=$(echo -n $line | cut -d " " -f7)
    action3=$(echo -n $line | cut -d " " -f8)
    action="$action1 $action2 $action3"
    echo -n "$action|" >> $OUTPUT_FILE

    return_code=$(echo $line | cut -d " " -f9)
    echo -n "$return_code|" >> $OUTPUT_FILE

    size=$(echo $line | cut -d " " -f10)
    echo -n "$size|" >> $OUTPUT_FILE

    refferer=$(echo $line | cut -d " " -f11)
    echo -n "$refferer|" >> $OUTPUT_FILE

    #How to remove all new lines in bash ?
    accpoInfo1=$(echo -n $line | cut -d " " -f12)
    accpoInfo2=$(echo -n $line | cut -d " " -f13)
    accpoInfo3=$(echo -n $line | cut -d " " -f14)
    accpoInfo4=$(echo -n $line | cut -d " " -f15)
    accpoInfo="$accpoInfo1 $accpoInfo2 $accpoInfo3 $accpoInfo4"
    #accpoInfo=$(echo $accpoInfo | tr -d '\n')
    #accpoInfo=${accpoInfo//$'\n'/}
    accpoInfo=${accpoInfo::-1}
    echo -n "$accpoInfo|" >> $OUTPUT_FILE

    echo "" >> $OUTPUT_FILE

  fi
done <$INPUT_FILE



