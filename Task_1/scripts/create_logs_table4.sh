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

# Save current IFS (Internal Field Separator)
SAVEIFS=$IFS
# Change IFS to newline char
IFS=$'\n'

#filter the data from input file into a variable
while read -r line; do
  if [[ $line == *"HOME"* || $line == *"AWAY"* ]];
  then

    #removes ] [ and " characters
    line=$(echo $line | sed 's/\]//g; s/\[//g; s/"//g' )

    temp1=$(echo "$line" |awk '{print $1}')
    temp2=$(echo "${my_array[@]}" | grep "$temp1")

    if [[ ${#temp2} == 0 ]];
    then
     my_array+=($line)
    fi

  fi
done <$INPUT_FILE

# Restore original IFS
IFS=$SAVEIFS

#Iterate through filtered array
for (( i=0; i<${#my_array[@]}; i++ ))
do
   #echo -e "element $i: ${my_array1[$i]}"

  user_address=$(echo ${my_array[$i]} | awk '{print $1}')
  echo -n "|$user_address|" >> $OUTPUT_FILE

  rfc931=$(echo ${my_array[$i]} | awk '{print $2}')
  echo -n "$rfc931|" >> $OUTPUT_FILE

  user_auth=$(echo ${my_array[$i]} | awk '{print $3}')
  echo -n "$user_auth|" >> $OUTPUT_FILE

  date_time=$(echo ${my_array[$i]} | awk '{print $4}')
  echo -n "$date_time|" >> $OUTPUT_FILE

  gmt_offset=$(echo ${my_array[$i]} | awk '{print $5}')
  echo -n "$gmt_offset|" >> $OUTPUT_FILE

  action=$(echo ${my_array[$i]} | awk '{print $6,$7,$8}')
  echo -n "$action|" >> $OUTPUT_FILE

  return_code=$(echo ${my_array[$i]} | awk '{print $9}')
  echo -n "$return_code|" >> $OUTPUT_FILE

  size_code=$(echo ${my_array[$i]} | awk '{print $10}')
  echo -n "$size_code|" >> $OUTPUT_FILE

  refferer=$(echo ${my_array[$i]} | awk '{print $11}')
  echo -n "$refferer|" >> $OUTPUT_FILE

  accpoInfo=$(echo ${my_array[$i]} | awk '{print $12,$13,$14,$15}')
  accpoInfo=$(echo $accpoInfo | sed 's/.$//g')
  echo -n "$accpoInfo|" >> $OUTPUT_FILE

  echo "" >> $OUTPUT_FILE

done





