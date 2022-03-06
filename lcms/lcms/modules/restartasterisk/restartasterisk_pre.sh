#!/bin/bash

#-- Permanent Variables
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/restartasterisk/restartasteriskdir/restartasteriskparam)"
USER="$(sed -n '1p' /var/www/lcms/dep/admin/restartasterisk/loggeduserdir/loggeduser)"
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
chmod +x /var/www/lcms/dep/admin/restartasterisk/restartasterisk.sh
chown -R apache:apache /var/www/
}
perm_

#-- run script on remote host ssh
function ssh_ () {
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/restartasterisk/restartasteriskdir/restartasteriskparam)"
sudo -uroot ssh -p'22' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartasterisk/restartasterisk.sh
sudo -uroot ssh -p'44455' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartasterisk/restartasterisk.sh
sudo -uroot ssh -p'44433' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartasterisk/restartasterisk.sh
sudo -uroot ssh -p'33333' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartasterisk/restartasterisk.sh
sudo -uroot ssh -p'51111' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartasterisk/restartasterisk.sh
}

#-- run bash script on remote host 
ssh_

#-- if both logs ${MONTH}/${DATE}
function both_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/restartasterisk/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/restartasterisk/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restartasterisk/${FILE})"
echo -e "${LL}" >> /var/www/lcms/dep/admin/${STAT}
}

#-- if only stat log ${MONTH}/${DATE}
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/${STAT}
cat >/var/www/lcms/dep/admin/restartasterisk/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/restartasterisk/${FILE}
}

#-- if only user log ${MONTH}/${DATE}
function user_ () {
cat >/var/www/lcms/dep/admin/restartasterisk/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/restartasterisk/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/restartasterisk/${FILE}
cat /var/www/lcms/dep/admin/restartasterisk/${FILE} >> /var/www/lcms/dep/admin/${STAT}
}

sed -i -e 's/\r$//' /var/www/lcms/dep/admin/restartasterisk/restartasterisk.sh

#-- check which log ${MONTH}/${DATE}
CHECKF="$(cat /var/www/lcms/dep/admin/restartasterisk/$FILE | wc -l)"
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
MONTH="$(date | awk '{print $2}')"
CHECKM="$(cat /var/weblogs/${HIP}/logs/${MONTH} | wc -l)"
CHECKL="$(cat /var/weblogs/${HIP}/logs/${MONTH}/${DATE} | wc -l)"
if [ "$CHECKM" != "0" ] && [ "$CHECKL" != "0" ];
then
mkdir /var/weblogs/${HIP}/logs/${MONTH}
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restartasterisk/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKM" == "0" ] && [ "$CHECKL" != "0" ];
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restartasterisk/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
else
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restartasterisk/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKL" != "0" ];
fi

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/lcms/dep/admin/restartasterisk/${FILE}
rm -rf /var/www/lcms/dep/admin/restartasterisk/restartasteriskdir
rm -rf /var/www/lcms/dep/admin/restartasterisk/loggeduserdir
rm -rf /var/www/lcms/dep/admin/loggeduserdir
rm -rf /var/www/lcms/dep/admin/${FILE}

echo "Done"


