#!/usr/bin/sh
#/usr/bin/mv -f $3 /data/aria2/adown/stop/
path=$3
parents=$(/usr/bin/dirname $path)
if [ $2 -eq 0 ]; then
    exit 0
fi
if [ $2 -eq 1 ]; then
    /usr/bin/mv -f $path /data/aria2/adown/stop/
    /usr/bin/echo "$path".aria2 >>/.aria2/0.log

    exit 0
fi
/usr/bin/mv -f $parents /data/aria2/adown/stop/
/usr/bin/echo "$parents".aria2 >>/.aria2/0.log
