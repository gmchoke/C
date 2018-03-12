sudo passwd
sudo tee -a /etc/apt/sources.list << EOF
deb http://download.webmin.com/download/repository sarge contrib
deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib
EOF
cd /root
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
apt-get update
apt-get install webmin
sed -i s/ssl=1/ssl=0/g /etc/webmin/miniserv.conf;
service webmin restart

# go to root
cd
sudo apt-get update
#apt-get install ca-certificates
apt-get install zip
apt-get -y install openvpn

# Change to Time GMT+8
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://scripkguza.000webhostapp.com/KGUZA-ALL-SCRIP/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
# Download 1194-2.conf in Google to Save 1194.conf
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/gmchoke/GMCHOKE1/master/1194-2.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 1.1.0.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/gmchoke/A/master/iptables"
chmod +x /etc/network/if-up.d/iptables
cp /usr/lib/openvpn/openvpn-plugin-auth-pam.so /etc/openvpn/
mkdir /etc/openvpn/tmp
chmod 777 /etc/openvpn/tmp
/etc/init.d/openvpn restart
#service openvpn status

# Install Squid
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/gmchoke/A/master/squid.conf"
MYIP=$(wget -qO- ipv4.icanhazip.com);
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart

# install webmin
#wget -O webmin-current.deb "https://scripkguza.000webhostapp.com/KGUZA-ALL-SCRIP/webmin-current.deb"
#dpkg -i --force-all webmin-current.deb;
#apt-get -y -f install;
#rm /root/webmin-current.deb
#sed -i 

# Web Based Interface for Monitoring Network apache2 php5 php5-gd
sudo apt-get install vnstat
sudo apt-get install apache2 php5 php5-gd
wget -O vnstat_php_frontend-1.5.1.tar.gz "http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz"
#wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xzf vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 /var/www/html/vnstat
sed -i s/nl/th/g /var/www/html/vnstat/config.php;
#sed -i s/80/85/g /etc/apache2/ports.conf;
wget -O /var/www/html/vnstat/lang/th.php "https://raw.githubusercontent.com/gmchoke/A/master/th.php"
wget -O /var/www/html/vnstat/index.php "https://raw.githubusercontent.com/gmchoke/A/master/index.php"
sed -i s/xxxxxxxxxx/http/g /var/www/html/vnstat/index.php;
wget -O /var/www/html/vnstat/openvpn-as.png "https://docs.google.com/uc?export=download&id=1cmgyFpofMxFMQApLf2G4C7woQCc032rf"
wget -O /etc/apache2/sites-enabled/000-default.conf "https://raw.githubusercontent.com/gmchoke/A/master/000-default.conf"
sed -i s/85/80/g /etc/apache2/sites-enabled/000-default.conf;
sed -i s/85/10000/g /var/www/html/vnstat/index.php;
cd
wget -O client.ovpn "https://raw.githubusercontent.com/gmchoke/A/master/client.ovpn"
MYIP=$(wget -qO- ipv4.icanhazip.com);
sed -i s/xxxxxxxx/$MYIP/g client.ovpn;
mv client.ovpn /var/www/html/vnstat/
wget -O /var/www/html/vnstat/client.php "https://raw.githubusercontent.com/gmchoke/A/master/client.php"
sed -i s/client.zip/client.php/g /var/www/html/vnstat/index.php;

sudo service apache2 restart
#nano /var/www/html/vnstat/config.php
rm /root
