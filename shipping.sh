#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[m"

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

dnf install maven -y

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

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

VALIDATE $? "Downloading shipping"

cd /app

VALIDATE $? "moving to app directory"

unzip /tmp/shipping.zip

VALIDATE $? "unzipping shipping"

mvn clean package

VALIDATE $? "installing dependencies"

mv target/shipping-1.0.jar shipping.jar

VALIDATE $? "reamaining jar file"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

VALIDATE $? "copying shipping services"

systemctl daemon-reload

VALIDATE $? "daemon reloaded"

systemctl enable shipping

VALIDATE $? "enabling shipping"

systemctl start shipping

VALIDATE $? "start shipping"

dnf install mysql -y

VALIDATE $? "install mysql client"

mysql -h mysql.daws76s.cfd -uroot -pRoboShop@1 < /app/schema/shipping.sql

VALIDATE $? "loading shipping data"

systemctl restart shipping

VALIDATE $? "restart shipping"

