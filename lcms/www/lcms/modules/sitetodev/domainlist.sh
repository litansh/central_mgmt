#!/bin/bash
curl -s -X GET "https://api.Cloudflare.com/client/v4/zones/?per_page=100" -H "X-Auth-Email: gennady@cglms.com" -H "X-Auth-Key: 865acec931ba06e7b65dbb4102c30720cfad2" -H "Content-Type: application/json" | jq -r '.result[] | "\(.id) \(.name)"' | awk -F ' ' '{print $2}' >> tmp.txt
LISTG="$(echo $ID | grep **)"
TBC="/select"
TMPA="aaa"
TMPB="bbb"

while IFS= read -r line #LISTG
do
OPTIONIP="$($line | grep num)"
OPTIONHN="$($line | grep hostname)"
CHECK="$(cat /var/www/lcms/modules/sitetodev/sitetodev.php | grep ${OPTIONHN} | wc -l)"
if [ $CHECK == "0" ];
then
cat >/var/www/lcms/dep/admin/tmpa.txt <<-"EOF"
<option value="aaa">bbb</option>
</select>
EOF
BUTTON=$(</var/www/lcms/dep/admin/tmpa.txt)
awk -v X="$TBC" -v Y="$BUTTON" '{sub(X, Y)}1' /var/www/lcms/modules/sitetodev/sitetodev.php > /var/www/lcms/modules/sitetodev/sitetodev_tmp.php && mv -f /var/www/lcms/modules/sitetodev/sitetodev_tmp.php /var/www/lcms/modules/sitetodev/sitetodev.php
sed -i "s/$TMPA/$OPTIONIP/g" /var/www/lcms/modules/sitetodev/sitetodev.php
sed -i "s/$TMPB/$OPTIONHN/g" /var/www/lcms/modules/sitetodev/sitetodev.php
rm -rf /var/www/lcms/dep/admin/tmp.txt
fi
done

echo "Done"
exit 0
