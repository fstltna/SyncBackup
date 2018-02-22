# SyncBackup - backup script for the Synchronet BBS (1.0)
Creates a hot backup of your Synchronet BBS installation.

Official support sites: [Official Github Repo](https://github.com/fstltna/SyncBackup) - [Official Forum](https://synchronetbbs.org/index.php/forum/syncbackup) ![Synchronet Logo](https://SynchronetBBS.org/SynchronetLogo.png) 


---

1. Edit the settings at the top of syncbackup.pl if needed
2. create a cron job like this:

        1 1 * * * /root/syncbackup/syncbackup.pl

3. This will back up your SBBS installation at 1:01am each day, and keep the last 5 backups.

If you need more help visit https://SynchronetBBS.org/
