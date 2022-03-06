 #!/bin/bash

#-- Permanent Variables

USER="$(sed -n '1p' /var/www/lcms/dep/admin/newoptmp/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"
OPN="$(sed -n '1p' /var/www/lcms/dep/admin/newoptmp/newopdir/newopparam)"
OPNSH=$(find /var/www/lcms/dep/admin/newoptmp/* -type f -name "*.sh")
PERM="$(sed -n '2p' /var/www/lcms/dep/admin/newoptmp/newopdir/newopparam)"

#-- Permissions

function perm_ () {

find /var/www/lcms/dep/admin/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/admin/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/it/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/it/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/dev/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/dev/* -type f -exec chmod 644 '{}' \;
chmod +x /var/www/lcms/dep/admin/newoptmp/newop.sh
chown -R apache:apache /var/www/
}
perm_

sed -i -e 's/\r$//' /var/www/lcms/dep/admin/newoptmp/newop.sh

sh /var/www/lcms/dep/admin/newoptmp/scripts/newop.sh

#-- if both logs exists
function both_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/newoptmp/${FILE}
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
echo -e " ${OPN} has been created on ${PERM}! " >> /var/www/lcms/dep/admin/newoptmp/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/newoptmp/${FILE})"
echo -e "${LL}" >> /var/www/lcms/dep/admin/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
echo -e " ${USER} :    " >> /var/www/newoptmp/${FILE}
echo -e " ${OPN} has been created on ${PERM}! " >> /var/www/lcms/dep/admin/newoptmp/${FILE}
cat >/var/www/lcms/dep/admin/newoptmp/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${OPN} has been created on ${PERM}! " >> /var/www/lcms/dep/admin/${STAT}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/dep/admin/${STAT}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/newoptmp/${FILE}
echo -e " ${OPN} has been created on ${PERM}! " >> /var/www/lcms/dep/admin/${STAT}
echo -e " ${OPN} has been created on ${PERM}! " >> /var/www/lcms/dep/admin/newoptmp/${FILE}
}

#-- Permissions
chmod -R 777 /var/www/lcms/dep/admin/newoptmp
chmod +x /var/www/lcms/dep/admin/newoptmp/newoptmp.sh
sed -i -e 's/\r$//' /var/www/lcms/dep/admin/newoptmp/newoptmp.sh

#-- check which log exists
CHECKF="$(cat /var/www/lcms/dep/admin/newoptmp/$FILE | wc -l)"
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
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/${STAT})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKM" != "0" ] && [ "$CHECKL" == "0" ];
then
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/${STAT})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
else
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/${STAT})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
fi 

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/lcms/dep/admin/newoptmp/${FILE}
rm -rf /var/www/lcms/dep/admin/newoptmp/newoptmpdir
rm -rf /var/www/lcms/dep/admin/newoptmp/loggeduserdir
rm -rf /var/www/lcms/dep/admin/loggeduserdir
rm -rf /var/www/lcms/dep/admin/${FILE}

echo "Done"


