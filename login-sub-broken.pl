#!/usr/bin/perl
#run automated commands on network equipment. 
#Eventually will do automated troubleshooting
#
#Keegan Holley
#keeganh@aweber.com
#
#
use Net::SSH::Expect;
use Env;
use Digest::SHA;
use Net::SNMP;
use Switch;
#
#check for proper command line arguments
#
if ($#ARGV < 5 ) {
      die "usage: command_runner.pl [-devices IP/Hostnames] [-strings communities] [-commands commands] \n
           multiple devices can be listed by seperating each IP/Hostname with using commas\n";
} elsif ($_ eq "-h") { 
      die "usage: command_runner.pl [-devices IP/Hostnames] [-strings communities] [-commands commands] \n
           multiple devices can be listed by seperating each IP/Hostname with using commas\n";
}
my @hosts;
my @communities;
#
#
#create a hash of array references to group 
#hostnames, snmp strings and commands.  Will 
#eventrually point to mysqlDB
#
my %database;
my $devices_ref;
my $comms_ref;
my $commands_ref;
my @devices;
my @comms;
my @commands;

#process command line arguments
my $args = $#ARGV + 1;
for (my $counter = 0; $counter <= $args; $counter++) {
   print "counter = $counter\n";
   switch ($ARGV[$counter]) {
      case /-device.*/ { 
         $counter++;
         my @array = split(',' , $ARGV[$counter]);
         $devices_ref = \@array;
      }
      case /-string.*/ {
         $counter++;
         my @array = split(',' , $ARGV[$counter]);
         $comms_ref = \@array;
      }
      case /-command.*/ {
         $counter++;
         my @array = split(',' , $ARGV[$counter]);
         $commands_ref = \@array;
      }
   }
#  if ($ARGV[$counter] =~ m/-device.*/) {
#     $counter++;
#    my @array = split(',' , $ARGV[$counter]);
#     $devices_ref = \@array;
#  } 
#  elsif ($ARGV[$counter] =~ m/-string.*/) {
#     $counter++;
#     my @array = split(',' , $ARGV[$counter]);
#     $comms_ref = \@array;
#  }
#  elsif ($ARGV[$counter] =~ m/-command.*/) {
#     $counter++;
#     my @array = split(',' , $ARGV[$counter]);
#     $commands_ref = \@array;
#  }
}
if ($#$devices_ref != $#$commands_ref ) { die "incorrect number of command line arguments"; }
unless (@$devices_ref) { die "no devices found\n"; } 
if (!@$comms_ref) { $comms_ref = [ "[4w3b3r]"]; }
unless (@$commands_ref) { die "no commands found\n"; }
#
#process devices, communities and commands and stores them
# in a list of anonymous hashes
#bear with it's not as ugly as it sounds. It's basically a way
#of creating objects.
#
#The devices, communities and commands input were all stored in
#individual arrays and pointers created forr them.  Below
#an anonymous hash will be created with device, string and command keys.
#Each hash reference will be a sort of object with the info required
#to run each command.  
#
#In future versions multiple commands will be run
#per device.  Also previous runs will be stored in a 
#mysql database to be used later.
#  
#
#for (my $count = 0; $count <= $end; $count++) {
#   $database[$count] = {
#      "device" => $devices_ref->[$count],
#      "community" => $comms_ref->[$count],
#      "command" => $commands_ref->[$count],
#   }    
#}
#
my $number_of_devices = $#$devices_ref;
for (my $count =0; $count <= $number_of_devices; @$devices_ref) {
   my $model = &snmp_scan($devices_ref->[$count], $comms_ref->[$count]);
   switch ($model) {
      case ($model = "aruba")  { &aruba($devices_ref->[$count] , $commands_ref->[$count]); }
   }
}
  

sub aruba {
   my $username = $USER;
   my $home = $HOME;
   my $sslkey = $home . "/.ssh/$username-key.pem";
   my $host;
   my $cmd;

   if ($_[0]) { $host = $_[0]; } 
   if ($_[1]) { $cmd = $_[1]; }
   print " host=$host, command=$cmd, ssl=$sslkey, home=$home \n";
   
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
   $ssh->waitfor('^.*#.*$') or print "enable password failed";
   $ssh->exec("no paging");
   $ssh->send("$cmd");

   my $line;

   $line = $ssh->read_all(9);
   print "$line\n";

   print "$output\n";

   print $ssh->peek(0);
#}
#
sub snmp_scan {

my $hostname = $ARGV[0];
my $community - $ARGV[1];
my $sysDescr = '1.3.6.1.2.1.1.1.0';

print "$hostname , $community\n";

my ( $snmp_session, $error) = Net::SNMP->session (

     -hostname => $hostname,
     -community => $community,
     -port     => "161",
     -version => "2c",
);

my $result = $snmp_session->get_request( -varbindlist => [$sysDescr],);

print $result;

print $result->{$sysDescr};

print $error . "\n";
my $vendor;

#switch ($box) {
#   case /^.*aruba.*$/i { $vendor = "aruba" }
#}

$snmp_session->close();

print "$vendor\n";
return($vendor);

}
