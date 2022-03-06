#!/bin/bash

#-- Permanent Variables
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/restarthttpd/restarthttpddir/restarthttpdparam)"
USER="$(sed -n '1p' /var/www/lcms/dep/admin/restarthttpd/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"

#-- Permissions

function perm_ () {

find /var/www/lcms/dep/admin/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/admin/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/it/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/it/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/dev/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/dev/* -type f -exec chmod 644 '{}' \;
chmod +x /var/www/lcms/dep/admin/restarthttpd/restarthttpd.sh
chown -R apache:apache /var/www/
}
perm_

#-- run script on remote host ssh
function ssh_ () {
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/restarthttpd/restarthttpddir/restarthttpdparam)"
sudo -uroot ssh -p'22' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restarthttpd/restarthttpd.sh
sudo -uroot ssh -p'44455' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restarthttpd/restarthttpd.sh
sudo -uroot ssh -p'44433' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restarthttpd/restarthttpd.sh
sudo -uroot ssh -p'33333' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restarthttpd/restarthttpd.sh
sudo -uroot ssh -p'51111' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restarthttpd/restarthttpd.sh
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
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/restarthttpd/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/restarthttpd/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restarthttpd/${FILE})"
echo -e "${LL}" >> /var/www/lcms/dep/admin/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/${STAT}
cat >/var/www/lcms/dep/admin/restarthttpd/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/restarthttpd/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/dep/admin/restarthttpd/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/restarthttpd/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/restarthttpd/${FILE}
cat /var/www/lcms/dep/admin/restarthttpd/${FILE} >> /var/www/lcms/dep/admin/${STAT}
}

sed -i -e 's/\r$//' /var/www/lcms/dep/admin/restarthttpd/restarthttpd.sh

#-- check which log exists
CHECKF="$(cat /var/www/lcms/dep/admin/restarthttpd/$FILE | wc -l)"
CHECKS="$(cat /var/www/lcms/dep/admin/$STAT | wc -l)"
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
MONTH="$(date | awk '{print $2 $6}')"
CHECKM="$(cat /var/log/cm/ulog/${MONTH} | wc -l)"
CHECKL="$(cat /var/log/cm/ulog/${MONTH}/${DATE} | wc -l)"
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restarthttpd/${FILE})"
if [ "$CHECKM" == "0" ];
then
mkdir /var/log/cm/ulog/${MONTH}
mkdir /var/log/cm/ulog/${MONTH}/${DATE}
elif [ "$CHECKM" != "0" ] && [ "$CHECKL" == "0" ];
then
mkdir /var/log/cm/ulog/${MONTH}/${DATE}
fi 
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/lcms/dep/admin/restarthttpd/${FILE}
rm -rf /var/www/lcms/dep/admin/restarthttpd/restarthttpddir
rm -rf /var/www/lcms/dep/admin/restarthttpd/loggeduserdir
rm -rf /var/www/lcms/dep/admin/loggeduserdir
rm -rf /var/www/lcms/dep/admin/${FILE}

echo "Done"


