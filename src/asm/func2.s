.text
.globl main
_add:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 add $v0, $t0, $t1
 jr $ra
main:
 addi $sp, $sp, -4
 sw $ra, 4($sp)
 sw $fp, 0($sp)
 addi $fp, $sp, 4
 li $v0, 10
 sw $v0, 8($fp)
 move $a0, $v0
 li $v0, 1
 syscall
 jr $ra

.data
