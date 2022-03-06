#!/bin/bash
#-- Permanent Variables
NFSP="/var/weblogs/"

function totxt_ () {

echo "DE10" | tee -i >> /var/www/lcms/dep/admin/hostslist/hostslist.txt  
ls -la ${NFSP} | grep "192.168.10.*" | tee -i >> /var/www/lcms/dep/admin/hostslist/hostslist.txt  
echo "DE20" | tee -i >> /var/www/lcms/dep/admin/hostslist/hostslist.txt  
ls -la ${NFSP} | grep "192.168.20.*" | tee -i >> /var/www/lcms/dep/admin/hostslist/hostslist.txt  
echo "DE60" | tee -i >> /var/www/lcms/dep/admin/hostslist/hostslist.txt  
ls -la ${NFSP} | grep "192.168.60.*" | tee -i >> /var/www/lcms/dep/admin/hostslist/hostslist.txt  
echo "DE66" | tee -i >> /var/www/lcms/dep/admin/hostslist/hostslist.txt   
ls -la ${NFSP} | grep "192.168.66.*" | tee -i >> /var/www/lcms/dep/admin/hostslist/hostslist.txt  
}

totxt_

echo "Done"
exit 0