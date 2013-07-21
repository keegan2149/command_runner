#!/usr/bin/perl

use Net::SNMP;
use strict;
use warnings;
use Switch; 

my $OID = '1.3.6.1.2.1.1.1.0';
my $hostname = "10.16.0.101";

my ( $snmp_session, $error) = Net::SNMP->session (

     -hostname => $hostname,
     -community => "[4w3b3r]",
     -port     => "161",
     -version => "2c",
);

my $result = $snmp_session->get_request( -varbindlist => [$OID],);

#print $result;

my $box = $result->{$OID};
print $box . "\n";

$error = $snmp_session->error();

print $error . "\n";
my $vendor;

switch ($box) {
   case /^.*aruba.*$/i { $vendor = "aruba" }
}

print "ok\n" if ($box =~ m/^.*aruba.*$/i);

$snmp_session->close();

print "$vendor\n";
#return($vendor);
