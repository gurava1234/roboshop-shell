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

dnf install python36 gcc python3-devel -y

id roboshop 
if [$? -ne 0]
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y skipping $N"
fi  

mkdir -p /app

VALIDATE $? "creating app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip

VALIDATE $? "Downlodaing payment"

cd /app

unzip /tmp/payment.zip

VALIDATE $? "unzipping payment"

pip3.6 install -r requirements.txt

VALIDATE $? "installing dependenciest"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service

VALIDATE $? "copying payment service"

systemctl daemon-reload

VALIDATE $? "daemon reload"

systemctl enable payment 

VALIDATE $? "enabling payment"

systemctl start payment

VALIDATE $? "started payment"
