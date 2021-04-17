#!/usr/bin/sh
#/usr/bin/mv -f $3 /data/aria2/adown/stop/
path=$3
parents=$(/usr/bin/dirname $path)
if [[ $parents =~ "/data/aria2/adown/" ]]; then
    path=$parents
    parents=$(/usr/bin/dirname $path)
fi
if [[ $parents =~ "/data/aria2/adown/" ]]; then
    path=$parents
    parents=$(/usr/bin/dirname $path)
fi
if [[ $parents =~ "/data/aria2/adown/" ]]; then
    exit 0
fi
/usr/bin/mv -f $path /data/aria2/adown/stop/
/usr/bin/echo "$path".aria2 >>/.aria2/aria2.log
