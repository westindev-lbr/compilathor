.text
.globl main
_add:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 add $v0, $t0, $t1
 jr $ra
main:
 addi $sp, $sp, -4
 sw $ra, 0($sp)
 sw $fp, -4($sp)
 addi $fp, $sp, 0
 li $v0, 10
 sw $v0, 8($fp)
return:
 addi $sp, $sp, 4
 lw $ra, 0($fp)
 lw $fp, -4($fp)
 jr $ra

.data
