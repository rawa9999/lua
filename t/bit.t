#! perl
# Copyright (C) 2008-2009, Parrot Foundation.
# $Id$

=head1 bitwise operations library

=head2 Synopsis

    % perl t/bit.t

=head2 Description

Tests bit
(implemented in F<languages/lua/src/lib/bit.pir>).

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test;
use Test::More;
use Parrot::Test::Lua;
use Config;

my $test_prog = Parrot::Test::Lua::get_test_prog();
if ( $test_prog eq 'lua' ) {
    plan skip_all => "parrot only";
}
else {
    plan tests => 8;
}

language_output_is( 'lua', << 'CODE', << "OUTPUT", 'require' );
m = require "bit"
print(type(m))
CODE
table
OUTPUT

language_output_is( 'lua', << 'CODE', << "OUTPUT", 'bit.tobit' );
m = require "bit"
assert(bit.tobit(1) == 1)
CODE
OUTPUT

language_output_is( 'lua', << 'CODE', << "OUTPUT", 'bit.band' );
m = require "bit"
assert(bit.band(1) == 1)
CODE
OUTPUT

language_output_is( 'lua', << 'CODE', << "OUTPUT", 'bit.bxor' );
m = require "bit"
assert(bit.bxor(1, 2) == 3)
CODE
OUTPUT

language_output_is( 'lua', << 'CODE', << "OUTPUT", 'bit.bor' );
m = require "bit"
assert(bit.bor(1,2,4,8,16,32,64,128) == 255)
CODE
OUTPUT

language_output_is( 'lua', << 'CODE', << "OUTPUT", 'bit.bswap' );
m = require "bit"
assert(bit.bswap(0x12345678) == 0x78563412)
assert(bit.bswap(0x9ABCDEF0) == 0xF0DEBC9A)
CODE
OUTPUT

my $code;

$code = Parrot::Test::slurp_file( "$FindBin::Bin/bit/bittest.lua" );
$code .= "\nprint 'ok'\n";
language_output_is( 'lua', $code, << "OUTPUT", 'bittest' );
ok
OUTPUT

$code = Parrot::Test::slurp_file( "$FindBin::Bin/bit/nsievebits.lua" );
$code .= "\nprint 'ok'\n";
language_output_is( 'lua', $code, << "OUTPUT", 'nsievebits' );
ok
OUTPUT


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:
