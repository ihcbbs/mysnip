mkdir -p /web

cd /web
wget -O /web/delayalert.sh https://raw.githubusercontent.com/ihcbbs/mysnip/master/delayalert.sh
cd -
chmod a+x /web/delayalert.sh


 crontab -e

 
 #添加以下内容
*/15  *  *  *  * bash  /web/delayalert.sh



 crontab  -l
 