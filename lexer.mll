{
open Parser
open Functions
}

let langexp =
    '{'(' '*(['a'-'z']+|':')' '*','' '*)*(['a'-'z']+|':')?' '*'}'
let stringexp =
    ('"'['a'-'z''A'-'Z''0'-'9']*'"')|':'
let identexp =
    ['a'-'z''A'-'Z''0'-'9']+ as lxm
let commentexp =
    '/''*'_*'*''/'

rule lexer_main = parse
    | [' ' '\t' '\n']           { lexer_main lexbuf }
    | ['0'-'9']+ as lxm         { INT(int_of_string lxm) }
    | langexp as lxm            { LANG(lxm) }
    | stringexp as lxm          { STRING(lxm) }
    | commentexp                { COMMENT }
    | '('                       { LPAREN }
    | ')'                       { RPAREN }
    | '<'                       { LESSTHAN }
    | '>'                       { GREATERTHAN }
    | '='                       { EQUAL }
    | '+'                       { PLUS }
    | '-'                       { MINUS }
    | "=="                      { EQUALTO }
    | "start:"                  { START }
    | "end"                     { END }
    | "true" as lxm             { BOOLEAN(bool_of_string lxm) }
    | "false" as lxm            { BOOLEAN(bool_of_string lxm) }
    | "if"                      { IF }
    | "then:"                   { THEN }
    | "else:"                   { ELSE }
    | "kleene"                  { KLEENE }
    | "length"                  { LENGTH }
    | "concat"                  { CONCAT }
    | "func"                    { FUNC }
    | "var"                     { VAR }
    | "->"                      { ARROW }
    | "in"                      { IN }
    | ":"                       { EMPTYWORD("") }
    | "head"                    { HEAD }
    | "tail"                    { TAIL }
    | "union"                   { UNION }
    | "append"                  { APPEND }
    | "size"                    { SIZE }
    | "cons"                    { CONS }
    | "sort"                    { SORT }
    | "uniq"                    { UNIQ }
    | "cap"                     { CAP }
    | identexp                  { IDENT(lxm) }
    | "$"['1'-'9']+ as lxm      { LANG(get_line lxm) }
    | "$last_line"              { INT(get_last_line 10) }
    | eof                       { EOF }
