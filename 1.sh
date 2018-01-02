#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, you need to run this as root"
	exit 1
fi

if [[ ! -e /dev/net/tun ]]; then
	echo "TUN is not available"
	exit 2
fi

if grep -qs "CentOS release 5" "/etc/redhat-release"; then
	echo "CentOS 5 is too old and not supported"
	exit 3
fi


restartservice () {
	if [[ "$OS" = 'debian' ]]; then




if pgrep systemd-journal; then
				#Workaround to fix OpenVPN service on OpenVZ
				sed -i 's|LimitNPROC|#LimitNPROC|' /lib/systemd/system/openvpn\@.service
				sed -i 's|/etc/openvpn/server|/etc/openvpn|' /lib/systemd/system/openvpn\@.service
				sed -i 's|%i.conf|server.conf|' /lib/systemd/system/openvpn\@.service
				systemctl daemon-reload
				systemctl restart openvpn
				systemctl enable openvpn
		else
			/etc/init.d/openvpn restart
		fi
	else
		if pgrep systemd-journal; then
			if [[ "$OS" = 'arch' || "$OS" = 'fedora' ]]; then
				#Workaround to avoid rewriting the entire script for Arch & Fedora
				sed -i 's|/etc/openvpn/server|/etc/openvpn|' /usr/lib/systemd/system/openvpn-server@.service
				sed -i 's|%i.conf|server.conf|' /usr/lib/systemd/system/openvpn-server@.service
				systemctl daemon-reload
				systemctl restart openvpn-server@openvpn.service
				systemctl enable openvpn-server@openvpn.service
			else
				systemctl restart openvpn@server.service
				systemctl enable openvpn@server.service
			fi
		else
			service openvpn restart
			chkconfig openvpn on
		fi

		
	fi

}


wgetgit () {
	if [[ -d /etc/openvpn/easy-rsa/ ]]; then
		rm -rf /etc/openvpn/easy-rsa/
	fi

mkdir /etc/openvpn/
cd /etc/openvpn/
wget -O easy-rsa.tgz https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.3/EasyRSA-3.0.3.tgz 
tar xzf easy-rsa.tgz &&
mv EasyRSA-3.0.3/ easy-rsa/
chown -R root:root /etc/openvpn/easy-rsa/ &&
rm -rf easy-rsa.tgz &&
cd easy-rsa/
./easyrsa init-pki
./easyrsa --batch build-ca nopass
       
 }



if [[ -e /etc/debian_version ]]; then
	OS="debian"
	# Getting the version number, to verify that a recent version of OpenVPN is available
	VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.conf'
	if [[ "$VERSION_ID" != 'VERSION_ID="7"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="8"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="9"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="12.04"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="14.04"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="16.04"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="16.10"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="17.04"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="18.2"' ]]; then
        echo "
########################################################################################################
#                                                               #                                      #
#                        Houston, we have                       #    ░░░░░██▀▀▀▀▀▀▀▀▀▀▀████████░░░░    #
#                                                               #    ░░░░██░░░░░░░░░░░░░░███████░░░    #
#                           We have a                           #    ░░░██░░░░░░░░░░░░░░░████████░░    #
#                                                               #    ░░░█▀░░░░░░░░░░░░░░░▀███████░░    #
#                           | |   | |                           #    ░░░█▄▄██▄░░░▀█████▄░░▀██████░░    #
#            _ __  _ __ ___ | |__ | | ___ _ __ ___              #    ░░░█▀███▄▀░░░▄██▄▄█▀░░░█████▄░    #
#           |  _ \|  __/ _ \|  _ \| |/ _ \  _   _ \             #    ░░░█░░▀▀█░░░░░▀▀░░░▀░░░██░░▀▄█    #
#           | |_) | | | (_) | |_) | |  __/ | | | | |            #    ░░░█░░░█░░░▄░░░░░░░░░░░░░██░██    #
#           | .__/|_|  \___/|_.__/|_|\___|_| |_| |_|            #    ░░░█░░█▄▄▄▄█▄▀▄░░░░░░░░░▄▄█▄█░    #
#           | |                                                 #    ░░░█░░█▄▄▄▄▄▄░▀▄░░░░░░░░▄░▀█░░    #
#           |_|                                                 #    ░░░█░█▄████▀██▄▀░░░░░░░█░▀▀░░░    #
#################################################################    ░░░░██▀░▄▄▄▄░░░▄▀░░░░▄▀█░░░░░░    #
#                                                               #    ░░░░░█▄▀░░░░▀█▀█▀░▄▄▀░▄▀░░░░░░    #
#    Your version of Linux is not supported now by my script.   #    ░░░░░▀▄░░░░░░░░▄▄▀░░░░█░░░░░░░    #
#                                                               #    ░░░░░▄██▀▀▀▀▀▀▀░░░░░░░█▄░░░░░░    #
# However, if you are using Debian unstable/testing, Linux Mint #    ░░▄▄▀░░░▀▄░░░░░░░░░░▄▀░▀▀▄░░░░    #
#                       or Ubuntu beta,                         #    ▄▀▀░░░░░░░█▄░░░░░░▄▀░░░░░░█▄░░    #
#                   then you can continue,                      #    █░░░░░░░░░░░░░░░░░░░░░░░░░░▀█▄    #
#                                                               #    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    #
#          But please remember that I can not guarantee         #    ░░░░░░░░█▀▀█ █▀▀█ █▀▀▄░░░░░░░░    #
#                                                               #    ░░░░░░░░█▀▀▄ █▄▄█ █░░█░░░░░░░░    #
#               correct executing of my script                  #    ░░░░░░░░█▄▄█ █░░█ █▄▄▀░░░░░░░░    #
#                                                               #                                      #
########################################################################################################"



		while [[ $CONTINUE != "y" && $CONTINUE != "n" ]]; do
			read -p "Continue ? [y/n]: " -e CONTINUE
		done
		if [[ "$CONTINUE" = "n" ]]; then
			echo "Ok, bye !"
			exit 4
		fi
	fi
elif [[ -e /etc/centos-release || -e /etc/redhat-release && ! -e /etc/fedora-release ]]; then
	OS=centos
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.conf'
elif [[ -e /etc/arch-release ]]; then
	OS=arch
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.d/openvpn.conf'
elif [[ -e /etc/fedora-release ]]; then
	OS=fedora
	IPTABLES='/etc/iptables/iptables.rules'
	SYSCTL='/etc/sysctl.d/openvpn.conf'
else
	echo "Looks like you aren't running this installer on a Debian, Ubuntu, CentOS or ArchLinux system"
	exit 4
fi







# Try to get our IP from the system and fallback to the Internet.
# I do this to make the script compatible with NATed servers (LowEndSpirit/Scaleway)
# and to avoid getting an IPv6.
IP=$(wget -qO-  ifconfig.co)

# Get Internet network interface with default route
NIC=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)

if [[ -e /etc/openvpn/server.conf ]]; then
	while :
	do
	clear
echo "########################################################################################################
#                                                               #                                      #
#             Добро пожаловать в OpenVPN Controller             #    ░░░░░██▀▀▀▀▀▀▀▀▀▀▀████████░░░░    #
#                                                               #    ░░░░██░░░░░░░░░░░░░░███████░░░    #
#                           Made by                             #    ░░░██░░░░░░░░░░░░░░░████████░░    #
#                                                               #    ░░░█▀░░░░░░░░░░░░░░░▀███████░░    #
#    ██████╗  ██████╗ ██████╗ ████████╗███╗   ██╗██╗██╗  ██╗    #    ░░░█▄▄██▄░░░▀█████▄░░▀██████░░    #
#    ██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝████╗  ██║██║██║ ██╔╝    #    ░░░█▀███▄▀░░░▄██▄▄█▀░░░█████▄░    #
#    ██████╔╝██║   ██║██████╔╝   ██║   ██╔██╗ ██║██║█████╔╝     #    ░░░█░░▀▀█░░░░░▀▀░░░▀░░░██░░▀▄█    #
#    ██╔══██╗██║   ██║██╔══██╗   ██║   ██║╚██╗██║██║██╔═██╗     #    ░░░█░░░█░░░▄░░░░░░░░░░░░░██░██    #
#    ██████╔╝╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║██║  ██╗    #    ░░░█░░█▄▄▄▄█▄▀▄░░░░░░░░░▄▄█▄█░    #
#    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝    #    ░░░█░░█▄▄▄▄▄▄░▀▄░░░░░░░░▄░▀█░░    #
#                                                               #    ░░░█░█▄████▀██▄▀░░░░░░░█░▀▀░░░    #
#################################################################    ░░░░██▀░▄▄▄▄░░░▄▀░░░░▄▀█░░░░░░    #
#                                                               #    ░░░░░█▄▀░░░░▀█▀█▀░▄▄▀░▄▀░░░░░░    #
#              Что желаете сделать, мой господин?               #    ░░░░░▀▄░░░░░░░░▄▄▀░░░░█░░░░░░░    #
#                                                               #    ░░░░░▄██▀▀▀▀▀▀▀░░░░░░░█▄░░░░░░    #
#   1) Добавить сертификат для нового пользователя              #    ░░▄▄▀░░░▀▄░░░░░░░░░░▄▀░▀▀▄░░░░    #
#   2) Удалить существующий сертификат пользователя             #    ▄▀▀░░░░░░░█▄░░░░░░▄▀░░░░░░█▄░░    #
#   3) Показать все существующие сертификаты                    #    █░░░░░░░░░░░░░░░░░░░░░░░░░░▀█▄    #
#   4) Удалить OpenVPN                                          #    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    #
#   5) Выход                                                    #    █▄░░█ █▀▀█ ▀▀█▀▀░░█▀▀█ █▀▀█ █▀▀▄  #
#                                                               #    █░█░█ █░░█ ░░█░░░░█▀▀▄ █▄▄█ █░░█  #
#                                                               #    █░░▀█ █▄▄█ ░░█░░░░█▄▄█ █░░█ █▄▄▀  #
#                                                               #                                      #
########################################################################################################"
NUMBEROFCLIENTS=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep -c "^V")
echo ""
echo ""
		read -p "Select an option [1-5]: " -e -i 1 option

              case $option in
             1)
			echo ""
echo -ne "\e[1;33;4;44mTell \r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name for\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name for the\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name for the client\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name for the client cert:\r\e[0m"
echo ""
echo ""
echo '(Please, do not use special characters and spaces)'
echo ''
			read -p "Client name: " -e -i client CLIENT
echo ''
echo ''
if grep -qw "$CLIENT" /etc/openvpn/easy-rsa/pki/index.txt;
 then echo "This name in already taken"

echo ''
echo ''
echo ''
echo 'List of exist client:'
tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | nl -s ') '
exit 10
 fi


echo -ne '\e[1;33;4;44mDoes\r\e[0m'
sleep 0.1
echo -ne '\e[1;33;4;44mDoes $CLIENT\r\e[0m'
sleep 0.1
echo -ne '\e[1;33;4;44mDoes $CLIENT need\r\e[0m'
sleep 0.1
echo -ne '\e[1;33;4;44mDoes $CLIENT need password\r\e[0m'
sleep 0.1
echo -ne '\e[1;33;4;44mDoes $CLIENT need password for\r\e[0m'
sleep 0.1
echo -ne "\e[1;33;4;44mDoes $CLIENT need password for authorization?\r\e[0m"
echo ""
echo ""

	echo "   1) Yes, set password"
	echo "   2) No, do not set password"
	while [[ $SET_PASSWORD != "1" && $SET_PASSWORD != "2" ]]; do
echo ""
    read -p "What is about password? [1-2]: " -e -i 1 SET_PASSWORD
echo ""
	done


		
case $SET_PASSWORD in
		1)
          cd /etc/openvpn/easy-rsa/ 
          ./easyrsa build-client-full $CLIENT
		;;
		2) 
          cd /etc/openvpn/easy-rsa/
          ./easyrsa build-client-full $CLIENT nopass
        ;;
	esac


			newclient "$CLIENT"
			echo ""
			echo "Client $CLIENT added, certs available at ~keys/$CLIENT.ovpn"
			exit
			;;
			2)			
			if [[ "$NUMBEROFCLIENTS" = '0' ]]; then
				echo "You have no existing clients!"
				exit 5
			fi
			echo ""
			echo "Select the existing client certificate you want to revoke"
			tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | nl -s ') '
			if [[ "$NUMBEROFCLIENTS" = '1' ]]; then
				read -p "Select one client [1]: " CLIENTNUMBER
			else
				read -p "Select one client [1-$NUMBEROFCLIENTS]: " CLIENTNUMBER
			fi
			CLIENT=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | sed -n "$CLIENTNUMBER"p)
			cd /etc/openvpn/easy-rsa/
			./easyrsa --batch revoke $CLIENT
			EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
			rm -rf pki/reqs/$CLIENT.req
			rm -rf pki/private/$CLIENT.key
			rm -rf pki/issued/$CLIENT.crt
			rm -rf /etc/openvpn/crl.pem
			cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
			chmod 644 /etc/openvpn/crl.pem
            rm -f $DSTORE$CLIENT
			echo ""
			echo "Certificate for client $CLIENT revoked"
			echo "Exiting..."
			exit
			;;

 			3)
                        tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | nl -s ') '
                         if [[ "$NUMBEROFCLIENTS" = '0' ]]; then
				echo "You have no existing clients!"
				exit 5
			fi

                        exit
                        ;;
			4)
			echo ""
while [[ $REMOVE != "y" && $REMOVE != "n" ]]; do
			echo ""
			read -p "Do you really want to remove OpenVPN? [y/n]: " -e -i n REMOVE
		done

		if [[ "$REMOVE" = 'y' ]]; then
				PORT=$(grep '^port ' /etc/openvpn/server.conf | cut -d " " -f 2)
				if pgrep firewalld; then
					# Using both permanent and not permanent rules to avoid a firewalld reload.
					firewall-cmd --zone=public --remove-port=$PORT/udp
					firewall-cmd --zone=trusted --remove-source=10.8.0.0/24
					firewall-cmd --permanent --zone=public --remove-port=$PORT/udp
					firewall-cmd --permanent --zone=trusted --remove-source=10.8.0.0/24
				fi
				if iptables -L -n | grep -qE 'REJECT|DROP'; then
					if [[ "$PROTOCOL" = 'udp' ]]; then
						iptables -D INPUT -p udp --dport $PORT -j ACCEPT
					else
						iptables -D INPUT -p tcp --dport $PORT -j ACCEPT
					fi
					iptables -D FORWARD -s 10.8.0.0/24 -j ACCEPT
					iptables-save > $IPTABLES
				fi
				iptables -t nat -D POSTROUTING -o $NIC -s 10.8.0.0/24 -j MASQUERADE
				iptables-save > $IPTABLES
				if hash sestatus 2>/dev/null; then
					if sestatus | grep "Current mode" | grep -qs "enforcing"; then
						if [[ "$PORT" != '1194' ]]; then
							semanage port -d -t openvpn_port_t -p udp $PORT
						fi
					fi
				fi
				if [[ "$OS" = 'debian' ]]; then
					apt-get autoremove --purge -y openvpn
				elif [[ "$OS" = 'arch' ]]; then
					pacman -R openvpn --noconfirm
				else
					yum remove openvpn -y
				fi
				rm -rf /etc/openvpn
				rm -rf /usr/share/doc/openvpn*
				echo ""
				echo "OpenVPN removed!"
			else
				echo ""
				echo "Removal aborted!"
			fi
			exit
			;;
			4) exit;;
		esac
	done
else
	clear
echo "########################################################################################################
#                                                               #                                      #
#            OpenVPN installer for all Linux families           #    ░░░░░██▀▀▀▀▀▀▀▀▀▀▀████████░░░░    #
#                                                               #    ░░░░██░░░░░░░░░░░░░░███████░░░    #
#                           Made by                             #    ░░░██░░░░░░░░░░░░░░░████████░░    #
#                                                               #    ░░░█▀░░░░░░░░░░░░░░░▀███████░░    #
#    ██████╗  ██████╗ ██████╗ ████████╗███╗   ██╗██╗██╗  ██╗    #    ░░░█▄▄██▄░░░▀█████▄░░▀██████░░    #
#    ██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝████╗  ██║██║██║ ██╔╝    #    ░░░█▀███▄▀░░░▄██▄▄█▀░░░█████▄░    #
#    ██████╔╝██║   ██║██████╔╝   ██║   ██╔██╗ ██║██║█████╔╝     #    ░░░█░░▀▀█░░░░░▀▀░░░▀░░░██░░▀▄█    #
#    ██╔══██╗██║   ██║██╔══██╗   ██║   ██║╚██╗██║██║██╔═██╗     #    ░░░█░░░█░░░▄░░░░░░░░░░░░░██░██    #
#    ██████╔╝╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║██║  ██╗    #    ░░░█░░█▄▄▄▄█▄▀▄░░░░░░░░░▄▄█▄█░    #
#    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝    #    ░░░█░░█▄▄▄▄▄▄░▀▄░░░░░░░░▄░▀█░░    #
#                                                               #    ░░░█░█▄████▀██▄▀░░░░░░░█░▀▀░░░    #
#################################################################    ░░░░██▀░▄▄▄▄░░░▄▀░░░░▄▀█░░░░░░    #
#                                                               #    ░░░░░█▄▀░░░░▀█▀█▀░▄▄▀░▄▀░░░░░░    #
#        By the help of this script you will be able to         #    ░░░░░▀▄░░░░░░░░▄▄▀░░░░█░░░░░░░    #
#                                                               #    ░░░░░▄██▀▀▀▀▀▀▀░░░░░░░█▄░░░░░░    #
#         setup your own VPN server in a few clicks             #    ░░▄▄▀░░░▀▄░░░░░░░░░░▄▀░▀▀▄░░░░    #
#                                                               #    ▄▀▀░░░░░░░█▄░░░░░░▄▀░░░░░░█▄░░    #
#        even if you have never used OpenVPN before             #    █░░░░░░░░░░░░░░░░░░░░░░░░░░▀█▄    #
#################################################################    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    #
#           You may be interested in other my scripts           #    █▄░░█ █▀▀█ ▀▀█▀▀░░█▀▀█ █▀▀█ █▀▀▄  #
#                                                               #    █░█░█ █░░█ ░░█░░░░█▀▀▄ █▄▄█ █░░█  #
#                https://github.com/emobortnik                  #    █░░▀█ █▄▄█ ░░█░░░░█▄▄█ █░░█ █▄▄▀  #
#                                                               #                                      #
########################################################################################################"
echo ""

newclient () {
	# Where to write the custom client.ovpn?


	# Generates the custom client.ovpn
	cp /etc/openvpn/client-template.txt $DSTORE/$1.ovpn
	echo "<ca>" >> $DSTORE/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> $DSTORE/$1.ovpn
	echo "</ca>" >> $DSTORE/$1.ovpn
	echo "<cert>" >> $DSTORE/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> $DSTORE/$1.ovpn
	echo "</cert>" >> $DSTORE/$1.ovpn
	echo "<key>" >> $DSTORE/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/private/$1.key >> $DSTORE/$1.ovpn
	echo "</key>" >> $DSTORE/$1.ovpn
	echo "key-direction 1" >> $DSTORE/$1.ovpn
	echo "<tls-auth>" >> $DSTORE/$1.ovpn
	cat /etc/openvpn/tls-auth.key >> $DSTORE/$1.ovpn
	echo "</tls-auth>" >> $DSTORE/$1.ovpn
}


wgetgit > /dev/null 2>&1

echo ""
read -n1 -r -p "                           Press any key to start the installation"
clear
echo -ne '\e[1;33;4;44Where\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44Where do\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44Where do you\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhere do you want\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhere do you want to\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhere do you want to store\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhere do you want to store made\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhere do you want to store made ovpn\r\e[0m' 
echo -ne '\e[1;33;4;44mWhere do you want to store made ovpn certificate?\e[0m'
echo ""
echo ""
read -p "Path [can write own]: " -e -i /home/vpn/ DSTORE

if ! [ -d $DSTORE ]; then
mkdir -p $DSTORE/keys/ && mkdir -p $DSTORE/logs
fi

ENDSTORE=$(echo $DSTORE/keys | sed s#//*#/#g)


echo ""
echo ""
echo -ne "\e[1;33;4;44mTell \r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name for\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name for the\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name for the client\r\e[0m"
sleep 0.05
echo -ne "\e[1;33;4;44mTell me unique name for the client cert:\r\e[0m"
echo ""
echo ""
echo '(Please, do not use special characters and spaces)'
echo ''
			read -p "Client name: " -e -i client CLIENT

echo ''
echo ''
echo -ne '\e[1;33;4;44mDoes\r\e[0m'
sleep 0.1
echo -ne '\e[1;33;4;44mDoes $CLIENT\r\e[0m'
sleep 0.1
echo -ne '\e[1;33;4;44mDoes $CLIENT need\r\e[0m'
sleep 0.1
echo -ne '\e[1;33;4;44mDoes $CLIENT need password\r\e[0m'
sleep 0.1
echo -ne '\e[1;33;4;44mDoes $CLIENT need password for\r\e[0m'
sleep 0.1
echo -ne "\e[1;33;4;44mDoes $CLIENT need password for authorization?\r\e[0m"
echo ""
echo ""

	echo "   1) Yes, set password"
	echo "   2) No, do not set password"
	while [[ $SET_PASSWORD != "1" && $SET_PASSWORD != "2" ]]; do
echo ""
    read -p "What is about password? [1-2]: " -e -i 1 SET_PASSWORD
echo ""
	done


		
case $SET_PASSWORD in
		1)
          cd /etc/openvpn/easy-rsa/ 
          ./easyrsa build-client-full $CLIENT > /dev/null 2>&1 
		;;
		2) 
          cd /etc/openvpn/easy-rsa/
          ./easyrsa build-client-full $CLIENT nopass > /dev/null 2>&1 
        ;;
	esac



			
echo ""
echo ""
echo -ne '\e[1;33;4;44mWhat \r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat port\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat port do\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat port do you\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat port do you want\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat port do you want for\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat port do you want for OpenVPN?\r\e[0m'
sleep 0.05
echo ""
echo ""
read -p "Port [any unused]: " -e -i 1194 PORT
echo ""
echo ""
echo ""
echo -ne '\e[1;33;4;44mWhat\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat protocol\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat protocol do\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat protocol do you\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat protocol do you want\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat protocol do you want for\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat protocol do you want for OpenVPN?\r\e[0m'
sleep 0.05
echo ""
echo ""
echo -e "\e[1;34mUDP Connection:\e[0m"
echo "- is usually faster then TCP. UDP is ideal for video/audio streaming and P2P traffic"
echo "- is recommended for VPN connection, especially those running over non-blocked ports such as 53 (DNS system)"
echo "- is unreliable sometimes, because UDP protocol does not guarantee delivery of packets to destination."
echo ""	
echo -e "\e[1;34mTCP Connection:\e[0m"
echo "- is usually slower than UDP because in advance establish connections with addressee"
echo "- is usually allowed and not blocked, while UDP traffic may be blocked, usually in corporate networks"
echo "- is more reliable because after a TCP packet is sent, ACK packet is received as a reply to confirm acknowledgement."
echo "- is not recommended if UDP is working fine."
while [[ $PROTOCOL != "UDP" && $PROTOCOL != "TCP" ]]; do
        echo ""
	read -p "Protocol [UDP/TCP]: " -e -i UDP PROTOCOL
         
                                             done




	echo ""
echo ""
echo ""
echo -ne '\e[1;33;4;44mWhat\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS do\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS do you\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS do you want\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS do you want to\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS do you want to use\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS do you want to use with\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS do you want to use with the\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS do you want to use with the VPN\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mWhat DNS do you want to use with the VPN?\r\e[0m'
sleep 0.05
echo ""
echo ""
echo "   1) Current system resolvers (from /etc/resolv.conf)"
echo "   2) Quad9 (Anycast: worldwide)"
echo "   3) FDN (France)"
echo "   4) DNS.WATCH (Germany)"
echo "   5) OpenDNS (Anycast: worldwide)"
echo "   6) Google (Anycast: worldwide)"
echo "   7) Yandex Basic (Russia)"
echo "   8) AdGuard DNS (Russia)"
while [[ $DNS != "1" && $DNS != "2" && $DNS != "3" && $DNS != "4" && $DNS != "5" && $DNS != "6" && $DNS != "7" && $DNS != "8" ]]; do
        echo ""
		read -p "DNS [1-8]: " -e -i 6 DNS
	                                                                                                                              done
echo ""
echo ""
echo ""
echo -ne '\e[1;33;4;44mChoose\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do you\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do you want\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do you want to\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do you want to use\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do you want to use for\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do you want to use for the\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do you want to use for the data\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do you want to use for the data channel\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose which cipher do you want to use for the data channel:\r\e[0m'
sleep 0.05
echo ""
echo ""
echo "   1) AES-128-CBC (The fastest but not the best sufficiently secure, recommended unless you're not under surveillance)"
echo "   2) AES-192-CBC (Fast and sufficiently secure for everyone, recommended)"
echo "   3) AES-256-CBC"
echo ""
echo "Alternatives to AES. Difficult to compare strengths, both have received cryptographic analysis (AES more publicly) and they are good for securing data."
echo ""
echo "   4) CAMELLIA-128-CBC"
echo "   5) CAMELLIA-192-CBC"
echo "   6) CAMELLIA-256-CBC (The best security among all, recommended only if you are indeed under surveillance.)"
echo "   7) SEED-CBC"


while [[ $CIPHER != "1" && $CIPHER != "2" && $CIPHER != "3" && $CIPHER != "4" && $CIPHER != "5" && $CIPHER != "6" && $CIPHER != "7" ]]; do
        echo ''
		read -p "Cipher [1-7]: " -e -i 1 CIPHER
                                                                                                                                      	done
	case $CIPHER in
		1)
		CIPHER="cipher AES-128-CBC"
		;;
		2)
		CIPHER="cipher AES-192-CBC"
		;;
		3)
		CIPHER="cipher AES-256-CBC"
		;;
		4)
		CIPHER="cipher CAMELLIA-128-CBC"
		;;
		5)
		CIPHER="cipher CAMELLIA-192-CBC"
		;;
		6)
		CIPHER="cipher CAMELLIA-256-CBC"
		;;
		7)
		CIPHER="cipher SEED-CBC"
		;;
	esac



	echo ""
echo ""
echo ""
echo ""
echo -ne '\e[1;33;4;44mChoose\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of Diffie-Hellman\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of Diffie-Hellman key\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of Diffie-Hellman key do\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of Diffie-Hellman key do you\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of Diffie-Hellman key do you want\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of Diffie-Hellman key do you want to\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of Diffie-Hellman key do you want to use:\r\e[0m'
sleep 0.05
echo ""
echo ""
echo "   1) 2048 bits (fastest)"
echo "   2) 3072 bits (recommended, best compromise)"
echo "   3) 4096 bits (most secure)"
	while [[ $DH_KEY_SIZE != "1" && $DH_KEY_SIZE != "2" && $DH_KEY_SIZE != "3" ]]; do
        echo ''
		read -p "DH key size [1-3]: " -e -i 1 DH_KEY_SIZE
	                                                                               done
	case $DH_KEY_SIZE in
		1)
		DH_KEY_SIZE="2048"
		;;
		2)
		DH_KEY_SIZE="3072"
		;;
		3)
		DH_KEY_SIZE="4096"
		;;
	esac

echo ""
echo ""
echo ""
echo -ne '\e[1;33;4;44mChoose\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of RSA\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of RSA key\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of RSA key do\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of RSA key do you\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of RSA key do you want\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of RSA key do you want to\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of RSA key do you want to use\r\e[0m'
sleep 0.05
echo -ne '\e[1;33;4;44mChoose what size of RSA key do you want to use:\r\e[0m'
sleep 0.05
echo ''
echo ''
        echo "   1) 2048 bits (fastest)"
	echo "   2) 3072 bits (recommended, best compromise)"
	echo "   3) 4096 bits (most secure)"
echo ''
	while [[ $RSA_KEY_SIZE != "1" && $RSA_KEY_SIZE != "2" && $RSA_KEY_SIZE != "3" ]]; do
		read -p "RSA key size [1-3]: " -e -i 1 RSA_KEY_SIZE
	done
	case $RSA_KEY_SIZE in
		1)
		RSA_KEY_SIZE="2048"
		;;
		2)
		RSA_KEY_SIZE="3072"
		;;
		3)
		RSA_KEY_SIZE="4096"
		;;
	esac
echo "set_var EASYRSA_KEY_SIZE $RSA_KEY_SIZE" > /etc/openvpn/easy-rsa/vars
echo ""
echo ""
echo ""


echo -ne '\e[1;33;4;44mOkay, that was all I needed. Installation will start in 5 seconds...\r\e[0m\n'
sleep 1
echo -ne '\e[1;33;4;44mOkay, that was all I needed. Installation will start in 4 seconds...\r\e[0m\n'
sleep 1
echo -ne '\e[1;33;4;44mOkay, that was all I needed. Installation will start in 3 seconds...\r\e[0m\n'
sleep 1
echo -ne '\e[1;33;4;44mOkay, that was all I needed. Installation will start in 2 seconds...\r\e[0m\n'
sleep 1
echo -ne '\e[1;33;4;44mOkay, that was all I needed. Installation will start in 1 seconds...\r\e[0m\n'
echo ''
echo ''
sleep 1

	if [[ "$OS" = 'debian' ]]; then
		apt-get install ca-certificates -y
		# We add the OpenVPN repo to get the latest version.
		# Debian 7
		if [[ "$VERSION_ID" = 'VERSION_ID="7"' ]]; then
			echo "deb http://build.openvpn.net/debian/openvpn/stable wheezy main" > /etc/apt/sources.list.d/openvpn.list
			wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
			apt-get update
		fi
		# Debian 8
		if [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then
			echo "deb http://build.openvpn.net/debian/openvpn/stable jessie main" > /etc/apt/sources.list.d/openvpn.list
			wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
			apt update
		fi
		# Ubuntu 12.04
		if [[ "$VERSION_ID" = 'VERSION_ID="12.04"' ]]; then
			echo "deb http://build.openvpn.net/debian/openvpn/stable precise main" > /etc/apt/sources.list.d/openvpn.list
			wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
			apt-get update
		fi
		# Ubuntu 14.04
		if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
			echo "deb http://build.openvpn.net/debian/openvpn/stable trusty main" > /etc/apt/sources.list.d/openvpn.list
			wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
			apt-get update
		fi
		# Ubuntu >= 16.04 and Debian > 8 have OpenVPN > 2.3.3 without the need of a third party repository.
		# The we install OpenVPN
		apt-get install openvpn iptables openssl wget ca-certificates curl -y
		# Install iptables service
		if [[ ! -e /etc/systemd/system/iptables.service ]]; then
			mkdir /etc/iptables
			iptables-save > /etc/iptables/iptables.rules
			echo "#!/bin/sh
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT" > /etc/iptables/flush-iptables.sh
			chmod +x /etc/iptables/flush-iptables.sh
			echo "[Unit]
Description=Packet Filtering Framework
DefaultDependencies=no
Before=network-pre.target
Wants=network-pre.target
[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore /etc/iptables/iptables.rules
ExecReload=/sbin/iptables-restore /etc/iptables/iptables.rules
ExecStop=/etc/iptables/flush-iptables.sh
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/iptables.service
			systemctl daemon-reload
			systemctl enable iptables.service
		fi
	elif [[ "$OS" = 'centos' || "$OS" = 'fedora' ]]; then
		if [[ "$OS" = 'centos' ]]; then
			yum install epel-release -y
		fi
		yum install openvpn iptables openssl wget ca-certificates curl -y
		# Install iptables service
		if [[ ! -e /etc/systemd/system/iptables.service ]]; then
			mkdir /etc/iptables
			iptables-save > /etc/iptables/iptables.rules
			echo "#!/bin/sh
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT" > /etc/iptables/flush-iptables.sh
			chmod +x /etc/iptables/flush-iptables.sh
			echo "[Unit]
Description=Packet Filtering Framework
DefaultDependencies=no
Before=network-pre.target
Wants=network-pre.target
[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore /etc/iptables/iptables.rules
ExecReload=/sbin/iptables-restore /etc/iptables/iptables.rules
ExecStop=/etc/iptables/flush-iptables.sh
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/iptables.service
			systemctl daemon-reload
			systemctl enable iptables.service
			# Disable firewalld to allow iptables to start upon reboot
			systemctl disable firewalld
			systemctl mask firewalld
		fi
	else
		# Else, the distro is ArchLinux
		echo ""
		echo ""
		echo "As you're using ArchLinux, I need to update the packages on your system to install those I need."
		echo "Not doing that could cause problems between dependencies, or missing files in repositories."
		echo ""
		echo "Continuing will update your installed packages and install needed ones."
		while [[ $CONTINUE != "y" && $CONTINUE != "n" ]]; do
			read -p "Continue ? [y/n]: " -e -i y CONTINUE
		done
		if [[ "$CONTINUE" = "n" ]]; then
			echo "Ok, bye !"
			exit 4
		fi

		if [[ "$OS" = 'arch' ]]; then
			# Install dependencies
			pacman -Syu openvpn iptables openssl wget ca-certificates curl --needed --noconfirm
			iptables-save > /etc/iptables/iptables.rules # iptables won't start if this file does not exist
			systemctl daemon-reload
			systemctl enable iptables
			systemctl start iptables
		fi
	fi
	# Find out if the machine uses nogroup or nobody for the permissionless group
	if grep -qs "^nogroup:" /etc/group; then
		NOGROUP=nogroup
	else
		NOGROUP=nobody
	fi


	# Generate server.conf
	echo "port $PORT" > /etc/openvpn/server.conf
	if [[ "$PROTOCOL" = 'UDP' ]]; then
		echo "proto udp" >> /etc/openvpn/server.conf
	elif [[ "$PROTOCOL" = 'TCP' ]]; then
		echo "proto tcp" >> /etc/openvpn/server.conf
	fi
	echo "dev tun
user nobody
group $NOGROUP
persist-key
persist-tun
keepalive 10 120
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt" >> /etc/openvpn/server.conf
	# DNS resolvers
	case $DNS in
		1)
		# Obtain the resolvers from resolv.conf and use them for OpenVPN
		grep -v '#' /etc/resolv.conf | grep 'nameserver' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | while read line; do
			echo "push \"dhcp-option DNS $line\"" >> /etc/openvpn/server.conf
		done
		;;
		2) #Quad9
		echo 'push "dhcp-option DNS 9.9.9.9"' >> /etc/openvpn/server.conf
		;;
		3) #FDN
		echo 'push "dhcp-option DNS 80.67.169.12"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 80.67.169.40"' >> /etc/openvpn/server.conf
		;;
		4) #DNS.WATCH
		echo 'push "dhcp-option DNS 84.200.69.80"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 84.200.70.40"' >> /etc/openvpn/server.conf
		;;
		5) #OpenDNS
		echo 'push "dhcp-option DNS 208.67.222.222"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 208.67.220.220"' >> /etc/openvpn/server.conf
		;;
		6) #Google
		echo 'push "dhcp-option DNS 8.8.8.8"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 8.8.4.4"' >> /etc/openvpn/server.conf
		;;
		7) #Yandex Basic
		echo 'push "dhcp-option DNS 77.88.8.8"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 77.88.8.1"' >> /etc/openvpn/server.conf
		;;
		8) #AdGuard DNS
		echo 'push "dhcp-option DNS 176.103.130.130"' >> /etc/openvpn/server.conf
		echo 'push "dhcp-option DNS 176.103.130.131"' >> /etc/openvpn/server.conf
		;;
	esac
echo 'push "redirect-gateway def1 bypass-dhcp" '>> /etc/openvpn/server.conf
echo "crl-verify crl.pem
ca ca.crt
cert server.crt
key server.key
tls-auth tls-auth.key 0
dh dh.pem
auth SHA256
$CIPHER
tls-server
tls-version-min 1.2
tls-cipher TLS-DHE-RSA-WITH-AES-128-GCM-SHA256
status openvpn.log
verb 3" >> /etc/openvpn/server.conf



	# Create the sysctl configuration file if needed (mainly for Arch Linux)
	if [[ ! -e $SYSCTL ]]; then
		touch $SYSCTL
	fi

	# Enable net.ipv4.ip_forward for the system
	sed -i '/\<net.ipv4.ip_forward\>/c\net.ipv4.ip_forward=1' $SYSCTL
	if ! grep -q "\<net.ipv4.ip_forward\>" $SYSCTL; then
		echo 'net.ipv4.ip_forward=1' >> $SYSCTL
	fi
	# Avoid an unneeded reboot
	echo 1 > /proc/sys/net/ipv4/ip_forward
	# Set NAT for the VPN subnet
	iptables -t nat -A POSTROUTING -o $NIC -s 10.8.0.0/24 -j MASQUERADE
	# Save persitent iptables rules
	iptables-save > $IPTABLES
	if pgrep firewalld; then
		# We don't use --add-service=openvpn because that would only work with
		# the default port. Using both permanent and not permanent rules to
		# avoid a firewalld reload.
		if [[ "$PROTOCOL" = 'UDP' ]]; then
			firewall-cmd --zone=public --add-port=$PORT/udp
			firewall-cmd --permanent --zone=public --add-port=$PORT/udp
		elif [[ "$PROTOCOL" = 'TCP' ]]; then
			firewall-cmd --zone=public --add-port=$PORT/tcp
			firewall-cmd --permanent --zone=public --add-port=$PORT/tcp
		fi
		firewall-cmd --zone=trusted --add-source=10.8.0.0/24
		firewall-cmd --permanent --zone=trusted --add-source=10.8.0.0/24
	fi
	if iptables -L -n | grep -qE 'REJECT|DROP'; then
		# If iptables has at least one REJECT rule, we asume this is needed.
		# Not the best approach but I can't think of other and this shouldn't
		# cause problems.
		if [[ "$PROTOCOL" = 'UDP' ]]; then
			iptables -I INPUT -p udp --dport $PORT -j ACCEPT
		elif [[ "$PROTOCOL" = 'TCP' ]]; then
			iptables -I INPUT -p tcp --dport $PORT -j ACCEPT
		fi
		iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
		iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
		# Save persitent OpenVPN rules
        iptables-save > $IPTABLES
	fi
	# If SELinux is enabled and a custom port was selected, we need this
	if hash sestatus 2>/dev/null; then
		if sestatus | grep "Current mode" | grep -qs "enforcing"; then
			if [[ "$PORT" != '1194' ]]; then
				# semanage isn't available in CentOS 6 by default
				if ! hash semanage 2>/dev/null; then
					yum install policycoreutils-python -y
				fi
				if [[ "$PROTOCOL" = 'UDP' ]]; then
					semanage port -a -t openvpn_port_t -p udp $PORT
				elif [[ "$PROTOCOL" = 'TCP' ]]; then
					semanage port -a -t openvpn_port_t -p tcp $PORT
				fi
			fi
		fi
	fi
	# And finally, restart OpenVPN

restartservice  > /dev/null 2>&1

	# Try to detect a NATed connection and ask about it to potential LowEndSpirit/Scaleway users

	# client-template.txt is created so we have a template to add further users later
	echo "client" > /etc/openvpn/client-template.txt
	if [[ "$PROTOCOL" = 'UDP' ]]; then
		echo "proto udp" >> /etc/openvpn/client-template.txt
	elif [[ "$PROTOCOL" = 'TCP' ]]; then
		echo "proto tcp-client" >> /etc/openvpn/client-template.txt
	fi
	echo "remote $IP $PORT
dev tun
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA256
auth-nocache
$CIPHER
tls-client
tls-version-min 1.2
tls-cipher TLS-DHE-RSA-WITH-AES-128-GCM-SHA256
setenv opt block-outside-dns
verb 3" >> /etc/openvpn/client-template.txt
echo ''
echo ''
        # Create the PKI, set up the CA, the DH params and the server + client certificates
        cd /etc/openvpn/easy-rsa
        openssl dhparam -out dh.pem $DH_KEY_SIZE
        ./easyrsa build-server-full server nopass > /dev/null 2>&1
        EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl > /dev/null 2>&1  
        openvpn --genkey --secret /etc/openvpn/tls-auth.key > /dev/null 2>&1
        # Move all the generated files
        cp pki/ca.crt pki/private/ca.key dh.pem pki/issued/server.crt pki/private/server.key /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn > /dev/null 2>&1
        # Make cert revocation list readable for non-root
        chmod 644 /etc/openvpn/crl.pem 


newclient "$CLIENT"

echo ''
echo ''
echo "Finished!"
echo ""

 echo -e "Your client config is available at \e[42m$ENDSTORE/$CLIENT.ovpn\e[0m"
       echo "If you want to add more clients, you simply need to run this script another time!"


        while [[ $AGAIN != "y" && $AGAIN != "n" ]]; do
echo ""
    read -p "Execute again to add more clients?: " -e -i yes AGAIN
echo ""
        done

if [ $AGAIN != "y" ]; then
exit
else
echo num
fi



fi
exit 0;

