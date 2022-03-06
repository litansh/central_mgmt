#!/bin/bash

#-- Permanent Variables
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/addoption/addoptiondir/addoptionparam)"
USER="$(sed -n '1p' /var/www/lcms/dep/admin/addoption/loggeduserdir/loggeduser)"
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
chmod +x /var/www/lcms/dep/admin/addoption/addoption.sh
chown -R apache:apache /var/www/
}
perm_

sh ./addoption.sh

#-- if both logs exists
function both_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/addoption/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/addoption/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/addoption/${FILE})"
echo -e "${LL}" >> /var/www/lcms/dep/admin/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/${STAT}
cat >/var/www/lcms/dep/admin/addoption/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/addoption/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/dep/admin/addoption/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/addoption/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/addoption/${FILE}
cat /var/www/lcms/dep/admin/addoption/${FILE} >> /var/www/lcms/dep/admin/${STAT}
}

sed -i -e 's/\r$//' /var/www/lcms/dep/admin/addoption/addoption.sh

#-- check which log exists
CHECKF="$(cat /var/www/lcms/dep/admin/addoption/$FILE | wc -l)"
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
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/addoption/${FILE})"
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
rm -rf /var/www/lcms/dep/admin/addoption/${FILE}
rm -rf /var/www/lcms/dep/admin/addoption/addoptiondir
rm -rf /var/www/lcms/dep/admin/addoption/loggeduserdir
rm -rf /var/www/lcms/dep/admin/loggeduserdir
rm -rf /var/www/lcms/dep/admin/${FILE}

echo "Done"


