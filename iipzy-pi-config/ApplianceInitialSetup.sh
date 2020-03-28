#!/bin/bash
# Get image from https://www.raspberrypi.org/downloads/raspbian/ -- lite
# 
# Use DISKPART to initialize sd card
# 
# 	diskpart
# 	>list disk
# 	>select disk n
# 	>list disk
# 	>clean
# 	>list disk
# 	>create partition primary
# 	>list disk
# 	>exit
# 
# Use balenaEtcher to flash image to micro sd.
# 
# ====================================
# Enable SSH using connected keyboard and monitor/
# 	see https://www.raspberrypi.org/documentation/remote-access/ssh/
# ====================================
# 
# 	sudo systemctl enable ssh
# 	sudo systemctl start ssh
#	- note address.
#	ip addr
# 
# ====================================
# After this, use ssh
# ====================================
# 
# ====================================
# Install git
# ====================================
#
# fix up <username:password>@<git-repository> in the git clone request below.
#
#	sudo apt-get update
#
# 	sudo apt-get install git -y
# 
# 	git config --global user.name "User Name"
# 	git config --global user.email email@x.y
# 
# 	pwd
# 	/home/pi
# 	mkdir /home/pi/iipzy-service-a
# 	cd /home/pi/iipzy-service-a
# 	git init
# 	git remote add origin http://192.168.1.65/Bonobo.Git.Server/iipzy-pi
# 
# Get this install script
# 
# 	git clone http://<username:password>@<git-repository>/iipzy-configs-private.git
# 
# ====================================
# Run this script
# ====================================
# 
# 	/bin/bash /home/pi/iipzy-service-a/iipzy-configs-private/iipzy-pi-config/ApplianceInitialSetup.sh
# 
echo ====================================
echo Set timezone UTC
echo ====================================
# 
sudo timedatectl set-timezone UTC
# 
echo ====================================
echo Create iipzy folders
echo ====================================
#
mkdir /home/pi/iipzy-service-b
mkdir /home/pi/iipzy-sentinel-web-a
mkdir /home/pi/iipzy-sentinel-web-b
mkdir /home/pi/iipzy-sentinel-admin-a
mkdir /home/pi/iipzy-sentinel-admin-b
mkdir /home/pi/iipzy-updater-a
mkdir /home/pi/iipzy-updater-b
mkdir /home/pi/iipzy-updater-config
cd /home/pi/iipzy-service-a
# 
echo ====================================
echo Install unzip
echo ====================================
#
sudo apt install unzip
# 
echo ====================================
echo Install node.js
echo ====================================
# Install Node.js on Raspberry Pi	- from https://www.w3schools.com/nodejs/nodejs_raspberrypi.asp
# 
# 	With the Raspberry Pi properly set up, login in via SSH, and update your Raspberry Pi system packages to their latest versions.
# 
# 	Update your system package list:
# 
sudo apt-get update -y
# 
# 	Upgrade all your installed packages to their latest version:
# 
sudo apt-get dist-upgrade -y
# 
# 		Doing this regularly will keep your Raspberry Pi installation up to date.
# 
# 	To download and install newest version of Node.js, use the following command:
# 
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
# 
# 	Now install it by running:
# 
sudo apt-get install -y nodejs
# 
# 	Check that the installation was successful, and the version number of Node.js with:
# 
node -v
# 
npm config set package-lock false
# 
echo ====================================
echo Install static web server
echo ====================================
#
sudo npm install -g serve
#
echo ====================================
echo Create directories.
echo ====================================
#
# 
# 	- create /var/log/iipzy so that directory is writable by non-root
# 
sudo mkdir /var/log/iipzy
sudo chown pi:pi /var/log/iipzy
# 
# 	- create /etc/iipzy
# 
sudo mkdir /etc/iipzy
sudo chmod 777 /etc/iipzy
echo '{"serverAddress":"iipzy.net:8001"}' > /etc/iipzy/iipzy.json
#
echo ====================================
echo Install Sentinel
echo ====================================
#
cd /home/pi/iipzy-service-a
git clone http://<username:password>@<git-repository>/iipzy-shared.git
git clone http://<username:password>@<git-repository>/iipzy-pi.git
# 
# install iipzy-pi stuff
# 
cd /home/pi/iipzy-service-a
# 
cd /home/pi/iipzy-service-a/iipzy-shared
npm i
cd /home/pi/iipzy-service-a/iipzy-pi
npm i
#
echo ====================================
echo Install Sentinel-Web
echo ====================================
# 
cd /home/pi/iipzy-sentinel-web-a
git clone http://<username:password>@<git-repository>/iipzy-shared.git
git clone http://<username:password>@<git-repository>/iipzy-sentinel-web.git
# 
# install  iipzy-sentinel-web stuff
# 
cd /home/pi/iipzy-sentinel-web-a/iipzy-shared
npm i
cd /home/pi/iipzy-sentinel-web-a/iipzy-sentinel-web
npm i
#
echo ====================================
echo Build Sentinel-Web
echo ====================================						 
# 
npm run build
# 
# 	- test
# 
# 	npm start
# 
echo ====================================
echo Install Sentinel Admin
echo ====================================
# 
cd /home/pi/iipzy-sentinel-admin-a
git clone http://<username:password>@<git-repository>/iipzy-shared.git
git clone http://<username:password>@<git-repository>/iipzy-sentinel-admin.git
# 
# install  iipzy-sentinel-admin stuff
# 
cd /home/pi/iipzy-sentinel-admin-a/iipzy-shared
npm i
cd /home/pi/iipzy-sentinel-admin-a/iipzy-sentinel-admin
npm i
# 
# 	- test
# 
# 	npm start
# 
echo ====================================
echo Install Updater
echo ====================================
# 
cd /home/pi/iipzy-updater-a
git clone http://<username:password>@<git-repository>/iipzy-shared.git
git clone http://<username:password>@<git-repository>/iipzy-updater.git
# 
# install  iipzy-updater stuff
# 
cd /home/pi/iipzy-updater-a/iipzy-shared
npm i
cd /home/pi/iipzy-updater-a/iipzy-updater
npm i
# 
# 	- test
# 
# 	npm start
# 
echo ====================================
echo Install network monitoring tools
echo ====================================
# 
# For network monitor, promiscuous mode
# 
# 	the file /etc/network/interfaces...
# 
# 		#  interfaces(5) file used by ifup(8) and ifdown(8)
# 
# 		#  Please note that this file is written to be used with dhcpcd
# 		#  For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'
# 
# 		#  Include files from /etc/network/interfaces.d:
# 		source-directory /etc/network/interfaces.d
# 
# 		auto eth0
# 		iface eth0 inet manual
# 		        up ifconfig eth0 promisc up
# 		        down ifconfig eth0 promisc down
# 
sudo cp /home/pi/iipzy-service-a/iipzy-pi/src/extraResources/interfaces /etc/network/interfaces
# 
# For Bonjour monitoring in iipzy-pi
# 
cd /home/pi/iipzy-service-a/iipzy-pi
# 
# 	- install libpcap-dev
# 
sudo apt-get install libpcap-dev -y
# 
npm i pcap
sudo apt-get install arp-scan -y
sudo apt-get install nbtscan -y
sudo apt-get install avahi-utils -y
# 
# For cpu monitoring
# 
sudo apt-get install sysstat -y
#
echo ====================================
echo Build and install iperf3
echo ====================================
# 
# 	- build iperf3 - see https://software.es.net/iperf/building.html
# 
cd /home/pi
git clone http://<username:password>@<git-repository>/iperf3.git
cd /home/pi/iperf3
sudo chmod 777 /usr/local/lib
sudo chmod 777 /usr/local/bin
sudo chmod 777 /usr/local/include
sudo chmod 777 /usr/local/share/man
sudo ./configure --disable-shared 
sudo make 
sudo make install
# 
# 	- test
# 
iperf3
# 
echo =================================== 
echo Install Sentinel services.
echo =================================== 
#
cd /home/pi/iipzy-service-a/iipzy-pi
sudo cp src/extraResources/iipzy-pi-a.service /etc/systemd/system/.
sudo cp src/extraResources/iipzy-pi-b.service /etc/systemd/system/.
sudo systemctl enable iipzy-pi-a
sudo systemctl start iipzy-pi-a
sudo systemctl status iipzy-pi-a
# 
# 		 ? iipzy-pi.service - Node.js iipzy-pi
# 		 Loaded: loaded (/etc/systemd/system/iipzy-pi.service; enabled; vendor preset: enabled)
# 		 Active: active (running) since Sat 2019-07-27 00:11:01 BST; 5s ago
# 		 Main PID: 25911 (node)
# 		 Tasks: 12 (limit: 4035)
# 		 Memory: 18.7M
# 		 CGroup: /system.slice/iipzy-pi.service
# 		         +-25911 /usr/bin/node /home/pi/iipzy-service/iipzy-pi/src/index.js
# 		         +-25925 ping google.com
# 
# 		Jul 27 00:11:02 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:02.973+01:00 info  [cfg ] ...get, key=pingTarget, val=undefined
# 		Jul 27 00:11:02 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:02.973+01:00 info  [ping] ping.constructor: title = pingPlot, target = google.com, duration = 0, interval 5
# 		Jul 27 00:11:03 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:03.067+01:00 info  [send] ...ipcSend.emit: event = ipc_007, data = true
# 		Jul 27 00:11:03 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:03.068+01:00 info  [ewtr] addEvent: event =  ipc_007, data = true
# 		Jul 27 00:11:04 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:04.001+01:00 info  [rjmg] RemoteJobManager.run - before GET
# 		Jul 27 00:11:04 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:04.589+01:00 info  [ewtr] ...check queue, curts = 1564182664589, eventts = 1564182662584
# 		Jul 27 00:11:05 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:05.010+01:00 info  [rjmg] RemoteJobManager.run - before GET
# 		Jul 27 00:11:06 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:06.018+01:00 info  [rjmg] RemoteJobManager.run - before GET
# 		Jul 27 00:11:06 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:06.590+01:00 info  [ewtr] ...check queue, curts = 1564182666590, eventts = 1564182662584
# 		Jul 27 00:11:07 raspberrypi iipzy-pi[25911]: 2019-07-27 00:11:07.024+01:00 info  [rjmg] RemoteJobManager.run - before GET
# 
echo =================================== 
echo Install Sentinel-web services
echo =================================== 
# 
cd /home/pi/iipzy-sentinel-web-a/iipzy-sentinel-web
sudo cp src/extraResources/iipzy-sentinel-web-a.service /etc/systemd/system/.
sudo cp src/extraResources/iipzy-sentinel-web-b.service /etc/systemd/system/.
sudo systemctl enable iipzy-sentinel-web-a
sudo systemctl start iipzy-sentinel-web-a
sudo systemctl status iipzy-sentinel-web-a
# 
echo =================================== 
echo Install Sentinel Admin services
echo =================================== 
# 
cd /home/pi/iipzy-sentinel-admin-a/iipzy-sentinel-admin
sudo cp src/extraResources/iipzy-sentinel-admin-a.service /etc/systemd/system/.
sudo cp src/extraResources/iipzy-sentinel-admin-b.service /etc/systemd/system/.
sudo systemctl enable iipzy-sentinel-admin-a
sudo systemctl start iipzy-sentinel-admin-a
sudo systemctl status iipzy-sentinel-admin-a
# 
echo =================================== 
echo Install Updater services
echo =================================== 
# 
cd /home/pi/iipzy-updater-a/iipzy-updater
sudo cp src/extraResources/iipzy-updater-a.service /etc/systemd/system/.
sudo cp src/extraResources/iipzy-updater-b.service /etc/systemd/system/.
sudo systemctl enable iipzy-updater-a
sudo systemctl start iipzy-updater-a
sudo systemctl status iipzy-updater-a
# 
echo =================================== 
echo Verify installation
echo =================================== 
# check iipzy logs directory
# 
ls -l /var/log/iipzy/
# 
# 	you should see something like...
# 
# 	total 3404
# 	-rw-r--r-- 1 pi pi 1745931 Oct  3 00:31 iipzy-pi-2019-10-03-00.log
# 	-rw-r--r-- 1 pi pi 1719438 Oct  3 00:31 iipzy-pi.log
# 	-rw-r--r-- 1 pi pi    3114 Oct  3 00:31 iipzy-updater-2019-10-03-00.log
# 	-rw-r--r-- 1 pi pi    3114 Oct  3 00:31 iipzy-updater.log
# 
echo =================================== 
echo Remove secret stuff
echo =================================== 
# 
sudo rm -r -f cp /home/pi/iipzy-service-a/iipzy-configs-private
# 
#  check that services are running
# 	ps -Af | grep iipzy
# 	pi        8000     1 23 00:21 ?        00:00:05 /usr/bin/node /home/pi/iipzy-service-a/iipzy-pi/src/index.js
# 	pi        8409   787  0 00:22 pts/0    00:00:00 grep --color=auto iipzy
# 
echo =================================== 
echo Change password
echo =================================== 
# 
echo "pi:iipzy" | sudo chpasswd
# 
echo =================================== 
echo reboot
echo =================================== 
# 
sudo reboot
# 
# ====================================
# 
# Before shipping AND/OR making an image.
#
# 	- stop services.  Note which of "a" or "b" service is active (e.g., "iipzy-pi-a" vs "iipzy-pi-b")
#
# 	ps -Af | grep iipzy
# 	pi        1026     1  0 14:43 ?        00:00:05 /usr/bin/node /home/pi/iipzy-updater-b/iipzy-updater/src/index.js
# 	pi        2161     1  2 15:02 ?        00:01:04 /usr/bin/node /home/pi/iipzy-service-b/iipzy-pi/src/index.js
# 	pi        4924 27819  0 15:51 pts/0    00:00:00 grep --color=auto iipzy
#
#	sudo systemctl stop iipzy-updater-b
#	sudo systemctl stop iipzy-pi-b
# 	
# 	- remove state files from /etc/iipzy
# 	
# 	rm -r -f /etc/iipzy/*
# 	
# 	- initialize /etc/iipzy/iipzy.json
# 
#   echo '{"serverAddress":"iipzy.net:8001"}' > /etc/iipzy/iipzy.json
# 
# 	- remove log files from /var/logs/iipzy/.
#
#	rm -r -f /var/log/iipzy/*
#
#	- change password
#
#	echo "pi:iipzy" | sudo chpasswd
#
#	- zero out to minimize compressed size.  THIS TAKES A LONG TIME. ~30 minutes
#
#	sudo apt-get autoremove -y
#	sudo apt-get clean -y
#	cat /dev/zero >> zero.file;sync;rm zero.file;date
# 
# 	sudo shutdown
# 
# ====================================
#
# Create archive of pi image
#
# ====================================
#
# Use Win32DiskImager to copy image from micro-sd card --> iipzy-server\RPI-images\iipzypi.img
#
# Use 7-zip to compress the .img file.
#

