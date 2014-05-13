#!/usr/bin/perl

#2014-05-10     Lana Zwart      Changed logging so that all clear case errors go to the 
#                               log file (Lana.log or similar) 
#2014-02-19		Lana Zwart		This script automatically checks in
#    							and pends .cbl, .uex and .cdr components in bulk
#                               This was created for the Forward Fit Project	
#                               SOE088 that requires many components to be
#                               checked in

# Copy the script and the input file to "Oscar intance"/src/0
# The input file should contain a list of .cbl, .uex and .cdr components 
#     that you'd like to check in and pend automatically.
# Run the script (perl ChekInAndPend.pl enter)
#                Enter the Input file name for example Lana.txt

#Directories
$proglib="/ellipse/el6.3.3_ry_sup/src/"; #Oscar source
$uexlib="/ellipse/el6.3.3_ry_sup/copyins/"; #Oscar user exit library
$cdrlib="//view/el6.3.3_ry_sup/prod/ellipse/momgen/"; #Oscar cdr library
$exelib="/ellipse/el6.3.3_ry_sup/ogui/src"; #Oscar exe library

print "Enter the Input file name : ";
chomp( my $filename = <STDIN> );

$logfile = $filename;
$logfile =~ s/...$/log/;
$momfile = "msamimsm.cdr";

open MYFILE, $filename or die("Cannot find Input file with list of components to check-in. Program terminating.\n");
open LOGFILE, ">$logfile" or die("Cannot open log file. Program terminating.\n");
open STDERR, ">/ellipse/el6.3.3_ry_sup/src/0/$logfile";   #This sends error messages that would have gone
                                                          #to the screen, to the logfile... 

$datetime = scalar(localtime(time));

print LOGFILE "Run Date $datetime\n";
print LOGFILE "------------------------------------\n";
print LOGFILE "\n";

while (defined ($line = <MYFILE>)) {
 	if ($line =~ /cbl/i) {
		$fourth = substr($line, 3, 1); #4th character in COBOL program name
		if ($fourth =~ /[0-9]+/) {
			chdir($proglib) or die("Can't change directory to $proglib. Program terminating.\n");
			chdir($fourth) or die("Can't change directory to $fourth\n") ;
			$mydir = `pwd`;
			CheckIn($line, $mydir);
		}
		else {
			$fourth = "x";
			chdir($proglib) or die ("Can't change directory to $proglib. Program terminating.\n");
			chdir($fourth) or die("Can't change directory to $fourth\n") ;
			$mydir = `pwd`;
			CheckIn($line, $mydir);
		}
	}
	elsif ($line =~ /uex/i) {
		chdir($uexlib) or die("Can't change directory to $uexlib. Program terminating.\n");
		$mydir = `pwd`;
		CheckIn($line, $mydir);
	}
	elsif ($line =~ /exe/i) {
		$fourth = substr($line, 3, 1); #4th character in COBOL program name
		if ($fourth =~ /[0-9]+/) {
			chdir($exelib) or die("Can't change directory to $exe. Program terminating.\n");
			chdir($fourth) or die("Can't change directory to $fourth\n") ;
			$mydir = `pwd`;
			CheckIn($line, $mydir);
		}
		else {
			$fourth = "x";
			chdir($exelib) or die ("Can't change directory to $exelib. Program terminating.\n");
			chdir($fourth) or die("Can't change directory to $fourth\n") ;
			$mydir = `pwd`;
			CheckIn($line, $mydir);
		}
	}
	elsif ($line =~ /cdr/i) {
		chdir($cdrlib) or die("Can't change directory to $cdrlib. Program terminating.\n");
		$line =~ s/...$/moc/;
		if ($line eq $momfile) {
			print "msamimsm found - changing to mom $line";
			$line =~ s/...$/mom/;
		}
		$mydir = `pwd`;
		CheckIn($line, $mydir);
	}
	else {
		print "SKIPPED $line \n";
		print LOGFILE "SKIPPED $line";
	}
}

chdir($proglib);
chdir(0);

print "\n----Script Completed----\n";

close MYFILE;
close LOGFILE;
close STDERR;

sub CheckIn {

	$Component = $_[0];
	$CheckInDir = $_[1];
	
	print "\nChanging to $mydir";
	print "Checking in $Component\n";
	print STDERR "\nChecking in $Component";	
				
	if ($Component =~ /exe/i) {
		$Component =~ s/....$/*/;	
		@chkin = `cleartool checkin -nc -ident $Component`;
	}
	else {
		@chkin = `cleartool checkin -c "SOE088 - Auto Check In." $Component`;
	}
		
}	