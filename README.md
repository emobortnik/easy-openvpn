## Description
By the help of this script you will be able to setup your own VPN server in a few clicks, even if you have never used OpenVPN before.

Once the script has executed, you can run it again to add more users (certificates), check list of currently users, remove some of them or even completely uninstall OpenVPN.


### Instruction
1. You need to get server [here](https://scaleway.com).
2. [Connect via ssh](https://www.howtogeek.com/311287/how-to-connect-to-an-ssh-server-from-windows-macos-or-linux/) to your server and then execute following command:

`wget https://git.io/vbAzp -O easy-openvpn-install.sh && chmod +x easy-openvpn-install.sh && ./easy-openvpn-install.sh`

3. [Connect to OpenVPN Server](https://openvpn.net/index.php/access-server/docs/admin-guides-sp-859543150/howto-connect-client-configuration.html) which you have just created via [OpenVPN client](https://openvpn.net/index.php/open-source/downloads.html).



### Requires
* [Easy-rsa](https://github.com/OpenVPN/easy-rsa): Will be installed, if you still have not this app.
* [Enabled TUN module]: By default TUN is enabled on the most servers.
