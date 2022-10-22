.text


main:	



# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	# Name: Alireza Tahmasebi
	## Test code that calls procedure for part A
	# jal save_our_souls

	## morse_flash test for part B
	# addi $a0, $zero, 0x42   # dot dot dash dot
	# jal morse_flash
	
	## morse_flash test for part B
	# addi $a0, $zero, 0x37   # dash dash dash
	# jal morse_flash
		
	## morse_flash test for part B
	# addi $a0, $zero, 0x32  	# dot dash dot
	# jal morse_flash
			
	## morse_flash test for part B
	# addi $a0, $zero, 0x11   # dash
	# jal morse_flash	
	
	# flash_message test for part C
	# la $a0, test_buffer
	# jal flash_message
	
	# letter_to_code test for part D
	# the letter 'P' is properly encoded as 0x46.
	# addi $a0, $zero, 'P'
	# jal letter_to_code
	
	# letter_to_code test for part D
	# the letter 'A' is properly encoded as 0x21
	# addi $a0, $zero, 'A'
	# jal letter_to_code
	
	# letter_to_code test for part D
	# the space' is properly encoded as 0xff
	# addi $a0, $zero, ' '
	# jal letter_to_code
	
	# encode_message test for part E
	# The outcome of the procedure is here
	# immediately used by flash_message
	la $a0, message01
	la $a1, buffer01
	jal encode_message
	la $a0, buffer01
	jal flash_message
	
	
	# Proper exit from the program.
	addi $v0, $zero, 10
	syscall

	
	
###########
# PROCEDURE
save_our_souls:
	addi $sp, $sp, -4
	sw $31, 0($sp)
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	lw $31, 0($sp)
	addi $sp, $sp, 4
	jr $31

# PROCEDURE
morse_flash:
	addi $sp, $sp, -28
	sw $ra, 24($sp)	
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	add $s0, $s0, $a0 	       # get one byte contained in $a0
	addi $s5, $zero, 0xff 	       # store special value for space
	beq $a0, $s5, spaces 	       # if the parameter is a space go to the loop spaces
	addi $s5, $zero, 0xffffffff    # store special value for space
	beq $a0, $s5, spaces 	       # if the parameter is a space go to the loop spaces 
	andi $s0, $a0, 0x0f 	       # get the 4 rightmost bits (sequence of dots and dashes)
	srl $s1, $a0, 4 	       # to get the 4 leftmost bits shift right by 4
	addi $s2, $zero, 1 	       # mask for dashes and dots
	addi $s3, $s1, -1 	       # length - 1 for shifting left 
	sllv $s2, $s2, $s3 	       # mask for dots and dashes (single bit)
loop1:
	and $s4, $s0, $s2           # mask the bit for checking if it's set or unset
	beq $s4, $zero, dots 	    # if the bit is 0 then go to loop dots else it's a dash
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	srl $s2, $s2, 1             # shift mask for dots and dashes (single bit)
	addi $s1, $s1, -1     	    # decrease counter
	beq $s1, $zero, finish_m    # go to finish_m if counter reaches 0
	beq $zero, $zero, loop1     # repeat loop 1
dots:
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	srl $s2, $s2, 1             # shift mask for dots and dashes (single bit)
	addi $s1, $s1, -1           # decrease counter
	beq $s1, $zero, finish_m    # go to finish_m if counter reaches 0
	beq $zero, $zero, loop1     
spaces:
	jal seven_segment_off
	jal delay_long
	jal delay_long
	jal delay_long
	beq $zero, $zero, finish_m    
finish_m:
	lw $ra, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $s4, 4($sp)
	lw $s5, 0($sp)
	addi $sp, $sp, 28
	jr $ra

###########
# PROCEDURE
flash_message:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	add $s0, $zero, $a0        # get data-memory address
	add $s1, $zero, $zero      # used for incrementing $s0
loop2:
	add $s0, $s0, $s1	   # get the next byte
	lb $a0, 0($s0) 		   # load the byte for passing the argument $a0
	beq $a0, $zero, finish     # go to loop finish if we reached the end of sequence
	jal morse_flash	
	addi $s1, $zero, 1	   # increment $s1
	beq $zero, $zero, loop2    # repeat loop2
finish:
	lw $ra, 8($sp)
	lw $s0, 4($sp)
	lw $s1, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
###########
# PROCEDURE
letter_to_code:
	addi $sp, $sp, -28
	sw $ra, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	la $s0, codes		 # get table of codes (dot-dash sequence for each letter)
	addi $s2, $zero, 45 	 # ascii code for dash
	addi $s3, $zero, 32 	 # ascii code for space
	add $s4, $zero, $zero    # counter used to get the length (leftmost 4 bits)
	add $s5, $zero, $zero    # the actual byte we have to return
	addi $t0, $zero, 0x08    # mask used to set bits for dashes
	addi $t1, $zero, 4       # max length
checkletter:	
	lb $s1, 0($s0)		 	 # get the letter at the start of the line from codes
	beq $a0, $s3, retspace   	 # if the data-memory address is for a space go to retspace
	beq $s1, $a0, dashdot    	 # if the data-memory address is for a dash or a dot go to dashdot
	addi $s0, $s0, 8	 	 # go to the next line
	beq $zero, $zero, checkletter    # repeat the loop checkletter
retspace:
	addi $v0, $zero, 0xff            # store special value for space for returning $v0
	beq $zero, $zero, finish_after   # go to finish_after
dashdot:
	addi $s0, $s0, 1	     # increment address of codes
	lb $s1, 0($s0)		     # get the next character
	beq $s1, $zero, shiftbits    # go to shiftbits if the sequence ends
	addi $s4, $s4, 1 	     # increase length by 1
	beq $s1, $s2, checkdash      # go to checkdash if the character is a dash
	srl $t0, $t0, 1              # shift the mask for dashes
	beq $zero, $zero, dashdot    # repeat dashdot
checkdash:	
	add $s5, $s5, $t0 	     # set bit for a dash
	srl $t0, $t0, 1 	     # shift the mask for dashes
	beq $zero, $zero, dashdot    # repeat dashdot
shiftbits:
	beq $s4, $t1, finish_before        # go to finish_before if maximum length is reached
	sub $t3, $t1, $s4 		   # get shift amount for correcting the byte
	srlv $s5, $s5, $t3 		   # shift the byte 
	beq $zero, $zero, finish_before    # go to finish_before
finish_before:
	sll $s4, $s4, 4			   # set the leftmost 4 bits (length)
	add $s5, $s5, $s4		   # add the length and the byte used to get the dash-dot sequence
	add $v0, $zero, $s5		   # store the byte in $v0 for returning
	beq $zero, $zero, finish_after     # go to finish_after
finish_after:
	lw $ra, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $s4, 4($sp)
	lw $s5, 0($sp)
	addi $sp, $sp, 28
	jr $ra


###########
# PROCEDURE
encode_message:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	la $s0, 0($a0)
loop3:
	lb $a0, 0($s0) 			# get the letter or space in the message
	beq $a0, $zero, finish_final    # if the sequence ends go to finish_final
	jal letter_to_code 
	sb $v0, 0($a1) 			# store the one byte value in the buffer
	addi $s0, $s0, 1 		# increment the address for getting the next character
	addi $a1, $a1, 1 		# increment the address for the buffer
	beq $zero, $zero, loop3 	# repeat loop3 
finish_final:
	la $a0, 0($a1) 			# load the address of buffer for future call to flash_message
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31




#############
# DATA MEMORY
.data
codes:
	.byte 'A', '.', '-', 0, 0, 0, 0, 0
	.byte 'B', '-', '.', '.', '.', 0, 0, 0
	.byte 'C', '-', '.', '-', '.', 0, 0, 0
	.byte 'D', '-', '.', '.', 0, 0, 0, 0
	.byte 'E', '.', 0, 0, 0, 0, 0, 0
	.byte 'F', '.', '.', '-', '.', 0, 0, 0
	.byte 'G', '-', '-', '.', 0, 0, 0, 0
	.byte 'H', '.', '.', '.', '.', 0, 0, 0
	.byte 'I', '.', '.', 0, 0, 0, 0, 0
	.byte 'J', '.', '-', '-', '-', 0, 0, 0
	.byte 'K', '-', '.', '-', 0, 0, 0, 0
	.byte 'L', '.', '-', '.', '.', 0, 0, 0
	.byte 'M', '-', '-', 0, 0, 0, 0, 0
	.byte 'N', '-', '.', 0, 0, 0, 0, 0
	.byte 'O', '-', '-', '-', 0, 0, 0, 0
	.byte 'P', '.', '-', '-', '.', 0, 0, 0
	.byte 'Q', '-', '-', '.', '-', 0, 0, 0
	.byte 'R', '.', '-', '.', 0, 0, 0, 0
	.byte 'S', '.', '.', '.', 0, 0, 0, 0
	.byte 'T', '-', 0, 0, 0, 0, 0, 0
	.byte 'U', '.', '.', '-', 0, 0, 0, 0
	.byte 'V', '.', '.', '.', '-', 0, 0, 0
	.byte 'W', '.', '-', '-', 0, 0, 0, 0
	.byte 'X', '-', '.', '.', '-', 0, 0, 0
	.byte 'Y', '-', '.', '-', '-', 0, 0, 0
	.byte 'Z', '-', '-', '.', '.', 0, 0, 0
	
message01:	.asciiz "AAAAAAAAAA"
message02:	.asciiz "SOS"
message03:	.asciiz "WATERLOO"
message04:	.asciiz "DANCING QUEEN"
message05:	.asciiz "CHIQUITITA"
message06:	.asciiz "THE WINNER TAKES IT ALL"
message07:	.asciiz "MAMMA MIA"
message08:	.asciiz "TAKE A CHANCE ON ME"
message09:	.asciiz "KNOWING ME KNOWING YOU"
message10:	.asciiz "FERNANDO"

buffer01:	.space 128
buffer02:	.space 128
test_buffer:	.byte 0x30 0x37 0x30 0x00    # This is SOS
