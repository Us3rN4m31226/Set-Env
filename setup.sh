#!/bin/bash
RED='\033[0;31m'
PURP='\033[0;35m'
WHITE="\[\033[0;37m\]"

if [[ $EUID -ne 0 ]]; then
	printf "${RED}This script must be run as root.\n${WHITE}"
	printf "${PURP}Usage: ${RED}sudo ./setup.sh\n${WHITE}"
	exit
else
	MY_NAME=$(echo $HOME | cut -c 7-50)
	apt update 
	apt install vim openssh-server nmap libc6-i386 -y
	service ssh start
	printf "${PURP}[+] ${RED}vim, ssh, nmap Done.\n${WHITE}"
	apt-get update
	apt-get install python2.7 python-pip python-dev git libssl-dev libffi-dev build-essential -y
	pip install --upgrade pip
	pip install --upgrade pwntools
	printf "${PURP}[+] ${RED}pwntool Done.\n${WHITE}"
	su -c "mkdir tools" $MY_NAME
	cd tools
	su -c "git clone https://github.com/apogiatzis/gdb-peda-pwndbg-gef.git" $MY_NAME
	cd gdb-peda-pwndbg-gef
	./install.sh
	printf "${PURP}[+] ${RED}GDB Done.\n${WHITE}"
	cd $HOME/tools
	rm -rf *
	su -c "git clone https://github.com/kiosuper/attach.git" $MY_NAME
	echo >> $HOME/.gdbinit
	echo "source $HOME/tools/attach/at.py" >> $HOME/.gdbinit
	echo "define m" >> $HOME/.gdbinit
	echo "disass main" >> $HOME/.gdbinit
	echo "end" >> $HOME/.gdbinit
	echo "define full" >> $HOME/.gdbinit
	echo "set print elements 1000" >> $HOME/.gdbinit
	echo "end" >> $HOME/.gdbinit
	echo "define vm" >> $HOME/.gdbinit
	echo "vmmap" >> $HOME/.gdbinit
	echo "end" >> $HOME/.gdbinit
	printf "${PURP}[+] ${RED}gdbinit Done.\n${WHITE}"
	chown root:root $HOME/tools/attach/aslr
	cp -v $HOME/tools/attach/aslr /usr/bin
	chmod +x /usr/bin/aslr
	printf "${PURP}[+] ${RED}ASLR Done.\n${WHITE}"
	pip install capstone
	pip install keystone-engine
	pip install "filebytes<0.9.20" ropper
	printf "${PURP}[+] ${RED}ropper Done.\n${WHITE}"
	#apt-get install qemu qemu-user-static kpartx gdb-multiarch -y
fi
