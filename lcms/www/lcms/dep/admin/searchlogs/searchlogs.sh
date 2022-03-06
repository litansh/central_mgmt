#!/bin/bash
rm -rf /var/www/lcms/dep/admin/result.txt

YEAR="$(sed -n '1p' /var/www/lcms/dep/admin/searchlogs/searchlogsdir/searchlogsparam)" 
MONTH="$(sed -n '2p' /var/www/lcms/dep/admin/searchlogs/searchlogsdir/searchlogsparam)" 
DAY="$(sed -n '3p' /var/www/lcms/dep/admin/searchlogs/searchlogsdir/searchlogsparam)" 
USERC="$(sed -n '4p' /var/www/lcms/dep/admin/searchlogs/searchlogsdir/searchlogsparam)" 

cat /var/www/lcms/dep/admin/logs/${MONTH}${YEAR}/${MONTH}${DAY}/${USERC}.txt | tee >> /var/www/lcms/dep/admin/result.txt
rm -rf /var/www/lcms/dep/admin/searchlogs/searchlogsdir

echo "Done"


