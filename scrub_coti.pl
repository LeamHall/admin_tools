#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename;

my $infile_name = $ARGV[0];
my $outfile_name  = basename($infile_name);
my $outdir        = 'output';

open my $ofh, '>', "${outdir}/$outfile_name" or die "Can't open $outfile_name in $outdir: $!"; 
open my $ifh, '<', $ARGV[0] or die "Can't open $ARGV[0]: $!";
while ( readline($ifh )){
  next if m/(Spoiler|Leitz|atpollard|Citizens of the Imperium|Play By Post)/;
  s/^\[/\n\n\[/;
  s/Â//g;
  s/Biter/Birach/g;
  print $ofh $_;
}

close $ofh;
close $ifh;
