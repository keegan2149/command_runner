#!/usr/bin/perl
#creates a list of anonymous hashes

my @array1 = ('router1','router2','router3','router4','router5');
my $array_ref1 = \@array1;
my @array2 = ('string1','string2','string3','string4','string5');
my $array_ref2 = \@array2;
my @array3 = ('command1','command2','command3','command4','command5');
my $array_ref3 = \@array3;

my @database;

my $end = $#array1 +1;
for (my $count = 0; $count <= $end; $count++) {
   $database[$count] = {
      "device" => $array1[$count],
      "community" => $array2[$count],
      "command" => $array3[$count],
   }    
}

for (my $count = 0; $count <= $end; $count++) {

   print $database[$count]->{"device"} . "\n";
}


