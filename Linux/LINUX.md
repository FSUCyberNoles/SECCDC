# Linux Script Directory

### dumpCronJobs

Dumps cron jobs from the directories listed below into /cronJobs

`/var/spool/cron/crontabs`

`/etc/crontab`

`/etc/cron.hourly`

`/etc/cron.daily`

`/etc/cron.weekly`

`/cetc/cron.monthly`

> cron.hourly/daily/weekly/monthly are Debian specific and won't exist on other distros. (This does carry over to Ubuntu and other Debain forks.

### checkUsers

Compares /etc/passwd to a users.txt file in the local directory.

The users.txt file should be formatted like this:

```
root
user
david
mike
jess
```

Usernames all on one line will not be parsed correctly.

If the script has no output, then it found no differences.

Right arrows > indicate that a user should be added to the system.

Left arrows < indicate that a user needs to be removed from the system. 
