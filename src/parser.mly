%{
  open Ast
  open Ast.Syntax
%}

/* declare que les entiers et la fin du fichier */
%token <int> Lint
%token <bool> Lbool
%token <string> Lident
%token Lsc Lend Lvar Leq

%start prog

/* %type <Ast.Syntax.expr> prog */
%type <Ast.Syntax.block> prog

%%

/* un pro c'est une expr et la fin  */
prog:
/* | e = expr; Lend { e } */ // plus necessaire
/* | e = expr ; Lsc ; b = prog { e :: b} */
/*  deja une liste */
| i = instr ; Lsc ; b = prog { i @ b}
| i = instr ; Lsc ; Lend { i }
;

instr:
  | Lvar; id = Lident 
  {
    [DeclVar { name = id ; pos = $startpos(id)}]
  }
  /* On renvoi des listes  */
  | Lvar; id = Lident ; Leq; e = expr 
  {
    [ DeclVar { name = id ; pos = $startpos(id)}
      ;Assign { var = id
      ; expr = e ; pos = $startpos($3)}
    ]
  }
  | id = Lident; Leq; e = expr{
    [Assign { var = id
      ; expr = e 
      ; pos = $startpos($2)
      }
    ]
  }

expr:
| n = Lint {
  Int { value = n ; pos = $startpos(n) }
}
| b = Lbool {
  Bool { value = b ; pos = $startpos(b)} 
  }

| v = Lident 
{ Var { name = v ; pos = $startpos(v)}}
;
