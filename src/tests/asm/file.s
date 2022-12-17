.text
.globl main
main:
 move $fp, $sp
 addi $sp, $sp, -4
 li $v0, 1312
 sw $v0, 0($fp)
 move $a0, $v0
 li $v0, 1
 syscall
 jr $ra

.data
