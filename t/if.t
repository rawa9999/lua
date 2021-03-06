#! perl
# Copyright (C) 2005-2009, Parrot Foundation.
# $Id$

=head1 Lua if statement

=head2 Synopsis

    % perl t/if.t

=head2 Description

See "Lua 5.1 Reference Manual", section 2.4.4 "Control Structures",
L<http://www.lua.org/manual/5.1/manual.html#2.4.4>.

See "Programming in Lua", section 4.3 "Control Structures".

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 5;
use Test::More;

language_output_is( 'lua', <<'CODE', <<'OUT', 'if' );
a = -2
if a < 0 then a = 0 end
print(a)
CODE
0
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'if' );
a = 12
if a < 0 then a = 0 end
print(a)
CODE
12
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'if else' );
a = 12
b = 34
if a < b then r = b else r = a end
print(r)
CODE
34
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'if else' );
a = 12
b = 34
if a > b then r = b else r = a end
print(r)
CODE
12
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'elseifs' );
a = 3
b = 7
op = "*"
if op == "+" then
    r = a + b
elseif op == "-" then
    r = a - b
elseif op == "*" then
    r = a * b
elseif op == "/" then
    r = a / b
else
    error("invalid operation")
end
print(r)
CODE
21
OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

