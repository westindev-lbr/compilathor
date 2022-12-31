# COMPILATHOR 🔨

Axel Labarre - Projet Compilation / Interprétation

Université Paris 8

---

## Utilisation

### Compiler en executable avec use-menhir

```shell
ocamlbuild -use-menhir main.byte
```

### Compiler un code source de test

```shell
./main.byte /tests/<some_tests>
```

### Créer un fichier de sortie assembleur

```shell
 ./main.byte ./tests/<source_code> > asm/file.s
 ```

### Executer avec M.I.P.S

 ```shell
spim load file.s
run main
```

## Implémentation du langage

[x] valeures entières et les booléenes
[x] fin de fichier EOF et les points virgules ";" (fin d'instruction)
[x] Variable et assignation
[x] Déclaration de Fonction, Appel de fonction
[x] Gestion de Frame Pointer et Stack Pointer
[x] Return
[x] Expr
[x] Le type void (à revoir)
[x] Affichage Représentation intermédiaire en commentaire en Output
[x] Les autres fonctions arithmétiques et logiques MIPS
[x] Block d'instructions entre accollades
[x] Opérateurs logiques
[x] Conditions IF / ELSE (block option)
[x] Récursivité Fonction (exemple Factorielle)
[x] Boucle while(cond){ .. instr ..  };
[] String
[] Typage & Verification de type
[] Malloc / Deref / Pointeur
[] Liste / Tab / Struct
[] Liste chainée
[] Commentaires
