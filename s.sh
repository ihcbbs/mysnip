#!/usr/bin/sh

cd /root
wget -O id_rsa.pub https://raw.githubusercontent.com/ihcbbs/mysnip/master/id_rsa.pub
mkdir .ssh
chmod 700 ~/.ssh;
rm ~/.ssh/id_rsa.pub
 mv id_rsa.pub ~/.ssh;
 cd ~/.ssh;
 rm -rf authorized_keys;
cat id_rsa.pub >> authorized_keys;
chmod 600 authorized_keys;

cd /etc/ssh 

wget -O sshd_config https://raw.githubusercontent.com/ihcbbs/mysnip/master/sshd_config
service ssh restart;



cd /etc
rm -f sysctl.conf
wget -O sysctl.conf https://raw.githubusercontent.com/ihcbbs/mysnip/master/sysctl.conf
sysctl -p
cd -

apt update && apt upgrade -y

#低版本wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.92/linux-image-4.9.92-040992-generic_4.9.92-040992.201803311730_amd64.deb

#32位版本 wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.92/linux-image-4.9.92-040992-generic_4.9.92-040992.201803311730_i386.deb
#dpkg -i linux-image-4.9*.deb

