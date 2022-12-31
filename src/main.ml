(* ocamlbuild -use-menhir main.byte *)

open Lexing
open Ast

let err msg pos =
  Printf.eprintf "Error on line %d col %d: %s.\n"
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol) msg ;
  exit 1

let () =
  if (Array.length Sys.argv) != 2 then begin
      Printf.eprintf "Usage: %s <file>\n" Sys.argv.(0) ;
      exit 1
    end;
    
  let f = open_in Sys.argv.(1) in
  (* buffer de lexing en se rappelent de là ou on est *)
  let buf = Lexing.from_channel f in
  try
    let parsed = Parser.prog Lexer.token buf in
    close_in f ;
    (* on ferme le fichier *)
    let ast = Semantics.analyze parsed in
    print_string "# Représentation Intermédiaire :\n";
    List.iter (fun s -> print_endline s) (List.map (fun s -> String.make 1 '#' ^ s) (List.map IR.string_of_ir ast));
    print_newline ();
    (* on analyse semantique, on pourra rajouter ici l'étape de collecte de chaine constantes *)
    let asm = Compiler.compile ast in
    Mips.emit Stdlib.stdout asm
  with
  | Lexer.Error c ->
     err (Printf.sprintf "unrecognized char '%c'" c) (Lexing.lexeme_start_p buf)
  | Parser.Error ->
     err "syntax error" (Lexing.lexeme_start_p buf)
  | Semantics.Error (msg, pos) ->
     err msg pos


     