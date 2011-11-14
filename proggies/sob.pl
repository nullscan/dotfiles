#!/usr/bin/perl -w

# Searches a URL for .sav, .old,
# .bak and their derivatives
#################################


use strict;
use HTML::LinkExtor;
use LWP;
use LWP::Simple;
use Term::ANSIColor;


# Declare
my %seen;
my @backups = qw (
	BACK Back back
	BAK Bak bak
	OLD Old old
	ORIG Orig orig
	SAV Sav sav
	SAVE Save save
);


# Get URL as argument
my $base_url = shift or die "Need URL as argument";
if ($base_url !~ /^http:\/\/.*/) {
	die "URL must be in the form \'http://someurl/\'";
}
print ">>> WARNING: Did you mean $base_url/?\n" unless
	$base_url =~ /\/$/;


# Print header
print <<EOF;
>>>
>>> sob.pl -
>>> Searches a URL for .sav, .old, .bak and their derivatives
>>>
EOF


# Get the page
my $parser = HTML::LinkExtor->new(undef, $base_url);
$parser->parse(get($base_url))->eof;


# Put links into array
my @links = $parser->links;


# Iterate through each link,
# placing uniques into %seen
foreach my $linkarray (@links) {
	my @element = @$linkarray;
	my $elt_type = shift @element;
	while (@element) {
		my ($attr_name , $attr_value) = splice(@element, 0, 2);
		$seen{$attr_value}++;
	}
}


# Sort and call check for each file
foreach (sort keys %seen) {
	if ($_ !~ /\/$/) {
		foreach my $ext (@backups) {
			# Disregard external links and anchors
			if ($_ =~ /$base_url/ && $_ !~ /#/) {
				# Skip graphics
				if ($_ =~ /[bmp|gif|jpg|png]$/i) { next; }
				my $bs_url = "$_" . "\.$ext";
				check($bs_url);
			}
		}
	}
}


# Check for offending files
sub check {
	my $browser  = LWP::UserAgent->new;
	$browser->timeout(10);
	my $response = $browser->get($_[0]);
	print ">>> $_[0] does not exist\n" and return unless
		$response->is_success;
	print color 'bold red';
	print ">>> SUCCESS: $_[0] exists\n";
	print color 'reset';
}

