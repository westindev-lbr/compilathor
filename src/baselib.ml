open Ast

module Env = Map.Make(String)

let _types_ = Env.empty

let builtins = []
(* mettre des fonctions deja écrites en assembleur *)
