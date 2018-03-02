apt-get install linux-headers-$(uname -r)  linux-image-$(uname -r) build-essential -y

cd
wget -O ./tcp_superbbr.c https://raw.githubusercontent.com/ihcbbs/mysnip/master/superbbr.c
echo "obj-m:=tcp_superbbr.o" > Makefile
make -C /lib/modules/$(uname -r)/build M=`pwd` modules CC=/usr/bin/gcc
install tcp_superbbr.ko /lib/modules/$(uname -r)/kernel
cp -rf ./tcp_superbbr.ko /lib/modules/$(uname -r)/kernel/net/ipv4
depmod -a
cd /etc
rm -f sysctl.conf
wget https://raw.githubusercontent.com/ihcbbs/mysnip/master/sysctl.conf
sysctl -p
cd -


cd 
rm -f Makefile  modules.order  Module.symvers  tcp_superbbr.c  tcp_superbbr.ko  tcp_superbbr.mod.c  tcp_superbbr.mod.o  tcp_superbbr.o .tcp*
echo "net.ipv4.tcp_congestion_control = superbbr" >> /etc/sysctl.conf