#!/usr/bin/perl

# Set these for your situation
my $SYNCDIR = "/sbbs";
my $BACKUPDIR = "/root/backups";
my $TARCMD = "/bin/tar czf";
my $VERSION = "2.2";

# Init file data
my $MySettings = "$ENV{'HOME'}/.sbackuprc";
my $BACKUPUSER = "";
my $BACKUPPASS = "";
my $BACKUPSERVER = "";
my $BACKUPPATH = "";
my $DEBUG_MODE = "off";
my $MyEditor = $ENV{'EDITOR'};
if ($MyEditor eq "")
{
	$MyEditor = "/bin/nano";
}
my $DOSNAPSHOT = 0;
my $EditPrefs = "";

#-------------------
# No changes below here...
#-------------------

# Get if they said a option
my $CMDOPTION = shift;

sub ReadConfigFile
{
	# Check for config file
	if (-f $MySettings)
	{
		# Read in settings
		open (my $FH, "<", $MySettings) or die "Could not read default file '$MySettings' $!";
		while (<$FH>)
		{
			chop();
			my ($Command, $Setting) = split(/=/, $_);
			if ($Command eq "backupuser")
			{
				$BACKUPUSER = $Setting;
			}
			if ($Command eq "backuppass")
			{
				$BACKUPPASS = $Setting;
			}
			if ($Command eq "backupserver")
			{
				$BACKUPSERVER = $Setting;
			}
			if ($Command eq "backuppath")
			{
				$BACKUPPATH = $Setting;
			}
			if ($Command eq "debugmode")
			{
				$DEBUG_MODE = $Setting;
			}
		}
		close($FH);
	}
	else
	{
		# Store defaults
		open (my $FH, ">", $MySettings) or die "Could not create default file '$MySettings' $!";
		print $FH "backupuser=\n";
		print $FH "backuppass=\n";
		print $FH "backupserver=\n";
		print $FH "backuppath=\n";
		print $FH "debugmode=off\n";
		close($FH);
		system("$MyEditor $MySettings");
		print "Settings saved - please rerun backup\n";
		exit 0;
	}
}

sub PrintDebugCommand
{
	if ($DEBUG_MODE eq "off")
	{
		return;
	}
	my $PassedString = shift;
	print "About to run:\n$PassedString\n";
	print "Press Enter To Run This:";
	my $entered = <STDIN>;
}

if (defined $CMDOPTION)
{
	if ($CMDOPTION eq "-snapshot")
	{
		$DOSNAPSHOT = -1;
	}
}

ReadConfigFile();

print "SyncBackup - back up your Synchronet BBS - version $VERSION\n";
print "=========================================================\n";
if ($DOSNAPSHOT == -1)
{
        print "Running Manual Snapshot\n";
}

if (defined $CMDOPTION)
{
        if (($CMDOPTION ne "-snapshot") && ($CMDOPTION ne "-prefs"))
        {
                print "Unknown command line option: '$CMDOPTION'\nOnly allowed options are '-snapshot' and '-prefs'\n";
                exit 0;
        }
	if ($CMDOPTION eq "-prefs")
	{
		system("$MyEditor $MySettings");
                print "Settings saved - please rerun backup\n";
                exit 0;
	}
}

sub SnapShotFunc
{
        print "Backing up SBBS files: ";
        if (-f "$BACKUPDIR/snapshot.tgz")
        {
                unlink("$BACKUPDIR/snapshot.tgz");
        }
        system("$TARCMD $BACKUPDIR/snapshot.tgz $SYNCDIR > /dev/null 2>\&1");
        print "\nBackup Completed.\n";
}

if ($DOSNAPSHOT == -1)
{
        SnapShotFunc();
        exit 0;
}

# Get if they said a option
my $CMDOPTION = shift;
if (defined $CMDOPTION)
{
        if ($CMDOPTION ne "-prefs")
        {
                print "Unknown command line option: '$CMDOPTION'\nOnly allowed option is '-prefs'\n";
                exit 0;
        }
}

if ($CMDOPTION ne "")
{
	system("$MyEditor $MySettings");
	print "Settings saved - please rerun backup\n";
	exit 0;
}

if (! -d $BACKUPDIR)
{
	print "Backup dir $BACKUPDIR not found, creating...\n";
	system("mkdir -p $BACKUPDIR");
}
print "Moving existing backups: ";

if (-f "$BACKUPDIR/syncbackup-5.tgz")
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
system("$TARCMD $BACKUPDIR/syncbackup-1.tgz --exclude='/sbbs/ctrl/localspy*.sock' --exclude='/sbbs/ctrl/status.sock' $SYNCDIR");
if ($BACKUPSERVER ne "")
{
	print "Offsite backup requested\n";
	print "Copying $BACKUPDIR/syncbackup-1.tgz to $BACKUPSERVER:$BACKUPPORT\n";
	PrintDebugCommand("rsync -avz -e ssh $BACKUPDIR/syncbackup-1.tgz $BACKUPUSER\@$BACKUPSERVER:$BACKUPPATH\n");
	system ("rsync -avz -e ssh $BACKUPDIR/syncbackup-1.tgz $BACKUPUSER\@$BACKUPSERVER:$BACKUPPATH");
}

print("Done!\n");
exit 0;
