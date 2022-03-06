#!/bin/bash
HIP="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep 192.168)"
NFSP="/var/weblogs/${HIP}_${HN}/stat"
PORT="$(sed -n '2p' /var/weblogs/${HIP}_${HN}/stat/paramfilesshto)"
STATUS="active (running)"

function perm_ () {

find /var/www/* -type d -exec chmod 755 '{}' \;
find /var/www/* -type f -exec chmod 644 '{}' \;
}
perm_

rm -rf ${NFSP}/stat.txt
sed -i "\/Port\s[^0-9]*/c"${PORT}"" /etc/ssh/sshd_config
systemctl restart sshd

CHECK="$(systemctl status sshd | grep "${STATUS}" | wc -l)"
if [ ${CHECK} != 0 ];
then
echo -e " $("date"): Changed SSH Port to ${PORT} on ${HIP} Status: Active Running!! " >> ${NFSP}/stat.txt 
else
echo -e " $("date"): Did not change SSH Port on ${HIP}!! Please Check!! " >> ${NFSP}/stat.txt 
fi

rm -rf /var/weblogs/${HIP}_${HN}/stat/paramfilesshto
echo "Done"
exit 0





