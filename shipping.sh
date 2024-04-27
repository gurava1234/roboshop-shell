#!/bin/bash
 
ID=$(id -u)
 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[m"
 
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
LOGFILE="/tmp/$0-$TIMESTAMP.log"
 
echo "Script started executing at $TIMESTAMP"
 
VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... ${R}FAILED${N}"
        exit 1
    else
        echo -e "$2 ... ${G}SUCCESS${N}"
    fi
}
 
if [ $ID -ne 0 ]; then 
    echo -e "${R}ERROR:${N} Please run this script with root access."
    exit 1
else 
    echo "You are a root user."
fi
 
dnf install maven -y
VALIDATE $? "Installing Maven"
 
id roboshop 
if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "Roboshop user creation"
else
    echo "Roboshop user already exists, skipping."
fi
 
mkdir -p /app
VALIDATE $? "Creating app directory"
 
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip
VALIDATE $? "Downloading shipping"
 
cd /app
VALIDATE $? "Moving to app directory"
 
unzip -o /tmp/shipping.zip
VALIDATE $? "Unzipping shipping"
 
mvn clean package
VALIDATE $? "Packaging application"
 
mv target/shipping-1.0.jar shipping.jar
VALIDATE $? "Renaming jar file"
 
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "Copying shipping service"
 
systemctl daemon-reload
VALIDATE $? "Reloading daemon"
 
systemctl enable shipping
VALIDATE $? "Enabling shipping service"
 
systemctl start shipping
VALIDATE $? "Starting shipping service"
 
dnf install mysql -y
VALIDATE $? "Installing MySQL client"
 
mysql -h mysql.daws76s.cfd -uroot -pRoboShop@1 < /app/schema/shipping.sql
VALIDATE $? "Loading shipping data"

