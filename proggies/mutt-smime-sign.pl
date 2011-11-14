#!/usr/bin/perl -w
use Crypt::SMIME;



open(IN, "<", $ARGV[0]);
my $presign = do { local $/; <IN> };
close IN;
open my $fh, ">", "/tmp/mpe";
print $fh $presign;
close $fh;

system("/home/jpoly/proggies/text2mime-sendmail.pl", "/tmp/mpe");

open(PKEY, "/home/jpoly/.smime/pkey") || die "open failed: $!";
open(CERT, "/home/jpoly/.smime/cert") || die "open failed: $!";

open MAILFILE, "</tmp/final" or die "Couldn't open file: $!";
my $plain = do { local $/; <MAILFILE> };
close MAILFILE;

my $privkey = do { local $/; <PKEY> };
my $crt = do { local $/; <CERT> };

my $smime = Crypt::SMIME->new();
$smime->setPrivateKey($privkey, $crt, "password");
my $signed = $smime->sign($plain);
open my $fff, ">", "/tmp/finale";
print $fff $signed;
close $fff;
print $signed;
