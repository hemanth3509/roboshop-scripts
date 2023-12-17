#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%T)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

R="\e[31m"
G="\e[32m"
N="\e[0m"


echo "Script started executing at $TIMESTAMP" $>> $LOGFILE

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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE
 check $? "Downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE
check $? "Downloading rabbitmq script"

dnf install rabbitmq-server -y  &>> $LOGFILE
check $? "Installing RabbitMQ server"

systemctl enable rabbitmq-server &>> $LOGFILE
check $? "Enabling rabbitmq server"

systemctl start rabbitmq-server  &>> $LOGFILE
check $? "Starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
check $? "creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
check $? "setting permission"