#!/bin/bash


if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit 1
fi


if [[ -e /etc/debian_version ]]; then
	OS="debian"
fi



#тут проверка или есть питон установлен


if [[ 	OS="debian" ]]; then 
apt-get update &&  apt-get install software-properties-common python-software-properties curl wget htop -y && 
add-apt-repository ppa:jonathonf/python-3.6 -y &&  apt-get update && apt-get install python3.6 git -y &&  apt-get install python3-pip -y && 
curl -O https://bootstrap.pypa.io/get-pip.py && /usr/bin/python3.5m get-pip.py && sudo pip3 install telegram-send


echo "Now you should open https://telegram.me/BotFather and create bot. And afreк it you will be able to get access token"
echo ""
echo ""
echo " If you are having problems with it, so, to not hesitate to ask google."

read -n1 -r -p "                           Press any key when you got access token"

telegram-send --configure --global-config


echo "if everuthing was fine, you should see  these writting:"
echo ""
echo ""
echo -e "\e[32mCongratulations emobort! telegram-send is now ready for use!\e[0m"




