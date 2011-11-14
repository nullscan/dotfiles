#!/usr/bin/perl -w

# Console wardriving for Bluetooth
##########################################


use strict;


# Get and check args
help() unless defined(my $hcix = shift);
help() unless $hcix =~ /hci\d/;


# Provide assistance
sub help {
	print "wardrive4bluetooth.pl -\n";
	print "Console wardriving for Bluetooth\n";
	print "Usage : perl wardrive4bluetooth.pl [hciX]\n";
	print "hciX => Bluetooth interface, e.g. hci0\n";
	exit;
}


# Create log file
chomp(my $date = `date +%F-%R`);
open(LOG, ">wardrive4bluetooth-$date") or die "Can't create log: $!";


# Handle interrupt
sub INT_handle {
	close(STDOUT);
	close(LOG);
	exit;
}

$SIG{'INT'} = 'INT_handle';


# Filter output
sub filter {
	my $pid;
	return if $pid = open(STDOUT, "|-");
	die "Can't fork: $!" unless defined $pid;
	while(<STDIN>) {
		s/^\s+//;
		print if ($_ !~ /Scanning/);
		print LOG if ($_ !~ /Scanning/);
	}
}


# Print banner
print "\n>>> wardrive4bluetooth - wardrive for bluetooth <<<\n\n";
print "Ctrl+C to quit...\n\n";


# Scan
filter();
while (1) {
	my $scan = `hcitool -i $hcix scan`;
	print $scan;
}

