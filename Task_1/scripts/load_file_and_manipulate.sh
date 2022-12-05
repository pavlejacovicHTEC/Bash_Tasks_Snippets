#!/bin/bash

#load arguments into variables
while getopts f: flag
do
    case "${flag}" in
        f) file=${OPTARG};;
    esac
done

starting_template="# LOG ENTRIES
|1.User Address |2.RFC931       |3.User auth    |4.Date/Time    |5.GMT Offset   |6.Action       |7.Return Code  |8.Size         |9.Referrer     |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |:-------------:|"

if [ ! -f example_output_file.md ];
then
  echo "$starting_template" >> example_output_file.md
fi

while read -r line; do
  if [[ $line == *"HOME"* || $line == *"AWAY"* ]];
  then

    #takes substring from position 0 in the string and takes 16 characters after
    user_address=${line:0:16}
    echo $user_address

    rfc931=${line:16:4}
    echo $rfc931

    user_auth="-"
    echo $user_auth

    #takes substring between character [ and character ]
    date_time=$(echo $line | grep -oP '\[\K.*?(?=\])' |  rev | cut -c7- | rev)
    echo $date_time

    #TO EXPLAIN
    gmt_offset=${line#*-*-*}
    gmt_offset=${gmt_offset%]*}
    echo $gmt_offset

    #This divides string based on delimeter " and takes second elemend (f2)
    action=$(echo $line | cut -d "\"" -f2)
    echo $action

    return_code=$(echo $line | cut -d "\"" -f3)
    return_code=${return_code:0:4}
    echo $return_code

    size=$(echo $line | cut -d " " -f10)
    echo $size

    refferer=$(echo $line | cut -d " " -f11)
    refferer=$(echo $refferer | tr -d '"')
    echo $refferer

    access_point_information=$(echo $line | cut -d "\"" -f6)
    echo $access_point_information

    echo ""

  fi
done <$file



