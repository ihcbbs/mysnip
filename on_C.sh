#!/bin/sh
if [ $2 -eq 1 ]; then
	mv "$3" /exdata
fi
echo [$(date)] $2, $3, $1 "<br>" >> /exdata/_log.html
