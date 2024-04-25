#!//bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m
N="\e[0m

TIMESTAMP=$(date +%f-%H-%M-%M)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

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

cp mongo.repo /etc/yum.repos.d/mongo.db &>> $LOGFILE

VALIDATE $? "copied mongoDB Repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing mongoDB"

systemctl enable mongod &>> $LOGFILE

VLIADTE $? "enabling MongoDB"

systemctl start mongod &>> $LOGFILE

VLIDATE $? "starting MongoDB"

sed -i 's/127.0.0.1/0.0.0/g' /etc/mongod.config $LOGFILE

VALIDATE $? "Remote access to MongoDB"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting MongoDB"