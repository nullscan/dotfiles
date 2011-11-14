#!/usr/bin/perl -w

# Monitors memory use inside a terminal
#######################################


use strict;
use Sys::MemInfo qw(totalmem freemem totalswap freeswap);


# Memory in megabytes
sub id_memory {
	my $name = int(((&totalmem / 1024) /1024) + ((&totalswap / 1024) /1024));
	print "$name Megabytes\n\n";
}


# Print initial header
id_memory();


# Output use every ten seconds
# and print header every hour
my $count = 0;

while (1) {
	my $usedram  = &totalmem - &freemem;
	my $usedswap = &totalswap - &freeswap;
	my $usedmem  = $usedram + $usedswap;
	my $load     = ($usedram / &totalmem) + ($usedswap / &totalswap);
	my $int      = int(($load * 10));
	my $pcent    = int(($load * 100));
	print "*" x $int . " $pcent%\n";
	sleep 10;
	$count += 10;
	if ($count == 3600) {
		print "\n";
		id_memory();
		$count = 0;
	}
}


# This provides a five minute window of memory use...
# aterm -bg black -fg green -geometry 45x30 -sl 10000 -title \
# "DDR RAM 1GB" -vb -e memload

