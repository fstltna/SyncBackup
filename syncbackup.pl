#!/usr/bin/perl

# Set these for your situation
my $SYNCDIR = "/sbbs";
my $BACKUPDIR = "/root/backups";
my $TARCMD = "/bin/tar czf";
my $VERSION = "1.0";

#-------------------
# No changes below here...
#-------------------

print "SyncBackup - back up your Synchronet BBS - version $VERSION\n";
print "======================================================\n";

if (! -d $BACKUPDIR)
{
	print "Backup dir $BACKUPDIR not found, creating...\n";
	system("mkdir -p $BACKUPDIR");
}
print "Moving existing backups: ";

if (-f "$BACKUPDIR/citbackup-5.tgz")
{
	unlink("$BACKUPDIR/syncbackup-5.tgz")  or warn "Could not unlink $BACKUPDIR/syncbackup-5.tgz: $!";
}
if (-f "$BACKUPDIR/syncbackup-4.tgz")
{
	rename("$BACKUPDIR/syncbackup-4.tgz", "$BACKUPDIR/syncbackup-5.tgz");
}
if (-f "$BACKUPDIR/syncbackup-3.tgz")
{
	rename("$BACKUPDIR/syncbackup-3.tgz", "$BACKUPDIR/syncbackup-4.tgz");
}
if (-f "$BACKUPDIR/syncbackup-2.tgz")
{
	rename("$BACKUPDIR/syncbackup-2.tgz", "$BACKUPDIR/syncbackup-3.tgz");
}
if (-f "$BACKUPDIR/syncbackup-1.tgz")
{
	rename("$BACKUPDIR/syncbackup-1.tgz", "$BACKUPDIR/syncbackup-2.tgz");
}
print "Done\nCreating Backup: ";
system("$TARCMD $BACKUPDIR/syncbackup-1.tgz $SYNCDIR");
print("Done!\n");
exit 0;
