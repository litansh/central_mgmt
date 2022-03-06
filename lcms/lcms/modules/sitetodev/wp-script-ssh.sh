#!/bin/bash

#-- Permanent Variables
USER="$(sed -n '1p' /var/www/lcms/modules/sitetodev/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"
HIP="$(sed -n '3p' /var/www/lcms/modules/sitetodev/paramdir/paramfile)"

function perm_ () {

find /var/www/lcms/modules/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/modules/* -type f -exec chmod 644 '{}' \;
chmod -R 755 /var/www/paramfile
chmod -R 755 /var/www/postapi.sh
find /var/www/${DB}/* -type d -exec chmod 755 '{}' \;
find /var/www/${DB}/* -type f -exec chmod 644 '{}' \;
chmod +x /var/www/lcms/modules/sitetodev/wp-script.sh
chown -R apache:apache /var/www/
}
perm_

sed -i -e 's/\r$//' /var/www/lcms/modules/sitetodev/wp-script.sh
sudo -uroot scp /var/www/lcms/modules/sitetodev/paramdir/* root@${HIP}:/var/www/

#-- run script on remote host ssh
function ssh_ () {
HIP="$(sed -n '1p' /var/www/lcms/modules/sitetodev/sitetodevdir/sitetodevparam)"
sudo -uroot ssh -p'22' root@${HIP} 'bash -s' < /var/www/lcms/modules/sitetodev/wp-script.sh
sudo -uroot ssh -p'44455' root@${HIP} 'bash -s' < /var/www/lcms/modules/sitetodev/wp-script.sh
sudo -uroot ssh -p'44433' root@${HIP} 'bash -s' < /var/www/lcms/modules/sitetodev/wp-script.sh
sudo -uroot ssh -p'33333' root@${HIP} 'bash -s' < /var/www/lcms/modules/sitetodev/wp-script.sh
sudo -uroot ssh -p'51111' root@${HIP} 'bash -s' < /var/www/lcms/modules/sitetodev/wp-script.sh
}

#-- run bash script on remote host 
ssh_

function move_ () {
scp -f -i -l 8192 id_rsa -p 44433 root@${HIP}:/var/log/cm/ulog /var/log/cm/ulog
scp -f -i -l 8192 id_rsa -p 44433 root@${HIP}:/var/weblogs/${HIP}_${HN} /var/weblogs/${HIP}_${HN}
}
move_

#-- if both logs exists
function both_ () {
echo -e " ${USER} :    " >> /var/www/lcms/modules/sitetodev/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/sitetodev/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/modules/sitetodev/${FILE})"
echo -e "${LL}" >> /var/www/lcms/modules/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/modules/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/${STAT}
cat >/var/www/lcms/modules/sitetodev/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/modules/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/sitetodev/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/modules/sitetodev/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/modules/sitetodev/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/sitetodev/${FILE}
cat /var/www/lcms/modules/sitetodev/${FILE} >> /var/www/lcms/modules/${STAT}
}

#-- Permissions
chmod +x /var/www/lcms/modules/sitetodev/wp-script.sh
sed -i -e 's/\r$//' /var/www/lcms/modules/sitetodev/wp-script.sh

#-- check which log exists
CHECKF="$(cat /var/www/lcms/modules/sitetodev/$FILE | wc -l)"
CHECKS="$(cat /var/www/lcms/modules/$STAT | wc -l)"
if [ "$CHECKF" != "0" ] && [ "$CHECKS" != "0" ];
then
both_
elif [ "$CHECKF" == "0" ] && [ "$CHECKS" != "0" ];
then
stat_
else
user_
fi
 
#-- move user log to all history logs
DATE="$(date | awk '{print $2 $3}')"
MONTH="$(date | awk '{print $2}')"
CHECKM="$(cat /var/log/cm/ulog/${MONTH} | wc -l)"
CHECKL="$(cat /var/log/cm/ulog/${MONTH}/${DATE} | wc -l)"
if [ "$CHECKM" != "0" ] && [ "$CHECKL" != "0" ];
then
mkdir /var/log/cm/ulog/${MONTH}
mkdir /var/log/cm/ulog/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/modules/sitetodev/${FILE})"
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKM" == "0" ] && [ "$CHECKL" != "0" ];
then
mkdir /var/log/cm/ulog/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/modules/sitetodev/${FILE})"
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}
else
LL="$(awk 'END{print}' /var/www/lcms/modules/sitetodev/${FILE})"
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKL" != "0" ];
fi 

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/lcms/modules/sitetodev/${FILE}
rm -rf /var/www/lcms/modules/sitetodev/sitetodevdir
rm -rf /var/www/lcms/modules/sitetodev/loggeduserdir
rm -rf /var/www/lcms/modules/loggeduserdir
rm -rf /var/www/lcms/modules/${FILE}
rm -rf /var/www/lcms/modules/sitetodev/paramdir

echo "Done"


