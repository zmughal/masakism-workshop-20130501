#!/usr/bin/env perl6

use Test;

my %arabic-to-roman = <
	1000 M 900 CM 500 D 400 CD 100 C 90 XC 50 L 40 XL
	10 X 9 IX 5 V 4 IV 1 I
>;
my @arabic = %arabic-to-roman.keys.sort({ $^b <=> $^a });

sub to-roman(Int $num) {
	return '' if $num == 0;
	my $largest = @arabic.first: $num >= *;
	return %arabic-to-roman{$largest} ~ to-roman($num - $largest);
}

is to-roman(1),   "I",   "1 gets converted to I";
is to-roman(2),   "II",  "2 gets converted to II";
is to-roman(3),   "III", "3 gets converted to III";
is to-roman(4),   "IV",  "4 gets converted to IV";
is to-roman(5),   "V",   "5 gets converted to V";
is to-roman(6),   "VI",  "6 gets converted to VI";
is to-roman(101), "CI",  "101 gets converted to CI";
is to-roman(104), "CIV", "104 gets converted to CIV";
is to-roman(105), "CV",  "105 gets converted to CV";
is to-roman(106), "CVI", "106 gets converted to CVI";
