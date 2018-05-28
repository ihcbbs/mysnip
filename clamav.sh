apt install  clamav clamav-daemon clamav-freshclam clamdscan  -y;
rm /var/log/clamav/freshclam.log
freshclam
freshclam
service clamav-daemon status;
service clamav-freshclam status;
clamscan -r /
clamscan --archive-verbose  --stdout  --detect-pua=yes --detect-structured=yes --phishing-sig=yes --algorithmic-detection=yes   --dumpcerts   linux_deb_x64