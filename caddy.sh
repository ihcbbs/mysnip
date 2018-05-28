
curl https://getcaddy.com | bash -s personal http.cache,http.cgi,http.cors,http.jwt,http.locale,http.login,http.minify,http.ipfilter,http.filemanager,http.nobots,http.ratelimit,http.realip,http.webdav,http.proxyprotocol,net,tls.dns.cloudflare

apt update && apt install sudo -y
#若无用户需要添加
sudo groupadd -g 33 www-data
sudo useradd \
  -g www-data --no-user-group \
  --home-dir /var/www --no-create-home \
  --shell /usr/sbin/nologin \
  --system --uid 33 www-data
#结束

##############此处可选############
mkdir /dv1 /dv2
   chown www-data:www-data /dv1 /dv2
###################################


   apt install lrzsz sudo libcap2-bin -y 
   
   
touch /var/log/caddy.log
chown www-data:www-data /var/log/caddy.log
sudo mkdir /etc/caddy
sudo chown -R root:www-data /etc/caddy
sudo mkdir /etc/ssl/caddy
sudo chown -R www-data:root /etc/ssl/caddy
sudo chmod 0770 /etc/ssl/caddy
cd /etc/systemd/system/
wget  -O caddy.service https://raw.githubusercontent.com/ihcbbs/mysnip/master/caddy.service
cd -



#修改caddyfile




sudo chown root:root /etc/systemd/system/caddy.service
sudo chmod 644 /etc/systemd/system/caddy.service
sudo systemctl daemon-reload
sudo systemctl start caddy.service
sudo systemctl enable caddy.service

service caddy restart && sleep 5  && service caddy status

######################伪装
mv /usr/local/bin/caddy /usr/local/bin/forw

   apt install lrzsz sudo libcap2-bin -y 
   
touch /var/log/caddy.log
touch /var/log/forw.log
chown www-data:www-data /var/log/caddy.log
chown www-data:www-data /var/log/forw.log
sudo mkdir /etc/forw
sudo chown -R root:www-data /etc/forw
sudo mkdir /etc/ssl/forw
sudo chown -R www-data:root /etc/ssl/forw
sudo chmod 0770 /etc/ssl/forw
cd /etc/systemd/system/
wget  -O forw.service https://raw.githubusercontent.com/ihcbbs/mysnip/master/forw.service
cd -


mv /etc/caddy /etc/forw 
mv /etc/forw/Caddyfile /etc/forw/Forwfile
touch /etc/forw/Forwfile
#修改forwfile




sudo chown root:root /etc/systemd/system/forw.service
sudo chmod 644 /etc/systemd/system/forw.service
sudo systemctl daemon-reload
sudo systemctl start forw.service
sudo systemctl enable forw.service

service forw restart && sleep 5  && service forw status




#######################################




