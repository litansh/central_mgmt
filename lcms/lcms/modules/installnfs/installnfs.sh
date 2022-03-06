#!/bin/bash

#-- Permanent Variables
INSTALLNFS="$(rpm -ql nfs-utils | grep -P -o /var/lib/nfs | sort | uniq -c | wc -l)"
IP="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep 192.168)"
HIP="192.168.25.221"
HN="$(hostname)"

#-- Admins Mail
SM="litansh@gmail.com"
#-- Import From File
MNT="192.168.25.221:/var/weblogs/${IP}"


function perm_ () {

find /var/www/lcms/dep/admin/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/admin/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/it/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/it/* -type f -exec chmod 644 '{}' \;
find /var/www/lcms/dep/dev/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/dev/* -type f -exec chmod 644 '{}' \;
chmod +x /etc/nfsmonitor.sh
}
perm_


function mntp_ (){

cat > /etc/nfsmonitor.sh <<-"EOF"
#!/bin/bash
x=$(mount | grep ${BCKP})
if [ -z "$x" ]
then
    echo 'Mount Point Down' | mail -s 'Mount Point Down' system@domain.com
fi
EOF

echo -e "
*/1 * * * * cd /etc && sh nfsmonitor.sh
" >> /etc/crontab
systemctl restart crond
restart_
}

function df_ () {

 IP="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep 192.168)"
 MNT="192.168.25.221:/var/weblogs/${IP}"
 CHECK="$(df -hk | grep -P -o ${MNT} | sort | uniq -c | wc -l)"
 
 if [ ${CHECK} -eq 1 ];
 then
  echo "Mount exists on Host!!"  
  echo "Mount Up and Running on ${IP} to Host ${HIP}\nMount Path:/var/weblogs/${IP}" | mail -s "Mount Up and Running on ${IP}!!!" ${SM}
  exit 0
 else  
  echo "No Mount on Host!!"
  echo "Working on Mount on ${IP}..." | mail -s "No Mount on server ${IP}!!!" ${SM}
  config_
 fi
}

function restart_ () {

 systemctl enable rpcbind
 systemctl enable nfs-server
 systemctl enable nfs-lock
 systemctl enable nfs-idmap
 systemctl start rpcbind
 systemctl start nfs-server
 systemctl start nfs-lock
 systemctl start nfs-idmap
 df_
}

function installnfs_ () {

 yum install nfs-utils -y
 restart_
}

function config_ () {

 IP="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep 192.168)"
 HIP="192.168.25.221"
 mount -t nfs ${HIP}:/var/weblogs/${IP} /var/weblogs/${IP}
 echo -e "
 ${HIP}:/var/weblogs/${IP}  /var/weblogs/${IP}   nfs defaults 0 0
 " >> /etc/fstab
 mntp_
}

function main_ () {

 INSTALLNFS="$(rpm -ql nfs-utils | grep -P -o /var/lib/nfs | sort | uniq -c | wc -l)"
 if [ ${INSTALLNFS} -eq 1 ];
 then
  echo "NFS Installed"
  df_
 else
  installnfs_
 fi
}

main_