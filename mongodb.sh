#!/bin/bash

ID=$(id -u )  #it gives the id num of the current user ge 0, if root user it is 0
TIMESTAMP=$(date +%F-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Scripting Started executing at $TIMESTAMP " &>> $LOGFILE 

check (){
   if [ $1 -ne 0 ]
   then
        echo "$2...FAILED"
        exit 1
   else 
        echo "$2... Success"
   fi
}

if [ $ID -ne 0 ]
then
echo "Please run the script with root access"
exit 1
else 
echo " Script running with root access" &>> $LOGFILE
fi

cp  mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
 check $? "Copying mongodb repo" 