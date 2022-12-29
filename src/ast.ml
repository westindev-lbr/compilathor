module Syntax = struct
  type ident = string
  type expr =
    | Int of { value: int
             ; pos: Lexing.position }
    | Bool of { value: bool
              ; pos: Lexing.position }  
    | Var of { name: string
             ; pos: Lexing.position }  
    | Call of { func : ident
              ; args: expr list
              ; pos: Lexing.position }

  type instr = 
    | DeclVar of { name: string ; pos: Lexing.position}
    | Assign of {
        var: string
      ; expr: expr
      ; pos: Lexing.position
      }
    | DeclFunc of { name: ident
              ; args: string list
              ; body: block
              ; pos: Lexing.position }
  and block = instr list
end


module IR = struct
  type ident = string
  type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Call of ident * expr list

  type instr = 
    | DeclVar of string
    | Assign of string * expr
  and block = instr list

  type def = 
    | Func of ident * string list * block

  type prog = def list

end