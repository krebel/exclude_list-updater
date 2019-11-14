#!/bin/bash
#
###############################
#
# mkexcld.sh - automate updating /usr/openv/netbackup/exclude_list entries for anything over 43 days old
#
# - Script adds selections to be excluded from backup of filesystem /data/dumps/*/*/* only.
# - Resulting exclude_list excludes any file with filename containing date string format YYYYMMDD (ex. 20190830) older than 42 days.
#
# - Place this script in /usr/openv/netbackup/bin/goodies on the backup client.
# - Make script executable (chmod 550 /usr/openv/netbackup/bin/goodies/mkexcld.sh)
# - Schedule execution via cron to run daily.
# - NOTE: script makes a copy of the original exclude_list in /log/exclude_list<date>
# - change the directory paths, number of days to suit the environment
#
###############################

# Variables:
epoch=`date --date="43 days ago" +%Y%m%d`
yrmon=`echo $epoch | cut -c 1-6`
endday=`echo $epoch | cut -c 7-8`
fivemo=`date --date="5 months ago" +%Y%m`
fourmo=`date --date="4 months ago" +%Y%m`
threemo=`date --date="3 months ago" +%Y%m`
twomo=`date --date="2 months ago" +%Y%m`

# main

# keep a copy of the existing exclude_list file:
cp -p /usr/openv/netbackup/exclude_list /log/exclude_list_`date +%d%b%Y`

# overwrite and add previous 3, 4 and 5 months ago excludes for those entire months:
echo "/data/dumps/*/*/*"$fivemo"*" > /usr/openv/netbackup/exclude_list
echo "/data/dumps/*/*/*"$fourmo"*" >> /usr/openv/netbackup/exclude_list
echo "/data/dumps/*/*/*"$threemo"*" >> /usr/openv/netbackup/exclude_list
echo "/mnt/remote/*/*/*"$twomo"*" >> /usr/openv/netbackup/exclude_list


# For the month the 43rd day ago falls in, create wild card exclude days leading up to
# the 43rd day ago only if that day is not the 1st of the month:

if [ "$endday" = "01" ]; then
    echo "/data/dumps/*/*/*"$yrmon$endday"*" >> /usr/openv/netbackup/exclude_list
    exit 0
elif [ "$endday" != "01" ]; then
    echo "/data/dumps/*/*/*"$yrmon"[01-"$endday"]*" >> /usr/openv/netbackup/exclude_list
fi
