#!//bin/bash

ID=$(id -u)


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

VALIDATE $questionmark "copied mongoDB Repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE $QUESTIONMAK "Installing mongoDB"

systemctl enable mongod

VLIADTE $questionmark "Enabling MongoDB"

systemctl start mongod

VLIDATE $questionmark "starting mongoDB

sed -i 's/127.0.0.1/0.0.0/g' / /etc/mongod.cong &LOGFILE

VALIDATE $questionmark "Remote access to MongoDB"

systemctl restart mongod &>> $LOGFILE
