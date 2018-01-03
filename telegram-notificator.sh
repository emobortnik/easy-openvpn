#!/bin/bash


if [[ -e /etc/debian_version ]]; then
	OS="debian"
fi



#check if python is already installed


if [[ 	OS="debian" ]]; then 
apt-get update &&  apt-get install software-properties-common python-software-properties curl wget htop -y && 
add-apt-repository ppa:jonathonf/python-3.6 -y &&  apt-get update && apt-get install python3.6 git -y &&  apt-get install python3-pip -y && 
curl -O https://bootstrap.pypa.io/get-pip.py && /usr/bin/python3.5m get-pip.py && sudo pip3 install telegram-send && 
echo ""
echo ""
echo ""
echo ""
echo "Now you should open https://telegram.me/BotFather and create bot. And afrer it you will be able to get access token"
echo ""
echo ""
echo ""
read -n1 -r -p "                           Press any key when you got access token"

telegram-send --configure --global-config

echo ""
echo ""
echo ""
echo ""
echo "if everything was fine, you should see  these writting:"
echo ""
echo ""
echo ""
echo ""
echo -e "\e[32mCongratulations! telegram-send is now ready for use!\e[0m"
echo ""
echo ""
echo "but if was just external config which is located cat /etc/telegram-send.conf - i advise to save it."
echo ""
echo ""
echo "So, lets go to create internal config "
echo ""
echo ""
telegram-send --configure  && telegram-send "this is test message:)"
echo ""
echo ""
else 
echo "Soon will be packages for other OS but I am a human and want to sleeep too"
fi

