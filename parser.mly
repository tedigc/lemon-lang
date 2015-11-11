%{
    open Expr
%}
%token <int> INT
%token <bool> BOOLEAN
%token <string> LANG
%token <string> STRING
%token <string> IDENT
%token <string> EMPTYWORD
%token COMMENT
%token START END
%token PLUS MINUS LESSTHAN GREATERTHAN EQUALTO
%token IF THEN ELSE
%token TRUE FALSE
%token LPAREN RPAREN
%token HEAD TAIL UNION APPEND CONS
%token SORT UNIQ CAP SIZE
%token FUNC IN ARROW VAR EQUAL
%token CONCAT LENGTH KLEENE
%token EOF
%start parser_main
%type <Expr.expr> parser_main
%%

parser_main:
    | expr EOF { $1 }
;

expr:
    | INT                                        { Integer $1 }
    | LANG                                       { Language $1 }
    | STRING                                     { String $1 }
    | IDENT                                      { Var $1 }
    | EMPTYWORD                                  { String $1 }
    | BOOLEAN                                    { Boolean $1 }
    | COMMENT expr                               { $2 }
    | START expr END expr                        { StartExpr ($2, $4) }
    | START expr END                             { $2 }
    | LPAREN expr PLUS expr RPAREN               { PlusExpr ($2, $4) }
    | LPAREN expr MINUS expr RPAREN              { MinusExpr ($2, $4) }
    | LPAREN expr LESSTHAN expr RPAREN           { LessThanExpr ($2, $4) }
    | LPAREN expr GREATERTHAN expr RPAREN        { GreaterThanExpr ($2, $4) }
    | LPAREN expr EQUALTO expr RPAREN            { EqualToExpr ($2, $4) }
    | LPAREN IF expr THEN expr ELSE expr RPAREN  { IfExpr ($3, $5, $7) }
    | LPAREN FUNC IDENT IDENT ARROW expr IN expr RPAREN {FuncExpr1 ($3, $4, $6, $8) }
    | LPAREN FUNC IDENT IDENT IDENT ARROW expr IN expr RPAREN {FuncExpr2 ($3, $4, $5, $7, $9) }
    | LPAREN FUNC IDENT IDENT IDENT IDENT ARROW expr IN expr RPAREN {FuncExpr3 ($3, $4, $5, $6, $8, $10) }
    | LPAREN expr expr RPAREN                    { AppExpr1 ($2, $3) }
    | LPAREN expr expr expr RPAREN               { AppExpr2 ($2, $3, $4) }
    | LPAREN expr expr expr expr RPAREN          { AppExpr3 ($2, $3, $4, $5) }
    | LPAREN VAR IDENT EQUAL expr IN expr RPAREN { VarExpr ($3, $5, $7) }
    | LPAREN HEAD expr RPAREN       	         { HeadExpr $3 }
    | LPAREN TAIL expr RPAREN                    { TailExpr $3 }
    | LPAREN UNION  expr expr RPAREN             { UnionExpr  ($3, $4) }
    | LPAREN APPEND expr expr RPAREN             { AppendExpr ($3, $4) }
    | LPAREN CONS expr expr RPAREN               { ConsExpr ($3, $4) }
    | LPAREN CONCAT expr expr RPAREN             { ConcatExpr ($3, $4) }
    | LPAREN LENGTH expr RPAREN                  { LengthExpr $3 }
    | LPAREN KLEENE expr expr RPAREN             { KleeneExpr ($3, $4) }
    | LPAREN SIZE expr RPAREN                    { SizeExpr $3 }
    | LPAREN SORT expr RPAREN                    { SortExpr $3 }
    | LPAREN UNIQ expr RPAREN                    { UniqExpr $3 }
    | LPAREN CAP expr expr RPAREN                { CapExpr ($3, $4) }
;
