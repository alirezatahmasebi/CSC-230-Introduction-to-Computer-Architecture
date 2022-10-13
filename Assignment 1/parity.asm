# UVic CSC 230, Summer 2020
# Assignment #1, part A

# Student name: Alireza Tahmasebi
# Student number: V00918121


# Compute even parity of word that must be in register $8
# Value of even parity (0 or 1) must be in register $15


.text

start:
	lw $8, testcase4  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	# $3 : same function as $0 (used for comparison to see if remainder is 0)
	# $4 : stored value 2 to subtract from the number of set bits 
 	# $5 : for comparting to check if the remainder is 1 after repeated subtraction
 	# $10 : counter to run the loop only 32 times (avoid infinite loop)
 	# $7 : store number of set bits 

	xor $3, $8, $8   # set register 3 to the value 0
	ori $4, $3, 2    # set register 4 to the value 2
	ori $5, $3, 1    # set register 5 to the value 1
	ori $10, $3, 0 	 # set register 10 to be the first counter
	ori $7, $3, 0  	 # set register 7 to be the second counter
	b   loop	 # branch to loop
loop:
	addi $10, $10, 1       # increment the first counter
	beq  $10, 32, loop2    # branch to loop2 if loop runs 32 times
	andi $9, $8, 1         # set register 9 to bitwise and of register 8 and the value 1
	srl  $8, $8, 1	       # logical shift of register 8 right by 1
	beq  $9, $3, loop      # if register 9 and register 3 are equal then branch to loop
	addi $7, $7, 1         # increment the second counter
	b    loop	       # branch to loop
loop2:
	sub $7, $7, $4	       # subtract register 4 (the value 2) from register 7 (number of set bits in test case)
	beq $7, $3, evenbit    # if the remainder is 0 then branch to evenbit
	beq $7, $5, oddbit     # if the remainder is 1 then branch to oddbit	
	b   loop2	       # branch to loop2
evenbit:	
	addi $15, $3, 0    # store parity bit in register 15
	b    exit          # branch to exit
oddbit:
	addi $15, $3, 1    # store parity bit in register 15
	b    exit          # branch to exit

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


exit:
	add $2, $0, 10
	syscall
		

.data

testcase1:
	.word	0x00200020    # even parity is 0

testcase2:
	.word 	0x0000000b   # even parity is 1
	
testcase3:
	.word  	0xbaadf00d     # even parity is is 1
testcase4:
	.word  	0xdecafbad     # even parity is is 0
