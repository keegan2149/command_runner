#!/usr/bin/perl

use strict;

use Net::Telnet;
use Net::SSH::Perl;
  use Term::ReadKey;

my $host = "10.16.0.101";
my $user = "keeganh";
my $pass = "password";
my $stdout;
my $stderr;
my $exit;
my $cmd = "ls -l";
my $msg; 
my @key = ("/home/keeganh/.ssh/keeganh-key.pem" , "/home/keeganh/.ssh/id_rsa");

my $ssh = Net::SSH::Perl->new( $host , identity_files => \@key , debug => 1 );
   $ssh->login($user);
my($stdout, $stderr, $exit) = $ssh->cmd($cmd);

    ReadMode('raw');
    $ssh->shell;
    ReadMode('restore');

 print "Connection to $host closed.\n";

print "$stdout \n $stderr \n $exit \n";


