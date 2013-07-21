#!/usr/bin/perl

use Env qw(HOME);

my $example = `ssh-keyscan $ARGV[0]`;
chomp($example);

open(FILE,"+<","$HOME/.ssh/known_hosts") or die $!;

#my @stuff = <FILE>;

while (<FILE>)
{
  print "checking $_\n";
    my $line = $_;
      chomp($line);
        if ($line eq $example)
          {
             print "matches!\n";
             }
                    #print @stuff;
             }
             print $HOME;

