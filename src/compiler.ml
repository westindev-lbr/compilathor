open Ast.IR
open Mips

module Env = Map.Make(String)

type cinfo = {
  asm: Mips.instr list 
; env: Mips.loc Env.t (* Adresses  *)
; fpo: int
}

let rec compile_expr expr env =
  match expr with
  | Int n  -> [ Li (V0, n) ]
  | Bool b -> [Li (V0, if b then 1 else 0)] 
  | Var v -> [Lw (V0, Env.find v env)] 

let compile_instr instr info = 
  match instr with 
  | DeclVar v -> 
    {
      info with 
      fpo = info.fpo -4 (* FP rempli vers le bas sur 1024 de memoire 0 == 1024 et prochaine valeur stoké a -4 donc 1020 *)
      ; env = Env.add v (Mem (FP, info.fpo)) info.env
    }
  | Assign (v,e) -> 
    { info with 
    asm = info.asm 
    @ compile_expr e info.env
     @ [ Sw (V0, Env.find v info.env)]
    }


let rec compile_block block info = 
  match block with
  | i :: b -> 
    let new_info = compile_instr i info in compile_block b new_info
  | [] -> info


let compile ir =
  let info = compile_block ir 
      {
        asm = Baselib.builtins
      ; env = Env.empty
      ; fpo = 0
      }
  in
  { text =[ 
        Move (FP, SP) 
      ;Addi (SP, SP, info.fpo )] 
      @ info.asm
  ; data = [] }
