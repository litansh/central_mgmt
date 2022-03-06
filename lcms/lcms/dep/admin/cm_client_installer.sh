#!/bin/bash

#--mkdir
mkdir /var/www/weblogs
mkdir /var/log/lcms/ulog

#--unzip /var/www + .sql Template (Finito)
#--convert
 tar -cvzf /BCKP/httpd/httpd$(date +%d-%m-%Y).tar.gz /etc/httpd/conf/httpd.conf
#--untar
 tar -zxvf /var/www/lcms.tar.gz -C /var/www/

#--mv files -> path

function apache_ (){
 yum -y install httpd
 systemctl start httpd.service
 systemctl enable httpd.service
}

function php_ (){
 yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
 yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
 yum install yum-utils -y
 yum-config-manager --enable remi-php73
 yum install php php-opcache php-cli php-common php-gd php-ldap php-mysql php-odbc php-pdo php-pear -y
 yum install php-pecl-apc php-pecl-memcache php-pgsql php-soap php-xml php-xmlrpc php-mbstring php-mcrypt -y
 systemctl restart httpd
}

function ssl_ (){
 yum install mod_ssl -y
}

function mariadb_ (){
 yum -y install mariadb-server mariadb
 systemctl start mariadb.service
 systemctl enable mariadb.service
}

#--Check if installed :
#--Apache
HTTPD="$(systemctl status httpd | grep apache | wc -l)"
if [ "$HTTPD" != 0 ]
 then
 echo "Apache is installed"
 else
 apache_
fi

#--PHP
PHP="$(php -v | grep Copyright | wc -l)"
if [ "$PHP" != 0 ]
 then
 echo "PHP is installed in latest version"
 else
 php_
fi

#--mod_ssl
SSL="$(netstat -a | grep https | wc -l)"
if [ "$SSL" != 0 ]
 then
 echo "SSL is installed"
 else
 ssl_
fi

#--MariaDB
MYSQL="$(systemctl status mariadb | grep "maria" | wc -l)"
if [ "$MYSQL" != 0 ]
 then 
 echo "MariaDB installed and running"
 else
 mariadb_
fi

#-- Permissions
function perm_ () {
find /var/www/lcms/* -type d -exec chmod 775 '{}' \;
find /var/www/lcms/* -type f -exec chmod 644 '{}' \;
chown -R apache:apache /var/www/lcms
find /var/www/lcms/* -type f -iname "*.sh" -exec chmod +x {} \;
}
perm_

