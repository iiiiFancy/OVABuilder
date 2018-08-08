#!/usr/bin/env bash
yes | tdnf install unzip
yes | tdnf install nodejs
yes | tdnf install cronie
yes | tdnf install xorriso
yes | tdnf install iputils

checkPkg() {
    count=0
    while [ $count -lt ${2} ]
    do
        tdnf list installed|grep ${1}
        if [ $? -eq 1 ]
        then
            yes|tdnf install ${1}
        else
            echo ${1} has been installed
            break
        fi
        let count++
        if [ $count -eq ${2} ]
        then
            echo ${1} install failed
        fi
    done
}

checkPkg unzip 3
checkPkg nodejs 3
checkPkg cronie 3
checkPkg xorriso 3
checkPkg iputils 3


unzip /root/connector.zip -d /
crontab /root/setupAutoRun.txt
chmod u+x /connector/launch.sh
sed -i '1 i [DHCP]\nClientIdentifier=mac\n\t' /etc/systemd/network/99-dhcp-en.network
sed -i '1 i dwdt-deployer' /etc/hostname
sed -i '2 d' /etc/hostname
systemctl stop sshd
systemctl disable sshd
rm /root/connector.zip
