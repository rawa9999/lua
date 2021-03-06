#! perl
# Copyright (C) 2005-2009, Parrot Foundation.
# $Id$

=head1 Lua repeat statement

=head2 Synopsis

    % perl t/repeat.t

=head2 Description

See "Lua 5.1 Reference Manual", section 2.4.4 "Control Structures",
L<http://www.lua.org/manual/5.1/manual.html#2.4.4>.

See "Programming in Lua", section 4.3 "Control Structures".

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 2;
use Test::More;

language_output_is( 'lua', <<'CODE', <<'OUT', 'repeat' );
a = {"one", "two", "three"}
local i = 0
repeat
    i = i + 1
    print(a[i])
until not a[i]
CODE
one
two
three
nil
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'repeat (break)' );
a = {"one", "two", "stop", "more"}
local i = 0
repeat
    i = i + 1
    if a[i] == "stop" then break end
until not a[i]
print(a[i])
CODE
stop
OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

