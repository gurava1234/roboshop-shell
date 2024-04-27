#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m
N="\e[0m
MONGODB_HOST=mongo.gonepudirobot.online

TIMESTAMP=$(date +%f-%H-%M-%M)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" 

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then 
   echo -e " $R ERROR:: please run this script with root access $N"
   exit 1 # you can give otherthan 0
else 
   echo "you are root user"
fi #fi means reverse of if, indicating condition end

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

VALIDATE $? "Downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

VALIDATE $? "Downloading rabbitmq  script"

dnf install rabbitmq-server -y

VALIDATE $? "installing rabitmq server"

systemctl enable rabbitmq-server 

VALIDATE $? "enabling rabbitmq server"

systemctl start rabbitmq-server

VALIDATE $? "starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123

VALIDATE $? "creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

VALIDATE $? "setting permissions"