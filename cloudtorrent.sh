 mkdir  -p /dv1/ct/  /dv1/exdata/btdown 

#复制openvpn配置文件(注意注释setenv那行)
#复制正确的resolv.conf
#直接拖到当前文件夹即可，自动复制
mv resolv.conf /dv1/ct/
mv -f  client.ovpn /dv1/ct/
mv -f auth.txt /dv1/ct/
   chown -R www-data:www-data /dv1/

docker rm -f ct
 
docker pull jpillora/cloud-torrent-openvpn
 docker run \
     --name ct \
    -it -d  --restart=always \
     --cap-add=NET_ADMIN \
     --device /dev/net/tun:/dev/net/tun \
     -p 127.0.0.1:3000:3000     -v  /dv1/ct/resolv.conf:/etc/resolv.conf  -v /dv1/ct/client.ovpn:/opt/openvpn/client.conf -v /dv1/ct/auth.txt:/opt/openvpn/auth.txt -v /dv1/exdata/btdown:/opt/cloud-torrent/downloads jpillora/cloud-torrent-openvpn
	 
