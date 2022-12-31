type reg =
  | Zero
  | V0
  | A0
  | A1
  | FP
  | SP
  | T0
  | T1
  | RA

type label = string

type loc = 
  | Lbl of label
  | Mem of reg * int
  | Reg of reg

type instr =
  | Label   of label
  | Li      of reg * int
  | La      of reg * loc
  | Sw      of reg * loc
  | Lw      of reg * loc 
  | Move    of reg * reg 
  | Addi    of reg * reg * int
  | Add     of reg * reg * reg
  | Mul     of reg * reg * reg
  | Sub     of reg * reg * reg
  | Div     of reg * reg * reg
  | Seq     of reg * reg * reg
  | Sne     of reg * reg * reg
  | Sgt     of reg * reg * reg
  | Slt     of reg * reg * reg
  | And     of reg * reg * reg
  | Or      of reg * reg * reg
  | Syscall
  | B       of label
  | Beqz    of reg * label
  | Jr      of reg
  | Jal     of label

type directive =
  | Asciiz of string

type decl = label * directive

type asm = { text: instr list ; data: decl list }

module Syscall = struct
  let print_int = 1
  let print_str = 4
  let read_int  = 5
  let read_str  = 8
  let sbrk      = 9
end

let ps = Printf.sprintf (* alias raccourci *)

let fmt_reg = function
  | Zero -> "$zero"
  | V0 -> "$v0"
  | A0 -> "$a0"
  | A1 -> "$a1"
  | FP -> "$fp"
  | SP -> "$sp"
  | T0 -> "$t0"
  | T1 -> "$t1"
  | RA -> "$ra"

let fmt_loc = function
  | Lbl (l)     -> l
  | Mem ( r,o ) -> ps "%d(%s)" o (fmt_reg r)
  | Reg (r)     -> ps "%s" (fmt_reg r)

let fmt_instr = function
  | Label (l)         -> ps "%s:" l
  | Li (r, i)         -> ps " li %s, %d" (fmt_reg r) i
  | La (r, a)         -> ps " la %s, %s" (fmt_reg r) (fmt_loc a)
  | Sw (r, l)         -> ps " sw %s, %s" (fmt_reg r) (fmt_loc l)
  | Lw (r, l)         -> ps " lw %s, %s" (fmt_reg r) (fmt_loc l)
  | Move (d,s)        -> ps " move %s, %s" (fmt_reg d) (fmt_reg s)
  | Addi (d, r, i)    -> ps " addi %s, %s, %d" (fmt_reg d) (fmt_reg r) i
  | Add (d, r1, r2)   -> ps " add %s, %s, %s" (fmt_reg d) (fmt_reg r1) (fmt_reg r2)
  | Mul (rd, rs, rt)  -> ps " mul %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Sub (rd, rs, rt)  -> ps " sub %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Div (rd, rs, rt)  -> ps " div %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Seq (rd, rs, rt)  -> ps " seq %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Sne (rd, rs, rt)  -> ps " sne %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Sgt (rd, rs, rt)  -> ps " sgt %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Slt (rd, rs, rt)  -> ps " slt %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | And (rd, rs, rt)  -> ps " and %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Or (rd, rs, rt)   -> ps " or %s, %s, %s" (fmt_reg rd) (fmt_reg rs) (fmt_reg rt)
  | Syscall           -> ps " syscall"
  | B (l)             -> ps " b %s" l
  | Beqz (r, l)       -> ps " beqz %s, %s" (fmt_reg r) l
  | Jr (r)            -> ps " jr %s" (fmt_reg r)
  | Jal (l)           -> ps " jal %s" l

let fmt_dir = function
  | Asciiz (s) -> ps ".asciiz \"%s\"" s

let emit oc asm =
  (* Printf.fprintf oc ".text\n.globl main\nmain:\n" ;*)
  Printf.fprintf oc ".text\n.globl main\n" ;
  (* on rajoute le label main en dur car on a pas encore la gesion des fonctions *)
  List.iter (fun i -> Printf.fprintf oc "%s\n" (fmt_instr i)) asm.text ;
  (* retour *)
  (*Printf.fprintf oc " move $a0, $v0\n li $v0, 1\n syscall\n jr $ra\n" ;*)
  Printf.fprintf oc "\n.data\n" ;
  List.iter (fun (l, d) -> Printf.fprintf oc "%s: %s\n" l (fmt_dir d)) asm.data


(*  Faire le resultat dans un file.s avec commande > après l'executable exe -> foo.s  *)