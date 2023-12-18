#!/bin/bash

#R="\e[31m"
#G="\e[32m"
#Y="\e[33m"
#N="\e[0m"

echo " Script started $OPTARG"



help(){
    echo -e " Please find the below usage of the script \n"
    echo -e " -s <source dir> \n "
    echo -e " -a <Archive> or <Delete> \n "
    echo -e " -D <destination > \n "
    echo -e " -t <time> \n "
}

archive (){
    echo "inside archive func"
}
delete (){
    echi "inside delete func"
}
options(){
    OPTSTRING=":s:a:D:t:"
    echo "inside options "
while getopts ${OPTSTRING} opt;
do
case ${opt} in
s) 
    SOURCE_DIR=$2 ; 
    echo "source dir $SOURCE_DIR ";;
a)  archive=$4 ; 
    echo " archive $archive" ;;
D)  DESTINATION=$6 ; 
    echo " destination is $DESTINATION" ;;
t) 
    TIME=$8 ; 
    echo " time is $TIME" ;;
#:) 
##    echo " in : please pass the arguments";
#   help; 
 #   exit 1 ;;
\?)  help;
    exit 1 ;;
esac
done
}

echo "Before calling options"
if [ "$1" == " " ]
then
help
else
options "$@"
fi

echo " after options calling" 

if [ "$SOURCE_DIR" = " " ] || [ "$DATE" = " " ] || [ "$TIME" = " " ]
then
echo -e "Calling help if inputs are empty \n"
help
fi

if [ "$archive" == "archive" ]
then
archive
else [ "$Delete" == "delete" ]
fi





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