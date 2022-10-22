# UVic CSC 230, Summer 2020
# Assignment #1, part B

# Student name: Alireza Tahmasebi

# Compute the reverse of the input bit sequence that must be stored
# in register $8, and the reverse must be in register $15.

	
.text
start:
	lw $8, testcase3   # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	# $3 : same function as $0 (used because $0 must not be used for Assignment 1)
	# $9 : copy of $9 (helps to have two separate copies of the testcase word for shifting left and right)
	# $11 : used for shifting the right amount
	# $13 : subtract from $11 to shifting one less for the next loop run
	# $7 : used as counter to avoid infinite loop
	# $16 : for comparison because there are 32 bits and we shift two of the end bits ever time so the loop runs 16 time 
	# $14 : used to store the reversed bits
	# $17 : used to store the reversed bits
	 
	xor $3, $8, $8    # set register 3 to the value 0
	add $9, $8, $3	  # copy register 8 to register 9
	ori $11, $3, 31   # set register 11 to the value 31
	ori $13, $3, 1	  # set register 13 to the value 1
	ori $7, $3, 0     # set register 7 to be the counter
	ori $16, $3, 16   # set register 16 to the value 16
	ori $14, $3, 0	  # set register 14 to the value 0
	ori $17, $3, 0    # set register 17 to the value 0
	
loop:
	addi $7, $7, 1    	    # increment the counter
	andi $10, $8, 0x00000001    # set register 10 to bitwise and of register 8 and the value 0x00000001
	sllv $10, $10, $11 	    # logical shift of register 10 left by the amount in register 11
	srl  $8, $8, 1	            # logical shift of register 8 right by 1
	andi $12, $9, 0x80000000    # set register 12 to bitwise and of register 9 and the value 0x80000000
	srlv $12, $12, $11          # logical shift of register 12 right by the amount in register 11
	sll  $9, $9, 1              # logical shift of register 9 left by 1
	sub  $11, $11, $13          # subtract register 13 from register 11 and set $11 to the result
	add  $17, $10, $12          # add register 10 and register 12 and set $17 to the result
	add  $14, $14, $17          # add register 14 and register 17 and set $17 to the result
	beq  $7, $16, loop2         # if register 7 and register 16 are equal then branch to loop2
	b    loop                   # branch to loop
	
loop2:
	add  $15, $3, $14    # store the reversed order of bits in register 15
	b    exit	     # branch to exit

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

exit:
	add $2, $0, 10
	syscall
	
	

.data

testcase1:
	.word	0x00200020    # reverse is 0x04000400

testcase2:
	.word 	0x00300020    # reverse is 0x04000c00
	
testcase3:
	.word	0x1234fedc     # reverse is 0x3b7f2c48
