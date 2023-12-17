#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGDB_HOST=mongodb.hs2km.online

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

echo "$0 Script started executing at $TIMESTAMP" &>> $LOGFILE

if [ $ID -ne 0 ]
then
echo -e "Please access with Root user $R ERROR $N"
echo "please refer to log file at $LOGFILE"
exit 1
else
echo -e "Script running with root user $G Success $N "
fi

check(){
if [ $1 -ne 0 ]
then
echo -e "$2 ... $R FAILED $N"
echo "please refer to log file at $LOGFILE"
exit 1
else
echo -e "$2 ... $G SUCCESS $N"
fi
}

dnf module disable nodejs -y &>> $LOGFILE
check $? "Disabling current NodeJS"

dnf module enable nodejs:18 -y  &>> $LOGFILE
check $? "Enabling NodeJS:18"

dnf install nodejs -y  &>> $LOGFILE
check $? "Installing NodeJS:18"

id roboshop &>> $LOGFILE #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    check $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app
check $? "creating app directory"

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>> $LOGFILE
check $? "Downloading user application"

cd /app 

unzip -o /tmp/user.zip  &>> $LOGFILE
check $? "unzipping user"

npm install  &>> $LOGFILE
check $? "Installing dependencies"

cp /home/centos/roboshop-scripts/user.service /etc/systemd/system/user.service
check $? "Copying user service file"

systemctl daemon-reload &>> $LOGFILE
check $? "user daemon reload"

systemctl enable user &>> $LOGFILE
check $? "Enable user"

systemctl start user &>> $LOGFILE
check $? "Starting user"

cp /home/centos/roboshop-scripts/mongo.repo /etc/yum.repos.d/mongo.repo
check $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
check $? "Installing MongoDB client"

mongo --host $MONGDB_HOST </app/schema/user.js &>> $LOGFILE
check $? "Loading user data into MongoDB"

echo "Script execution completed for further please refer to log file at $LOGFILE"