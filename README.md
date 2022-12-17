# COMPILATHOR 🔨

Axel Labarre - Projet Compilation / Interprétation

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
 ./main.byte ./tests/<source_code> > ./tests/asm/file.s
 ```

### Tester avec M.I.P.S

 ```shell
spim read file.s
run main
```
