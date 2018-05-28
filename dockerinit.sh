apt install sudo curl -y
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
   sudo apt-get update
   sudo apt-get install docker-ce -y
   
   
   ##################################web-ui
   
   docker rm portainer 
   docker pull portainer/portainer
   docker run -d -p 127.0.0.1:1082:9000 --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /opt/portainer:/data --name=portainer portainer/portainer

