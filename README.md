# SyncBackup - backup script for the Synchronet BBS (2.3.1)
Creates a hot backup of your Synchronet BBS installation and optionally copies it to a offsite server.

Official support sites: [Official Github Repo](https://github.com/fstltna/SyncBackup) - [Official Forum](https://synchronetbbs.org/index.php/forum/syncbackup) ![Synchronet Logo](https://SynchronetBBS.org/SynchronetLogo.png) 

[![Visit our IRC channel](https://kiwiirc.com/buttons/irc.synchro.net/SynchronetFans.png)](https://kiwiirc.com/client/irc.synchro.net/?nick=guest|?#SynchronetFans)

---

1. Make sure ssh-keygen is installed: "apt install ssh-keygen"
2. Run "ssh-keygen" and when asked for the password just press enter twice
3. Run "ssh-copy-id -i ~/.ssh/id_rsa.pub your-destination-server" - This will ask you for your remote password. This is normal.
4. Run "syncbackup -prefs" and update the backup fields
5. create a cron job like this:

        1 1 * * * /home/bbsowner/SyncBackup/syncbackup.pl > /dev/null 2>&1

6. This will back up your SBBS installation at 1:01am each day, and keep the last 5 backups.

If you need more help visit https://SynchronetBBS.org/ and check out this website: https://superuser.com/questions/555799/how-to-setup-rsync-without-password-with-ssh-on-unix-linux

