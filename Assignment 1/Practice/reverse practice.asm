# UVic CSC 230, Summer 2020
# Assignment #1, part B

# Student name: Alireza Tahmasebi

# Compute the reverse of the input bit sequence that must be stored
# in register $8, and the reverse must be in register $15.

	
.text
start:
	lw $8, testcase1   # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	xor $3, $8, $8    # set register 3 to the value 0
	xor $4, $8, $8    # set register 4 to the value 0
	ori $5, $3, 1  	  # set register 5 to the value 1
	xor $6, $8, $8    # set register 6 to the value 0
	ori $7, $3, 0     # set register 7 to be the counter
	ori $9, $3, 33    # set register 9 to the value 33
	b   loop	  # branch to loop
loop:
	addi $7, $7, 1    	# increment the counter
	beq  $7, $9, loop2	# branch to loop2 if the counter reaches the value 33
	sll  $4, $4, 1		# logical shift of register 4 left by 1
	andi $6, $8 , 1		# set register 6 to bitwise and of register 8 and the value 1
	srl  $8, $8, 1		# logical shift of register 8 right by 1
	bne  $6, $5, loop	# branch to loop if register 6 is not equal to register 5
	xor  $4, $4, 1		# set register 4 to bitwise exlusive or of register 4 and value 1
	b    loop		# branch to loop
loop2:
	add  $15, $4, 0    # store the value of register 4 in register 15
	b    exit	   # branch to exit

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
