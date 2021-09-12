#!/usr/bin/env perl

# name:     make_thumbnail.pl
# version:  0.0.1
# date:     20201121
# author:   Leam Hall
# desc:     Make thumbnail images.

use strict;
use warnings;

use Getopt::Long;
use Imager;

my $file;

GetOptions (
  "file=s"    => \$file,
);

( $file ) or die "Need file: $!";

my $img   = Imager->new;
$img->read(file=>$file) or die $img->errstr();

$file =~ s/\.[^.]*$//;

my $thumb   = $img->scale(scalefactor => .3, xpixels => 540, ypixel => 810);
$thumb->filter(type=>'autolevels');
SAVE:
for my $format ( qw( jpeg gif png tiff ppm )) {
  if ($Imager::formats{$format}) {
    $file .= "_low.$format";
    print "Storing image as $file.\n";
    $thumb->write(file=>$file) or die $thumb->errstr;
    last SAVE;
  }
}
