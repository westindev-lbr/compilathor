{
  open Lexing
  open Parser

  exception Error of char
}

let num = ['0'-'9']
let alpha = ['a' - 'z' 'A' - 'Z']
let ident = alpha ( alpha | num | '_')*

rule token = parse
| eof             { Lend }
| [ ' ' '\t' ]    { token lexbuf }
| '\n'            { Lexing.new_line lexbuf; token lexbuf }
| "true"          { Lbool (true)}
| "false"         { Lbool (false)}
| ";"             { Lsc }
| "="             { Leq }
| "var"           { Lvar }
| num+ as n       { Lint (int_of_string n) }
| ident as id     { Lident (id)}
| _ as c          { raise (Error c) }