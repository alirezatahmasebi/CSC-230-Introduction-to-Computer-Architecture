	.include "display.asm"
	
	.data
	
GEN_A:	.space 256
GEN_B:	.space 256
GEN_Z:	.space 256

# Students may modify the ".data" and "main" section temporarily
# for their testing. However, when evaluating your submission, all
# code from lines 1 to 58 will be replaced by other testing code
# (i.e., we will only keep code from lines 59 onward). If your
# solution breaks because you have ignored this note, then a mark
# of zero for Part 4 of the assignment is possible.

PATTERN_GLIDER:
	.word   0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
        	0x0000 0x0000 0x0000 0x0000 0x0e00 0x0200 0x0400 0x0000
        	
PATTERN_PULSAR:
	.word 	0x0000 0x0e38 0x0000 0x2142 0x2142 0x2142 0x0e38 0x0000
		0x0e38 0x2142 0x2142 0x2142 0x0000 0x0e38 0x0000 0x0000
		
PATTERN_PIPSQUIRTER:
	.word   0x0000 0x0020 0x0020 0x0000 0x0088 0x03ae 0x0431 0x0acd
        	0x0b32 0x6acc 0x6a90 0x06f0 0x0100 0x0140 0x00c0 0x0000
	
PATTERN_HONEYCOMB:
	.word   0x0000 0x0000 0x0000 0x0000 0x0000 0x0180 0x0240 0x05a0
        	0x0240 0x0180 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
       
PATTERN_EATER:
	.word   0x0000 0x0000 0x1800 0x24c0 0x2848 0x1054 0x0348 0x0240
        	0x1080 0x1f00 0x0000 0x0400 0x0a00 0x0407 0x0004 0x0002
        
	.globl main
	
	
	.text
main:
	la $a0, GEN_A
	la $a1, PATTERN_PULSAR
	jal bitmap_to_16x16		# Convert bitmap pattern...
	
	la $a0, GEN_A
	jal draw_16x16			# ... and draw it.
	
next_gen:
	jal life_next_generation	# Procedure uses 16x16 0/1 "dead/alive" data in GEN_A ...
	la $a0, GEN_A			# ... and then proceeds to draw the result ...
	jal draw_16x16
	
	addi $a0, $zero, 750		# 750 milliseconds (three-quarters of a second)
	addi $v0, $zero, 32		# sleep system call
	syscall
	
	beq $zero, $zero, next_gen	# ... over and over again. Comment out this line if
					# you just want to try life_next_generation once during testing.

	addi $v0, $zero, 10
	syscall


# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	.data
	
# Available for any extra `.eqv` or data needed for your solution.

	.text

		
# life_next_generation:
#
# This procedure HAS NO PARAMETERS.
#
# Use GEN_A as the generation to draw
#
# Use GEN_B as a scratch array to compute the
# next generation (i.e., compute the value
# of the next generation in GEN_B, and once
# completed, copy over GEN_B into GEN_A

life_next_generation:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	add $s1, $zero, $zero
life_next_row:
	add $s2, $zero, $zero
life_next_col:
	la $a0, GEN_A
	add $a1, $zero, $s1
	add $a2, $zero, $s2
	jal sum_neighbours
	add $s0, $zero, $v0	# Number of live neighbours around row $s1, col $s2
	
	la $a0, GEN_A
	add $a1, $zero, $s1
	add $a2, $zero, $s2
	jal get_16x16		# Determine whether row $s1, col $s2 is currently alive
	beq $v0, $zero, life_check_for_birth	# Not alive -- so check if a birth may happen...
	
	# At this point, we have a live cell.
	# But should the cell stay alive?
	beq $s0, 2, life_staying_alive_staying_alive
	beq $s0, 3, life_staying_alive_staying_alive
	
	# At this point, we have a cell that must die
	beq $zero, $zero, life_cell_is_dead
	
life_staying_alive_staying_alive:
	la $a0, GEN_B
	add $a1, $zero, $s1
	add $a2, $zero, $s2
	addi $a3, $zero, 1
	jal set_16x16
	beq $zero, $zero, life_next_element
	
life_check_for_birth:
	bne $s0, 3, life_cell_is_dead
	la $a0, GEN_B
	add $a1, $zero, $s1
	add $a2, $zero, $s2
	addi $a3, $zero, 1
	jal set_16x16
	beq $zero, $zero, life_next_element
	
life_cell_is_dead:	
	la $a0, GEN_B
	add $a1, $zero, $s1
	add $a2, $zero, $s2
	add $a3, $zero, $zero
	jal set_16x16
	beq $zero, $zero, life_next_element

life_next_element:
	add $s2, $s2, 1			# DEBUG Z
	blt $s2, 16, life_next_col	
	add $s1, $s1, 1
	blt $s1, 16, life_next_row
	
	la $a0, GEN_A
	la $a1, GEN_B
	jal copy_16x16		# Copy scratch array back into main array
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra



# Use here your solution to Part A for this function
# (i.e., copy-and-paste your code).
set_16x16:

	jr $ra
	
	
# Use here your solution to Part A for this function
# (i.e., copy-and-paste your code).
get_16x16:

	jr $ra
	

# Use here your solution to Part A for this function
# (i.e., copy-and-paste your code).
copy_16x16:

	jr $ra
	

# Use here your solution to Part B for this function
# (i.e., copy-and-paste your code).
sum_neighbours:

	jr $ra
	

# Use here your solution to Part C for this function
# (i.e., copy-and-paste your code).	
bitmap_to_16x16:

	jr $ra
	
# Use here your solution to Part C for this function
# (i.e., copy-and-paste your code).		
draw_16x16:

	jr $ra
	


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
