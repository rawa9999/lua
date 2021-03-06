# Copyright (C) 2007-2009, Parrot Foundation.
# $Id$

=head1 A compiler for Lua 5.1

=head2 Synopsis

  $ parrot-luap script.lua
  $ parrot-luap --target=parse script.lua
                         PAST
                         POST
                         PIR

=head2 Description

C<luap> is a compiler for Lua 5.1 on Parrot
with the standard interface of PCT::HLLCompiler.

=cut

.include 'stat.pasm'

.sub 'main' :anon :main
    .param pmc args
    $I0 = stat 'lua.pbc', .STAT_EXISTS
    unless $I0 goto L1
    load_bytecode 'lua.pbc'
    goto L2
  L1:
    load_bytecode 'languages/lua/lua.pbc'
  L2:
    $P0 = compreg 'lua'
    $S0 = "Compiler Lua 5.1 on Parrot  Copyright (C) 2005-2009, Parrot Foundation.\n"
    $P0.'commandline_banner'($S0)
    $P0.'command_line'(args)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
