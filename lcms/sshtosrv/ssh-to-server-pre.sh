#!/bin/bash

USERS="$(sed -n '1p' /var/www/lcms/modules/sshtosrv/paramdirssh/paramfilessh)"
PASS="$(sed -n '2p' /var/www/lcms/modules/sshtosrv/paramdirssh/paramfilessh)"
HIP="$(sed -n '3p' /var/www/lcms/modules/sshtosrv/paramdirssh/paramfilessh)"
USER="$(sed -n '1p' /var/www/lcms/modules/sshtosrv/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"

function perm_ () {

find /var/www/lcms/modules/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/modules/* -type f -exec chmod 644 '{}' \;
chmod +x /var/www/lcms/modules/sshtosrv/ssh-to-server.sh
chmod +x /var/www/lcms/modules/sshtosrv/sshtosrv.sh
chown -R apache:apache /var/www/
}
perm_

yum install sshpass -y
sshpass -p "${PASS}" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub ${USERS}@${HIP}  
sh /var/www/lcms/modules/sshtosrv/ssh-to-server.sh

function scps_ () {
sudo -uroot scp -P 22 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44433 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 44455 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 33333 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
sudo -uroot scp -P 51111 root@${HIP}:/var/weblogs/${HIP}_${HN}/stat/* /var/weblogs/${HIP}_${HN}/stat
}

scps_

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/modules/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/${STAT}
cat >/var/www/lcms/modules/sshtosrv/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/modules/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/sshtosrv/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/modules/sshtosrv/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/modules/sshtosrv/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/sshtosrv/${FILE}
cat /var/www/lcms/modules/sshtosrv/${FILE} >> /var/www/lcms/modules/${STAT}
}

#-- check which log exists
CHECKF="$(cat /var/www/lcms/modules/sshtosrv/$FILE | wc -l)"
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
LL="$(awk 'END{print}' /var/www/lcms/modules/sshtosrv/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/lcms/modules/sshtosrv/${FILE}
rm -rf /var/www/lcms/modules/sshtosrv/sshtosrvdir
rm -rf /var/www/lcms/modules/sshtosrv/loggeduserdir
rm -rf /var/www/lcms/modules/loggeduserdir
rm -rf /var/www/lcms/modules/${FILE}
rm -rf /var/www/lcms/modules/sshtosrv/paramdirssh

echo "Done"


