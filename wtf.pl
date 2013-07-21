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
