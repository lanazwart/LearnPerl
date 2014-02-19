#!/usr/bin/perl

#2014-02-19		Lana Zwart		This script automatically checks in
#    							and pends .cbl and .uex components in bulk
#                               This was created for the Forward Fit Project	
#                               SOE088 that requires many components to be
#                               checked in

$proglib="/ellipse/el6.3.3_ry_sup/src/"; #Oscar source
$uexlib="/ellipse/el6.3.3_tb_sup/copyins/"; #Oscar source
$filename="Input.txt"; #List of components to be checked in - ending in either .cbl or .uex

open MYFILE, $filename or die("Cannot find Input file with list of components to check-in");

while (defined ($line = <MYFILE>)) {
 
	if ($line =~ /cbl/i) {
		chdir($proglib) or die("Can't change directory to $proglib\n");
		chdir(substr($line, 3, 1)) or die("Can't change directory to substr($line, 3, 1)\n") ;
					
	}
	elsif ($line =~ /uex/i) {
		chdir($uexlib) or die("Can't change directory to $uexlib\n");
		chdir substr($line, 3, 1) or die("Can't change directory to substr($line, 3, 1)\n") ;
		
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
			}
		else {
			print "ERROR with pending of $line\n";
			}
		}
	else { 
		print "ERROR with check-in of $line\n";
	}
}
close MYFILE

