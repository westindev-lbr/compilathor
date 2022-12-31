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
main:
 addi $sp, $sp, -8
 sw $ra, 4($sp)
 sw $fp, 0($sp)
 addi $fp, $sp, 4
 li $v0, 255
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal puti
 addi $sp, $sp, 4
 b ret0
 li $v0, 255
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal puti
 addi $sp, $sp, 4
 b ret0
ret0:
 addi $sp, $sp, 8
 lw $ra, 0($fp)
 lw $fp, -4($fp)
 jr $ra

.data
