.text
.globl main
_add:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  add $v0, $t0, $t1
  jr $ra
_sub:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  sub $v0, $t1, $t0
  jr $ra
_mul:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  mul $v0, $t0, $t1
  jr $ra
_div:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  div $v0, $t1, $t0
  jr $ra
_nor:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  nor $v0, $t1, $t0
  addi $v0, $v0, 2
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
_is_equal:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  seq $v0, $t0, $t1
  jr $ra
_not_equal:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  sne $v0, $t0, $t1
  jr $ra
_greater_than:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  sgt $v0, $t1, $t0
  jr $ra
_great_or_equal:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  sge $v0, $t1, $t0
  jr $ra
_less_than:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  slt $v0, $t1, $t0
  jr $ra
_less_or_equal:
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  sle $v0, $t1, $t0
  jr $ra
puts:
  lw $a0, 0($sp)
  li $v0, 4
  syscall
  jr $ra
puti:
  lw $a0, 0($sp)
  li $v0, 1
  syscall
  jr $ra
putb:
  lw $a0, 0($sp)
  li $v0, 1
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
  li $v0, 0
  b ret0
ret0:
  addi $sp, $sp, 20
  lw $ra, 0($fp)
  lw $fp, -4($fp)
  jr $ra

.data