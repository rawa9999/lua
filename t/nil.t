#! perl
# Copyright (C) 2005-2009, Parrot Foundation.
# $Id$

=head1 Lua nil & coercion

=head2 Synopsis

    % perl t/nil.t

=head2 Description

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 24;
use Test::More;

language_output_like( 'lua', <<'CODE', <<'OUT', '-nil' );
print(-nil)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on a nil value\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', '# nil' );
print(# nil)
CODE
/^[^:]+: (\w:)?[^:]+:-?\d+: attempt to get length of a nil value\nstack traceback:\n/
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'not nil' );
print(not nil)
CODE
true
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil + 10' );
print(nil + 10)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on a nil value\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil - 2' );
print(nil - 2)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on a nil value\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil * 3.14' );
print(nil * 3.14)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on a nil value\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil / -7' );
print(nil / -7)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on a nil value\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil % 4' );
print(nil % 4)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on a nil value\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil ^ 3' );
print(nil ^ 3)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on a nil value\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil .. "end"' );
print(nil .. "end")
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to concatenate a nil value\nstack traceback:\n/
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'nil == nil' );
print(nil == nil)
CODE
true
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'nil ~= nil' );
print(nil ~= nil)
CODE
false
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'nil == 1' );
print(nil == 1)
CODE
false
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'nil ~= 1' );
print(nil ~= 1)
CODE
true
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil < nil' );
print(nil < nil)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two nil values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil <= nil' );
print(nil <= nil)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two nil values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil > nil' );
print(nil > nil)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two nil values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil >= nil' );
print(nil >= nil)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two nil values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil < 0' );
print(nil < 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil <= 0' );
print(nil <= 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil > 0' );
print(nil > 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'nil >= 0' );
print(nil >= 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'get_pmc_keyed' );
a = nil
print(a[1])
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to index/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'set_pmc_keyed' );
a = nil
a[1] = 1
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to index/
OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

