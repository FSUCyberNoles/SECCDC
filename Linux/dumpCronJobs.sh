#!/bin/bash

# SHOULD BE RUN AS ROOT!
# Dumps cronJobs to /cronJobs from the following folders:
# /var/spool/cron/crontabs
# /etc/crontab
# /etc/crontab.hourly
# /etc/crontab.daily
# /etc/crontab.weekly
# /etc/crontab.monthly

if [ "$EUID" -ne 0 ]
        then echo "Run as root"
        exit
fi

echo "Dumping cron jobs into /cronJobs"
mkdir -p /cronJobs
mkdir -p /cronJobs/varSpool/
mkdir -p /cronJobs/etc/hourly
mkdir -p /cronJobs/etc/daily
mkdir -p /cronJobs/etc/weekly
mkdir -p /cronJobs/etc/monthly

echo "Dumping /var/spool"
cp -r /var/spool/cron/crontabs /cronJobs/varSpool/
echo "Dumping /etc"
cp -r /etc/crontab /cronJobs/etc/
echo "Dumping hourly,daily,weekly,monthly"
cp -r /etc/cron.hourly /cronJobs/etc/hourly
cp -r /etc/cron.daily /cronJobs/daily
cp -r /etc/cron.weekly /cronJobs/weekly
cp -r /etc/cron.monthly /cronJobs/monthly

input=""
read -p "Display list of files? (y/n) " input
if [ $input = "y" ]
        then find /cronJobs/ -type f
fi
