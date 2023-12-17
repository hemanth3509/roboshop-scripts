#!/bin/bash

ID=$(id -u )  #it gives the id num of the current user ge 0, if root user it is 0
TIMESTAMP=$(date +%D-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Scripting Started executing at $TIMESTAMP" &>> $LOGFILE

if [ $ID ne 0 ]
then
echo "Please run the script with root access"
exit 1
else 
echo " Script running with root access"
fi
