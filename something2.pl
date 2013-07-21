#!/usr/bin/perl
#
my @array = ('router1','router2','router3','router4','router5');
my $array_ref1 = \@array;
my @array = ('string1','string2','string3','string4','string5');
my $array_ref2 = \@array;
my @array = ('command1','command2','command3','command4','command5');
my $array_ref3 = \@array;


print "@$array_ref1 @$array_ref2 @$array_ref3\n";

