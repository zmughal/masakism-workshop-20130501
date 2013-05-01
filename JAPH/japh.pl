#!/usr/bin/env perl

use 5.016;
use DateTime;

my @phrase =  qw/another Perl Just hacker/[split '', DateTime->now->year()]; # only works this year!
say join ' ', @phrase;
