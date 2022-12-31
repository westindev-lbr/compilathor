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
 addi $sp, $sp, -20
 sw $ra, 16($sp)
 sw $fp, 12($sp)
 addi $fp, $sp, 16
 li $v0, 10
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 li $v0, 2
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal _mul
 addi $sp, $sp, 8
 sw $v0, 8($fp)
 li $v0, 3
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 li $v0, 2
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal _add
 addi $sp, $sp, 8
 sw $v0, 12($fp)
 lw $v0, 8($fp)
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 lw $v0, 12($fp)
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal _mul
 addi $sp, $sp, 8
 sw $v0, 16($fp)
 lw $v0, 16($fp)
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 jal puti
 addi $sp, $sp, 4
 b return
return:
 addi $sp, $sp, 20
 lw $ra, 0($fp)
 lw $fp, -4($fp)
 jr $ra

.data
