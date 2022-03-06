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

#-- if both logs exists
function both_ () {
echo -e " ${USER} :    " >> /var/www/lcms/modules/sshtosrv/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/modules/sshtosrv/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/modules/sshtosrv/${FILE})"
echo -e "${LL}" >> /var/www/lcms/modules/${STAT}
}

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

sed -i -e 's/\r$//' /var/www/lcms/modules/sshtosrv/sshtosrv.sh

function move_ () {
scp -f -i -l 8192 id_rsa -p 44433 root@${HIP}:/var/weblogs/${HIP}/logs /var/log/cm/ulog
scp -f -i -l 8192 id_rsa -p 44433 root@${HIP}:/var/weblogs/${HIP}_${HN} /var/weblogs/${HIP}_${HN}
}
move_

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
MONTH="$(date | awk '{print $2}')"
CHECKM="$(cat /var/log/cm/ulog/${MONTH} | wc -l)"
CHECKL="$(cat /var/log/cm/ulog/${MONTH}/${DATE} | wc -l)"
if [ "$CHECKM" != "0" ] && [ "$CHECKL" != "0" ];
then
mkdir /var/log/cm/ulog/${MONTH}
mkdir /var/log/cm/ulog/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/modules/sshtosrv/${FILE})"
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKM" == "0" ] && [ "$CHECKL" != "0" ];
then
mkdir /var/log/cm/ulog/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/modules/sshtosrv/${FILE})"
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}
else
LL="$(awk 'END{print}' /var/www/lcms/modules/sshtosrv/${FILE})"
echo -e "${LL}" >> /var/log/cm/ulog/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKL" != "0" ];
fi 

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


