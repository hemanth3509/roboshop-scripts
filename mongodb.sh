#!/bin/bash

ID=$(id -u )  #it gives the id num of the current user ge 0, if root user it is 0
TIMESTAMP=$(date +%F-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"




echo "Scripting Started executing at $TIMESTAMP " &>> $LOGFILE 

check (){
   if [ $1 -ne 0 ]
   then
        echo -e "$2... $R FAILED $N"
        exit 1
   else 
        echo -e "$2... $G Success $N"
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

 dnf install mongodb-org -y &>> $LOGFILE
 check $? "Installing mongodb"

 systemctl enable mongod &>> $LOGFILE
 check $? "Enabling mongodb service"

 systemctl start mongod &>> $LOGFILE
 check $? "Starting mongodb service"

 sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
 check $? "Editing mongod.conf file to provide remote access"
 
 systemctl restart mongod &>> $LOGFILE
 check $? "Restarting the  mongdb service"


