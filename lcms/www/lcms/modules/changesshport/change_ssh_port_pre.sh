#!/bin/bash
#-- Permanent Variables
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/changesshport/paramdirsshto/paramfilesshto)"
USER="$(sed -n '1p' /var/www/lcms/dep/admin/changesshport/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"

function perm_ () {

find /var/www/lcms/dep/admin/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/admin/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/it/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/it/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/dev/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/dev/* -type f -exec chmod 644 '{}' \;
chmod +x /var/www/lcms/dep/admin/changesshport/change_ssh_port.sh
chown -R apache:apache /var/www/
}
perm_

#-- run script on remote host ssh
function ssh_ () {
chmod +x /var/www/lcms/dep/admin/changesshport/change_ssh_port.sh
sed -i -e 's/\r$//' /var/www/lcms/dep/admin/changesshport/change_ssh_port.sh
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/changesshport/paramdirsshto/paramfilesshto)"
sudo -uroot ssh -p'22' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/changesshport/change_ssh_port.sh
sudo -uroot ssh -p'44455' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/changesshport/change_ssh_port.sh
sudo -uroot ssh -p'44433' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/changesshport/change_ssh_port.sh
sudo -uroot ssh -p'33333' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/changesshport/change_ssh_port.sh
sudo -uroot ssh -p'51111' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/changesshport/change_ssh_port.sh
}

function scp_ () {
sudo -uroot scp -P 22 /var/www/lcms/dep/admin/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44455 /var/www/lcms/dep/admin/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44433 /var/www/lcms/dep/admin/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 33333 /var/www/lcms/dep/admin/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 51111 /var/www/lcms/dep/admin/changesshport/paramdirsshto/* root@${HIP}:/var/weblogs/${HIP}_${HN}/stat
}

scp_
#-- run bash script on remote host 
ssh_

#-- if both logs exists
function both_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/changesshport/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/changesshport/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/changesshport/${FILE})"
echo -e "${LL}" >> /var/www/lcms/dep/admin/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/${STAT}
cat >/var/www/lcms/dep/admin/changesshport/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/changesshport/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/dep/admin/changesshport/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/changesshport/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/changesshport/${FILE}
cat /var/www/lcms/dep/admin/changesshport/${FILE} >> /var/www/lcms/dep/admin/${STAT}
}

#-- check which log exists
CHECKF="$(cat /var/www/lcms/dep/admin/changesshport/$FILE | wc -l)"
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
CHECKM="$(cat /var/weblogs/${HIP}/logs/${MONTH} | wc -l)"
CHECKL="$(cat /var/weblogs/${HIP}/logs/${MONTH}/${DATE} | wc -l)"
if [ "$CHECKM" == "0" ];
then
mkdir /var/weblogs/${HIP}/logs/${MONTH}
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/changesshport/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKM" != "0" ] && [ "$CHECKL" == "0" ];
then
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/changesshport/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
else
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/changesshport/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
fi



#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/lcms/dep/admin/changesshport/${FILE}
rm -rf /var/www/lcms/dep/admin/changesshport/paramdirsshto
rm -rf /var/www/lcms/dep/admin/changesshport/loggeduserdir
rm -rf /var/www/lcms/dep/admin/loggeduserdir
rm -rf /var/www/lcms/dep/admin/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/paramfilesshto

echo "Done"





