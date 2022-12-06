#!/bin/bash

#load arguments into variables
while getopts f: flag
do
    case "${flag}" in
        f) file=${OPTARG};;
    esac
done

#What is the smartest way to check flags and give feedback to the user that is runing the script ?
if [[ $file == "" || ! -f $file ]];
then
  echo ">>>> Please provide the valid input file (-f <input_file>) <<<<"
  exit 0;
fi

starting_template="# LOG ENTRIES
| 1.User Address | 2.RFC931       | 3.User auth    | 4.Date/Time    | 5.GMT Offset   | 6.Action       | 7.Return Code  | 8.Size         | 9.Referrer     | 10.APInfo      |
|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|:--------------:|"

#Check if the example output file exists
if [ ! -f example_output_file.md ];
then
  echo "$starting_template" >> example_output_file.md
fi

#Reads output file line by line, filters data, and writes that data to an output file in table format
while read -r line; do
  if [[ $line == *"HOME"* || $line == *"AWAY"* ]];
  then

    #13
    #Takes substring from position 0 in the string and takes 16 characters after
    user_address=${line:0:16}
    echo -n "|$user_address|" >> example_output_file.md

    rfc931=${line:16:4}
    echo -n "$rfc931|" >> example_output_file.md

    user_auth="-"
    echo -n "$user_auth|" >> example_output_file.md

    #Takes substring between character [ and character ]
    #Square brackets are special characters and they have to be escaped with \
    date_time=$(echo $line | grep -oP '\[\K.*?(?=\])' |  rev | cut -c7- | rev)
    echo -n "$date_time|" >> example_output_file.md

    #First line removes remove prefix, everything up to second symbol -
    #Second line removes suffix, everything from first symbol ]
    gmt_offset=${line#*-*-*}
    gmt_offset=${gmt_offset%]*}
    echo -n "$gmt_offset|" >> example_output_file.md

    #This divides string based on delimiter " and takes second element (f2)
    action=$(echo $line | cut -d "\"" -f2)
    echo -n "$action|" >> example_output_file.md

    return_code=$(echo $line | cut -d "\"" -f3)
    return_code=${return_code:1:3}
    echo -n "$return_code|" >> example_output_file.md

    #This divides string based on delimiter whitespace and takes 10th element (f10)
    size=$(echo $line | cut -d " " -f10)
    echo -n "$size|" >> example_output_file.md

    #First line divides string based on delimiter whitespace and takes 11th element (f11)
    #Second line removes all symbols " from a string
    refferer=$(echo $line | cut -d " " -f11)
    refferer=$(echo $refferer | tr -d '"')
    echo -n "$refferer|" >> example_output_file.md

    accpoInfo=$(echo $line | cut -d "\"" -f6)
    echo -n "$accpoInfo|" >> example_output_file.md

    #shifts to the next row in table
    echo "" >> example_output_file.md

  fi
done <$file



