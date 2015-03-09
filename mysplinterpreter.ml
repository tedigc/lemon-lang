open Expr
open Lexer
open Parser
open Arg
open Printf

let parseProgram c =
    try let lexbuf = Lexing.from_channel c in
            parser_main lexer_main lexbuf
    with Parsing.Parse_error -> failwith "Syntax Error!" ;;

let arg = ref stdin in
  let setProg p = arg := open_in p in
    let usage = "mysplinterpreter PROGRAM_FILE" in
      parse [] setProg usage ;
      let parsedProg = parseProgram !arg in
        let result = eval parsedProg in
          print_result result ;
          print_newline() ;
          flush stdout
