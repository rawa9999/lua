# Copyright (C) 2005-2009, Parrot Foundation.
# $Id$

use strict;
use warnings;

package pirVisitor;
{

    sub new {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = {};
        bless $self, $class;
        my ($fh) = @_;
        $self->{fh}       = $fh;
        $self->{prologue} = q{# generated by luac.pl

.include 'interpinfo.pasm'
.HLL 'lua'
.loadlib 'lua_group'

.sub '__start' :anon :main
    .param pmc args
#    print "start Lua\n"
    sweepoff
    load_bytecode 'languages/lua/src/lib/luaaux.pbc'
    load_bytecode 'languages/lua/src/lib/luabasic.pbc'
    load_bytecode 'languages/lua/src/lib/luacoroutine.pbc'
    load_bytecode 'languages/lua/src/lib/luapackage.pbc'
    load_bytecode 'languages/lua/src/lib/luastring.pbc'
    load_bytecode 'languages/lua/src/lib/luaregex.pbc'
    load_bytecode 'languages/lua/src/lib/luatable.pbc'
    load_bytecode 'languages/lua/src/lib/luamath.pbc'
    load_bytecode 'languages/lua/src/lib/luaio.pbc'
    load_bytecode 'languages/lua/src/lib/luafile.pbc'
    load_bytecode 'languages/lua/src/lib/luaos.pbc'
    load_bytecode 'languages/lua/src/lib/luadebug.pbc'
    load_bytecode 'languages/lua/src/lib/luaperl.pbc'
    lua_openlibs()
    .local pmc env
    env = get_hll_global '_G'
    .local pmc vararg
    vararg = argstolua(env, args)
    .const 'Sub' main = '_main'
    main.'setfenv'(env)
    ($I0, $P0) = docall(main, vararg :flat)
    unless $I0 goto L1
    printerr 'luac.pl: '
    printerr $P0
  L1:
.end

};
        return $self;
    }

    sub visitUnaryOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    $op->{result}->{symbol} = $op->{op} $op->{arg1}->{symbol}\n";
        return;
    }

    sub visitBinaryOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        if ( $op->{result} == $op->{arg1} ) {
            print {$FH} "    $op->{op} $op->{result}->{symbol}, $op->{arg2}->{symbol}\n";
        }
        else {
            print {$FH}
"    $op->{result}->{symbol} = $op->{op} $op->{arg1}->{symbol}, $op->{arg2}->{symbol}\n";
        }
        return;
    }

    sub visitRelationalOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH}
            "    $op->{result}->{symbol} = $op->{op} $op->{arg1}->{symbol}, $op->{arg2}->{symbol}\n";
        return;
    }

    sub visitAssignOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    assign $op->{result}->{symbol}, $op->{arg1}->{symbol}\n";
        return;
    }

    sub visitSetOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    set $op->{result}->{symbol}, $op->{arg1}->{symbol}\n";
        return;
    }

    sub visitKeyedGetOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    $op->{result}->{symbol} = $op->{arg1}->{symbol}\[$op->{arg2}->{symbol}\]\n";
        return;
    }

    sub visitKeyedSetOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    $op->{result}->{symbol}\[$op->{arg1}->{symbol}\] = $op->{arg2}->{symbol}\n";
        return;
    }

    sub visitIncrOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    inc $op->{result}->{symbol}\n";
        return;
    }

    sub visitInterpInfoOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    $op->{result}->{symbol} = interpinfo $op->{arg1}\n";
        return;
    }

    sub visitFindLexOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    $op->{result}->{symbol} = find_lex '$op->{arg1}->{symbol}'\n";
        return;
    }

    sub visitStoreLexOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    store_lex '$op->{arg1}->{symbol}', $op->{arg2}->{symbol}\n";
        return;
    }

    sub visitCloneOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    $op->{result}->{symbol} = clone $op->{arg1}->{symbol}\n";
        return;
    }

    sub visitNewOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    $op->{result}->{symbol} = new '$op->{arg1}'\n";
        return;
    }

    sub visitNewClosureOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    $op->{result}->{symbol} = newclosure $op->{arg1}->{symbol}\n";
        return;
    }

    sub visitNoOp {

        #my $self = shift;
        #my ($op) = @_;
        #my $FH   = $self->{fh};
        #print {$FH} "    noop\n";
        return;
    }

    sub visitToBoolOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    set $op->{result}->{symbol}, $op->{arg1}->{symbol}\n";
        return;
    }

    sub visitCallOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    ";
        if ( exists $op->{result} and scalar( @{ $op->{result} } ) ) {
            print {$FH} "(";
            my $first = 1;
            foreach ( @{ $op->{result} } ) {
                print {$FH} ", " unless ($first);
                print {$FH} "$_->{symbol}";
                if ( exists $_->{pragma} and $_->{pragma} eq 'multi' ) {
                    print {$FH} " :slurpy";
                }
                $first = 0;
            }
            print {$FH} ") = ";
        }
        print {$FH} "$op->{arg1}->{symbol}(";
        my $first = 1;
        foreach ( @{ $op->{arg2} } ) {
            print {$FH} ", " unless ($first);
            print {$FH} "$_->{symbol}";
            if ( exists $_->{pragma} and $_->{pragma} eq 'multi' ) {
                print {$FH} " :flat";
            }
            $first = 0;
        }
        print {$FH} ")\n";
        delete $self->{getfenv};
        return;
    }

    sub visitCallMethOp {
        my $self = shift;
        my ($op) = @_;
        if ( $op->{arg1} eq 'getfenv') {
            return if ( exists $self->{getfenv} );
            $self->{getfenv} = 1;
        }
        my $FH   = $self->{fh};
        print {$FH} "    ";
        if ( exists $op->{result} and scalar( @{ $op->{result} } ) ) {
            print {$FH} "(" if ( scalar( @{ $op->{result} } ) > 1 );
            my $first = 1;
            foreach ( @{ $op->{result} } ) {
                print {$FH} ", " unless ($first);
                print {$FH} "$_->{symbol}";
                $first = 0;
            }
            print {$FH} ")" if ( scalar( @{ $op->{result} } ) > 1 );
            print {$FH} " = ";
        }
        my @args = @{ $op->{arg2} };
        my $obj  = shift @args;
        print {$FH} "$obj->{symbol}.'$op->{arg1}'(";
        my $first = 1;
        foreach (@args) {
            print {$FH} ", " unless ($first);
            print {$FH} "$_->{symbol}";
            if ( exists $_->{pragma} and $_->{pragma} eq 'multi' ) {
                print {$FH} " :flat";
            }
            $first = 0;
        }
        print {$FH} ")\n";
        return;
    }

    sub visitTailCallDir {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    .tailcall $op->{arg1}->{symbol}(";
        my $first = 1;
        foreach ( @{ $op->{arg2} } ) {
            print {$FH} ", " unless ($first);
            print {$FH} "$_->{symbol}";
            if ( exists $_->{pragma} and $_->{pragma} eq 'multi' ) {
                print {$FH} " :flat";
            }
            $first = 0;
        }
        print {$FH} ")\n";
        return;
    }

    sub visitBranchIfOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        my $cond;
        if ( exists $op->{op} ) {
            if ( exists $op->{arg2} ) {
                $cond = "$op->{arg1}->{symbol} $op->{op} $op->{arg2}->{symbol}";
            }
            else {
                $cond = "$op->{op} $op->{arg1}";
            }
        }
        else {
            $cond = "$op->{arg1}->{symbol}";
        }
        print {$FH} "    if $cond goto $op->{result}->{symbol}\n";
        return;
    }

    sub visitBranchUnlessOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        my $cond;
        if ( exists $op->{op} ) {
            if ( exists $op->{arg2} ) {
                $cond = "$op->{arg1}->{symbol} $op->{op} $op->{arg2}->{symbol}";
            }
            else {
                $cond = "$op->{op} $op->{arg1}->{symbol}";
            }
        }
        else {
            $cond = "$op->{arg1}->{symbol}";
        }
        print {$FH} "    unless $cond goto $op->{result}->{symbol}\n";
        return;
    }

    sub visitBranchOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "    goto $op->{result}->{symbol}\n";
        return;
    }

    sub visitLabelOp {
        my $self = shift;
        my ($op) = @_;
        my $FH   = $self->{fh};
        print {$FH} "  $op->{arg1}->{symbol}:\n";
        delete $self->{getfenv};
        return;
    }

    sub visitSubDir {
        my $self  = shift;
        my ($dir) = @_;
        my $FH    = $self->{fh};
        print {$FH} ".sub '$dir->{result}->{symbol}' :anon :lex";
        if ( exists $dir->{outer} ) {
            print {$FH} " :outer($dir->{outer})";
        }
        print {$FH} "\n";
        delete $self->{getfenv};
        return;
    }

    sub visitEndDir {
        my $self  = shift;
        my ($dir) = @_;
        my $FH    = $self->{fh};
        print {$FH} ".end\n";
        print {$FH} "\n";
        return;
    }

    sub visitParamDir {
        my $self  = shift;
        my ($dir) = @_;
        my $FH    = $self->{fh};
        if ( exists $dir->{pragma} ) {
            print {$FH} "    .param $dir->{result}->{type} $dir->{result}->{symbol} $dir->{pragma}\n";
        }
        else {
            print {$FH} "    .param $dir->{result}->{type} $dir->{result}->{symbol} :optional\n";
        }
        return;
    }

    sub visitReturnDir {
        my $self  = shift;
        my ($dir) = @_;
        my $FH    = $self->{fh};
        print {$FH} "    .return (";
        my $first = 1;
        foreach ( @{ $dir->{result} } ) {
            print {$FH} ", " unless ($first);
            print {$FH} "$_->{symbol}";
            if ( exists $_->{pragma} and $_->{pragma} eq 'multi' ) {
                print {$FH} " :flat";
            }
            $first = 0;
        }
        print {$FH} ")\n";
        return;
    }

    sub visitLocalDir {
        my $self = shift;
        my ($dir) = @_;
        return if ( $dir->{result}->{symbol} =~ /^\$/ );
        my $FH = $self->{fh};
        print {$FH} "    .local $dir->{result}->{type} $dir->{result}->{symbol}\n";
        return;
    }

    sub visitLexDir {
        my $self  = shift;
        my ($dir) = @_;
        my $FH    = $self->{fh};
        print {$FH} "    .lex '$dir->{arg1}->{symbol}', $dir->{arg1}->{symbol}\n";
        return;
    }

    sub visitConstDir {
        my $self  = shift;
        my ($dir) = @_;
        my $FH    = $self->{fh};
        print {$FH} "    .const '$dir->{type}' $dir->{result}->{symbol} = '$dir->{arg1}'\n";
        return;
    }

}

1;

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

