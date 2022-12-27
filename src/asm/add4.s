.text
.globl main
_add:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 add $v0, $t0, $t1
 jr $ra

main:
 move $fp, $sp
 addi $sp, $sp, -4
 sw $ra, 0($sp) # On sauvegarde $ra

 li $v0, 13
 addi $sp, $sp, -4
 sw $v0, 0($sp)

 li $v0, 12
 addi $sp, $sp, -4
 sw $v0, 0($sp)
 
 jal _add

 addi $sp, $sp, 8
 sw $v0, 0($fp)
 move $a0, $v0

 lw $ra, 0($sp) # On récupère $ra
 addi $sp, $sp, 4 # On dépile

 li $v0, 1
 syscall
 
 jr $ra

.data
