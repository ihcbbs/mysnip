#!/usr/bin/bash
traceroute -T -A -p 443 ah.189.cn > /web/temp




Issue=0
Issue=$(traceroute -T -A -p 443 ah.189.cn |grep  -m 1 4134| cut -d ']' -f 3|cut -d '.' -f 1)
if [ $Issue -gt 91  ];then
echo "High delay." >> /web/temp
fi
if [ $Issue -lt 91  ];then
 echo "Low delay." >> /web/temp
fi
Issue=$(traceroute -T -A -p 443 ah.189.cn |grep  -m 1 4134| cut -d ']' -f 3|cut -d '.' -f 1)
if [ $Issue -gt 91  ];then
echo "High delay." >> /web/temp
fi
if [ $Issue -lt 91  ];then
 echo "Low delay." >> /web/temp
fi

mv /web/temp /web/alert.txt

chown -R www-data:www-data /web
exit 0
