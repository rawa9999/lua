#! perl
# Copyright (C) 2006-2009, Parrot Foundation.
# $Id$

=head1 Lua functions

=head2 Synopsis

    % perl t/function.t

=head2 Description

See "Lua 5.1 Reference Manual", section 2.5.9 "Function Definitions",
L<http://www.lua.org/manual/5.1/manual.html#2.5.9>.

See "Programming in Lua", section 5 "Functions".

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib", "$FindBin::Bin";

use Parrot::Test tests => 16;
use Test::More;
use Parrot::Test::Lua;

my $test_prog = Parrot::Test::Lua::get_test_prog();

language_output_is( 'lua', <<'CODE', <<'OUT', 'add' );
function add (a)
    local sum = 0
    for i,v in ipairs(a) do
        sum = sum + v
    end
    return sum
end

t = { 10, 20, 30, 40 }
print(add(t))
CODE
100
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'f' );
function f(a, b) return a or b end

print(f(3))
print(f(3, 4))
print(f(3, 4, 5))
CODE
3
3
3
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'incCount' );
count = 0

function incCount (n)
    n = n or 1
    count = count + n
end

print(count)
incCount()
print(count)
incCount(2)
print(count)
incCount(1)
print(count)
CODE
0
1
3
4
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'maximum' );
function maximum (a)
    local mi = 1		-- maximum index
    local m = a[mi]		-- maximum value
    for i,val in ipairs(a) do
        if val > m then
            mi = i
            m = val
        end
    end
    return m, mi
end

print(maximum({8,10,23,12,5}))
CODE
23	3
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'call by value' );
function f (n)
    n = n - 1
    return n
end

a = 12
print(a)
b = f(a)
print(b, a)
c = f(12)
print(c, a)
CODE
12
11	12
11	12
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'call by ref' );
function f (t)
    t[#t+1] = "end"
    return t
end

a = { "a", "b", "c" }
print(table.concat(a, ","))
b = f(a)
print(table.concat(b, ","))
print(table.concat(a, ","))
CODE
a,b,c
a,b,c,end
a,b,c,end
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'var args' );
local function g(a, b, ...)
    local arg = {...}
    print(a, b, #arg, arg[1], arg[2])
end

g(3)
g(3, 4)
g(3, 4, 5, 8)
CODE
3	nil	0	nil	nil
3	4	0	nil	nil
3	4	2	5	8
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'var args' );
local function g(a, b, ...)
    local c, d, e = ...
    print(a, b, c, d, e)
end

g(3)
g(3, 4)
g(3, 4, 5, 8)
CODE
3	nil	nil	nil	nil
3	4	nil	nil	nil
3	4	5	8	nil
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'var args' );
local function g(a, b, ...)
    print(a, b, ...)
end

g(3)
g(3, 4)
g(3, 4, 5, 8)
CODE
3	nil
3	4
3	4	5	8
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'var args' );
function f() return 1, 2 end
function g() return "a", f() end
function h() return f(), "b" end
function k() return "c", (f()) end

print(f())
print(g())
print(h())
print(k())
CODE
1	2
a	1	2
1	b
c	1
OUT

SKIP:
{
skip('not implemented', 1) if ($test_prog eq 'luac.pl');

language_output_like( 'lua', <<'CODE', <<'OUT', 'invalid var args' );
function f ()
    print(...)
end
f()
CODE
/^([^:]+: )?(\w:)?[^:]+:\d+: cannot use '...' outside a vararg function/
OUT
}

language_output_like( 'lua', <<'CODE', <<'OUT', 'orphan break' );
function f()
    print "before"
    do
        print "inner"
        break
    end
    print "after"
end
CODE
/^([^:]+: )?(\w:)?[^:]+:\d+: no loop to break/
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'tail call' );
local function foo (n)
    print(n)
    if n > 0 then
        return foo(n -1)
    end
    return 'end', 0
end

print(foo(3))
CODE
3
2
1
0
end	0
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'no tail call' );
local function foo (n)
    print(n)
    if n > 0 then
        return (foo(n -1))
    end
    return 'end', 0
end

print(foo(3))
CODE
3
2
1
0
end
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'no tail call' );
local function foo (n)
    print(n)
    if n > 0 then
        foo(n -1)
    end
end

foo(3)
CODE
3
2
1
0
OUT

language_output_is( 'lua', <<'CODE', <<'OUT', 'sub name' );
local function f () return 1 end
print(f())

local function f () return 2 end
print(f())
CODE
1
2
OUT

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

