apt update && apt upgrade -y
apt-get install initscripts wget sudo git  net-tools dnsutils curl nano  htop  mc gpm ncdu hardinfo p7zip thefuck cpm hatop  bmon wicd-curses jq shellcheck iptraf-ng gnupg2 yapet zsh-syntax-highlighting cpuid    glances  gdisk lnav  catdoc mtr ctop frogdata gt5 ht  pads  aptitude bpython zsh iotop  python-pip nethogs httpry progress apg iptraf-ng -y;
service gpm restart;
apt remove atop vnstat ranger  apt-dater yacpi byobu pinentry-curses cpm  transmission-remote-cli cmake-curses-gui cbm saidar jed barnowl -y;
apt autoremove -y;


apt install zsh git zsh-syntax-highlighting -y
wget -O /root/.zshrc https://raw.githubusercontent.com/ihcbbs/mysnip/master/.zshrc
chsh -s /bin/zsh;
zsh;
antigen bundle zsh-users/zsh-syntax-highlighting;





curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash;
source ~/.bashrc;
source ~/.zshrc;
nvm install stable;
 dirvish   monit  	  avfs rush