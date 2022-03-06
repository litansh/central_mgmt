#!/bin/bash
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/installnfs/nfsparamdir/nfsparamfile)"
PORT="$(sed -n '2p' /var/www/lcms/dep/admin/installnfs/nfsparamdir/nfsparamfile)"
USER="$(sed -n '1p' /var/www/lcms/dep/admin/installnfs/loggeduserdir/loggeduser)"
FILE="${USER}.txt"
STAT="stat.txt"

function perm_ () {

find /var/www/lcms/dep/admin/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/admin/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/it/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/it/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/dev/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/dev/* -type f -exec chmod 644 '{}' \;
chmod +x /var/www/lcms/dep/admin/installnfs/installnfs.sh
chown -R apache:apache /var/www/
}
perm_

mkdir /var/weblogs/${HIP}

systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap

echo -e "/var/weblogs/${HIP}   ${HIP}(rw,sync,no_root_squash,no_all_squash)" >> /etc/exports

systemctl restart nfs-server 
exportfs -rav
exportfs -r

sed -i -e 's/\r$//' /var/www/lcms/dep/admin/installnfs/installnfs.sh

#-- run script on remote host ssh
function ssh_ () {
HIP="$(sed -n '1p' /var/www/lcms/dep/admin/installnfs/nfsparamdir/nfsparamfile)"
sudo -uroot ssh -p'22' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/installnfs/installnfs.sh
sudo -uroot ssh -p'44455' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/installnfs/installnfs.sh
sudo -uroot ssh -p'44433' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/installnfs/installnfs.sh
sudo -uroot ssh -p'33333' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/installnfs/installnfs.sh
sudo -uroot ssh -p'51111' root@${HIP} 'bash -s' < /var/www/lcms/dep/admin/installnfs/installnfs.sh
}

#-- run bash script on remote host 
ssh_

#-- if both logs exists
function both_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/installnfs/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/installnfs/${FILE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/installnfs/${FILE})"
echo -e "${LL}" >> /var/www/lcms/dep/admin/${STAT}
}

#-- if only stat log exists
function stat_ () {
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${STAT}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/${STAT}
cat >/var/www/lcms/dep/admin/installnfs/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/installnfs/${FILE}
}

#-- if only user log exists
function user_ () {
cat >/var/www/lcms/dep/admin/installnfs/${FILE}  <<-"EOF"
LOG:
START >> 
EOF
echo -e " ${USER} :    " >> /var/www/lcms/dep/admin/installnfs/${FILE}
cat /var/weblogs/${HIP}_${HN}/stat/${STAT} >> /var/www/lcms/dep/admin/installnfs/${FILE}
cat /var/www/lcms/dep/admin/installnfs/${FILE} >> /var/www/lcms/dep/admin/${STAT}
}

#-- Permissions
chmod -R 777 /var/www/lcms/dep/admin/installnfs
chmod +x /var/www/lcms/dep/admin/installnfs/installnfs.sh
sed -i -e 's/\r$//' /var/www/lcms/dep/admin/installnfs/installnfs.sh

#-- check which log exists
CHECKF="$(cat /var/www/lcms/dep/admin/installnfs/$FILE | wc -l)"
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
MONTH="$(date | awk '{print $2}')"
CHECKM="$(cat /var/weblogs/${HIP}/logs/${MONTH} | wc -l)"
CHECKL="$(cat /var/weblogs/${HIP}/logs/${MONTH}/${DATE} | wc -l)"
if [ "$CHECKM" != "0" ] && [ "$CHECKL" != "0" ];
then
mkdir /var/weblogs/${HIP}/logs/${MONTH}
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/installnfs/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKM" == "0" ] && [ "$CHECKL" != "0" ];
mkdir /var/weblogs/${HIP}/logs/${MONTH}/${DATE}
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/installnfs/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
else
LL="$(awk 'END{print}' /var/www/lcms/dep/admin/installnfs/${FILE})"
echo -e "${LL}" >> /var/weblogs/${HIP}/logs/${MONTH}/${DATE}/${FILE}
elif [ "$CHECKL" != "0" ];
fi

#-- remove all logs file and dir
rm -rf /var/weblogs/${FILE}
rm -rf /var/weblogs/${HIP}_${HN}/stat/${STAT}
rm -rf /var/www/lcms/dep/admin/installnfs/${FILE}
rm -rf /var/www/lcms/dep/admin/installnfs/installnfsdir
rm -rf /var/www/lcms/dep/admin/installnfs/loggeduserdir
rm -rf /var/www/lcms/dep/admin/loggeduserdir
rm -rf /var/www/lcms/dep/admin/${FILE}
rm -rf /var/www/lcms/dep/admin/installnfs/nfsparamdir

echo "Done"


