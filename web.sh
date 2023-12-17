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

dnf install nginx -y &>> $LOGFILE
check $? "Installing nginx"

systemctl enable nginx &>> $LOGFILE
check $? "Enable nginx" 

systemctl start nginx &>> $LOGFILE
check $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
check $? "removed default website"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
check $? "Downloaded web application"

cd /usr/share/nginx/html &>> $LOGFILE
check $? "moving nginx html directory"

unzip -o /tmp/web.zip &>> $LOGFILE
check $? "unzipping web"
 
cp /home/centos/roboshop-scripts/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE 
check $? "copied roboshop reverse proxy config"

systemctl restart nginx &>> $LOGFILE
check $? "restarted nginx"

echo "Script execution completed for further please refer to log file at $LOGFILE"