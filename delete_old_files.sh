#!/bin/bash

#R="\e[31m"
#G="\e[32m"
#Y="\e[33m"
#N="\e[0m"

main (){
    options $@
}

otions(){
local OPTIND opt i
while getopts ":saDdt:" opt;
do
case $opt in
s) SOURCE_DIR=$1 ; echo "source dir $SOURCE_DIR ";;
a) echo " archive ";;
D) echo "Delete " ;;
d) DATE=$2 ; echo " date $DATE" ;;
t) TIME=$3 ; echo " time is $TIME" ;;
\?) help;exit 1 ;;
esac
done

}

if [ $SOURCE_DIR = " " ] || [ $DATE = " " ] || [ $TIME = " " ]
then
help
fi

help(){
    echo -e " Please find the below usage of the script \n"
    echo -e " -s <source dir> \n "
    echo -e " -a <Archive> \n "
    echo -e " -D <Delete> \n "
    echo -e " -d <destination > \n "
    echo -e " -t <time> \n "
}


#if [ ! -d $SOURCE_DIR ] # ! denotes opposite
#then
#    echo -e "$R Source directory: $SOURCE_DIR does not exists. $N"
#fi

#FILES_TO_DELETE=$(find $SOURCE_DIR -type f -mtime +14 -name "*.log")

#while IFS= read -r line
#do
#    echo "Deleting file: $line"
#    rm -rf $line
#done <<< $FILES_TO_DELETE