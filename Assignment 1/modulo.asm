# UVic CSC 230, Summer 2020
# Assignment #1, part C

# Student name: Alireza Tahmasebi

# Compute M % N, where M must be in $8, N must be in $9,
# and M % N must be in $15.


.text
start:
	lw $8, testcase2_M
	lw $9, testcase2_N

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	# $3 : same purpose as $0
	# $4 : used for comparison (e.g. slt, beq) or to check if the M or N are negative
	# $10 : return -1 if error occurs
	# $14 : used to check that N is less than 128
			
 	xor $3, $8, $8 	    # set register 3 to the value 0
	ori $4, $3, 1       # set register 4 to the value 1
	ori $10, $3, -1     # set register 10 to the value -1
	ori $14, $3, 128    # set register 14 to the value 128
	b   loop	    # branch to loop
loop:	
	slt $12, $8, $9       # set register 12 to 1 if $8 < $9, else set it to 0
	beq $12, $4, loop2    # branch to loop2 if register 12 and register 4 are equal
	slt $16, $8, $4       # set register 16 to 1 if $8 < $4, else set it to 0
	beq $16, $4, loop3    # branch to loop3 if register 16 and register 4 are equal
	slt $17, $9, $4	      # set register 17 to 1 if $9 < $4, else set it to 0
	beq $17, $4, loop3    # branch to loop3 if register 17 and register 4 are equal
	slt $18, $9, $14      # set register 18 to 1 if $9 < $14, else set it to 0
	bne $18, $4, loop3    # branch to loop3 if register 18 and register 4 are equal
	sub $8, $8, $9        # set register 8 to the result obtained from subtracting register 9 from register 8
	b   loop              # branch to loop
loop2:
	addi $15, $8, 0    # store the value of register 8 in register 15
	b    exit          # branch to exit
loop3:
	addi $15, $10, 0    # store the value of register 10 in register 15
	b    exit           # branch to exit

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

exit:
	add $2, $0, 10
	syscall
		

.data

# testcase1: 370 % 120 = 10
#
testcase1_M:
	.word	370
testcase1_N:
	.word 	120
	
# testcase2: 24156 % 77 = 55
#
testcase2_M:
	.word	123456
testcase2_N:
	.word 	1179

# testcase3: 21 % 0 = -1
#
testcase3_M:
	.word	21
testcase3_N:
	.word 	0
	
# testcase4: 33 % 120 = 33
#
testcase4_M:
	.word	33
testcase4_N:
	.word 	120
