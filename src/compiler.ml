open Ast.IR
open Mips

module Env = Map.Make(String)

type cinfo = {
  asm: instr list 
; env: loc Env.t (* Adresses  *)
; fpo: int
; counter: int
; return: string
}

let compile_value v = 
  match v with
  | Void    -> [ Li (V0, 0) ]
  | Bool b  -> [ Li (V0, if b then 1 else 0) ]
  | Int n   -> [ Li (V0, n) ]

let rec compile_expr expr env =
  match expr with
  | Value v -> compile_value v
  | Var v   -> [Lw (V0, Env.find v env)]
  | Call (f, args) ->
    let cargs = List.map (fun arg -> 
        compile_expr arg env 
        @ [ Addi (SP, SP, -4)
          ; Sw (V0, Mem (SP, 0))]) args in
    List.flatten cargs
    @ [ Jal f ; Addi (SP, SP, 4 * (List.length args)) ]

let compile_instr instr info = 
  match instr with 
  | DeclVar v -> 
    {
      info with 
      env = Env.add v (Mem (FP, info.fpo)) info.env
    ;fpo = info.fpo +4 (* FP rempli vers le bas sur 1024 de memoire 0 == 1024 et prochaine valeur stoké a -4 donc 1020 *)
    }
  | Assign (v,e) -> 
    { info with 
      asm = info.asm 
            @ compile_expr e info.env
            @ [ Sw (V0, Env.find v info.env)]
    }
  | Expr e ->
    { info with 
      asm = info.asm 
            @ compile_expr e info.env }
  | Return e ->
    { info with
      asm = info.asm
            @ compile_expr e info.env
            @ [ B info.return ] }


let rec compile_block block info = 
  match block with
  | i :: b -> 
    let new_info = compile_instr i info in compile_block b new_info
  | [] -> info

let rec compile_def ( Func (name, args, body)) counter = 
  let cbody = compile_block body
      {
        asm = []
      ; env = List.fold_left
            (fun env (arg, addr) -> Env.add arg addr env)
            Env.empty
            (List.mapi (fun i arg -> arg, Mem (FP, 4 * (i + 1))) (List.rev args))
      ; fpo = 8 
      ; counter = counter +1
      ; return = "ret" ^ (string_of_int counter)
      }
  in cbody.counter,
     []
     @
     [ Label name
     ; Addi (SP, SP, -cbody.fpo)
     ; Sw (RA, Mem (SP, cbody.fpo - 4))
     ; Sw (FP, Mem (SP, cbody.fpo - 8))
     ; Addi (FP, SP, cbody.fpo - 4) ]
     @ cbody.asm
     @ [Label cbody.return 
       ; Addi (SP, SP, cbody.fpo)
       ; Lw (RA, Mem (FP, 0))
       ; Lw (FP, Mem (FP, -4))
       ; Jr (RA) ]

let rec compile_prog p counter =
  match p with
  | [] -> []
  | d :: r ->
    let new_counter, cd = compile_def d counter in
    cd @ (compile_prog r new_counter)


let compile ir =
  { text = Baselib.builtins @ compile_prog ir 0
  ; data = [] }
