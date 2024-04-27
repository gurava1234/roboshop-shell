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

dnf module disable nodejs -y 

VALIDATE $? "Disabaling current NodeJS" 

dnf module enable nodejs:18 -y 

VALIDATE $? "enabling NodeJS:18"

dnf install nodejs -y 

VALIDATE $? "Installing NodeJS:18" 

id roboshop 
if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exists, skipping"
fi 

mkdir -p /app

VALIDATE $? "creating app directory" 

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip 

VALIDATE $? "Downloading cart application" 

cd /app

unzip -o /tmp/cart.zip 

VALIDATE $? "unzipping cart" 

npm install 

VALIDATE $? "Installing dependencies" 

#use absolutepath,because cart.service exists there

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

VALIDATE $? "copying cart service file"

systemctl daemon-reload 

VALIDATE $? "cart daemon reload" 

systemctl enable cart

VALIDATE $? "Enable cart" 

systemctl start cart

VALIDATE $? "starting cart" 

