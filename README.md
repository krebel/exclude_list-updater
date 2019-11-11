# exclude_list-updater
Automate updating NetBackup exclude_list

- BASH script adds selections to be excluded from backup of filesystem /data/dumps/*/*/* only.
- Resulting exclude_list excludes any file with filename containing date string format YYYYMMDD (ex. 20190830) older than 43 days.

- Place this script in /usr/openv/netbackup/bin/goodies on the backup client.
- Make script executable (chmod 550 /usr/openv/netbackup/bin/goodies/mkexcld.sh)
- Schedule execution via cron to run daily.
- NOTE: script makes a copy of the original exclude_list in /log/exclude_list<date>
- change the directory paths, and number of days to suit the environment
