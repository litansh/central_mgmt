#!/bin/bash

#-- Permanent Variables

USER="$(sed -n '1p' /var/www/permtmp/opntmp/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"
USER="$(sed -n '1p' /var/www/permtmp/opntmp/opntmpdir/opntmpparam)"
PASSWORD="$(sed -n '2p' /var/www/permtmp/opntmp/opntmpdir/opntmpparam)"
PORT="$(sed -n '3p' /var/www/permtmp/opntmp/opntmpdir/opntmpparam)"
HIP="$(sed -n '4p' /var/www/permtmp/opntmp/opntmpdir/opntmpparam)"

function perm_ () {

find /var/www/lcms/dep/admin/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/admin/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/it/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/it/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/dev/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/dev/* -type f -exec chmod 644 '{}' \;
chown -R apache:apache /var/www
chmod +x /var/www/lcms/dep/admin/opntmp/opntmp.sh
}
perm_

#-- run script on remote host ssh
function ssh_ () {
HIP="$(sed -n '1p' /var/www/permtmp/opntmp/opntmpdir/opntmpparam)"
sudo -uroot ssh -p'22' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/opntmp/opntmp.sh
sudo -uroot ssh -p'44455' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/opntmp/opntmp.sh
sudo -uroot ssh -p'44433' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/opntmp/opntmp.sh
sudo -uroot ssh -p'33333' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/opntmp/opntmp.sh
sudo -uroot ssh -p'51111' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/opntmp/opntmp.sh
}

#-- run bash script on remote host 
ssh_

#-- if both logs exists
function both_ () {
echo -e " ${USER} :    " >> /var/www/permtmp/opntmp/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/permtmp/opntmp/${FILE}
LL="$(awk 'END{print}' /var/www/permtmp/opntmp/${FILE})"
echo -e "${LL}" >> /var/www/permtmp/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/permtmp/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/permtmp/${STAT}
cat >/var/www/permtmp/opntmp/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/permtmp/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/permtmp/opntmp/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/permtmp/opntmp/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/permtmp/opntmp/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/permtmp/opntmp/${FILE}
cat /var/www/permtmp/opntmp/${FILE} >> /var/www/permtmp/${STAT}
}

#-- to admin log
function alog_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/${STAT})"
echo -e "${LL}" >> /var/www/lcms/dep/it/${STAT}
}

#-- check which log exists
CHECKS="$(cat /var/www/lcms/dep/admin/$STAT | wc -l)"
if [ "$CHECKS" == "0" ];
then
cat >/var/www/lcms/dep/admin/${STAT}  <<-"EOF"
LOG:
START >> 
EOF
alog_
else
alog_
fi


sed -i -e 's/\r$//' /var/www/lcms/dep/admin/opntmp/opntmp.sh

#-- check which log exists
CHECKF="$(cat /var/www/permtmp/opntmp/$FILE | wc -l)"
CHECKS="$(cat /var/www/permtmp/$STAT | wc -l)"
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
LL="$(awk 'END{print}' /var/www/permtmp/opntmp/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKM" != "0" ] && [ "$CHECKL" == "0" ];
then
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/permtmp/opntmp/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
else
LL="$(awk 'END{print}' /var/www/permtmp/opntmp/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
fi 

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/permtmp/opntmp/${FILE}
rm -rf /var/www/permtmp/opntmp/opntmpdir
rm -rf /var/www/permtmp/opntmp/loggeduserdir
rm -rf /var/www/permtmp/loggeduserdir
rm -rf /var/www/permtmp/${FILE}

echo "Done"


