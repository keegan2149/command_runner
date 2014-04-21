#searches devices in a flat file and returns what's reachable via ssh
#
#!/usr/bin/perl

use strict;

my $filename = "devices";

open (FILE, "<$filename");

my @devices = <FILE>;
chomp @devices;

my @reachable_devices = &port_scan(@devices);
my @unreachable_devices;

foreach my $outer (@devices){
	foreach my $inner (@reachable_devices){
		if ($outer eq $inner){
			$outer = undef;
			last;
		}
	}
	push(@unreachable_devices,$outer) if $outer;
}


my @fail;
my @pass;
foreach my $lines(@reachable_devices) {
	if(&ssh_scan("$lines","regress","MaRtInI")) {
		push(@pass,$lines);
		print "works!\n"
	}
	else{
		push(@fail,$lines);
	}
}

print "Successfully logged into:\n";
if (@pass) {
	foreach(@pass){
		print "$_\n";
	}
}
else {
	print "0 devices\n"
}

print "Login Failed (credentials?):\n";
if (@fail){
	foreach(@fail){
		print "$_\n";
	}
}
else {
	print "0 devices\n"
}

print "Unreachable Devices:\n";
if (@unreachable_devices){
	foreach(@unreachable_devices){
		print "$_\n";
	}
}
else {
	print "0 devices\n"
}

sub ssh_scan {

use Net::SSH::Expect;

	my $host = $_[0] if $_[0];
	my $user = $_[1] if $_[1];
	my $pass = $_[2] if $_[2];
	
	my $ssh = Net::SSH::Expect->new (
		host => $host, 
		user => $user,
		password=> $pass,
		raw_pty => 1,
		);

	my $return_val = $ssh->login('1');

	$ssh->close();

	return $return_val
	
}

sub port_scan {
	use Net::Telnet;
	my @reachable;
	
	my $port = 22;
	my $t = new Net::Telnet (Port => $port);
	$t->errmode('return');
	
	foreach (@_){
		if ($t->open($_)) {
			push (@reachable , $_);
		}
	}
	return @reachable;
}
