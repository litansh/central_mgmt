#!/bin/bash

USER="$(sed -n '1p' /var/www/lcms/dep/admin/sshtosrv/paramdirssh/paramfilessh)"
HIP="$(sed -n '3p' /var/www/lcms/dep/admin/sshtosrv/paramdirssh/paramfilessh)"
USERS="$(sed -n '1p' /var/www/lcms/dep/admin/sshtosrv/loggeduserdir/loggeduser)"
NFSP="/var/www/lcms/dep/admin/stat.txt"

function perm_ () {

find /var/www/lcms/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/* -type f -exec chmod 644 '{}' \;
}
perm_

ssh -q -o PasswordAuthentication=no ${USER}@${HIP} 
RES=$(echo $?)

if [ ${RES} == 0 ];
then
echo -e " ${USERS}:
$("date"): SSH connection established!! on ${HIP} " >> $NFSP
else
echo -e " ${USERS}:
$("date"): SSH connection NOT established!! on ${HIP} " >> $NFSP
fi

rm -rf /var/www/lcms/dep/admin/sshtosrv/paramdirssh
echo "Done"
exadmin 0


