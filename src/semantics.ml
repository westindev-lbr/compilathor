open Ast
open Ast.IR
open Baselib

exception Error of string * Lexing.position

(* Analyse une expression *)
let rec analyze_expr expr env =
  match expr with
  | Syntax.Int n -> Int n.value
  | Syntax.Bool b -> Bool b.value
  | Syntax.Var v -> 
    if not (Env.mem v.name env ) then 
      raise (Error ("unbound variable: " ^ v.name, v.pos));
    Var v.name
  | Syntax.Call c -> 
    let aargs = List.map (fun arg -> analyze_expr arg env) c.args in
    Call (c.func, aargs)

(* Analyse une instruction *)
let rec analyze_instr instr env =
  match instr with
  | Syntax.DeclVar dv -> 
    DeclVar dv.name, Env.add dv.name true env
  (* Verifier qu'une variable a deja été affecté "false" *)
  | Syntax.Assign a -> 
    if not (Env.mem a.var env ) then 
      raise (Error ("variable does not exist: " ^a.var, a.pos));
    let ae = analyze_expr a.expr env in
    Assign (a.var, ae), env

(* Analyse une liste d'instructions *)
let rec analyze_block block env =
  match block with
  | i :: b -> 
    let ai, new_env = analyze_instr i env in 
    ai :: (analyze_block b new_env)
  (* On renvoi l'environnement retourné par l'analyse d'instr précédente *)
  | [] -> []

let analyze parsed =
  analyze_block parsed Baselib._types_
(* on commence a lire avec l'environement de base de typage *)


