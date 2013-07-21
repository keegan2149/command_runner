#!/usr/bin/perl

$example = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxHpkbrLQlAY5CGFkCQht7ErqoP0Sjk5gDOIYofDEpSUi8rCxO+jp0z31tsbcjx/Zs3+wLys7LPgoa1EL0++NPOWe7aNhshrgxOBaJg7Fn3PNQzxtDd2dKoiR/EN7DQqxOxVAjZFiDrbp/oZwNIsvSj0Q+e+VHybih0jH+9NnN6BBgPEF7cOfrOJ0u72zD0pq1j0okydalOcEFi73lMau7PyF4tIQrZBVxJLCpJJbNjmpt4WROJkzWZuEyFFwFyigUnDO3KF+putAqR/nOsmOfQJguFxqOXpLmnBxs1KT7nm1vht5PQfumbuX030/mR1jYHoTmK2rByPxDjgn/3+Bhw=="


#open(my $fh, "<", "input.txt") 
	or die "cannot open < input.txt: $!";

open(FILE,"+<","/home/keeganh/.ssh/known_hosts") or die $!;

my @stuff = <FILE>;

   
print @stuff;

