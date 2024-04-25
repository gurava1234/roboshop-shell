#!//bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m
N="\e[0m

TIMESTAMP=$(date +%f-%H-%M-%M)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" 

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
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

cp mongo.repo /home/centos/roboshop-shell/mongo.repo

VALIDATE $? "copied mongoDB Repo"

dnf install mongodb-org -y 

VALIDATE $? "Installing mongoDB"

systemctl enable mongod 

VALIDATE $? "enabling MongoDB"

systemctl start mongod 

VALIDATE $? "starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.config 

VALIDATE $? "Remote access to MongoDB"

systemctl restart mongod 

VALIDATE $? "Restarting MongoDB"