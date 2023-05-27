source common.sh
component=catalogue

echo -e "${color} Configuring NodeJS Repos ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>$log_file

echo -e "${color} Install NodeJS${nocolor}"
yum install nodejs -y  &>>$log_file

echo -e "${color} Add Application User${nocolor}"
useradd roboshop  &>>$log_file

echo -e "${color} Create Application Directory ${nocolor}"
rm -rf ${app_path}  &>>$log_file
mkdir ${app_path}

echo -e "${color} Download Application Content${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip  &>>$log_file
cd ${app_path}

echo -e "${color} Extract Application Content${nocolor}"
unzip /tmp/$component.zip  &>>$log_file
cd ${app_path}

echo -e "${color} Install NodeJS Dependencies${nocolor}"
npm install  &>>$log_file

echo -e "${color} Setup SystemD Service  ${nocolor}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>$log_file

echo -e "${color} Start $component Service ${nocolor}"
systemctl daemon-reload  &>>$log_file
systemctl enable $component  &>>$log_file
systemctl restart $component  &>>$log_file

echo -e "${color} Copy MongoDB Repo file ${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>$log_file

echo -e "${color} Install MongoDB Client ${nocolor}"
yum install mongodb-org-shell -y  &>>$log_file

echo -e "${color} Load Schema ${nocolor}"
mongo --host mongodb-dev.devopsb73.store <${app_path}/schema/$component.js  &>>$log_file