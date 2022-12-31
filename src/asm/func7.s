# Représentation Intermédiaire :
#[ Func ("printNum", [num ],[ Return (Var "num") ])]
#[ Func ("main", [ ],[ DeclVar "a"
#; Assign ("a", Value (Int 1))
#; DeclVar "b"
#; Assign ("b", Value (Int 2))
#; DeclVar "c"
#; Assign ("c", Value (Int 3))
#; DeclVar "d"
#; Assign ("d", Value (Int 4))
#; Expr (Call ("puti", [ Value (Int 20) ]))
#; Expr (Call ("puti", [ Value (Int 10) ])) ])]

.text
.globl main
_add:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 add $v0, $t0, $t1
 jr $ra
_mul:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 mul $v0, $t0, $t1
 jr $ra
puti:
 lw $a0, 0($sp)
 li $v0, 1
 syscall
 jr $ra
geti:
 lw $a0, 0($sp)
 li $v0, 5
 syscall
 jr $ra
puts:
 lw $a0, 0($sp)
 li $v0, 4
 syscall
 jr $ra
printNum:
 addi $sp, $sp, -8
 sw $ra, 4($sp)
 sw $fp, 0($sp)
 addi $fp, $sp, 4
 lw $v0, 4($fp)
 b ret0
ret0:
 addi $sp, $sp, 8
 lw $ra, 0($fp)
 lw $fp, -4($fp)
 jr $ra
main:
 addi $sp, $sp, -24
 sw $ra, 20($sp)
 sw $fp, 16($sp)
 addi $fp, $sp, 20
 li $v0, 1
 sw $v0, 8($fp)
 li $v0, 2
 sw $v0, 12($fp)
 li $v0, 3
 sw $v0, 16($fp)
 li $v0, 4
 sw $v0, 20($fp)
 li $v0, 20
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal puti
 addi $sp, $sp, 4
 li $v0, 10
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal puti
 addi $sp, $sp, 4
ret1:
 addi $sp, $sp, 24
 lw $ra, 0($fp)
 lw $fp, -4($fp)
 jr $ra

.data
