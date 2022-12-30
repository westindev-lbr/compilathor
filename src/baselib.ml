open Ast
open Mips

module Env = Map.Make(String)

let _types_ = Env.empty

let builtins = [
  Label "_add"
  ; Lw (T0, Mem (SP, 0)) (* Charge le 1er nombre dans TO à sp 0*)
  ; Lw (T1, Mem (SP, 4)) (* Charge le 2eme dans T1 à sp + 4 *)
  ; Add (V0, T0, T1) (* Ajoute T0 et T1 et stock le résultat dans VO *)
  ; Jr RA (* Saute vers l'instruction de retour *)


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

]

(* mettre des fonctions deja écrites en assembleur MIPS ici *)
