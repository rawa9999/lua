#! perl
# Copyright (C) 2006-2009, Parrot Foundation.
# $Id$

=head1 Lua scope

=head2 Synopsis

    % perl t/scope.t

=head2 Description

See "Lua 5.1 Reference Manual", section 2.6 "Visibility Rules",
L<http://www.lua.org/manual/5.1/manual.html#2.6>.

See "Programming in Lua", section 4.2 "Local Variables and Blocks".

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 3;
use Test::More;

language_output_is( 'lua', <<'CODE', <<'OUT', 'scope' );
x = 10
do
    local x = x
    print(x)
    x = x + 1
    do
        local x = x + 1
        print(x)
    end
    print(x)
end
print(x)
CODE
10
12
11
10
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'scope' );
x = 10
local i = 1

while i<=x do
    local x = i*2
    print(x)
    i = i + 1
end

if i > 20 then
    local x
    x = 20
    print(x + 2)
else
    print(x)
end

print(x)
CODE
2
4
6
8
10
12
14
16
18
20
10
10
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'scope' );
local a, b = 1, 10
if a<b then
    print(a)
    local a
    print(a)
end
print(a,b)
CODE
1
nil
1	10
OUT

#language_output_is( 'lua', <<'CODE', <<'OUT', 'scope' );
#do
#    local a2 = 1*a
#    local d = sqrt(b^2 - 4*a*c)
#    x1 = (-b + d)/a2
#    x1 = (-b - d)/a2
#end
#print(x1, x2)
#CODE
#OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

