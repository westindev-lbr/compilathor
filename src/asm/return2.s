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
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 li $v0, 21
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal _add
 addi $sp, $sp, 8
 sw $v0, 8($fp)
 lw $v0, 8($fp)
 b return
return:
 addi $sp, $sp, 4
 lw $ra, 0($fp)
 lw $fp, -4($fp)
 jr $ra

.data
