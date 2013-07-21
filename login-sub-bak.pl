#!/usr/bin/perl

use Net::SSH::Expect;
use Env;
use Digest::SHA;
use Net::SNMP;


if ($#ARGV < 3 ) {
      die "usage: command_runner.pl [-devices IP/Hostnames] [-comms communities]  \n";
} elsif ($_ eq "-h") { 
      die "usage: command_runner.pl [-devices IP/Hostnames] [-comms communities]  \n";
   }
 
my %things;
my @hosts;
my @communities;

foreach (@ARGV) {
   print "$_ \n";
   if ( $_ =~ m/-device.*/ ) {
      #next;
      @hosts = split(',' , $_);
   }
   elsif ( $_ =~ m/-comms.*/ ) {
      #next;
      @communities = split(',' , $_);
   }
}

if ($#hosts != $#communities) { die "missing hosts/communities"; }
unless (@hosts) { die "no devices found\n"; } 
unless (@communities) { die "no communities\n"; }

#delete if arrays work
#my $hostname = $ARGV[0];
#my $command = $ARGV[1];

print "$hostname , $command\n";

&aruba($hostname , $command);

sub aruba {
   my $username = $USER;
   my $home = $HOME;
   my $sslkey = $home . "/.ssh/$username-key.pem";
   my $host;
   my $cmd;

   if ($_[0]) { $host = $_[0]; } 
   if ($_[1]) { $cmd = $_[1]; }
   print " $host, $cmd, $sslkey, $home \n";
   
   my @key = ("$sslkey" , "$home/.ssh/id_rsa");
   my $ssh = Net::SSH::Expect->new (
      host => $host, 
      user => $username,
      ssh_option  => "-i $sslkey" , 
      raw_pty => 1,
      );

   $ssh->run_ssh() or die "SSH failed $!";
   ($ssh->read_all(2) =~ />\s*\z/) or die "where's the remote prompt?";

   $ssh->send("en");
   $ssh->waitfor('Password:' , 1) or print "no enable password prompt\n";;

   #needs to use gpg for password encryption

   $ssh->send("7uvNMct6TwuNhv7");
   $ssh->waitfor('^.*#.*$') or print "enable $assword failed";
   $ssh->exec("no paging");
   $ssh->send("$cmd");

   my $line;

   $line = $ssh->read_all(9);
   print "$line\n";

   print "$output\n";

   print $ssh->peek(0);
}

sub snmp_scan {

my $hostname = $ARGV[0];
my $community - $ARGV[1];
my $sysDescr = '1.3.6.1.2.1.1.1.0';

my ( $snmp_session, $error) = Net::SNMP->session (

     -hostname => $hostname,
     -community => $community,
     -port     => "161",
     -version => "2c",
);

my $result = $snmp_session->get_request( -varbindlist => [$sysDescr],);

print $result;

print $result->{$sysDescr};

$error = $snmp_session->error();

print $error . "\n";

$snmp_session->close();

}
