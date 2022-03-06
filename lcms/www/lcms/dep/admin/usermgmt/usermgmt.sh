#!/bin/bash
#-- Variables
USERC="$(sed -n '1p' /var/www/lcms/dep/admin/usermgmt/usermgmtdir/usermgmtparam)" 
PASS="$(sed -n '2p' /var/www/lcms/dep/admin/usermgmt/usermgmtdir/usermgmtparam)" 
OPTION="$(sed -n '3p' /var/www/lcms/dep/admin/usermgmt/usermgmtdir/usermgmtparam)"
PERM="$(sed -n '4p' /var/www/lcms/dep/admin/usermgmt/usermgmtdir/usermgmtparam)"

HN="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep 192.168)"

HIP="$(sed -n '1p' /var/www/lcms/dep/admin/usermgmt/usermgmtdir/usermgmtparam)"
USER="$(sed -n '1p' /var/www/lcms/dep/admin/usermgmt/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"

#-- admins email
SM="litansh@gmail.com"

#-- Edadmining function for users
function edit_ () {

sed "/$USERC/d" -i /etc/httpd/.htpasswd_$PERM
printf "${USERC}:$(openssl passwd -crypt ${PASS})\n" >> /etc/httpd/.htpasswd_$PERM
if [ "$PERM" == "admin" ];
 then
 sed "/$USERC/d" -i /etc/httpd/.htpasswd_it /etc/httpd/.htpasswd_dev
 cat /etc/httpd/.htpasswd_admin | grep test4 | tee >> /etc/httpd/.htpasswd_it /etc/httpd/.htpasswd_dev
fi
}
#-- Run function edit_
if [ "OPTION" == "delete" ];
then
sed "/$USERC/d" -i /etc/httpd/.htpasswd_$PERM
else
edit_
fi

#-- if both logs exists
function both_ () {
echo -e " ${USER} :  ${OPTION}d User ${USERC} with permissions to ${PERM} " >> /var/www/lcms/dep/admin/usermgmt/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/usermgmt/${FILE})"
echo -e "${LL}" >> /var/www/lcms/dep/admin/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :  ${OPTION}d User ${USERC} with permissions to ${PERM} " >> /var/www/lcms/dep/admin/${STAT}
cat >/var/www/lcms/dep/admin/usermgmt/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :  ${OPTION}d User ${USERC} with permissions to ${PERM} " >> /var/www/lcms/dep/admin/${FILE}
cat /var/www/lcms/dep/admin/${STAT} >> /var/www/lcms/dep/admin/usermgmt/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/dep/admin/${STAT}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :  ${OPTION}d User ${USERC} with permissions to ${PERM} " >> /var/www/lcms/dep/admin/${STAT}
echo -e " ${USER} :  ${OPTION}d User ${USERC} with permissions to ${PERM} " >> /var/www/lcms/dep/admin/usermgmt/${FILE}
}

#-- check which log exists
CHECKF="$(cat /var/www/lcms/dep/admin/usermgmt/$FILE | wc -l)"
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
CHECKM="$(cat /var/www/lcms/dep/admin/logs/${MONTH} | wc -l)"
CHECKL="$(cat /var/www/lcms/dep/admin/logs/${MONTH}/${DATE} | wc -l)"
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/usermgmt/${FILE})"
if [ "$CHECKM" == "0" ];
then
mkdir /var/www/lcms/dep/admin/logs/${MONTH}
mkdir /var/www/lcms/dep/admin/logs/${MONTH}/${DATE}
elif [ "$CHECKM" != "0" ] && [ "$CHECKL" == "0" ];
then
mkdir /var/www/lcms/dep/admin/logs/${MONTH}/${DATE}
fi
echo -e "${LL}" >> /var/www/lcms/dep/admin/logs/${MONTH}/${DATE}/${FILE}
#-- Remove edadmining scraps
rm -rf /var/www/lcms/dep/admin/usermgmt/usermgmtdir

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
#rm -rf /var/www/lcms/dep/admin/${STAT}
rm -rf /var/www/lcms/dep/admin/usermgmt/${FILE}
rm -rf /var/www/lcms/dep/admin/usermgmt/usermgmtdir
rm -rf /var/www/lcms/dep/admin/usermgmt/loggeduserdir
rm -rf /var/www/lcms/dep/admin/loggeduserdir
rm -rf /var/www/lcms/dep/admin/${FILE}

#-- Mail to admins
echo "Details: Username: $USERC Password: $PASS" | mail -s "User $USERC has been edadmined on CM ($HN)!" $SM

echo "Done"
exit 0
