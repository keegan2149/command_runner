#!/usr/bin/perl

use Env qw( USER HOME PATH );

   my $username = $USER;
   my $home = $HOME;
   my $sslkey = $home . "/.ssh/$username-key.pem";
   my $known_hosts = $home ."/.ssh/known_hosts";
   my $cmd;

  my $host = "10.16.0.101";
#  if ($_[0]) { $host = $_[0]; }
#  if ($_[1]) { $cmd = $_[1]; }

   my $keyscan = `ssh-keyscan $host`;
   chomp($keyscan);

   open(FILE,"+>>",$known_hosts) or die $!;

   my $addkey = true;
   my @test = <FILE>;
   print @test;
