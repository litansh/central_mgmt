#!/bin/bash

USER="$(sed -n '1p' /var/www/lcms/dep/admin/sshtosrv/paramdirssh/paramfilessh)"
HIP="$(sed -n '3p' /var/www/lcms/dep/admin/sshtosrv/paramdirssh/paramfilessh)"
USERS="$(sed -n '1p' /var/www/lcms/dep/admin/sshtosrv/loggeduserdir/loggeduser)"

function perm_ () {

find /var/www/lcms/dep/admin/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/admin/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/it/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/it/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/dev/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/dev/* -type f -exec chmod 644 '{}' \;
}
perm_

ssh -q -o PasswordAuthentication=no ${USER}@${HIP} exadmin 
RES=$(echo $?)

if [ ${RES} == 0 ];
then
echo -e " ${USERS}:
$("date"): SSH connection established!! on ${HIP} " >> /var/www/lcms/dep/admin/stat.txt 
else
echo -e " ${USERS}:
$("date"): SSH connection NOT established!! on ${HIP} " >> /var/www/lcms/dep/admin/stat.txt
fi

rm -rf /var/www/lcms/dep/admin/sshtosrv/paramdirssh
echo "Done"
exadmin 0


