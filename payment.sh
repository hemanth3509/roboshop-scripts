#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

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

dnf install python36 gcc python3-devel -y &>> $LOGFILE
check $? "Installing Python"

id roboshop &>> $LOGFILE #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    check $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app &>> $LOGFILE
check $? "creating app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE
check $? "Downloading payment"

cd /app 

unzip -o /tmp/payment.zip &>> $LOGFILE
check $? "unzipping payment"

pip3.6 install -r requirements.txt &>> $LOGFILE
check $? "Installing Dependencies"

cp /home/centos/roboshop-scripts/payment.service /etc/systemd/system/payment.service &>> $LOGFILE
check $? "Copying payment service"

systemctl daemon-reload &>> $LOGFILE
check $? "daemon reaload"

systemctl enable payment  &>> $LOGFILE
check $? "Enable payment"

systemctl start payment &>> $LOGFILE
check $? "Start payment"

echo "Script execution completed for further please refer to log file at $LOGFILE"