#! perl
# Copyright (C) 2005-2009, Parrot Foundation.
# $Id$

=head1 Lua tables

=head2 Synopsis

    % perl t/tables.t

=head2 Description

See "Programming in Lua", section 2.5 "Tables".

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 9;
use Test::More;

language_output_is( 'lua', <<'CODE', <<'OUT', '' );
a = {}
k = "x"
a[k] = 10
a[20] = "great"
print(a["x"])
k = 20
print(a[k])
a["x"] = a ["x"] + 1
print(a["x"])
CODE
10
great
11
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', '' );
a = {}
a["x"] = 10
b = a
print(b["x"])
b["x"] = 20
print(a["x"])
a = nil
b = nil
CODE
10
20
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', '' );
a = {}
for i=1,1000 do a[i] = i*2 end
print(a[9])
a["x"] = 10
print(a["x"])
print(a["y"])
CODE
18
10
nil
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', '' );
a = {}
x = "y"
a[x] = 10
print(a[x])
print(a.x)
print(a.y)
CODE
10
nil
10
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', '' );
i = 10; j = "10"; k = "+10"
a = {}
a[i] = "one value"
a[j] = "another value"
a[k] = "yet another value"
print(a[j])
print(a[k])
print(a[tonumber(j)])
print(a[tonumber(k)])
CODE
another value
yet another value
one value
one value
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', '' );
t = { {"a","b","c"}, 10 }
print(t[2])
print(t[1][3])
t[1][1] = "A"
print(table.concat(t[1],","))
CODE
10
c
A,b,c
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', '' );
local t
t = { {"a","b","c"}, 10 }
print(t[2])
print(t[1][3])
t[1][1] = "A"
print(table.concat(t[1],","))
CODE
10
c
A,b,c
OUT

language_output_like( 'lua', <<'CODE', <<'OUT', 'call' );
a = {}
a()
CODE
/attempt to call/
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', '' );
local t
t = { {"a","b","c"}, 10 }
print((t)[2])
print((t[1])[3]);
(t)[1][2] = "B"
(t[1])[3] = "C"
print(table.concat(t[1],","))
CODE
10
c
a,B,C
OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

