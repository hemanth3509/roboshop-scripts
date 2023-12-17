#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MYSQL_HOST=mysql.hs2km.online

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

dnf install maven -y &>> $LOGFILE
check $? "Installing maven"

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

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE
check $? "Downloading shipping"

cd /app
check $? "moving to app directory"

unzip -o /tmp/shipping.zip &>> $LOGFILE
check $? "unzipping shipping"

mvn clean package &>> $LOGFILE
check $? "Installing dependencies"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
check $? "renaming jar file"

cp /home/centos/roboshop-scripts/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE
check $? "copying shipping service"

systemctl daemon-reload &>> $LOGFILE
check $? "deamon reload"

systemctl enable shipping  &>> $LOGFILE
check $? "enable shipping"

systemctl start shipping &>> $LOGFILE
check $? "start shipping"

dnf install mysql -y &>> $LOGFILE
check $? "install MySQL client"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE
check $? "loading shipping data"

systemctl restart shipping &>> $LOGFILE
check $? "restart shipping"

echo "Script execution completed for further please refer to log file at $LOGFILE"