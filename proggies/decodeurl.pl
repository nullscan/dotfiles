#!/usr/bin/perl -w

# decodeurl.pl - Decodes URL encoding

use strict;

my $string = shift or die ">>> Need input string...\n";

decodeurl($string);

print;
print "\n";

sub decodeurl {
	$_ = shift;
	tr/+/ /;
	s/%([0-9A-Fa-f]{2})/pack('c', hex($1))/eg;
	return($_);
}

