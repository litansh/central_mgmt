#!/bin/bash
OPN="$(sed -n '1p' /var/www/lcms/dep/admin/newoptmp/newopdir/newopparam)"
PERM="$(sed -n '2p' /var/www/lcms/dep/admin/newoptmp/newopdir/newopparam)"
OPNSH=$(find '/var/www/lcms/dep/admin/newoptmp/*' -type f -path '*' -name '*.sh' | grep /var/www/lcms/dep/admin/newoptmp/*.sh | awk -F'/' '{print $8}' | awk -F'.' '{print $1}')

function perm_ () {

find /var/www/lcms/dep/* -type d -exec chmod 755 '{}' \;
find /var/www/lcms/dep/* -type f -exec chmod 644 '{}' \;
chown -R apache:apache /var/www
}
perm_

#-- Create in admin
mkdir /var/www/lcms/dep/admin/${OPN}
cp -f /var/www/lcms/dep/admin/newoptmp/tmp/* /var/www/lcms/dep/admin/${OPN}/
cp -f /var/www/lcms/dep/admin/newoptmp/${OPNSH} /var/www/lcms/dep/admin/${OPN}/

mv /var/www/lcms/dep/admin/${OPN}/newoptmp.php /var/www/lcms/dep/admin/${OPN}/${OPNSH}.php  
mv /var/www/lcms/dep/admin/${OPN}/newoptmp_fun.php /var/www/lcms/dep/admin/${OPN}/${OPNSH}_fun.php  
mv /var/www/lcms/dep/admin/${OPN}/newoptmp_pre.sh /var/www/lcms/dep/admin/${OPN}/${OPNSH}_pre.sh 

TBC="Enjoy"
CM="Central Management"
NTMPF="newoptmp"
sed -i "s/${CM}/${OPN}/g" /var/www/lcms/dep/admin/${OPN}/${OPNSH}.php
sed -i "s/${NTMPF}/${OPN}/g" /var/www/lcms/dep/admin/${OPN}/${OPNSH}.php
noptd="newoptmpdir"
noptdo="${OPN}dir"
sed -i "s/${noptd}/${noptdo}/g" /var/www/lcms/dep/admin/${OPN}/${OPNSH}_fun.php
noptp="newoptmpparam"
noptpo="${OPN}param"
sed -i "s/${noptp}/${noptpo}/g" /var/www/lcms/dep/admin/${OPN}/${OPNSH}_fun.php
noptpsh="newoptmp_pre.sh"
noptpsho="${OPN}.sh"
sed -i "s/${noptpsh}/${noptpsho}/g" /var/www/lcms/dep/admin/${OPN}/${OPNSH}_fun.php
nopt="New Operation TMP"
sed -i "s/${nopt}/${OPN}/g" /var/www/lcms/dep/admin/${OPN}/${OPNSH}_fun.php
onopt="opntmp"
sed -i "s/${onopt}/${OPN}/g" /var/www/lcms/dep/admin/${OPN}/${OPNSH}_pre.sh
ptmp="permtmp"
sed -i "s/${ptmp}/${PERM}/g" /var/www/lcms/dep/admin/${OPN}/${OPNSH}_pre.sh

cat >/var/www/lcms/dep/admin/newoptmp/tmp.txt <<-"EOF"
<button type="button" class="block" onClick="parent.location='./aaa/aaa.php'">aaa</button>	<br>
To Be Continued...
EOF
BUTTON=$(</var/www/lcms/dep/admin/newoptmp/tmp.txt)
TBC="To Be Continued..."
awk -v X="$TBC" -v Y="$BUTTON" '{sub(X, Y)}1' /var/www/lcms/dep/admin/index.php > /var/www/lcms/dep/admin/cm_admin_tmp.php && mv -f /var/www/lcms/dep/admin/cm_admin_tmp.php /var/www/lcms/dep/admin/index.php
TMPA="aaa"
sed -i "s/${TMPA}/${OPN}/g" /var/www/lcms/dep/admin/index.php

#-- Create also in IT
if [ "${PERM}" == "adminit" ];
then
mkdir /var/www/lcms/dep/it/${OPN}
cp -f /var/www/lcms/dep/admin/${OPN} /var/www/lcms/dep/it/${OPN}
cat >/var/www/lcms/dep/admin/newoptmp/tmpa.txt <<-"EOF"
header("Location: http://lcms/dep/admin/index.php");
EOF
cat >/var/www/lcms/dep/admin/newoptmp/tmpi.txt <<-"EOF"
header("Location: http://lcms/dep/it/index.php");
EOF
cat >/var/www/lcms/dep/admin/newoptmp/tmpd.txt <<-"EOF"
header("Location: http://lcms/dep/dev/index.php");
EOF
changea=$(</var/www/lcms/dep/admin/newoptmp/tmpa.txt)
changei=$(</var/www/lcms/dep/admin/newoptmp/tmpi.txt)
changed=$(</var/www/lcms/dep/admin/newoptmp/tmpd.txt)
awk -v X="$changea" -v Y="$changei" '{sub(X, Y)}1' /var/www/lcms/dep/it/${OPN}/${OPNSH}_fun.php > /var/www/lcms/dep/it/${OPN}/${OPNSH}_funtmp.php && mv -f /var/www/lcms/dep/it/${OPN}/${OPNSH}_funtmp.php /var/www/lcms/dep/it/${OPN}/${OPNSH}_fun.php
BUTTON=$(</var/www/lcms/dep/admin/newoptmp/tmp.txt)
awk -v X="$TBC" -v Y="$BUTTON" '{sub(X, Y)}1' /var/www/lcms/dep/it/index.php > /var/www/lcms/dep/it/cm_it_tmp.php && mv -f /var/www/lcms/dep/it/cm_it_tmp.php /var/www/lcms/dep/it/index.php
TMPA="aaa"
sed -i "s/${TMPA}/${OPN}/g" /var/www/lcms/dep/it/index.php

#-- Create for ALL
elif  [ "${PERM}" == "all" ];
then
mkdir /var/www/lcms/dep/it/${OPN}
cp -f /var/www/lcms/dep/admin/${OPN} /var/www/lcms/dep/it/${OPN}
awk -v X="$changea" -v Y="$changei" '{sub(X, Y)}1' /var/www/lcms/dep/it/${OPN}/${OPNSH}_fun.php > /var/www/lcms/dep/it/${OPN}/${OPNSH}_funtmp.php && mv -f /var/www/lcms/dep/it/${OPN}/${OPNSH}_funtmp.php /var/www/lcms/dep/it/${OPN}/${OPNSH}_fun.php
BUTTON=$(</var/www/lcms/dep/admin/newoptmp/tmp.txt)
awk -v X="$TBC" -v Y="$BUTTON" '{sub(X, Y)}1' /var/www/lcms/dep/it/index.php > /var/www/lcms/dep/it/cm_it_tmp.php && mv -f /var/www/lcms/dep/it/cm_it_tmp.php /var/www/lcms/dep/it/index.php
TMPA="aaa"
sed -i "s/${TMPA}/${OPN}/g" /var/www/lcms/dep/it/index.php
mkdir /var/www/lcms/dep/dev/${OPN}
cp -f /var/www/lcms/dep/admin/${OPN} /var/www/lcms/dep/dev/${OPN}
awk -v X="$changea" -v Y="$changed" '{sub(X, Y)}1' /var/www/lcms/dep/dev/${OPN}/${OPNSH}_fun.php > /var/www/lcms/dep/dev/${OPN}/${OPNSH}_funtmp.php && mv -f /var/www/lcms/dep/dev/${OPN}/${OPNSH}_funtmp.php /var/www/lcms/dep/dev/${OPN}/${OPNSH}_fun.php
BUTTON=$(</var/www/lcms/dep/admin/newoptmp/tmp.txt)
awk -v X="$TBC" -v Y="$BUTTON" '{sub(X, Y)}1' /var/www/lcms/dep/dev/index.php > /var/www/lcms/dep/dev/cm_dev_tmp.php && mv -f /var/www/lcms/dep/dev/cm_dev_tmp.php /var/www/lcms/dep/dev/index.php
TMPA="aaa"
sed -i "s/${TMPA}/${OPN}/g" /var/www/lcms/dep/dev/index.php
fi

rm -rf /var/www/lcms/dep/admin/tmp.txt
rm -rf /var/www/lcms/dep/admin/newoptmp/tmp.txt
rm -rf /var/www/lcms/dep/admin/newoptmp/tmpa.txt
rm -rf /var/www/lcms/dep/admin/newoptmp/tmpi.txt
rm -rf /var/www/lcms/dep/admin/newoptmp/tmpd.txt
rm -rf /var/www/lcms/dep/admin/${OPN}/newoptmp.php
rm -rf /var/www/lcms/dep/admin/${OPN}/newoptmp_fun.php
rm -rf /var/www/lcms/dep/admin/${OPN}/newoptmp_pre.sh
rm -rf /var/www/lcms/dep/it/${OPN}/newoptmp.php
rm -rf /var/www/lcms/dep/it/${OPN}/newoptmp_fun.php
rm -rf /var/www/lcms/dep/it/${OPN}/newoptmp_pre.sh
rm -rf /var/www/lcms/dep/dev/${OPN}/newoptmp.php
rm -rf /var/www/lcms/dep/dev/${OPN}/newoptmp_fun.php
rm -rf /var/www/lcms/dep/dev/${OPN}/newoptmp_pre.sh
rm -rf /var/www/lcms/dep/admin/newoptmp/newopdir


echo "Done"
exit 0


