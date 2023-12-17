#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check(){
    if [ $1 -ne 0 ]
    then
    echo -e "$2 ... $R FAILED $N"
    exit 1
    else
    echo -e "$2 ... $G SUCESS $N"
    fi
}

echo "Script Started executing at $TIMESTAMP" &>> $LOGFILE

if [ $ID -ne 0 ]
then
echo -e "Please run the script with root access $R Error $N " 
else
echo -e "Script running with root access $G Success $N "
fi

dnf module disable mysql -y &>> $LOGFILE
check $? "Disabling mysql"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
check $? "Copying mysql repo"

dnf install mysql-community-server -y &>> $LOGFILE
check $? "installing MYSQL"

systemctl enable mysqld &>> $LOGFILE 
check $? "Enabling MySQL Server"

systemctl start mysqld &>> $LOGFILE
check $? "Starting  MySQL Server" 

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
check $? "Setting  MySQL root password"

echo "Script execution completed for further please refer to log file at $LOGFILE"