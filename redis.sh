#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
check $? "Installing Remi release"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
check $? "enabling redis"

dnf install redis -y &>> $LOGFILE
check $? "Installing Redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE
check $? "allowing remote connections"

systemctl enable redis &>> $LOGFILE
check $? "Enabled Redis"

systemctl start redis &>> $LOGFILE
check $? "Started Redis"

echo "Script execution completed for further please refer to log file at $LOGFILE"
