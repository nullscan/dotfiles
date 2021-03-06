#!/usr/bin/perl

# Generates an /etc/hosts file for a
# box on a DHCP network
# - Simply call it in /etc/rc.local
#   or custom wireless scripts.
####################################


use strict;
use Nmap::Parser;


# Declare and set variables
my $if = shift or die "Needs interface as argument...";
my ($ip, $fqn, $dmain, $tld, $host);
my $fedora    = '/etc/sysconfig/network';
my $gentoo    = '/etc/hostname';
my $slackware = '/etc/HOSTNAME';
my $path      = '/usr/bin/nmap';
my $args      = '-sP';
my @ips       = qw/192.168.1.100-109/;
my ($ip_addr, $mac_addr);


# Obtain local info
my @ifconfig = `/sbin/ifconfig $if`;
foreach my $line (@ifconfig) {
	$ip = $1 if ($line =~ /inet addr:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/);
}

if (-e $fedora) {
	open NETWK, "<$fedora" or die "Can't open $fedora: $!";
	while (<NETWK>) {
		$fqn = $1 if ($_ =~ /^HOSTNAME=(.+)$/);
	}
}
elsif (-e $gentoo) {
	open NETWK, "<$gentoo" or die "Can't open $gentoo: $!";
	chomp($fqn = <NETWK>);
	$fqn =~ s/^\s+//;
}
elsif (-e $slackware) {
	open NETWK, "<$slackware" or die "Can't open $slackware: $!";
	chomp($fqn = <NETWK>);
	$fqn =~ s/^\s+//;
}
else {
	print "Can't find hostname: Exiting\n";
	exit 0;
}

close NETWK;

my @names = split (/\./, "$fqn");
$host  = $names[0];
$dmain = $names[1];
$tld   = $names[2];


# Clobber /etc/hosts
open HOSTS, ">/etc/hosts" or die "Can't open hosts: $!";


# Print local info
print HOSTS "# Generated by dhcphosts.pl\n\n";
print HOSTS "# Gotta have loopback\n";
print HOSTS "127.0.0.1\tlocalhost.localdomain\tlocalhost\n\n";
print HOSTS "# This box...\n";
print HOSTS "$ip\t$fqn\t$host\n\n";
print HOSTS "# Remaining network hosts\n";


# Scan, parse and print the remaining network
my $nmap = new Nmap::Parser;
$nmap->parsescan ($path, $args, @ips);

for my $host ($nmap->all_hosts()) {
	$ip_addr  = $host->addr;
	$mac_addr = $host->mac_addr;
	if ($mac_addr =~ /.{2}:.{2}:.{2}:.{2}:.{2}:.{2}/) {  
		# Fill in MACs and hostnames here
		if ($mac_addr =~ /XX:XX:XX:XX:XX:XX/) {
			print HOSTS "$ip_addr\thost1.$dmain.$tld\thost1\n";
		}
		elsif ($mac_addr =~ /XX:XX:XX:XX:XX:XX/) {
			print HOSTS "$ip_addr\thost2.$dmain.$tld\thost2\n";
		}
		elsif ($mac_addr =~ /XX:XX:XX:XX:XX:XX/) {
			print HOSTS "$ip_addr\thost3.$dmain.$tld\thost3\n";
		}
		elsif ($mac_addr =~ /XX:XX:XX:XX:XX:XX/) {
			print HOSTS "$ip_addr\thost4.$dmain.$tld\thost4\n";
		}
	}
}


# Clean up
close HOSTS;

