#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGDB_HOST=mongodb.hs2km.online

R="\e[31m"
G="\e[32m"
N="\e[0m"

echo "$0 Script started executing at $TIMESTAMP" &>> $LOGFILE

if [ $ID -ne 0 ]
then
echo -e "Please access with Root user $R ERROR $N"
else
echo -e "Script running with root user $G Success $N "
fi

check(){
if [ $1 -ne 0 ]
then
echo -e "$2 ... $R FAILED $N"
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

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    check $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app
check $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $LOGFILE
check $? "Downloading catalogue application"

cd /app 

unzip -o /tmp/catalogue.zip  &>> $LOGFILE
check $? "unzipping catalogue"

npm install  &>> $LOGFILE
check $? "Installing dependencies"

# use absolute, because catalogue.service exists there
cp /home/centos/roboshop-scripts/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
check $? "Copying catalogue service file"

systemctl daemon-reload &>> $LOGFILE
check $? "catalogue daemon reload"

systemctl enable catalogue &>> $LOGFILE
check $? "Enable catalogue"

systemctl start catalogue &>> $LOGFILE
check $? "Starting catalogue"

cp /home/centos/roboshop-scripts/mongo.repo /etc/yum.repos.d/mongo.repo
check $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
check $? "Installing MongoDB client"

mongo --host $MONGDB_HOST </app/schema/catalogue.js &>> $LOGFILE
check $? "Loading catalouge data into MongoDB"

echo "Script execution completed for further please refer to log file at $LOGFILE"