#!/bin/bash

#load arguments into variables
while getopts f:o: flag
do
    case "${flag}" in
        f) file=${OPTARG};;
        o) output_file=${OPTARG};;
    esac
done

#Variables
INPUT_FILE="$file"
OUTPUT_FILE="$output_file"
STARTING_TEMPLATE="# LOG ENTRIES
| 1.User Address | 2.RFC931       | 3.User auth    | 4.Date/Time    | 5.GMT Offset   | 6.Action       | 7.Return Code  | 8.Size         | 9.Referrer     | 10.APInfo      |
|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|"

#What is the optimal way to check flags and give feedback to the user that is running the script ?
if [[ $INPUT_FILE == "" ]];
then
  echo ">>>> Please provide the valid input file (-f <input_file>) <<<<"
  exit 0;
fi
if [[ $OUTPUT_FILE == "" ]];
then
  echo ">>>> Please provide the valid output file (-o <output_file>) <<<<"
  exit 0;
fi

#Check if the example output file exists
if [ ! -f $OUTPUT_FILE ];
then
  echo "$STARTING_TEMPLATE" >> $OUTPUT_FILE
fi

#Reads output file line by line, filters data, and writes that data to an output file in table format

#Print the entire file
#awk '{print}' $INPUT_FILE

#Print the HOME and AWAY patern
awk '/HOME/ {print} /AWAY/ {print}' $INPUT_FILE


