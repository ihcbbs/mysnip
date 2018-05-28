mkdir -p /dv1/vesta/ /dv1/vesta/{home,backup,vesta}
chown -R www-data:www-data /dv1/vesta 
#切换到主机执行：切换到主机执行：
cd /etc/ssl/caddy/acme/acme-v01.api.letsencrypt.org/sites/www.tldt.pw
ln -s  www.tldt.pw.crt certificate.crt
ln -s www.tldt.pw.key certificate.key


#启动镜像，填写参数；
#绑定/etc/ssl/caddy/acme/acme-v01.api.letsencrypt.org/sites/www.tldt.pw到/usr/local/vesta/ssl(只读)
docker rm -f vesta
docker run -it -d --restart=always -e PGID=33 -e PUID=33 -p 10080-10090:80-90 -p 18083:8083 -v /etc/ssl/caddy/acme/acme-v01.api.letsencrypt.org/sites/www.tldt.pw:/usr/local/vesta/ssl:ro  -v /dv1/vesta/vesta:/opt/vestacp/vesta -v /dv1/vesta/home:/home -v /dv1/vesta/backup:/opt/vestacp/backup  --name=vesta debian
docker exec -it vesta /bin/bash
apt update && apt upgrade -y
apt-get install   wget sudo git  net-tools dnsutils curl nano  htop  mc gpm ncdu hardinfo p7zip thefuck    bmon wicd-curses jq shellcheck iptraf-ng gnupg2  zsh-syntax-highlighting cpuid    glances  gdisk lnav  catdoc mtr ctop  gt5 ht    aptitude  zsh iotop  python-pip nethogs  progress apg iptraf-ng nethogs -y;
service gpm restart;
 apt install lsb-release net-tools wget curl ssh initscripts  git procps -y
############################################################################
 
 curl -O http://vestacp.com/pub/vst-install.sh
 apt update && apt upgrade -y
bash vst-install.sh --nginx yes --phpfpm yes --apache no --named no --remi yes --vsftpd no --proftpd no --iptables no --fail2ban yes --quota yes --exim no --dovecot no --spamassassin no --clamav no --softaculous yes --mysql no --postgresql no --interactive no -force yes --hostname www.tldt.pw --email doruison@gmail.com
exit



#重启后执行,注意删掉所有配置文件中的网桥ip
docker exec -it vesta /bin/bash
service nginx start && service php-fpm start && service vesta start
service nginx status && service php-fpm status && service vesta status



#切换到主机执行：切换到主机执行：
rm -rf /usr/local/vesta/ssl/certificat*
ln -s  /etc/ssl/caddy/acme/acme-v01.api.letsencrypt.org/sites/www.tldt.pw/www.tldt.pw.crt /usr/local/vesta/ssl/certificate.crt
ln -s  /etc/ssl/caddy/acme/acme-v01.api.letsencrypt.org/sites/www.tldt.pw/www.tldt.pw.key /usr/local/vesta/ssl/certificate.key

#cockpit-ws ----address 127.0.0.1
#######################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################
apt install gnupg2 -y;
 curl -O http://vestacp.com/pub/vst-install.sh
bash vst-install.sh --interactive no --nginx yes --phpfpm yes --apache no --named no --remi yes --vsftpd no --proftpd no --iptables no --fail2ban no --quota yes --exim no --dovecot no --spamassassin no --clamav no --softaculous yes --mysql yes --postgresql no --hostname tldt.pw --email doruison@gmail.com
cd /etc/ssh 
rm -f sshd_config
wget https://raw.githubusercontent.com/ihcbbs/mysnip/master/sshd_config
service ssh restart;
cd /usr/local/vesta/ssl
rm cert*
ln -s /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/www.tldt.pw/www.tldt.pw.crt certificate.crt
ln -s /etc/ssl/caddy/acme/acme-v02.api.letsencrypt.org/sites/www.tldt.pw/www.tldt.pw.key certificate.key
service vesta restart
ln -s /usr/local/vesta/bin/* /usr/bin
export VESTA=/usr/local/vesta/
apg
#v-change-user-password admin  {密码}




#修改 /home/admin/conf端口号
service nginx restart
#nginx 配置文件加入：
 #set_real_ip_from 127.0.0.1;
  #              real_ip_header    X-Forwarded-For;
#探针 
 cd /home/admin/web/tldt.pw/public_html
  wget https://raw.githubusercontent.com/jakehu/phpinfo-by-yahei/master/tz.php
  

apt install ufw -y

ufw allow 443
ufw allow 80
ufw allow 2629
ufw allow 8083
ufw allow from 172.17.0.1/24
ufw default deny
ufw reload
ufw enable
ufw reload