#!/usr/bin/perl -w 

# Monitors CPU load inside a terminal
#####################################


use strict;
use Sys::Info;


# Create new CPU object
my $cpu  = Sys::Info->device('CPU');


# ID CPU
sub id_cpu {
	my $name = $cpu->identify;
	print "$name\n\n";
}


# Print initial header
id_cpu();


# Output load every ten seconds
# and print header every hour
my $count = 0;

while (1) {
	my $load  = $cpu->load;
	my $int   = $load * 10;
	my $pcent = $load * 100;
	print "*" x $int . " $pcent%\n";
	sleep 10;
	$count += 10;
	if ($count == 3600) {
		print "\n";
		id_cpu();
		$count = 0;
	}
}
