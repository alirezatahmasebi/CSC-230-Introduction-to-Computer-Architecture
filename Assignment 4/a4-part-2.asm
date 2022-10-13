	.data
	
TEST_A_16x16:
	.byte  	9 3 8 5 7 0 8 3 9 3 4 7 3 5 7 1
       		4 3 2 1 7 8 5 3 7 5 3 6 6 3 1 6
       		7 4 3 1 9 5 4 6 6 3 6 1 6 6 0 7
       		3 8 1 5 0 5 5 0 4 9 2 0 6 2 4 1
       		2 6 5 9 7 2 7 8 4 2 8 0 1 1 0 9
       		5 8 7 1 9 9 7 2 2 3 8 7 2 1 2 4
       		5 6 1 0 8 8 5 7 0 3 4 5 1 4 2 4
       		7 3 6 1 8 5 3 1 4 2 0 0 6 9 7 9
       		0 5 3 4 7 3 8 9 8 5 5 0 2 4 5 5
       		6 6 0 3 8 1 3 2 1 2 5 1 5 0 7 3
       		5 8 8 3 2 7 8 8 5 4 4 4 3 6 3 7
       		4 0 3 0 9 5 7 7 0 4 8 3 0 7 9 0
       		0 6 7 4 9 2 7 0 0 4 9 1 1 9 7 5
       		8 1 2 7 6 1 4 0 3 5 3 8 1 3 3 2
       		2 9 3 7 2 0 3 8 8 3 1 9 8 0 5 8
       		2 9 7 2 1 1 0 7 9 9 9 9 1 4 6 2
	
	.text
main:

# Students may modify this "main" section temporarily for their testing.
# However, when evaluating your submission, all code from lines 1
# to 49 will be replaced by other testing code (i.e., we will only
# keep code from lines 50 onward). If your solution breaks because
# you have ignored this note, then a mark of zero for Part 2
# of the assignment is possible.

	la $a0, TEST_A_16x16
	addi $a1, $zero, 4
	addi $a2, $zero, 0
	jal sum_neighbours		# Test 2a; $v0 should be 30
	
	la $a0, TEST_A_16x16
	addi $a1, $zero, 9
	addi $a2, $zero, 8
	jal sum_neighbours		# Test 2b; $v0 should be 43
	
	la $a0, TEST_A_16x16
	addi $a1, $zero, 15
	addi $a2, $zero, 15
	jal sum_neighbours		# Test 2c; $v0 should be 19
			
	addi $v0, $zero, 10
	syscall


# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	.data
	
# Available for any extra `.eqv` or data needed for your solution.

	.eqv maxnum 2
	
	.text
	
# sum_neighbours:
#
# $a0 is 16x16 byte array
# $a1 is row (0 is topmost)
# $a2 is column (0 is leftmost)
#
# $v0 holds the value of the bytes around the row and column
sum_neighbours:
	addi $a1, $a1, -1	# move up by one row
	addi $a2, $a2, -1	# move left by one column
	add $s0, $zero, $zero   # the sum total of bytes around the given row and column
	add $s1, $zero, $zero   # counter used to stay in range of the neighbouring elemnts
top:
	addi $sp, $sp, -24    	     # room to save $ra, $s0, $s1, $a0, $a1, $a2
	sw $ra, 0($sp)		     # "push" value of $ra
	sw $s0, 4($sp)		     # "push" value of $s0
	sw $s1, 8($sp)		     # "push" value of $s1
	sw $a0, 12($sp)		     # "push" value of $a0
	sw $a1, 16($sp)		     # "push" value of $a1
	sw $a2, 20($sp)		     # "push" value of $a2
	jal get_16x16		     # read the byte (get the value) at the location given by $a1 and $a2
	lw $ra, 0($sp)		     # restore original value of $ra
	lw $s0, 4($sp)		     # restore original value of $s0
	lw $s1, 8($sp)		     # restore original value of $s1
	lw $a0, 12($sp)		     # restore original value of $a0
	lw $a1, 16($sp)		     # restore original value of $a1
	lw $a2, 20($sp)		     # restore original value of $a2
	addi $sp, $sp, 24    	     # shrink stack by six words
	add $s0, $s0, $v0	     # sum of neighbouring array elements += value of current neighbouring element
	addi $s1, $s1, 1	     # increment the counter
	addi $a2, $a2, 1	     # go right by one column
	beq $s1, maxnum, beforeright # branch out of the loop after reading the elements in the upper row
	beq $zero, $zero, top	     # repeat the loop to read the next neighbouring element
beforeright:
	add $s1, $zero, $zero # reset counter
right:
	addi $sp, $sp, -24    	      # room to save $ra, $s0, $s1, $a0, $a1, $a2
	sw $ra, 0($sp)		      # "push" value of $ra
	sw $s0, 4($sp)		      # "push" value of $s0
	sw $s1, 8($sp)		      # "push" value of $s1
	sw $a0, 12($sp)		      # "push" value of $a0
	sw $a1, 16($sp)		      # "push" value of $a1
	sw $a2, 20($sp)		      # "push" value of $a2
	jal get_16x16		      # read the byte (get the value) at the location given by $a1 and $a2
	lw $ra, 0($sp)		      # restore original value of $ra
	lw $s0, 4($sp)		      # restore original value of $s0
	lw $s1, 8($sp)		      # restore original value of $s1
	lw $a0, 12($sp)		      # restore original value of $a0
	lw $a1, 16($sp)		      # restore original value of $a1
	lw $a2, 20($sp)		      # restore original value of $a2
	addi $sp, $sp, 24    	      # shrink stack by six words
	add $s0, $s0, $v0	      # sum of neighbouring array elements += value of current neighbouring element
	addi $s1, $s1, 1	      # increment the counter
	addi $a1, $a1, 1              # go down by one row
	beq $s1, maxnum, beforebottom # branch out of the loop after reading the elements in the right column
	beq $zero, $zero, right       # repeat the loop to read the next neighbouring element
beforebottom:
	add $s1, $zero, $zero # reset counter
bottom:
	addi $sp, $sp, -24    	    # room to save $ra, $s0, $s1, $a0, $a1, $a2
	sw $ra, 0($sp)		    # "push" value of $ra
	sw $s0, 4($sp)		    # "push" value of $s0
	sw $s1, 8($sp)		    # "push" value of $s1
	sw $a0, 12($sp)		    # "push" value of $a0
	sw $a1, 16($sp)		    # "push" value of $a1
	sw $a2, 20($sp)		    # "push" value of $a2
	jal get_16x16		    # read the byte (get the value) at the location given by $a1 and $a2
	lw $ra, 0($sp)		    # restore original value of $ra
	lw $s0, 4($sp)		    # restore original value of $s0
	lw $s1, 8($sp)		    # restore original value of $s1
	lw $a0, 12($sp)		    # restore original value of $a0
	lw $a1, 16($sp)		    # restore original value of $a1
	lw $a2, 20($sp)		    # restore original value of $a2
	addi $sp, $sp, 24    	    # shrink stack by six words
	add $s0, $s0, $v0	    # sum of neighbouring array elements += value of current neighbouring element
	addi $s1, $s1, 1	    # increment the counter
	addi $a2, $a2, -1	    # go left by one column
	beq $s1, maxnum, beforeleft # branch out of the loop after reading the elements in the lower row
	beq $zero, $zero, bottom    # repeat the loop to read the next neighbouring element
beforeleft:
	add $s1, $zero, $zero # reset counter
left:
	addi $sp, $sp, -24    	     # room to save $ra, $s0, $s1, $a0, $a1, $a2
	sw $ra, 0($sp)		     # "push" value of $ra
	sw $s0, 4($sp)		     # "push" value of $s0
	sw $s1, 8($sp)		     # "push" value of $s1
	sw $a0, 12($sp)		     # "push" value of $a0
	sw $a1, 16($sp)		     # "push" value of $a1
	sw $a2, 20($sp)		     # "push" value of $a2
	jal get_16x16		     # read the byte (get the value) at the location given by $a1 and $a2
	lw $ra, 0($sp)		     # restore original value of $ra
	lw $s0, 4($sp)		     # restore original value of $s0
	lw $s1, 8($sp)		     # restore original value of $s1
	lw $a0, 12($sp)		     # restore original value of $a0
	lw $a1, 16($sp)		     # restore original value of $a1
	lw $a2, 20($sp)		     # restore original value of $a2
	addi $sp, $sp, 24    	     # shrink stack by six words
	add $s0, $s0, $v0            # sum of neighbouring array elements += value of current neighbouring element
	addi $s1, $s1, 1	     # increment the counter
	addi $a1, $a1, -1	     # go up by one row
	beq $s1, maxnum, returnfinal # branch out of the loop after reading the elements in the left column
	beq $zero, $zero, left       # repeat the loop to read the next neighbouring element
returnfinal:
	add $v0, $zero, $s0 # return the sum total of neighbouring array elements
	jr $ra
	
# set_16x16:
#	
# $a0 is 16x16 byte array
# $a1 is row (0 is topmost)
# $a2 is column (0 is leftmost)
# $a3 is the value to be stored (i.e., rightmost 8 bits)
# 
# If $a1 or $a2 are outside bounds of array, then
# nothing happens.
set_16x16:
	addi $t1, $zero, 16 	   # set $t1 to be the max row index + 1 or max column index + 1
	addi $t2, $zero, 0         # set $t2 to be the min row index - 1 or min column index - 1
	slt $t0, $a1, $t1          # check if row index is less than 16
	beq $t0, $zero, set_return # prepare to return from procedure since row index is out of range
	slt $t0, $a2, $t1          # check if column index is less than 16
	beq $t0, $zero, set_return # prepare to return from procedure since column index is out of range
	slt $t0, $a1, $t2   	   # check if row index is greater than or equal to 0 (not less than 0)	 
	bne $t0, $zero, set_return # prepare to return from procedure since row index is out of range
	slt $t0, $a2, $t2          # check if column index is greater than or equal to 0 (not less than 0)
	bne $t0, $zero, set_return # prepare to return from procedure since column index is out of range
	sll $a1, $a1, 4 	   # row index * row length (shift left 4 times to multiply by 2^4 or 16)
	add $a1, $a1, $a2	   # row index * row length + column index
	add $a0, $a0, $a1	   # store the location of 2d element in 16x16 byte array
	sb $a3, 0($a0)  	   # write the value in 16x16 byte array
set_return:
	jr $ra
	
# get_16x16:
#
# $a0 is 16x16 byte array
# $a1 is row (0 is topmost)
# $a2 is column (0 is leftmost)
# 
# If $a1 or $a2 are outside bounds of array, then
# the value of zero is returned
#
# $v0 holds the value of the byte at that array location
get_16x16:
	addi $t1, $zero, 16	 # set $t1 to be the max row index + 1 or max column index + 1
	addi $t2, $zero, 0	 # set $t2 to be the min row index - 1 or min column index - 1
	slt $t0, $a1, $t1 	 # check if row index is less than 16
	beq $t0, $zero, get_exit # prepare to return from procedure since row index is out of range
	slt $t0, $a2, $t1  	 # check if column index is less than 16
	beq $t0, $zero, get_exit # prepare to return from procedure since column index is out of range
	slt $t0, $a1, $t2 	 # check if row index is greater than or equal to 0 (not less than 0)
	bne $t0, $zero, get_exit # prepare to return from procedure since row index is out of range
	slt $t0, $a2, $t2	 # check if column index is greater than or equal to 0 (not less than 0)
	bne $t0, $zero, get_exit # prepare to return from procedure since column index is out of range
	sll $a1, $a1, 4 	 # row index * row length (shift left 4 times to multiply by 2^4 or 16)
	add $a1, $a1, $a2	 # row index * row length + column index
	add $a0, $a0, $a1 	 # store the location of 2d element in 16x16 byte array
	lb $v0, 0($a0) 		 # read the value at the desired location
	beq $zero, $zero, get_return
get_exit:
	addi $v0, $zero, 0
get_return:
	jr $ra
	
# copy_16x16:
#
# $a0 is the destination 16x16 byte array
# $a1 is the source 16x16 byte array
copy_16x16:
	addi $s0, $zero, 256 	     # last possible index in 1d 16x16 byte array + 1 (used to check for reaching last value)
	lb $s4, 0($a1)		     # read the byte from the source array
	sb $s4, 0($a0)  	     # write the byte in the destination array
	addi $a1, $a1, 1 	     # point to the next element in source array
	addi $a0, $a0, 1             # point to the next element in destination array
	addi $t5, $t5, 1 	     # increment counter
	beq $t5, $s0, copy_return    # prepare to return from procedure because the last array element was copied
	beq $zero, $zero, copy_16x16 # prepare to get the next value from source array and copy it 
copy_return:
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
