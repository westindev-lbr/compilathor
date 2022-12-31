%{
  open Ast
  open Ast.Syntax
%}

%token <int> Lint
%token <bool> Lbool
%token <string> Lident
%token Lsc Lend Lvar Leq
%token Ladd Lmul Lsub Ldiv
%token Land Lor Lequal Lnotequal Lbigger Lsmaller
%token Lfunc
%token Llpar Lrpar Lcomma Llbrace Lrbrace
%token Lreturn
%token Lwhile Lfor
//%token Lprint
%token Lif Lelse

%left Lor
%left Land
%left Ladd Lsub
%left Lmul Ldiv
%left Lequal Lnotequal
%left Lbigger Lsmaller


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
  | { [] }
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
  | Lif ; Llpar ; cond = expr ; Lrpar ; b1 = block ; b2 = opt_block
    {
      [Cond { cond = cond; tbranch = b1; fbranch = b2; pos = $startpos($1) }]
    }
  | Lwhile ; Llpar ; cond = expr ; Lrpar ; b = block 
    { 
      [Loop { cond = cond; body = b; pos = $startpos($1) }] 
    }
  ;


opt_block:
  | Lelse ; b = block { Some b }
  | { None }
  ;

block:
  | Llbrace; b = block_contents; Lrbrace 
    { b }
  ;


block_contents:
  | i = instr ; Lsc ; b = block_contents { i @ b }
  | i = instr ; Lsc { i }
  | { [] }
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
  | Llpar; e = expr; Lrpar   { e }
  | a = expr; Land; b = expr 
    { 
      Call { func = "_and" ;  args = [ a ; b ] ; pos = $startpos($2) }
    }
  | a = expr; Lor; b = expr 
    { 
      Call { func = "_or" ;  args = [ a ; b ] ; pos = $startpos($2) }
    }
  | a = expr; Lequal; b = expr 
    { 
      Call { func = "_equal" ;  args = [ a ; b ] ; pos = $startpos($2) }
    }
  | a = expr; Lnotequal; b = expr
    { 
      Call { func = "_notequal" ;  args = [ a ; b ] ; pos = $startpos($2) }
    }
  | a = expr; Lbigger; b = expr 
    { 
      Call { func = "_bigger" ;  args = [ a ; b ] ; pos = $startpos($2) }
    }
  | a = expr; Lsmaller; b = expr 
    { 
      Call { func = "_smaller" ;  args = [ a ; b ] ; pos = $startpos($2) }
    }
  | a = expr; Ladd ; b = expr
    {
      Call { func = "_add" ; args = [ a ; b ] ; pos = $startpos($2) }
    }
  | a = expr; Lmul ; b = expr
    {
      Call { func = "_mul" ; args = [ a ; b ] ; pos = $startpos($2) }
    }
  | a = expr; Lsub ; b = expr
    {
      Call { func = "_sub" ; args = [ a ; b ] ; pos = $startpos($2) }
    }
  | a = expr; Ldiv ; b = expr
    {
      Call { func = "_div" ; args = [ a ; b ] ; pos = $startpos($2) }
    }
  /* APPEL DE FONCTION */
  | id = Lident; Llpar; args = expr_list; Lrpar
    {
      Call { func = id; args = args; pos = $startpos(id) }
    }
  ;
