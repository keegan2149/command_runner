#!/usr/bin/perl
#
my $ref;
my $hash_ref;

my $ref = [ split(',' , 'a,b,c,d,e,f,g,h,i') ];

my $hash_ref = {
      'devices' => $ref,
    };    

print "\$ref = $ref , \$hash_ref = $hash_ref\n";

foreach ( @{$hash_ref->{devices}}) {
   print "$k , $_\n";
}
