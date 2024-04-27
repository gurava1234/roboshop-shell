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

dnf module disable mysql -y

VALIDATE $? "disable current MySQL version"

cp mysql.repo /etc/yum.repos.d/mysql.repo

VALIDATE $? "copied mysql repo"

dnf install mysql-community-server -y

VALIDATE $? "intsalling mysql community server"

systemctl enable mysqld

VALIDATE $? "enabling mysql server"

systemctl start mysqld

VALIDATE $? "started mysql server"

mysql_secure_installation --set-root-pass RoboShop@1

VALIDATE $? "setting  mysql root password"


