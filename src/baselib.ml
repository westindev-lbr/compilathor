open Ast
open Mips

module Env = Map.Make(String)

let _types_ = Env.empty

let builtins = [
  Label "_add"
  ; Lw (T0, Mem (SP, 0)) (* Charge le 1er nombre dans TO à sp 0*)
  ; Lw (T1, Mem (SP, 4)) (* Charge le 2eme dans T1 à sp + 4 *)
  ; Add (V0, T0, T1) (* Ajoute T0 et T1 et stock le résultat dans V0 *)
  ; Jr RA (* Saute vers l'instruction de retour *)

  ; Label "_mul"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Mul (V0, T0, T1)
  ; Jr RA

  ; Label "_sub"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Sub (V0, T1, T0)
  ; Jr RA

  ; Label "_div"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Div (V0, T1, T0)
  ; Jr RA

  ; Label "puti"
  ; Lw (A0, Mem (SP, 0))
  ; Li (V0, Syscall.print_int)
  ; Syscall
  ; Jr RA

  ; Label "geti"
  ; Lw (A0, Mem (SP, 0))
  ; Li (V0, Syscall.read_int)
  ; Syscall
  ; Jr RA

  ; Label "puts"
  ; Lw (A0, Mem (SP, 0))
  ; Li (V0, Syscall.print_str)
  ; Syscall
  ; Jr RA

  ; Label "_equal"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Seq (V0, T1, T0)
  ; Jr RA

  ; Label "_notequal"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Sne (V0, T1, T0)
  ; Jr RA

  ; Label "_bigger"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Sgt (V0, T1, T0)
  ; Jr RA

  ; Label "_smaller"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Slt (V0, T1, T0)
  ; Jr RA

  ; Label "_and"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; And (V0, T1, T0)
  ; Jr RA

  ; Label "_or"
  ; Lw (T0, Mem (SP, 0))
  ; Lw (T1, Mem (SP, 4))
  ; Or (V0, T1, T0)
  ; Jr RA
  
]

(* mettre des fonctions deja écrites en assembleur MIPS ici *)
