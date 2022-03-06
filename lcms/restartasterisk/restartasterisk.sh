#!/bin/bash
HIP="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep 192.168)"
NFSP="/var/weblogs/${HIP}_${HN}/stat"
STATUS="active (running)"

#-- Permissions

function perm_ () {

find /var/www/* -type d -exec chmod 755 '{}' \;
find /var/www/* -type f -exec chmod 644 '{}' \;
}
perm_

#rm -rf ${NFSP}/stat.txt
systemctl restart asterisk
CHECK="$(systemctl status asterisk | grep "${STATUS}" | wc -l)"

if [ ${CHECK} != 0 ];
then
echo -e " $("date"): Asterisk on ${HIP} Status: Active Running!! " >> ${NFSP}/stat.txt 
else
echo -e " $("date"): Asterisk on ${HIP} Not Running!! Please Check!! " >> ${NFSP}/stat.txt 
fi


echo "Done"
exit 0

