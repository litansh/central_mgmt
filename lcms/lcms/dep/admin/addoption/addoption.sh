#!/bin/bash
NAME="$(sed -n '1p' /var/www/lcms/dep/admin/addoption/addopndir/newopnparam)"
VALUE=P"$(sed -n '2p' /var/www/lcms/dep/admin/addoption/addopndir/newopnparam)"

cat >/var/www/lcms/dep/admin/addoption/tmp.txt <<-"EOF"
<option value="aaa">bbb</option>
</select>
EOF
BUTTON=$(</var/www/lcms/dep/admin/addoption/tmp.txt)
TBC="/select"
awk -v X="$TBC" -v Y="$BUTTON" '{sub(X, Y)}1' /var/www/lcms/dep/admin/${OPN}/${OPN}.php > /var/www/lcms/dep/admin/${OPN}/${OPN}_tmp.php && mv -f /var/www/lcms/dep/admin/${OPN}/${OPN}_tmp.php /var/www/lcms/dep/admin/${OPN}/${OPN}.php
TMPA="aaa"
TMPB="bbb"
sed -i "s/${TMPA}/${VALUE}/g" /var/www/lcms/dep/admin/${OPN}/${OPN}.php
sed -i "s/${TMPB}/${NAME}/g" /var/www/lcms/dep/admin/${OPN}/${OPN}.php

echo "Done"
exit 0


