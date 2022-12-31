# Représentation Intermédiaire :
#[ Func ("fact", [n ],[ Cond (Call ("_bigger", [ Var "n" ; Value (Int 0) ]), [ Return (Call ("_mul", [ Var "n" ; Call ("fact", [ Call ("_sub", [ Var "n" ; Value (Int 1) ]) ]) ])) ], None)
#; Return (Value (Int 1)) ])]
#[ Func ("main", [ ],[ Expr (Call ("puti", [ Call ("fact", [ Value (Int 8) ]) ])) ])]

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
_sub:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 sub $v0, $t1, $t0
 jr $ra
_div:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 div $v0, $t1, $t0
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
_equal:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 seq $v0, $t1, $t0
 jr $ra
_notequal:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 sne $v0, $t1, $t0
 jr $ra
_bigger:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 sgt $v0, $t1, $t0
 jr $ra
_smaller:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 slt $v0, $t1, $t0
 jr $ra
_and:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 and $v0, $t1, $t0
 jr $ra
_or:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 or $v0, $t1, $t0
 jr $ra
fact:
 addi $sp, $sp, -8
 sw $ra, 4($sp)
 sw $fp, 0($sp)
 addi $fp, $sp, 4
 lw $v0, 4($fp)
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 li $v0, 0
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal _bigger
 addi $sp, $sp, 8
 beqz $v0, else1
 lw $v0, 4($fp)
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 lw $v0, 4($fp)
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 li $v0, 1
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal _sub
 addi $sp, $sp, 8
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal fact
 addi $sp, $sp, 4
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal _mul
 addi $sp, $sp, 8
 b ret0
 b endif1
else1:
endif1:
 li $v0, 1
 b ret0
ret0:
 addi $sp, $sp, 8
 lw $ra, 0($fp)
 lw $fp, -4($fp)
 jr $ra
main:
 addi $sp, $sp, -8
 sw $ra, 4($sp)
 sw $fp, 0($sp)
 addi $fp, $sp, 4
 li $v0, 8
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal fact
 addi $sp, $sp, 4
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal puti
 addi $sp, $sp, 4
ret2:
 addi $sp, $sp, 8
 lw $ra, 0($fp)
 lw $fp, -4($fp)
 jr $ra

.data
