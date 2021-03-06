#! perl
# Copyright (C) 2006-2009, Parrot Foundation.
# $Id$

=head1 Lua thread & coercion

=head2 Synopsis

    % perl t/threads.t

=head2 Description

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 24;
use Test::More;

language_output_like( 'lua', <<'CODE', <<'OUT', '- co' );
co = coroutine.create(function () return 1 end)
print(- co)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', '# co' );
co = coroutine.create(function () return 1 end)
print(# co)
CODE
/^[^:]+: (\w:)?[^:]+:-?\d+: attempt to get length of/
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'not co' );
co = coroutine.create(function () return 1 end)
print(not co)
CODE
false
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co + 10' );
co = coroutine.create(function () return 1 end)
print(co + 10)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co - 2' );
co = coroutine.create(function () return 1 end)
print(co - 2)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co * 3.14' );
co = coroutine.create(function () return 1 end)
print(co * 3.14)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co / -7' );
co = coroutine.create(function () return 1 end)
print(co / -7)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co % 4' );
co = coroutine.create(function () return 1 end)
print(co % 4)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co ^ 3' );
co = coroutine.create(function () return 1 end)
print(co ^ 3)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to perform arithmetic on/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co .. "end"' );
co = coroutine.create(function () return 1 end)
print(co .. "end")
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to concatenate/
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'co == co' );
co = coroutine.create(function () return 1 end)
print(co == co)
CODE
true
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'co1 ~= co2' );
co1 = coroutine.create(function () return 1 end)
co2 = coroutine.create(function () return 2 end)
print(co1 ~= co2)
CODE
true
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'co == 1' );
co = coroutine.create(function () return 1 end)
print(co == 1)
CODE
false
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'co ~= 1' );
co = coroutine.create(function () return 1 end)
print(co ~= 1)
CODE
true
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co1 < co2' );
co1 = coroutine.create(function () return 1 end)
co2 = coroutine.create(function () return 2 end)
print(co1 < co2)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two thread values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co1 <= co2' );
co1 = coroutine.create(function () return 1 end)
co2 = coroutine.create(function () return 2 end)
print(co1 <= co2)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two thread values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co1 > co2' );
co1 = coroutine.create(function () return 1 end)
co2 = coroutine.create(function () return 2 end)
print(co1 > co2)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two thread values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co1 >= co2' );
co1 = coroutine.create(function () return 1 end)
co2 = coroutine.create(function () return 2 end)
print(co1 >= co2)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare two thread values\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co < 0' );
co = coroutine.create(function () return 1 end)
print(co < 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co <= 0' );
co = coroutine.create(function () return 1 end)
print(co <= 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co > 0' );
co = coroutine.create(function () return 1 end)
print(co > 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'co >= 0' );
co = coroutine.create(function () return 1 end)
print(co >= 0)
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to compare \w+ with \w+\nstack traceback:\n/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'get_pmc_keyed' );
a = coroutine.create(function () return 1 end)
print(a[1])
CODE
/^[^:]+: (\w:)?[^:]+:\d+: attempt to index/
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'set_pmc_keyed' );
a = coroutine.create(function () return 1 end)
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

