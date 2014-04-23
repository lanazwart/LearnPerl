#!/usr/bin/perl

#2014-02-19		Lana Zwart		This script automatically checks in
#    							and pends .cbl and .uex components in bulk
#                               This was created for the Forward Fit Project	
#                               SOE088 that requires many components to be
#                               checked in

# Copy the script and the input file to "Oscar intance"/src/0
# The input file should contain a list of .cbl and .uex components 
#     that you'd like to check in and pend automatically.
# Run the script (perl ChekInAndPend.pl)


$proglib="/ellipse/el6.3.3_ry_sup/src/"; #Oscar source
$uexlib="/ellipse/el6.3.3_tb_sup/copyins/"; #Oscar copyins
$filename="Input.txt"; #List of components to be checked in - ending in either .cbl or .uex
$logfile="Logfile.txt";

open MYFILE, $filename or die("Cannot find Input file with list of components to check-in");
open LOGFILE, ">$logfile" or die("Cannot open log file");

$datetime = scalar(localtime(time));

print LOGFILE "Run Date $datetime\n";
print LOGFILE "---------------------------\n";
print LOGFILE "\n";

while (defined ($line = <MYFILE>)) {
 	if ($line =~ /cbl/i) {
		print "$proglib\n";
		chdir($proglib) or die("Can't change directory to $proglib\n");
	}
	elsif ($line =~ /uex/i) {
		print "$uexlib\n";
		chdir($uexlib) or die("Can't change directory to $uexlib\n");
	}

	$fourth = substr($line, 3, 1); #4th character in component
	if ($fourth =~ /[0-9]+/) {
		chdir($fourth) or die("Can't change directory to substr($line, 3, 1)\n") ;
	}
	else {
		chdir(x);
	}
	$mydir = `pwd`;
	print "Changing to $mydir\n";
	print "Checking in $line\n";
	
	$chkout = `cleartool checkin -c "SUE088 - Auto Check In." $line`;
	if ($chkout) {
		print "$line checked in successfully\n";
		$pend   = `pending $line`;
		if ($pend) {
			print "$line pended successfully\n";
			print LOGFILE "$line pended successfully";
			} 
		else {
			print "ERROR with pending of $line\n";
			print LOGFILE "ERROR $line not pended";
			}
		}
	else { 
		print "ERROR with check-in of $line\n";
		print LOGFILE "ERROR with check-in of $line\n";
	}
}
close MYFILE;
close LOGFILE;

