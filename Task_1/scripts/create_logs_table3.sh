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

while read -r line; do
  if [[ $line == *"HOME"* || $line == *"AWAY"* ]];
  then

    #removes ] [ and " characters
    line=$(echo $line | sed 's/\]//g; s/\[//g; s/"//g' )

    #prints first element in line (elements are seperated with whitespace)
    user_address=$(echo $line | awk '{print $1}')
    echo -n "|$user_address|" >> $OUTPUT_FILE

    rfc931=$(echo $line | awk '{print $2}')
    echo -n "$rfc931|" >> $OUTPUT_FILE

    user_auth=$(echo $line | awk '{print $3}')
    echo -n "$user_auth|" >> $OUTPUT_FILE

    date_time=$(echo $line | awk '{print $4}')
    echo -n "$date_time|" >> $OUTPUT_FILE

    gmt_offset=$(echo $line | awk '{print $5}')
    echo -n "$gmt_offset|" >> $OUTPUT_FILE

    action=$(echo $line | awk '{print $6,$7,$8}')
    echo -n "$action|" >> $OUTPUT_FILE

    return_code=$(echo $line | awk '{print $9}')
    echo -n "$return_code|" >> $OUTPUT_FILE

    size_code=$(echo $line | awk '{print $10}')
    echo -n "$size_code|" >> $OUTPUT_FILE

    refferer=$(echo $line | awk '{print $11}')
    echo -n "$refferer|" >> $OUTPUT_FILE

    accpoInfo=$(echo $line | awk '{print $12,$13,$14,$15}')
    accpoInfo=$(echo $accpoInfo | sed 's/.$//g')
    echo -n "$accpoInfo|" >> $OUTPUT_FILE

    echo "" >> $OUTPUT_FILE

  fi
done <$INPUT_FILE

#Replace second occurrence of ip 111.222.333.123 to 111.222.333.129 only once
condition1=$(grep 111.222.333.129 $OUTPUT_FILE)
if [[ $condition1=="" ]]
then
  #using sed only ( hard way )
  #sed --i "/111.222.333.123/ {n; :a; /111.222.333.123/! {N; ba;}; s/111.222.333.123/111.222.333.129/; :b; n; $! bb}" $OUTPUT_FILE

  using sed only ( easy way )
  sed --i '0,/111.222.333.123/!{0,/111.222.333.123/s/111.222.333.123/111.222.333.129/}' $OUTPUT_FILE

  #using sed and awk
  #target_line_number=$(awk -v n=2 '/111.222.333.123/ {getline; print NR; exit}' $OUTPUT_FILE)
  #sed --i "${target_line_number}s/111.222.333.123/111.222.333.129/1" $OUTPUT_FILE

  #using grep and sed
  #target_line_number=$(grep -n -m2 111.222.333.123 $OUTPUT_FILE | tail -n1 |  cut -d : -f 1)
  #sed --i"${target_line_number}s/111.222.333.123/111.222.333.129/1" $OUTPUT_FILE
fi


#Get only one record of unique ip address

#number_of_lines=$(cat $OUTPUT_FILE | grep 'HOME\|AWAY' | wc -l)

#awk '/HOME|AWAY/ {print $0}' $INPUT_FILE

#my_array=($(awk '/HOME|AWAY/ { print }' $INPUT_FILE))
#
#for element in ${my_array[@]}; do
#  echo $element
#done


















