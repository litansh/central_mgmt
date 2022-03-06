#!/bin/bash

#-- Permanent Variables
HIP="$(sed -n '1p' /var/www/lcms/modules/changesshport/paramdirsshto/paramfilesshto)"
USER="$(sed -n '1p' /var/www/lcms/modules/changesshport/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"

#-- local server permissions
function perm_ () {

find /var/www/lcms/modules/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/modules/* -type f -exec chmod 644 '{}' \;
chmod +x /var/www/lcms/modules/changesshport/change_ssh_port.sh
chown -R apache:apache /var/www/
}
perm_

#-- copy parameter to remote host 
function scp_ () {
sudo -uroot scp -P 22 /var/www/lcms/modules/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44455 /var/www/lcms/modules/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44433 /var/www/lcms/modules/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 33333 /var/www/lcms/modules/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 51111 /var/www/lcms/modules/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
}

scp_

#-- run script on remote host ssh
function ssh_ () {
chmod +x /var/www/lcms/modules/changesshport/change_ssh_port.sh
sed -i -e 's/\r$//' /var/www/lcms/modules/changesshport/change_ssh_port.sh
HIP="$(sed -n '1p' /var/www/lcms/modules/changesshport/paramdirsshto/paramfilesshto)"
sudo -uroot ssh -p'22' root@${HIP} 'bash -s' < /var/www/lcms/modules/changesshport/change_ssh_port.sh
sudo -uroot ssh -p'44455' root@${HIP} 'bash -s' < /var/www/lcms/modules/changesshport/change_ssh_port.sh
sudo -uroot ssh -p'44433' root@${HIP} 'bash -s' < /var/www/lcms/modules/changesshport/change_ssh_port.sh
sudo -uroot ssh -p'33333' root@${HIP} 'bash -s' < /var/www/lcms/modules/changesshport/change_ssh_port.sh
sudo -uroot ssh -p'51111' root@${HIP} 'bash -s' < /var/www/lcms/modules/changesshport/change_ssh_port.sh
}

ssh_

#-- copy status from remote host to server
function scps_ () {
sudo -uroot scp -P 22 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44433 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44455 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 33333 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 51111 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
}

scps_

#-- if both logs exists
function both_ () {
echo -e " ${USER} :    " >> /var/www/lcms/modules/changesshport/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/changesshport/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/modules/changesshport/${FILE})"
echo -e "${LL}" >> /var/www/lcms/modules/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/modules/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/${STAT}
cat >/var/www/lcms/modules/changesshport/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/modules/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/changesshport/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/modules/changesshport/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/modules/changesshport/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/changesshport/${FILE}
cat /var/www/lcms/modules/changesshport/${FILE} >> /var/www/lcms/modules/${STAT}
}

#-- check which log exists
CHECKF="$(cat /var/www/lcms/modules/changesshport/$FILE | wc -l)"
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
MONTH="$(date | awk '{print $2 $6}')"
CHECKM="$(cat /var/weblogs/${HIP}/logs/${MONTH} | wc -l)"
CHECKL="$(cat /var/weblogs/${HIP}/logs/${MONTH}/${DATE} | wc -l)"
if [ "$CHECKM" == "0" ];
then
mkdir /var/weblogs/${HIP}/logs/${MONTH}
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
elif [ "$CHECKM" != "0" ] && [ "$CHECKL" == "0" ];
then
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
else
fi
LL="$(awk 'END{print}' /var/www/lcms/modules/changesshport/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/lcms/modules/changesshport/${FILE}
rm -rf /var/www/lcms/modules/changesshport/paramdirsshto
rm -rf /var/www/lcms/modules/changesshport/loggeduserdir
rm -rf /var/www/lcms/modules/loggeduserdir
rm -rf /var/www/lcms/modules/${FILE}

echo "Done"





