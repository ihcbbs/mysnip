#安装
curl https://rclone.org/install.sh | sudo bash
#配置：
rclone config

#gdrive挂载webdav
rclone serve webdav gdrive:rclone --dir-cache-time 10s --poll-interval 2s --vfs-cache-mode full --vfs-cache-poll-interval 2s


#ftp上传
wput ftp://62280:mu5GCHHAxgmbz6fWUSRz62n1@46.38.225.190/cdrom/0.iso