%{
  open Ast
  open Ast.Syntax
%}

/* declare que les entiers et la fin du fichier */
%token <int> Lint
%token <bool> Lbool
%token <string> Lident
%token Lsc Lend Lvar Leq
%token Ladd Lmul
%token Lfunc
%token Llpar Lrpar Lcomma Llbracket Lrbracket
%token Lreturn
%token Lprint

%start prog

/* %type <Ast.Syntax.expr> prog */
%type <Ast.Syntax.def list> prog

%%

/* un prog c'est une expr et la fin  */
//prog:
/* | e = expr; Lend { e } */ // plus necessaire
/* | e = expr ; Lsc ; b = prog { e :: b} */
/*  deja une liste */
/*   | i = instr ; Lsc ; b = prog { i @ b }
  | i = instr ; Lsc ; Lend { i }
  ; */

prog:
  | df = def; p = prog { df @ p }
  | df = def ; Lend { df }
  | Lend { [] }
;

def:
  | Lfunc; id = Lident; Llpar; args = arg_list; Lrpar; b = block
    {
      [ Func { name = id; 
              args = args; 
              body = b; 
              pos = $startpos($1) } ]
    }
  ;

arg_list:
  | id = Lident; Lcomma; ids = arg_list { id :: ids }
  | id = Lident { [id] }
  | /* vide */ { [] }
  ;

  
instr:
  | Lvar; id = Lident 
    {
      [DeclVar { name = id ; pos = $startpos(id) }]
    }
  /* On renvoi des listes  */
  | Lvar; id = Lident ; Leq; e = expr 
    {
      [DeclVar { name = id ; pos = $startpos(id) }
        ;Assign { var = id
        ; expr = e ; pos = $startpos($3) }
      ]
    }
  | id = Lident; Leq; e = expr
    {
      [Assign { var = id
        ; expr = e 
        ; pos = $startpos($2) }
      ]
    }
  | e = expr
   {
    [Expr { expr = e; pos = $startpos(e)}]
   }
  | Lreturn; e = expr 
    { 
      [Return { expr = e ; pos = $startpos(e) }]
    }
  ;



block_contents:
  | i = instr ; Lsc ; b = block_contents { i @ b }
  | i = instr ; Lsc { i }
  | { [] }
  ;

block:
  | Llbracket; b = block_contents; Lrbracket 
    { b }
  ;

expr_list:
  | e = expr; Lcomma; el = expr_list { e :: el }
  | e = expr { [e] }
  | { [] }
  ;

expr:
  | n = Lint 
    {
      Value { value = Int n ; pos = $startpos(n) }
    }
  | b = Lbool 
    {
      Value { value = Bool b ; pos = $startpos(b) } 
    }
  | v = Lident 
    { 
      Var { name = v ; pos = $startpos(v) }
    }
  | a = expr; Ladd ; b = expr
    {
      Call { func = "_add"
      ; args = [ a ; b ]
      ; pos = $startpos($2) }
    }
  | a = expr; Lmul ; b = expr
    {
      Call { func = "_mul"
      ; args = [ a ; b ]
      ; pos = $startpos($2) }
    }
  /* APPEL DE FONCTION */
  | id = Lident; Llpar; args = expr_list; Lrpar
    {
      Call { func = id; args = args; pos = $startpos(id) }
    }
  /* CALL PRINT */
  | Lprint; Llpar; e = expr_list ; Lrpar
    {
      Call { func = "puti"; args = e; pos = $startpos($2) }
    }
  ;
