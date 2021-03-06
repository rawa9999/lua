/*
Copyright (C) 2005-2009, Parrot Foundation.
$Id$
*/

%token NAME
/* Literal */
%token STRING
%token NUMBER
/* Keyword */
%token AND
%token BREAK
%token DO
%token ELSE
%token ELSEIF
%token END
%token FALSE
%token FOR
%token FUNCTION
%token IF
%token IN
%token LOCAL
%token NIL
%token NOT
%token OR
%token REPEAT
%token RETURN
%token THEN
%token TRUE
%token WHILE

%nonassoc NONARG
%nonassoc '(' '{' STRING
%left AND OR
%left '==' '~=' '>' '<' '<=' '>='
%left '..'
%left '+' '-'
%left '*' '/' '%'
%left NEG '#' NOT
%right '^'

%expect 1

%start	chunk

%%

chunk
:   _stat    laststat   _semicolon_opt
|   _stat
;

_stat
:   _stat   stat    _semicolon_opt
|   /* empty */
;

_semicolon_opt
:   ';'
|   /* EMPTY */
;

block
:   chunk
;

stat
:   varlist1    '='	explist1
|   functioncall    %prec   NONARG
|   DO
        block   END
|   WHILE
            exp DO  block   END
|   REPEAT
            block   UNTIL   exp
|   _if_then    block   _elseif_star    ELSE
                                                    block   END
|   _if_then    block   _elseif_star    END
|   FOR NAME    '=' exp ',' exp ',' exp DO
                                            block   END
|   FOR NAME    '=' exp ',' exp DO
                                    block   END
|   FOR namelist    IN  explist1    DO
                                        block   END
|   FUNCTION    funcname
                            funcbody
|   LOCAL   FUNCTION    NAME
                                funcbody
|   LOCAL   namelist    '=' explist1
|   LOCAL   namelist
;

_if_then
:   IF  exp THEN
;

_elseif_star
:   _elseif_star    ELSEIF  exp THEN
                                        block
|   /* empty */
;

laststat
:   RETURN  explist1
|   RETURN
|   BREAK
;

funcname
:   _funcname
|   _funcname   ':'	NAME
;

_funcname
:   _funcname   '.' NAME
|   NAME
;

varlist1
:   varlist1    ',' var
|   var
;

var
:   NAME
|   '(' exp ')' key
|   functioncall    key
|   var key
;

key
:   '[' exp ']'
|   '.' NAME
;

namelist
:   namelist    ',' NAME
|   NAME
;

explist1
:   explist1    ',' exp
|   exp
;

exp
:   primary %prec   NONARG
|   var %prec   NONARG
|   functioncall    %prec   NONARG
|   exp '+' exp
|   exp '-' exp
|   exp '*' exp
|   exp '/' exp
|   exp '^' exp
|   exp '%' exp
|   exp '..'    exp
|   exp '<' exp
|   exp '<='    exp
|   exp '>' exp
|   exp '>='    exp
|   exp '=='    exp
|   exp '~='    exp
|   exp AND exp
|   exp OR  exp
|   '-' exp %prec   NEG
|   '#' exp
|   NOT exp
;

primary
:   NIL
|   FALSE
|   TRUE
|   NUMBER
|   STRING
|   '...'
|   function
|   tableconstructor
|   '(' exp ')'
;

functioncall
:   '(' exp ')' args
|   '(' exp ')' ':' NAME    args
|   var args
|   var ':' NAME    args
|   functioncall    args
|   functioncall    ':' NAME    args
;

args
:   '(' explist1    ')'
|   '(' ')'
|   tableconstructor
|   STRING
;

function
:   FUNCTION
                funcbody
;

funcbody
:   '(' parlist1    ')' block   END
|   '(' ')' block   END
;

parlist1
:   parlist ',' '...'
|   parlist
|   '...'
;

parlist
:   parlist ',' NAME
|   NAME
;

tableconstructor
:   '{' fieldlist   '}'
|   '{' '}'
;

fieldlist
:   _field_plus	fieldsep
|   _field_plus
;

_field_plus
:   _field_plus fieldsep    field
|   field
;

field
:   '[' exp ']' '=' exp
|   NAME    '=' exp
|   exp
;

fieldsep
:   ','
|   ';'
;

%%

/*
 * Local variables:
 *   c-file-style: "parrot"
 * End:
 * vim: expandtab shiftwidth=4:
 */
