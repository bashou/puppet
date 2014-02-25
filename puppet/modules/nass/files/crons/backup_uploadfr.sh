#!/bin/bash

# Date du jour
date=`date '+%d-%m-%Y'`
# Date d'il y a 7 jours
date2=`date --date '2 days ago' "+%d-%m-%Y"`

tar -czf /space/secure/backup/uploadfr/backup_uploadfr_$date.tar.gz /space/www/uploadfr.com/images
ln -s -f /space/secure/backup/uploadfr/backup_uploadfr_$date.tar.gz /space/secure/backup/uploadfr/backup_uploadfr.tar.gz
echo Tar.gz de uploadfr OK

rm -f /space/secure/backup/uploadfr/backup_uploadfr_$date2.tar.gz
echo Backup de $date2 supprime OK
