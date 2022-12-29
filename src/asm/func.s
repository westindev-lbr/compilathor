.text
.globl main
_add:
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 add $v0, $t0, $t1
 jr $ra
main:
 addi $sp, $sp, -4 #decale de -4 le sp
 sw $ra, 4($sp) # stock ra (main) dans sp +4 (
 sw $fp, 0($sp) # stock fp à sp mais fp vaut 0
 addi $fp, $sp, 4 # assigne à fp l'adresse de sp + 4 (donc pointe sur ra (main))
 li $v0, 10
 sw $v0, 8($fp) # stock v0 carrément à + 8 de fp 
 li $v0, 0 # Pourquoi ??? 
 lw $ra, 0($fp)  # Lis la valeur dans fp et stock dans ra 
 addi $sp, $fp, 4 # assigne dans sp la valeur de fp + 4
 lw $fp, -4($fp)
 jr $ra
 move $a0, $v0 # pas executé à cause du ra précédent
 li $v0, 1
 syscall
 jr $ra

.data
