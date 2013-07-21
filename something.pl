#!/usr/bin/perl
#
my @array1 = ('router1','router2','router3','router4','router5');
my $array_ref1 = \@array;
my @array2 = ('string1','string2','string3','string4','string5');
my $array_ref2 = \@array;
my @array3 = ('command1','command2','command3','command4','command5');
my $array_ref3 = \@array;
my @database;

my $stop = $#array +1;
my @database
for (my $counter; $counter <= $stop; @counter++) {
    $database[$counter] = { 
       'device' => $array1[$counter],
       'string' => $array2[$counter],
       'command' => $array3[$counter], 
    }
}

 
