#!/bin/bash

###-------------------------------------------------prerequisitions:
#--Centos 7
#--Apache
#--PHP
#--yum install mod_ssl -y
#--MariaDB
#--mailx
#--MySQL User: creator
#--.sql Template
#--mysql_secure_installation

#------------------------------------------------- Permanent Variables
#-- Import from file
WWW="$(sed -n '1p' /var/www/paramfile)" 
SD="$(sed -n '2p' /var/www/paramfile)" 
DM="$(sed -n '4p' /var/www/paramfile)" 

#--DB
DB="$SD${WWW//.}"
DBU=XDA6SBnkycTkKNjG
DBP=zn4HVAVybmWwfY5XadQALW
VMP="$(openssl rand -base64 20)"
SP="$(openssl rand -base64 20)"
LWP="/var/www/wordpress"
SQLB="/var/www/Finito.sql"

#--Configuration
DC=/var/www/litanshamircom.crt
DK=/var/www/litanshamircom.key
DIR=/var/www/$DB
DIR2=\"${DIR}\"
WAN="$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | sed -e 's/^192.*//g' | xargs echo -n | tr " "  "\n")"
IP="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep 192.168)"

#-- System Admin Mail
SM="cm@cglms.com"

#-----------------------------------------------------Permissions

function perm_ () {

find /var/www/lcms/dep/admin/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/admin/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/it/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/it/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/dev/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/dev/* -type f -exec chmod 644 '{}' \;
chmod +x /var/www/paramfile
chmod +x /var/www/postapi.sh
find /var/www/${DB}/* -type d -exec chmod 755 '{}' \;
find /var/www/${DB}/* -type f -exec chmod 644 '{}' \;
}
perm_


#----------------------------------------Install Clean WordPress + Name with new DB
function CWP_ () {

cd /var/www
yum install wget unzip -y
wget http://wordpress.org/latest.zip
unzip -q latest.zip -d /var/www/
mv ${LWP} "/var/www/${DB}"
}
#---------------------------Update users 'System' and 'DEV' + send email with new user password
function db_ () {

mysql -ucreator -p'!qazxsw2' -e "CREATE DATABASE IF NOT EXISTS ${DB};GRANT ALL PRIVILEGES ON ${DB}.* TO '${DBU}'@'127.0.0.1' IDENTIFIED BY '${DBP}';FLUSH PRIVILEGES;"

mysql -ucreator -p'!qazxsw2' ${DB} <${SQLB}

mysql -ucreator -p'!qazxsw2' -e "USE ${DB}; UPDATE wp_options SET option_value='${SD}.${WWW}' WHERE option_name = 'home'; UPDATE wp_options SET option_value='http://${SD}.${WWW}' WHERE option_name = 'siteurl'; UPDATE wp_options SET option_value='${SD}.${WWW}' WHERE option_name = 'blogname';"
mysql -ucreator -p'!qazxsw2' -e "USE ${DB}; UPDATE wp_users SET user_pass=MD5('${VMP}') WHERE user_login= 'DEV';"
mysql -ucreator -p'!qazxsw2' -e "USE ${DB}; UPDATE wp_users SET user_pass=MD5('${SP}') WHERE user_login= 'System';"
mysql -ucreator -p'!qazxsw2' -e "USE ${DB}; UPDATE wp_users SET option_value='DEV' WHERE option_name = 'user_login'; UPDATE wp_users SET option_value='${VMP}' WHERE option_name = 'user_pass'; UPDATE wp_users SET option_value='DEV' WHERE option_name = 'user_nicename'; UPDATE wp_users SET option_value='${DEVM}' WHERE option_name = 'user_email';"

echo "http://${SD}.${WWW}/wp-admin User:DEV Pass:${VMP}" | mail -s "${SD}.${WWW} has been created in ${IP}" ${DM}
echo "http://${SD}.${WWW}/wp-admin User:System Pass:${SP}" | mail -s "${SD}.${WWW} has been created in ${IP}" ${SM}
}
#----------------------------------------------Create wp-config.php file
function wpconfig_ () {

cat >/var/www/${DB}/wp-config.php <<-"EOF"
define('WP_ALLOW_MULTISITE', true);
/**#@+
* Authentication Unique Keys and Salts.
*
* Change these to different unique phrases!
* You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
* You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
*
* @since 2.6.0
*/
define('AUTH_KEY',         '-h=+@tP]ZL&&%1cBx_tKj);T.T]e`sO(E}<|NJ$Qwe:0X;5W2^*sElcq1T4.c0mz');
define('SECURE_AUTH_KEY',  'Jm#0J-5?gJiVBzYw+^$;.`8$$6Wt~AY)yjiG,7h4-_xY/v-JtmM-aDw4[VDEqF)-');
define('LOGGED_IN_KEY',    'iwb*2);+T*&5;M[.k)>jBO++8yhMKQx_0L5)x-LrKa`hkwizle) .5WE&Z_pHI4c');
define('NONCE_KEY',        '%h+hOP(9C[o|]EH-XY2)(vGW;;wG]pP|G|JnE#Y)lKG#HETI|ALBaP/r:G;j:|8_');
define('AUTH_SALT',        ')7M-%2Zjv?zj-yI(#q[5ac0w+4Tdk|RtE$YF&ZC%KH/$J|k<%E|Rsl[~o[C9Rm0Q');
define('SECURE_AUTH_SALT', 'yMn/CAa;9<FD1~?FmF_)ur{Rjj?M<?Fn::uioY]Xe,+-$n+cEh}RfI&D+QkS2+Hz');
define('LOGGED_IN_SALT',   '*)Y}-s4.L./<y`vvFvi/_7}mj,i7G#ZrV[b0*StJ&; ;Q>cy,Mxbr~1>bOW7H_*B');
define('NONCE_SALT',       '@I%EPr[1@t+hMd_d}TWLA_D|;|3bj.b|60vD.aeNcu^i=V0.-P{f+7RwAUB@a<4]');


/**#@-*/

/**
* WordPress Database Table prefix.
*
* You can have multiple installations in one database if you give each
* a unique prefix. Only numbers, letters, and underscores please!
*/
$table_prefix  = 'wp_';

/**
* For developers: WordPress debugging mode.
*
* Change this to true to enable the display of notices during development.
* It is strongly recommended that plugin and theme developers use WP_DEBUG
* in their development environments.
*
* For information on other constants that can be used for debugging,
* visit the Codex.
*
* @link https://codex.wordpress.org/Debugging_in_WordPress
*/

/*
* Handle multi domain into single instance of wordpress installation
*/

        define('WP_HOME', 'http://' . $_SERVER['HTTP_HOST']);
                define('WP_SITEURL', 'http://' . $_SERVER['HTTP_HOST']);
                
define('WP_DEBUG', false);
/*define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);
@ini_set('display_errors', 0);*/

define( 'WPCF7_AUTOP', false );

define( 'WP_AUTO_UPDATE_CORE', true );

define('WP_MEMORY_LIMIT', '256M');
define('WP_MAX_MEMORY_LIMIT', '256M');

define('WP_TEMP_DIR','/tmp-tradenet');

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
                define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
EOF

echo "
<?php
/**
* The base configuration for WordPress
*
* The wp-config.php creation script uses this file during the
* installation. You don't have to use the web site, you can
* copy this file to "wp-config.php" and fill in the values.
*
* This file contains the following configurations:
*
* * MySQL settings
* * Secret keys
* * Database table prefix
* * ABSPATH
*
* @link https://codex.wordpress.org/Editing_wp-config.php
*
* @package WordPress
*/

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', '${DB}');

/** MySQL database username */
define('DB_USER', '${DBU}');

/** MySQL database password */
define('DB_PASSWORD', '${DBP}');

/** MySQL hostname */
define('DB_HOST', '127.0.0.1');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

" | cat - /var/www/${DB}/wp-config.php >temp && mv temp /var/www/${DB}/wp-config.php
}
#----------------------------------------------------------------Hosts file
function hosts_ () {

echo -e "${WAN}  ${SD}.${WWW}" >>/etc/hosts
echo -e "${IP}  ${SD}.${WWW}" >>/etc/hosts
}
#-------------------------------------------------------------Binding to httpd
function httpd_ () {

#--443 Binding:
#<VirtualHost *:443>
#SSLEngine On
#SSLCertificateFile ${DC}
#SSLCertificateKeyFile ${DK}
#SSLProtocol all -SSLv2 -SSLv3
#SSLHonorCipherOrder on
#SSLCipherSuite SSLCST
#DocumentRoot ${DIR2}
#ServerName ${SD}.${WWW}
#headert
#headere
#<Directory ${DIR2}>
#</Directory>
#</VirtualHost>

echo -e "

<VirtualHost *:80>
DocumentRoot ${DIR2}
ServerName ${SD}.${WWW}
headert
headere
<Directory ${DIR2}>
</Directory>
</VirtualHost>
" >>/etc/httpd/conf/httpd.conf

sed -i 's/num/$1/g' /etc/httpd/conf/httpd.conf
sed -i 's/SSLCST/"EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS"/g' /etc/httpd/conf/httpd.conf
sed -i 's/headert/Header always edit Set-Cookie "(?i)^((?:(?!;\s?HttpOnly).)+)$" "$1; HttpOnly/g' /etc/httpd/conf/httpd.conf
sed -i 's/headere/Header always edit Set-Cookie "(?i)^((?:(?!;\s?secure).)+)$" "$1; secure/g' /etc/httpd/conf/httpd.conf
}
#--------------------------------------------------------------Update Local Permissions


#-- API to CloudFlare
#ID="$(curl -s -X GET "https://api.Cloudflare.com/client/v4/zones/?per_page=100" -H "X-Auth-Email: gennady@cglms.com" -H "X-Auth-Key: 865acec931ba06e7b65dbb4102c30720cfad2" -H "Content-Type: application/json" | jq -r '.result[] | "\(.id) \(.name)"' | grep -w "cglms.com" | sed "s/$WWW\b//g")"
#curl -X POST "https://api.cloudflare.com/client/v4/zones/$ID/dns_records" -H "X-Auth-Email: gennady@cglms.com" -H "X-Auth-Key: 865acec931ba06e7b65dbb4102c30720cfad2" -H "Content-Type:application/json" --data '{"type":"A","name":'$WWW',"content":'$IP',"ttl":120,"proxied":true}'
function api_ () {

IDTMP="$(curl -s -X GET "https://api.Cloudflare.com/client/v4/zones/?per_page=100" -H "X-Auth-Email: litansh@gmail.com" -H "X-Auth-Key: 000ff94c063a8ad911ac223ea230dfd44aff1" -H "Content-Type: application/json" | jq -r '.result[] | "\(.id) \(.name)"' | grep -w "$WWW" | sed "s/$WWW\b//g")"
ID=${IDTMP:0:32}
cat >/var/www/postapi.sh <<-"EOF"
#!/bin/bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/IDTMP/dns_records" -H "X-Auth-Email: litansh@gmail.com" -H "X-Auth-Key: 000ff94c063a8ad911ac223ea230dfd44aff1" -H "Content-Type:application/json" --data '{"type":"A","name":"SDTMP","content":"WANTMP","ttl":120,"proxied":true}'
EOF

sed -i "s/IDTMP/$ID/g" /var/www/postapi.sh
sed -i "s/SDTMP/$SD/g" /var/www/postapi.sh
sed -i "s/WANTMP/$WAN/g" /var/www/postapi.sh
chmod -R 755 /var/www/postapi.sh
chmod +x /var/www/postapi.sh
cd /var/www && sh postapi.sh
cd /
}
#------------------------------------------------------------ Check HandShake with site
function curl_ () {

sleep 1m
live="$(curl -Is http://$SD.$WWW | head -1 | grep "OK" | wc -l)"

if [ $live -eq 0 ] 
then
  echo "$SD.$WWW has been created in $IP" | mail -s 'New Wordpress Site IS UP' $SM
  echo -e " $("date"): $SD.$WWW has been created in $IP" >> /var/weblogs/${HIP}_${HN}/stat/stat.txt 
  exit 1
else
  echo "$SD.$WWW IS NOT FUNCTIONING!!! $IP" | mail -s 'New Wordpress Site NOT FUNCTIONING!!!' $SM
  echo -e " $("date"): $SD.$WWW IS NOT FUNCTIONING!!! $IP" >> /var/weblogs/${HIP}_${HN}/stat/stat.txt
fi

rm -rf /var/www/paramfile
rm -rf /var/www/latest.zip
rm -rf /var/www/postapi.sh
exit 0
}
#------------------------------------------------------------------ Run Functions

#--Clean WordPress Install
CWP_
#--Create DB and update users DEV + System
db_
#--Create wp-config + DB configurations
wpconfig_
#--Update hosts file
hosts_
#--httpd update
httpd_
#--Restart httpd
systemctl restart httpd
#--Change Local Permissions to Site Dir
perm_
#--Run API to CloudFlare
api_
#--Run CURL
curl_


#-----------------------------------------------------------------------FIN-------------------------------------------------------------------------------------#