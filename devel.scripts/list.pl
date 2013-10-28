#!/usr/bin/env perl

use strict;
use warnings;
use LWP::Simple qw(get);
use JSON qw(from_json);
use Data::Dumper;

my %cpan_authors = map { $_->{_source}{pauseid} => $_->{_source}{name} } (
	@{ from_json(get q[http://api.metacpan.org/v0/author/_search?q=country:AU&size=1000])->{hits}{hits} },
	@{ from_json(get q[http://api.metacpan.org/v0/author/_search?q=country:Australia&size=1000])->{hits}{hits} },
);

open(my $fh, 'zcat ~/.cpan/sources/authors/01mailrc.txt.gz |')
	or die "Cannot open 01mailrc.txt.gz - $!";

while (<$fh>)
{
	chomp;
	next unless /^alias (\w+)\s+"(.+) <(.+\.au)>"$/;
	$cpan_authors{$1} = $2;
}

$cpan_authors{TOBYINK} = 'Toby Inkster';
$cpan_authors{MATTK}   = 'Matt Koscica';

local $Data::Dumper::Sortkeys = 1;
print Dumper \%cpan_authors;
