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
  type block = instr list
end

module IR = struct
  type ident = string
  type expr =
    | Int of int
    | Bool of bool
    | Var of string
    | Call of ident * expr

  type instr = 
    | DeclVar of string
    | Assign of string * expr

  type block = instr list
end
