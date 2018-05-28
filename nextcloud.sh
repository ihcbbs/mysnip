#首先打开sql相关docker

mkdir  -p /dv1/nextcloud/html/aria2 /dv1/exdata/ncaria2
   chown -R www-data:www-data  /dv1/nextcloud/html /dv1/exdata
 #先恢复  

 #docker pull nextcloud
   docker stop nextcloud
 docker rm -f nextcloud  
   
docker  run  --restart=always  -d -p 127.0.0.1:1084:80 \
-v /dv1/nextcloud/html:/var/www/html/ \
-v /dv1/exdata:/exdata \
--name=nextcloud nextcloud
#更新###################################3
mv /dv1/nextcloud/html/{theme,custom_apps,apps,config,data} /dv1/nextcloud/
rm -rf /dv1/nextcloud/html/
mkdir  -p /dv1/nextcloud/html/aria2 /dv1/exdata
   chown -R www-data:www-data  /dv1/nextcloud/html /dv1/exdata
   mv /dv1/nextcloud/{theme,custom_apps,apps,config,data} /dv1/nextcloud/html/


docker pull nextcloud
   docker stop nextcloud
 docker rm -f nextcloud  
   
docker  run  --restart=always  -d -p 127.0.0.1:1084:80 \
-v /dv1/nextcloud/html:/var/www/html/ \
-v /dv1/exdata:/exdata \
--name=nextcloud nextcloud

#再打开网页









#修改caddyfile
service caddy restart && sleep 5 && service caddy status




#memcached
#参考config.php修改（镜像正常不必修改）
########################################ocdown配置
#ocdown修改目录/usr/bin/youtube-dl
docker exec -it nextcloud bash 
apt-get update  && apt upgrade -y
 apt-get install   libssl-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config   wget sudo python curl build-essential -y
wget https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.gz
tar zxvf *.gz 
cd aria2-1.33.1
./configure
 make
 make install 
 ln -s /usr/local/bin/aria2* /usr/bin
 cd ../
 rm -rf aria2*

#chown  -R www-data:www-data  /dv1/exdata/adown /dv1/.aria2/
cd /exdata/ncaria2
mkdir .aria2
touch .aria2/aria2.session
mkdir /etc/aria2 
wget -O .aria2/dht.dat https://raw.githubusercontent.com/ihcbbs/mysnip/master/dht.dat
wget -O /etc/aria2/aria2c.conf https://raw.githubusercontent.com/ihcbbs/mysnip/master/aria2cfornc.conf
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
 chmod a+rx /usr/local/bin/youtube-dl
 exit 
docker restart nextcloud


#cron任务
#Uptimerobot 或其他工具监视https://cloud.tldt.pw/cron.php
#设置页改为webcron


#####################
docker exec -it nextcloud cron
docker exec -it nextcloud bash 
/usr/bin/aria2c --rpc-allow-origin-all -c -D \
--log=/var/log/aria2.log --check-certificate=false \
--save-session-interval=2 --continue=true \
--rpc-save-upload-metadata=true --force-save=true \
--log-level=warn --console-log-level=warn --enable-rpc  \
--rpc-listen-all --conf-path=/etc/aria2/aria2c.conf
exit 
######################################################结束




#备份 
cd /dv1/nextcloud/html
tar zcvf nextbackup.tar.gz data config apps 3rdparty settings 

#恢复 
cd /dv1/nextcloud/html
rm -rf  config apps 3rdparty settings
#放置文件
tar zxvf  nextbackup.tar.gz 
rm -rf *.gz

