type reg =
  | V0
  | FP
  | SP
  | T0
  | T1
  | RA

type label = string

type loc = 
| Lbl of label
| Mem of reg * int

type instr =
  | Label of label
  | Li of reg * int
  | Sw of reg * loc
  | Lw of reg * loc 
  | Move of reg * reg 
  | Addi of reg * reg * int
  | Add of reg * reg * reg
  | Jr of reg
  | Jal of label

type directive =
  | Asciiz of string

type decl = label * directive

type asm = { text: instr list ; data: decl list }

let ps = Printf.sprintf (* alias raccourci *)

let fmt_reg = function
  | V0 -> "$v0"
  | FP -> "$fp"
  | SP -> "$sp"
  | T0 -> "$t0"
  | T1 -> "$t1"
  | RA -> "$ra"

  let fmt_loc = function
  | Lbl (l)     -> l
  | Mem ( r,o ) -> ps "%d(%s)" o (fmt_reg r)

let fmt_instr = function
  | Label (l)         -> ps "%s:" l
  | Li (r, i)         -> ps " li %s, %d" (fmt_reg r) i
  | Sw (r, l)         -> ps " sw %s, %s" (fmt_reg r) (fmt_loc l)
  | Lw (r, l)         -> ps " lw %s, %s" (fmt_reg r) (fmt_loc l)
  | Move (d,s)        -> ps " move %s, %s" (fmt_reg d) (fmt_reg s)
  | Addi (d, r, i)    -> ps " addi %s, %s, %d" (fmt_reg d) (fmt_reg r) i
  | Add (d, r1, r2)   -> ps " add %s, %s, %s" (fmt_reg d) (fmt_reg r1) (fmt_reg r2)
  | Jr (r)            -> ps " jr %s" (fmt_reg r)
  | Jal (l)           -> ps " jal %s" l

let fmt_dir = function
  | Asciiz (s) -> ps ".asciiz \"%s\"" s

let emit oc asm =
  Printf.fprintf oc ".text\n.globl main\nmain:\n" ;
(*   Printf.fprintf oc ".text\n.globl main\n" ; *)
  (* on rajoute le label main en dur car on a pas encore la gesion des fonctions *)
  List.iter (fun i -> Printf.fprintf oc "%s\n" (fmt_instr i)) asm.text ;
  (* retour *)
  Printf.fprintf oc " move $a0, $v0\n li $v0, 1\n syscall\n jr $ra\n" ;
  Printf.fprintf oc "\n.data\n" ;
  List.iter (fun (l, d) -> Printf.fprintf oc "%s: %s\n" l (fmt_dir d)) asm.data


  (*  Faire le resultat dans un file.s avec commande > après l'executable exe -> foo.s  *)