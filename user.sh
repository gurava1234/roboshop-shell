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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabaling current NodeJS" 

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling NodeJS:18 &>> 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing NodeJS:18 

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

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

VALIDATE $? "Downloading user application" &>> $LOGFILE

cd /app

unzip -o /tmp/user.zip &>> $LOGFILE

VALIDATE $? "unzipping user" 

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

VALIDATE $? "copying user service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "user daemon reload" 

systemctl enable user &>> $LOGFILE

VALIDATE $? "Enable user" 

systemctl start user &>> $LOGFILE

VALIDATE $? "starting user"

cp /home/centos/robosho-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongodb repo" 

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Inatalling mongoDB client" 

mongo --host $MONGODB_HOST </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "loading user data into mongoDB"


