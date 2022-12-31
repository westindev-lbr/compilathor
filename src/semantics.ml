open Ast
open Ast.IR
open Baselib

exception Error of string * Lexing.position


let analyze_value value =
  match value with
  | Syntax.Void -> Void
  | Syntax.Int n  -> Int n
  | Syntax.Bool b -> Bool b

(* Analyse une expression *)
let rec analyze_expr expr env =
  match expr with
  | Syntax.Value v ->
    let av = analyze_value v.value in
    Value av 
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
  | Syntax.DeclVar v -> 
    if Env.mem v.name env then
      raise (Error ("variable already declared: " ^ v.name, v.pos));
    DeclVar v.name, Env.add v.name true env
  (* Verifier qu'une variable a deja été affecté "false" *)
  | Syntax.Assign a -> 
    if not (Env.mem a.var env ) then 
      raise (Error ("variable does not exist: " ^a.var, a.pos));
    let ae = analyze_expr a.expr env in
    Assign (a.var, ae), env
  | Syntax.Return r ->
    let ae = analyze_expr r.expr env in
    Return ae, env
  | Syntax.Expr e ->
    let ae = analyze_expr e.expr env in
    Expr ae, env
  | Syntax.Cond c -> 
    let ac = analyze_expr c.cond env in
    let atb = analyze_block c.tbranch env in
    let afb = 
      match c.fbranch with
      | None -> None
      | Some b -> Some (analyze_block b env)
    in 
    Cond (ac, atb, afb) , env
  | Syntax.Loop l -> 
      let ac = analyze_expr l.cond env in
      let ab = analyze_block l.body env in
        Loop (ac, ab), env


(* Analyse une liste d'instructions *)
and analyze_block block env =
  match block with
  | i :: b -> 
    let ai, new_env = analyze_instr i env in 
    ai :: (analyze_block b new_env)
  (* On renvoi l'environnement retourné par l'analyse d'instr précédente *)
  | [] -> []


let rec analyze_def def env =
  match def with
  | Syntax.Func f -> 
    if Env.mem f.name env then
      raise (Error ("function already declared: " ^ f.name, f.pos));
    (* Analysez le corps de la fonction en utilisant un environnement étendu *)
    let aenv = List.fold_left (fun env' arg -> Env.add arg false env') env f.args in
    let abody = analyze_block f.body aenv in
    Func (f.name, f.args, abody), env


let analyze parsed =
  List.map fst (List.map (fun def -> analyze_def def Baselib._types_) parsed )

(* let analyze parsed =
   analyze_block parsed Baselib._types_ *)
(* on commence a lire avec l'environement de base de typage *)


