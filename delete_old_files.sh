#!/bin/bash

R="\e[31m"
G="\e[32m"
#Y="\e[33m"
N="\e[0m"

echo " Script started $OPTARG"



help(){
    echo -e " Please find the below usage of the script \n"
    echo -e " -s <source dir> \n "
    echo -e " -a <Archive> or <Delete> \n "
    echo -e " -d <destination > \n "
    echo -e " -t <time> \n "
}

action (){
    echo "inside actions func"
    if [ ! -d "$SOURCE_DIR" ]  # ! denotes opposite
then
    echo -e "$R Source directory: $SOURCE_DIR does not exists. $N"
    else
    if [ "$archive" == "archive" ]
    then
    echo -e "$G Source directory exists $SOURCE_DIR please archive $N"
    if [ ! -d "$DESTINATION" ]
    then
    echo -e "$R destination directory doesn't exists $N"
    else 
    echo -e "$G destination exits $N"
    fi
    fi
    if [ "$archive" == "delete" ]
    then 
        echo -e "$G Source directory exists $SOURCE_DIR please delete $N"
    fi
fi
}

options(){
    OPTSTRING=":s:a:d:t:"
    echo "inside options $1 "
while getopts ${OPTSTRING} opt;
do
case ${opt} in
s) 
    SOURCE_DIR=$2 ; 
    echo "source dir $SOURCE_DIR ";;
a)  archive=$4 ; 
    echo " archive $archive" ;;
d)  DESTINATION=$6 ; 
    echo " destination is $DESTINATION" ;;
t) 
    TIME=$8 ; 
    echo " time is $TIME" ;;
:) 
    echo " in : please pass the arguments";
   help; 
    exit 1 ;;
?)  help;
    exit 1 ;;
esac
done
}

echo "Before calling options"
echo " $1"
if [ "$1" != "-s" ]
then
help
else
options "$@"
fi

echo " after options calling" 

if [ "$archive" == "archive" ] || [ "$archive" == "delete" ]
then
action "$archive" "$DESTINATION"
else
help
fi

#FILES_TO_DELETE=$(find $SOURCE_DIR -type f -mtime +14 -name "*.log")

#while IFS= read -r line
#do
#    echo "Deleting file: $line"
#    rm -rf $line
# done <<< $FILES_TO_DELETE