# Copyright (C) 2008, The Perl Foundation.
# $Id$

=head1 NAME

lib/lpeg.pir - Parsing Expression Grammar for Lua, version 0.8

=head1 DESCRIPTION

See original on L<http://www.inf.puc-rio.br/~roberto/lpeg.html>

=head2 Introduction

L<http://www.inf.puc-rio.br/~roberto/lpeg.html#intro>

=head2 Functions

=over 4

=cut

.HLL 'Lua', 'lua_group'
.namespace [ 'lpeg' ]

.sub '__onload' :anon :load
#    print "__onload lpeg\n"
    .const .Sub entry = 'luaopen_lpeg'
    set_hll_global 'luaopen_lpeg', entry
.end

.const string VERSION = '0.8'
.const string PATTERN_T = 'pattern'

.sub 'luaopen_lpeg'

#    print "luaopen_lpeg\n"

    .local pmc _lua__GLOBAL
    _lua__GLOBAL = get_hll_global '_G'

    new $P1, 'LuaString'

    .local pmc _lpeg
    new _lpeg, 'LuaTable'
    set $P1, 'lpeg'
    _lua__GLOBAL[$P1] = _lpeg

    $P2 = split "\n", <<'LIST'
match
print
C
Ca
Cc
Cp
Cb
Carg
Cmt
Cs
Ct
P
R
S
V
span
type
version
LIST
    lua_register($P1, _lpeg, $P2)

    .local pmc _pattern
    _pattern = lua_newmetatable(PATTERN_T)

    new $P1, 'LuaString'
    set $P1, '__index'
    _pattern[$P1] = _pattern

    null $P1
    $P2 = split "\n", <<'LIST'
__add
__pow
__sub
__mul
__div
__unm
__len
LIST
    .local pmc _env
    new _env, 'LuaTable'
    lua_register($P1, _pattern, $P2, _env)

    .return (_lpeg)
.end


.sub 'getpatt' :anon
    .param int idx
    .param pmc patt
    .local pmc res
    .local int size
    .return (res, size)
.end


.sub 'testpattern'
    .param int narg
    .param pmc arg
    .local int res
    res = 0
    $I0 = isa arg, 'LuaUserdata'
    unless $I0 goto L1
    .local pmc _lua__REGISTRY
    .local pmc key
    _lua__REGISTRY = get_hll_global '_REGISTRY'
    new key, 'LuaString'
    set key, PATTERN_T
    $P0 = _lua__REGISTRY[key]
    $P1 = arg.'get_metatable'()
    unless $P0 == $P1 goto L1
    res = 1
  L1:
    .return (res)
.end


=item C<lpeg.match (pattern, subject [, init])>

The matching function. It attempts to match the given pattern against the
subject string. If the match succeeds, returns the index in the subject of
the first character after the match, or the values of captured values (if
the pattern captured any value).

An optional numeric argument C<init> makes the match starts at that position
in the subject string. As usual in Lua libraries, a negative value counts
from the end.

Unlike typical pattern-matching functions, C<match> works only in I<anchored>
mode; that is, it tries to match the pattern with a prefix of the given
subject string (at position C<init>), not with an arbitrary substring of the
subject. So, if we want to find a pattern anywhere in a string, we must
either write a loop in Lua or write a pattern that matches anywhere.
This second approach is easy and quite efficient; see examples.

NOT YET IMPLEMENTED.

=cut

.sub 'match'
    .param pmc pattern :optional
    .param pmc subject :optional
    .param pmc init :optional
    .param pmc extra :slurpy
    $P1 = getpatt(1, pattern)
    $S2 = lua_checkstring(2, subject)
    $I3 = lua_optint(3, init, 1)
    not_implemented()
.end


=item C<lpeg.print (pattern)>

NOT YET IMPLEMENTED.

=cut

.sub 'print'
    .param pmc pattern :optional
    .param pmc extra :slurpy
    $P1 = getpatt(1, pattern)
    not_implemented()
.end


=item C<lpeg.span (string)>

NOT YET IMPLEMENTED.

=cut

.sub 'span'
    .param pmc str :optional
    .param pmc extra :slurpy
    $S1 = lua_checkstring(1, str)
    not_implemented()
.end


=item C<lpeg.type (value)>

If the given value is a pattern, returns the string C<"pattern">.
Otherwise returns B<nil>.

=cut

.sub 'type'
    .param pmc value :optional
    .param pmc extra :slurpy
    .local pmc res
    $I0 = testpattern(1, value)
    unless $I0 goto L1
    new res, 'LuaString'
    set res, 'pattern'
    goto L2
  L1:
    new res, 'LuaNil'
  L2:
    .return (res)
.end


=item C<lpeg.version ()>

Returns a string with the running version of LPEG.

=cut

.sub 'version'
    .param pmc extra :slurpy
    .local pmc res
    new res, 'LuaString'
    set res, VERSION
    .return (res)
.end


=back

=head2 Basic Constructions

The following operations build patterns. All operations that expect a
pattern as an argument may receive also strings, tables, numbers, booleans,
or functions, which are translated to patterns according to the rules of
function C<lpeg.P>.

=over 4

=item C<lpeg.P (value)>

Converts the given value into a proper pattern, according to the following
rules:

* If the argument is a pattern, it is returned unmodified.

* If the argument is a string, it is translated to a pattern that matches
literally the string.

* If the argument is a number, it is translated as follows. A non-negative
number I<n> gives a pattern that matches exactly I<n> characters; a negative
number I<-n> gives a pattern that succeeds only if the input string does not
have I<n> characters. It is (as expected) equivalent to the unary minus
operation (see below) applied over the absolute value of I<n>.

* If the argument is a boolean, the result is a pattern that always succeeds
or always fails (according to the boolean value), without consuming any input.

* If the argument is a table, it is interpreted as a grammar (see Grammars).

* If the argument is a function, returns a pattern equivalent to a match-time
capture over the empty string.

If the function is called with parameters I<s> and I<i>, its result is valid
if it is in the range I<[i, len(s) + 1]>.

NOT YET IMPLEMENTED (see getpatt).

=cut

.sub 'P'
    .param pmc value :optional
    .param pmc extra :slurpy
    $P1 = getpatt(1, value)
    .return ($P1)
.end


=item C<lpeg.R ({range})>

Returns a pattern that matches any single character belonging to one of the
given I<ranges>. Each C<range> is a string I<xy> of length 2, representing
all characters with code between the codes of I<x> and I<y> (both inclusive).

As an example, the pattern C<lpeg.R("09")> matches any digit,
and C<lpeg.R("az", "AZ")> matches any ASCII letter.

NOT YET IMPLEMENTED.

=cut

.sub 'R'
    .param pmc vararg :slurpy
    not_implemented()
.end


=item C<lpeg.S (string)>

Returns a pattern that matches any single character that appears in the given
string. (The C<S> stands for I<Set>.)

As an example, the pattern C<lpeg.S("+-*/")> matches any arithmetic operator.

Note that, if I<s> is a character (that is, a string of length 1),
then C<lpeg.P(s)> is equivalent to C<lpeg.S(s)> which is equivalent to
C<lpeg.R(s..s)>. Note also that both C<lpeg.S("")> and C<lpeg.R()> are
patterns that always fail.

NOT YET IMPLEMENTED.

=cut

.sub 'S'
    .param pmc str :optional
    .param pmc extra :slurpy
    $S1 = lua_checkstring(1, str)
    $I1 = length $S1
    not_implemented()
.end


=item C<lpeg.V (v)>

This operation creates a non-terminal (a I<variable>) for a grammar.
The created non-terminal refers to the rule indexed by C<v> in the enclosing
grammar. (See Grammars for details.)

NOT YET IMPLEMENTED.

=cut

.sub 'V'
    .param pmc v :optional
    .param pmc extra :slurpy
    not_implemented()
.end


=item C<#patt>

Returns a pattern equivalent to I<&patt> in the original PEG notation.
This is a pattern that matches only if the input string does match C<patt>,
but without consuming any input, independently of success or failure.

When it succeeds, C<#patt> produces all captures produced by C<patt>.

NOT YET IMPLEMENTED.

=cut

.sub '__len' :method
    .param pmc patt
    ($P1, $I1) = getpatt(1, patt)
    not_implemented()
.end


=item C<-patt>

Returns a pattern equivalent to I<!patt> in the original PEG notation.
This pattern matches only if the input string does not match C<patt>.
It does not consume any input, independently of success or failure.

As an example, the pattern C<-1> matches only the end of string.

This pattern never produces any captures, because either C<patt> fails
or C<-patt> fails. (A failing pattern produces no captures.)

NOT YET IMPLEMENTED (see __sub).

=cut

.sub '__unm' :method
    .param pmc patt
    new $P0, 'LuaString'
    set $P0, ''
    .return __sub($P0, patt)
.end


=item C<patt1 + patt2>

Returns a pattern equivalent to an I<ordered choice> of C<patt1> and C<patt2>.
(This is denoted by I<patt1 / patt2> in the original PEG notation, not to be
confused with the C</> operation in LPeg.) It matches either C<patt1> or
C<patt2> (with no backtracking once one of them succeeds). The identity
element for this operation is the pattern C<lpeg.P(false)>, which always fails.

If both C<patt1> and C<patt2> are character sets, this operation is equivalent
to set union:

 lower = lpeg.R("az")
 upper = lpeg.R("AZ")
 letter = lower + upper

NOT YET IMPLEMENTED.

=cut

.sub '__add' :method
    .param pmc patt1
    .param pmc patt2
    $P1 = getpatt(1, patt1)
    $P2 = getpatt(2, patt2)
    not_implemented()
.end


=item C<patt1 - patt2>

Returns a pattern equivalent to I<!patt2 patt1>. This pattern asserts that
the input does not match C<patt2> and then matches C<patt1>.

If both C<patt1> and C<patt2> are character sets, this operation is equivalent
to set difference. Note that C<-patt> is equivalent to C<"" - patt>
(or C<0 - patt>). If C<patt> is a character set, C<1 - patt> is its complement.

NOT YET IMPLEMENTED.

=cut

.sub '__sub' :method
    .param pmc patt1
    .param pmc patt2
    $P1 = getpatt(1, patt1)
    $P2 = getpatt(2, patt2)
    not_implemented()
.end


=item C<patt1 * patt2>

Returns a pattern that matches C<patt1> and then matches C<patt2>, starting
where C<patt1> finished. The identity element for this operation is the
pattern C<lpeg.P(true)>, which always succeeds.

(LPeg uses the C<*> operator [instead of the more obvious C<..>] both because
it has the right priority and because in formal languages it is common to use
a dot for denoting concatenation.)

NOT YET IMPLEMENTED.

=cut

.sub '__mul' :method
    .param pmc patt1
    .param pmc patt2
    $P1 = getpatt(1, patt1)
    $P2 = getpatt(2, patt2)
    not_implemented()
.end


=item C<patt^n>

If C<n> is nonnegative, this pattern is equivalent to I<pattn patt*>.
It matches at least C<n> occurrences of C<patt>.

Otherwise, when C<n> is negative, this pattern is equivalent to I<(patt?)-n>.
That is, it matches at most C<-n> occurrences of C<patt>.

In particular, C<patt^0> is equivalent to I<patt*>, C<patt^1> is equivalent to
I<patt+>, and C<patt^-1> is equivalent to I<patt?> in the original PEG notation.

In all cases, the resulting pattern is greedy with no backtracking. That is,
it matches only the longest possible sequence of matches for C<patt>.

NOT YET IMPLEMENTED.

=cut

.sub '__pow' :method
    .param pmc patt
    .param pmc n
    $P1 = getpatt(1, patt)
    $I2 = lua_checknumber(2, n)
    not_implemented()
.end


=back

=head2 Grammars

With the use of Lua variables, it is possible to define patterns incrementally,
with each new pattern using previously defined ones. However, this technique
does not allow the definition of recursive patterns. For recursive patterns,
we need real grammars.

LPeg represents grammars with tables, where each entry is a rule.

The call C<lpeg.V(v)> creates a pattern that represents the nonterminal
(or I<variable>) with index C<v> in a grammar. Because the grammar still does
not exist when this function is evaluated, the result is an I<open reference>
to the respective rule.

A table is I<fixed> when it is converted to a pattern (either by calling
C<lpeg.P> or by using it wherein a pattern is expected). Then every open
reference created by C<lpeg.V(v)> is corrected to refer to the rule indexed
by C<v> in the table.

When a table is fixed, the result is a pattern that matches its I<initial rule>.
The entry with index 1 in the table defines its initial rule. If that entry is
a string, it is assumed to be the name of the initial rule. Otherwise,
LPeg assumes that the entry 1 itself is the initial rule.

As an example, the following grammar matches strings of a's and b's that have
the same number of a's and b's:

 equalcount = lpeg.P{
  "S";   -- initial rule name
  S = "a" * lpeg.V"B" + "b" * lpeg.V"A" + "",
  A = "a" * lpeg.V"S" + "b" * lpeg.V"A" * lpeg.V"A",
  B = "b" * lpeg.V"S" + "a" * lpeg.V"B" * lpeg.V"B",
 } * -1

=head2 Captures

Captures specify what a match operation should return (the so called
I<semantic information>). LPeg offers several kinds of captures, which
produces values based on matches and combine them to produce new values.

A capture pattern produces its values every time it succeeds. For instance,
a capture inside a loop produces as many values as matched by the loop.
A capture produces a value only when it succeeds. For instance, the pattern
C<lpeg.C(lpeg.P"a"^-1)> produces the empty string when there is no C<"a">
(because the pattern C<"a"?> succeeds), while the pattern C<lpeg.C("a")^-1>
does not produce any value when there is no C<"a"> (because the pattern C<"a">
fails).

Usually, LPEG evaluates all captures only after (and if) the entire match
succeeds. At I<match time> it only gathers enough information to produce the
capture values later. As a particularly important consequence, most captures
cannot affect the way a pattern matches a subject. The only exception to this
rule is the so-called I<match-time capture>. When a match-time capture matches,
it forces the immediate evaluation of all its nested captures and then calls
its corresponding function, which tells whether the match succeeds and also
what values are produced.

=over 4

=cut

# kinds of captures
.const int Cclose = 1
.const int Cposition = 2
.const int Cconst = 3
.const int Cbackref = 4
.const int C_arg = 5
.const int Csimple = 6
.const int Ctable = 7
.const int Cfunction = 8
.const int Cquery = 9
.const int Cstring = 10
.const int Csubst = 11
.const int Caccum = 12
.const int Cruntime = 13

.sub 'capture_aux' :anon
    .param pmc patt
    .param int kind
    .param int labelidx
    ($P1, $I1) = getpatt(1, patt)
    not_implemented()
.end

.sub 'emptycap_aux' :anon
    .param pmc n
    .param int kind
    .param string msg
    $I1 = lua_checknumber(1, n)
    not_implemented()
.end


=item C<lpeg.C (patt)>

Creates a I<simple capture>, which captures the substring of the subject that
matches C<patt>. The captured value is a string. If C<patt> has other captures,
their values are returned after this one.

NOT YET IMPLEMENTED (see capture_aux).

=cut

.sub 'C'
    .param pmc patt :optional
    .param pmc extra :slurpy
    .return capture_aux(patt, Csimple, 0)
.end


=item C<lpeg.Ca (patt)>

Creates an I<accumulator capture>. This capture assumes that C<patt> should
produce at least one captured value of any kind, which becomes the initial
value of an I<accumulator>. Pattern C<patt> then may produce zero or more
I<function captures>. Each of these functions in these captures is called
having the accumulator as its first argument (followed by any other arguments
provided by its own pattern), and the value returned by the function becomes
the new value of the accumulator. The final value of this accumulator is the
sole result of the whole capture.

As an example, the following pattern matches a list of numbers separated by
commas and returns their addition:

 -- matches a numeral and captures its value
 local number = lpeg.R"09"^1 / tonumber
 --
 -- auxiliary function to add two numbers
 local function add (acc, newvalue) return acc + newvalue end
 --
 list = lpeg.Ca(number * ("," * number / add)^0)
 --
 -- example of use
 print(list:match("10,30,43"))   --> 83

NOT YET IMPLEMENTED (see capture_aux).

=cut

.sub 'Ca'
    .param pmc patt :optional
    .param pmc extra :slurpy
    .return capture_aux(patt, Caccum, 0)
.end


=item C<lpeg.Carg (n)>

Creates an I<argument capture>. This pattern matches the empty string and
produces the value given as the nth extra argument given in the call to
C<lpeg.match>.

NOT YET IMPLEMENTED (see emptycap_aux).

=cut

.sub 'Carg'
    .param pmc n :optional
    .param pmc extra :slurpy
    .return emptycap_aux(n, C_arg, "invalid argument index")
.end


=item C<lpeg.Cb (n)>

Creates a I<back capture>. This pattern matches the empty string and produces
the values produced by the nth previous capture.

Captures are numbered dynamically. So, the first previous capture is the last
capture to match before the current one. The numbering includes only complete
captures; so, if the back capture is inside another capture, this enclosing
capture is ignored (because it is not complete when the back capture is seen).
Numbering does not count nested captures. Numbering counts captures, not the
values produced by them; it does not matter whether a capture produces zero
or many values, it counts as one.

B<This is an experimental feature. It probably will be changed or even removed
in future releases.>

NOT YET IMPLEMENTED (see emptycap_aux).

=cut

.sub 'Cb'
    .param pmc n :optional
    .param pmc extra :slurpy
    .return emptycap_aux(n, Cbackref, "invalid back reference")
.end


=item C<lpeg.Cc ({value})>

Creates a I<constant capture>. This pattern matches the empty string
and produces all given values as its captured values.

NOT YET IMPLEMENTED.

=cut

.sub 'Cc'
    .param pmc vararg :optional
    not_implemented()
.end


=item C<lpeg.Cp ()>

Creates a I<position capture>. It matches the empty string and captures
the position in the subject where the match occurs. The captured value
is a number.

NOT YET IMPLEMENTED.

=cut

.sub 'Cp'
    .param pmc extra :slurpy
    not_implemented()
.end


=item C<lpeg.Cs (patt)>

Creates a I<substitution capture>, which captures the substring of the subject
that matches C<patt>, with I<substitutions>. For any capture inside C<patt>,
the substring that matched the capture is replaced by the capture value (which
should be a string). The capture values from C<patt> are not returned
independently (only as substrings in the resulting string).

NOT YET IMPLEMENTED (see capture_aux).

=cut

.sub 'Cs'
    .param pmc patt :optional
    .param pmc extra :slurpy
    .return capture_aux(patt, Csubst, 0)
.end


=item C<lpeg.Ct (patt)>

Creates a I<table capture>. This capture creates a table and puts all captures
made by C<patt> inside this table in successive integer keys, starting at 1.

The captured value is only this table. The captures made by C<patt> are not
returned independently (only as table elements).

NOT YET IMPLEMENTED (see capture_aux).

=cut

.sub 'Ct'
    .param pmc patt :optional
    .param pmc extra :slurpy
    .return capture_aux(patt, Ctable, 0)
.end


=item C<patt / string>

Creates a I<string capture>. It creates a capture string based on C<string>.
The captured value is a copy of C<string>, except that the character C<%>
works as an escape character: any sequence in C<string> of the form I<%n>,
with I<n> between 1 and 9, stands for the match of the I<n>-th capture in
C<patt>. (Currently these nested captures can be only simple captures.)
The sequence C<%0> stands for the whole match.
The sequence C<%%> stands for a single C<%>.

=item C<patt / table>

Creates a I<query capture>. It indexes the given table using as key the value
of the first capture of C<patt>, or the whole match if C<patt> made no capture.
The value at that index is the final value of the capture. If the table does
not have that key, there is no captured value. Everything works as if there
was no capture.

=item C<patt / function>

Creates a I<function capture>. It calls the given function passing all
captures made by C<patt> as arguments, or the whole match if C<patt> made
no capture. The values returned by the C<function> are the final values
of the capture. (This capture may create multiple values.) In particular,
if function returns no value, there is no captured value; everything works
as if there was no capture.

NOT YET IMPLEMENTED (see capture_aux).

=cut

.sub '__div' :method
    .param pmc patt
    .param pmc arg
    $I0 = isa arg, 'LuaClosure'
    if $I0 goto L1
    $I0 = isa arg, 'LuaFunction'
    if $I0 goto L1
    goto L2
  L1:
    .return capture_aux(patt, Cfunction, 2)
  L2:
    $I0 = isa arg, 'LuaTable'
    unless $I0 goto L3
    .return capture_aux(patt, Cquery, 2)
  L3:
    $I0 = isa arg, 'LuaString'
    unless $I0 goto L4
    .return capture_aux(patt, Cstring, 2)
  L4:
    lua_argerror(2, "invalid replacement value")
.end


=item C<lpeg.Cmt (patt, function)>

Creates a I<match-time capture>. Unlike all other captures, this one is
evaluated immediately when a match occurs. It forces the immediate
evaluation of all its nested captures and then calls C<function>.

The function gets as arguments the entire subject, the current position
(after the match of C<patt>), plus any capture values produced by C<patt>.

The first value returned by C<function> defines how the match happens.
If the call returns a number, the match succeeds and the returned number
becomes the new current position. (Assuming a subject I<s> and current
position I<i>, the returned number must be in the range I<[i, len(s) + 1]>.)
If the call returns B<false>, B<nil>, or no value, the match fails.

Any extra values returned by the function become the values produced by the
capture.

NOT YET IMPLEMENTED.

=cut

.sub 'Cmt'
    .param pmc patt :optional
    .param pmc func :optional
    .param pmc extra :slurpy
    ($P1, $I1) = getpatt(1, patt)
    lua_checktype(2, func, 'function')
    not_implemented()
.end


=back

=head2 Some Examples

L<http://www.inf.puc-rio.br/~roberto/lpeg.html#ex>

=head1 LINKS

=over 4

=item Parsing Expression Grammars

L<http://pdos.csail.mit.edu/%7Ebaford/packrat/>

=item Wikipedia Entry for PEG

L<http://en.wikipedia.org/wiki/Parsing_expression_grammar>

=item Parsing Expression Grammars: A Recognition-Based Syntactic Foundation

L<http://pdos.csail.mit.edu/%7Ebaford/packrat/popl04/peg-popl04.pdf>

=back

=head1 AUTHORS

Francois Perrad

=cut


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
