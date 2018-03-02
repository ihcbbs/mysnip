#!/usr/bin/bash
traceroute -T -A -p 443 ah.189.cn > /web/alert.txt




Issue=0
Issue=$(traceroute -T -A -p 443 ah.189.cn |grep  -m 1 4134| cut -d ']' -f 3|cut -c 3-5 )
if [ $Issue -gt 100  ];then
echo "The delay is a problem" >> /web/alert.txt
fi
if [ $Issue -lt 100  ];then
 echo "No problem" >> /web/alert.txt
fi




chown -R www-data:www-data /web
exit 0