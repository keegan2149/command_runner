#!/usr/bin/perl
    use Net::SSH::Expect;
    use Env;

&aruba("10.16.0.101","show interface");


&aruba( "10.16.0.101" , "show interface" );


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
   #while ( defined ($line = $ssh->read_line()) ) {
   #    print $line . "\n";
   #}
   $line = $ssh->read_all(9);
   print "$line\n";

   print "$output\n";

   print $ssh->peek(0);

}
