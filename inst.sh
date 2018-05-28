apt update && apt upgrade -y
apt install iproute2 sed gawk grep wget  gnutls-bin -y

wget https://raw.githubusercontent.com/ihcbbs/mysnip/master/pure.sh 
#修改网络、源、加密等内容
bash pure.sh --mirror 'https://debian.anexia.at/debian/' -d stretch -v amd64 -m