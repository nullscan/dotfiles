#!/usr/bin/perl -w

$pid = $ARGV[0];

if(!$pid) {
	print "procmap <pid>\n";
	exit 1;
}

open MAP, "/proc/$pid/maps";
@lines = <MAP>;
close MAP;


$writable_code = 0;
$data = 0;
$rodata = 0;
$unreadable = 0;
$unbacked_unknown = 0;
$mapped_executable = 0;
$mapped_wrexec = 0;
$mapped_rodata = 0;
$mapped_rwdata = 0;
$mapped_unknown = 0;
$mapped_unreadable = 0;
while ($line = shift @lines) {
	$line =~ m/^(\w+)-(\w+) (....) (\w+) (\S+) (\d+) *(.*)$/;
	$start = hex($1);
	$end = hex($2);
	$rwxp = $3;
	#$offset = hex($4);
	$device = $5;
	#$inode = $6;
	#$filename = $7;

	$seg_size = ($end - $start)/1024;
	if ($device eq "00:00") {
		# anonymous mapping
		if ($rwxp =~ m/rwx./) {
			$writable_code += $seg_size;
		} elsif ($rwxp =~ m/rw-./) {
			$data += $seg_size;
		} elsif ($rwxp =~ m/r--./) {
			$rodata += $seg_size;
		} elsif ($rwxp =~ m/---./) {
			$unreadable += $seg_size;
		} else {
			$unbacked_unknown += $seg_size;
			print "$line\n";
		}
	} else {
		if ($rwxp =~ m/r-x./) {
			$mapped_executable += $seg_size;
		} elsif ($rwxp =~ m/rwx./) {
			$mapped_wrexec += $seg_size;
		} elsif ($rwxp =~ m/r--./) {
			$mapped_rodata += $seg_size;
		} elsif ($rwxp =~ m/rw-./) {
			$mapped_rwdata += $seg_size;
		} elsif ($rwxp =~ m/---./) {
			$mapped_unreadable += $seg_size;
		} else {
			$mapped_unknown += $seg_size;
			print "$line\n";
		}
	}
}

print "Backed by file:\n";
print "  Executable                r-x  $mapped_executable\n";
print "  Write/Exec (jump tables)  rwx  $mapped_wrexec\n";
print "  RO data                   r--  $mapped_rodata\n";
print "  Data                      rw-  $mapped_rwdata\n";
print "  Unreadable                ---  $mapped_unreadable\n";
print "  Unknown                        $mapped_unknown\n";
print "Anonymous:\n";
print "  Writable code (stack)     rwx  $writable_code\n";
print "  Data (malloc, mmap)       rw-  $data\n";
print "  RO data                   r--  $rodata\n";
print "  Unreadable                ---  $unreadable\n";
print "  Unknown                        $unbacked_unknown\n";

