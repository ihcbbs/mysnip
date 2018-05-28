apt update && apt upgrade -y
apt-get install   wget sudo git  net-tools dnsutils curl nano  htop  mc gpm ncdu hardinfo p7zip thefuck    bmon wicd-curses jq shellcheck iptraf-ng gnupg2  zsh-syntax-highlighting cpuid    glances  gdisk lnav  catdoc mtr ctop  gt5 ht    aptitude  zsh iotop  python-pip nethogs  progress apg iptraf-ng nethogs -y;
service gpm restart;



apt install zsh git zsh-syntax-highlighting -y
wget -O /root/.zshrc https://raw.githubusercontent.com/ihcbbs/mysnip/master/zshrc
chsh -s /bin/zsh;
zsh;
antigen bundle zsh-users/zsh-syntax-highlighting;




#安装node
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash;
source ~/.bashrc;
source ~/.zshrc;
nvm install stable;
apt install gnupg2 -y
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install npm 
#安装并执行具体项目
