#!/bin/bash

#-- Permanent Variables
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/restartvm/restartvmdir/restartvmparam)"
USER="$(sed -n '1p' /var/www/lcms/dep/admin/restartvm/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"
NFSP="/var/weblogs/${HIP}_${HN}/stat"

#-- Permissions

function perm_ () {

find /var/www/* -type d -exec chmod 755 '{}' \;
find /var/www/* -type f -exec chmod 644 '{}' \;
chmod +x /var/www/lcms/dep/admin/restartvm/restartvm.sh
chown -R apache:apache /var/www/
}
perm_

#-- run script on remote host ssh
function ssh_ () {
chmod 777 /var/www/lcms/dep/admin/restartvm/restartvm.sh
chmod +x /var/www/lcms/dep/admin/restartvm/restartvm.sh
sed -i -e 's/\r$//' /var/www/lcms/dep/admin/restartvm/restartvm.sh
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/restartvm/restartvmdir/restartvmparam)"
sudo -uroot ssh -p'22' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartvm/restartvm.sh
sudo -uroot ssh -p'44455' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartvm/restartvm.sh
sudo -uroot ssh -p'44433' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartvm/restartvm.sh
sudo -uroot ssh -p'33333' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartvm/restartvm.sh
sudo -uroot ssh -p'51111' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/restartvm/restartvm.sh
}

function scps_ () {
sudo -uroot scp -P 22 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44433 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44455 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 33333 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 51111 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
}

scps_

function sshcheck_ () {
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/restartvm/restartvmdir/restartvmparam)"
NFSP="/var/weblogs/${HIP}_${HN}/stat"

CHECK="$(ping -c 1 ${HIP} | grep from | wc -l)"

if [ ${CHECK} != 0 ];
then
echo -e " $("date"): ${HIP} IS UP After Reboot!!" >> ${NFSP}/stat.txt 
else
echo -e " $("date"): ${HIP} IS DOWN After Reboot!! Please Check!! " >> ${NFSP}/stat.txt 
fi
}

#-- run bash script on remote host 
ssh_
sleep 1m
sshcheck_

#-- if both logs exists
function both_ () {
echo -e " ${USER} :    " >> /var/www/lcms/modules/restartvm/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/restartvm/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/modules/restartvm/${FILE})"
echo -e "${LL}" >> /var/www/lcms/modules/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/modules/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/${STAT}
cat >/var/www/lcms/modules/restartvm/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/modules/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/restartvm/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/modules/restartvm/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/modules/restartvm/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/restartvm/${FILE}
cat /var/www/lcms/modules/restartvm/${FILE} >> /var/www/lcms/modules/${STAT}
}

#-- check which log exists
CHECKF="$(cat /var/www/lcms/modules/restartvm/$FILE | wc -l)"
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
LL="$(awk 'END{print}' /var/www/lcms/modules/restartvm/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/lcms/dep/admin/restartvm/${FILE}
rm -rf /var/www/lcms/dep/admin/restartvmdir
rm -rf /var/www/lcms/dep/admin/restartvm/loggeduserdir
rm -rf /var/www/lcms/dep/admin/loggeduserdir
rm -rf /var/www/lcms/dep/admin/${FILE}
rm -rf /var/www/lcms/dep/admin/restartvm/restartvmdir

echo "Done"


