.text
.globl main
main:
 move $fp, $sp
 addi $sp, $sp, -4
_add:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 add $v0, $t0, $t1
 jr $ra
 li $v0, 13
 li $v0, 12
 jal _add
 sw $v0, 0($fp)
 move $a0, $v0
 li $v0, 1
 syscall
 jr $ra

.data
