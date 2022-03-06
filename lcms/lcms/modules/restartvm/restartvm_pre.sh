#!/bin/bash

#-- Permanent Variables
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/restartvm/restartvmdir/restartvmparam)"
USER="$(sed -n '1p' /var/www/lcms/dep/admin/restartvm/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"
NFSP="/var/weblogs/${HIP}_${HN}/stat"

#-- Permissions

function perm_ () {

find /var/www/lcms/dep/admin/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/admin/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/it/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/it/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/dev/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/dev/* -type f -exec chmod 644 '{}' \;
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

function move_ () {
scp -f -i -l 8192 id_rsa -p 44433 root@${HIP}:/var/log/cm/ulog /var/log/cm/ulog
scp -f -i -l 8192 id_rsa -p 44433 root@${HIP}:/var/weblogs/${HIP}_${HN} /var/weblogs/${HIP}_${HN}
}
move_

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
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/restartvm/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/restartvm/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restartvm/${FILE})"
echo -e "${LL}" >> /var/www/lcms/dep/admin/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/${STAT}
cat >/var/www/lcms/dep/admin/restartvm/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/restartvm/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/dep/admin/restartvm/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/restartvm/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/restartvm/${FILE}
cat /var/www/lcms/dep/admin/restartvm/${FILE} >> /var/www/lcms/dep/admin/${STAT}
}

sed -i -e 's/\r$//' /var/www/lcms/dep/admin/restartvm/restartvm.sh

#-- check which log exists
CHECKF="$(cat /var/www/lcms/dep/admin/restartvm/$FILE | wc -l)"
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
if [ "$CHECKM" == "0" ];
then
mkdir /var/log/cm/ulog/${MONTH}
mkdir /var/log/cm/ulog/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restartvm/${FILE})"
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKM" != "0" ] && [ "$CHECKL" == "0" ];
then
mkdir /var/log/cm/ulog/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restartvm/${FILE})"
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}
else
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/restartvm/${FILE})"
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}
fi 

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


