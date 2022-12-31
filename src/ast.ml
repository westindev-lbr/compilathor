module Syntax = struct
  type ident = string
  type value = 
    | Void
    | Int of int
    | Bool of bool

  type expr =
    | Value   of { value: value ; pos: Lexing.position }  
    | Var     of { name: ident ; pos: Lexing.position }  
    | Call    of { func : ident
                 ; args: expr list
                 ; pos: Lexing.position }

  type instr = 
    | DeclVar of { name: ident ; pos: Lexing.position}
    | Assign  of { var: ident ; expr: expr ; pos: Lexing.position }
    | Expr    of { expr: expr ; pos: Lexing.position }
    | Return  of { expr: expr ; pos: Lexing.position }
    | Cond    of { cond: expr
                 ; tbranch: block
                 ; fbranch: block option
                 ; pos: Lexing.position
                 }
    | Loop    of { cond: expr ; body:block; pos: Lexing.position }
  and block = instr list

  type def = 
    | Func of { name: ident
              ; args: string list
              ; body: block
              ; pos: Lexing.position }
end


module IR = struct
  type ident = string
  type value = 
    | Void
    | Int of int
    | Bool of bool
  type expr =
    | Value of value
    | Var of ident
    | Call of ident * expr list

  type instr = 
    | DeclVar of ident
    | Assign of ident * expr
    | Expr of expr
    | Return of expr
    | Cond of expr * block * block option
    | Loop of expr * block
  and block = instr list

  type def = 
    | Func of ident * string list * block

  type prog = def list

  let string_of_ir ast =
    let rec fmt_v = function
      | Int n       -> "Int " ^ (string_of_int n)
      | Bool b      -> "Bool " ^ (string_of_bool b)

    and fmt_e = function
      | Value v     -> "Value (" ^ (fmt_v v) ^ ")"
      | Var v       -> "Var \"" ^ v ^ "\""
      | Call (f, a) -> "Call (\"" ^ f ^ "\", [ "
                       ^ (String.concat " ; " (List.map fmt_e a))
                       ^ " ])"
    and fmt_i = function
      | DeclVar v     -> "DeclVar \"" ^ v ^ "\""
      | Assign (v, e) -> "Assign (\"" ^ v ^ "\", " ^ (fmt_e e) ^ ")"
      | Expr e        -> "Expr (" ^ (fmt_e e) ^ ")"
      | Return e      -> "Return (" ^ (fmt_e e) ^ ")"
      | Cond (c, b1, b2) -> "Cond (" ^ (fmt_e c) ^ ", " ^ (fmt_b b1) ^ ", " ^ (fmt_b_opt b2) ^ ")"
      | Loop (c, b) -> "Loop (" ^ (fmt_e c) ^ ", " ^ (fmt_b b) ^ ")"
    and fmt_b b = "[ " ^ (String.concat "\n#; " (List.map fmt_i b)) ^ " ]"
    and fmt_b_opt b = 
      match b with
      | None -> "None"
      | Some b -> "Some " ^ (fmt_b b)
    and fmt_d = function
      | Func (f, a, b) ->  "[ Func (\"" ^ f ^ "\", [" ^ (String.concat "\n#; " (List.map (fun x -> x) a)) ^ " ],"
                           ^ (fmt_b b) 
                           ^ ")]"
    in fmt_d ast
end