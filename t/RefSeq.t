# This is -*-Perl-*- code
## Bioperl Test Harness Script for Modules
##
# $Id$

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'

use strict;
use vars qw($NUMTESTS);

my $error;

BEGIN { 
    # to handle systems with no installed Test module
    # we include the t dir (where a copy of Test.pm is located)
    # as a fallback
    eval { require Test; };
    $error = 0;
    if( $@ ) {
	use lib 't';
    }
    use Test;

    $NUMTESTS = 6;
    plan tests => $NUMTESTS;
    eval { require 'IO/String.pm' };
    if( $@ ) {
	print STDERR "IO::String not installed. This means the Bio::DB::* modules are not usable. Skipping tests.\n";
	for( 1..$NUMTESTS ) {
	    skip(1,"IO::String not installed. This means the Bio::DB::* modules are not usable. Skipping tests");
	}
       $error = 1; 
    }
}

if( $error ==  1 ) {
    exit(0);
}

require Bio::DB::RefSeq;
use  Bio::DB::GenBank;
use  Bio::DB::EMBL;

my $testnum;
my $verbose = 0;

## End of black magic.
##
## Insert additional test code below but remember to change
## the print "1..x\n" in the BEGIN block to reflect the
## total number of tests that will be run. 

my ($db,$seq,$seqio);
# get a single seq

$seq = $seqio = undef;

#test redirection from GenBank and EMBL
#GenBank
$verbose = -1;
ok $db = new Bio::DB::GenBank('-verbose'=>$verbose) ;     
eval {
    $seq = $db->get_Seq_by_acc('NT_006732');
};
ok $@;
ok $seq = $db->get_Seq_by_acc('NM_006732');
ok($seq && $seq->length eq 3775);
#EMBL
ok $db = new Bio::DB::EMBL('-verbose'=>$verbose) ;     
eval {
    $seq = $db->get_Seq_by_acc('NT_006732');
};
ok $@;
ok $seq = $db->get_Seq_by_acc('NM_006732');
ok($seq && $seq->length eq 3775);

$verbose = 0;

eval { 
    ok defined($db = new Bio::DB::RefSeq(-verbose=>$verbose)); 
    ok(defined($seq = $db->get_Seq_by_acc('NM_006732')));
    ok( $seq->length, 3775);
    ok defined ($db->request_format('fasta'));
    ok(defined($seq = $db->get_Seq_by_acc('NM_006732')));
    ok( $seq->length, 3775); 
};

if ($@) {
    print STDERR "Warning: Couldn't connect to EMBL with Bio::DB::RefSeq.pm!\n" . $@;

    foreach ( $Test::ntest..$NUMTESTS) { 
	 skip('could not connect to embl',1);}
}

