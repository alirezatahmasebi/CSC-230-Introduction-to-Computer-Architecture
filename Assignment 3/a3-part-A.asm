
	.data
ARRAY_A:
	.word	21, 210, 49, 4
ARRAY_B:
	.word	21, -314159, 0x1000, 0x7fffffff, 3, 1, 4, 1, 5, 9, 2
ARRAY_Z:
	.space	28
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
		
	
	.text  
main:	
	la $a0, ARRAY_A
	addi $a1, $zero, 4
	jal dump_array
	
	la $a0, ARRAY_B
	addi $a1, $zero, 11
	jal dump_array
	
	la $a0, ARRAY_Z
	lw $t0, 0($a0)
	addi $t0, $t0, 1
	sw $t0, 0($a0)
	addi $a1, $zero, 9
	jal dump_array
		
	addi $v0, $zero, 10
	syscall

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
dump_array:
	addi $s1, $s1, 1	     # increment counter
	add $s0, $zero, $a0	     # get the address of first integer
	lw $a0, 0($s0)		     # get the next character for output
	add $v0, $zero, 1	     # store 1 in $v0 for integer output
	syscall			     # system call 1 (print integer)
	la $a0, SPACE		     # used to print space between every integer
	add $v0, $zero, 4	     # store 4 in $v0 for string output
	syscall			     # system call 4 (print string)
	add $a0, $zero, $s0	     # get the actual address of array again
	addi $a0, $a0, 4	     # increment address of array
	bne $s1, $a1, dump_array     # check if reached the end of array
	add $s1, $zero, $zero        # re-initialize counter for new array 
	la $a0, NEWLINE		     # used to print newline at the end of each array
	add $v0, $zero, 4	     # store 4 in $v0 for string output
	syscall                      # system call 4 (print string)
	jr $ra
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
