	.data
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
KEYBOARD_COUNTS:
	.space  128
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
	
	
	.eqv 	LETTER_a 97
	.eqv	LETTER_b 98
	.eqv	LETTER_c 99
	.eqv 	LETTER_D 100
	.eqv 	LETTER_space 32
	
	
	.text  
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv  

	la $s1, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s2, 0($s1)
	ori $s2, $s2, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s2, 0($s1)
	beq $zero, $zero, check_for_event

loop2:
	addi $t0, $t0, 1	# increment counter for letter a
	add $t4, $zero, $zero   # reset last pressed key
	beq $zero, $zero, check_for_event
	
loop3:
	addi $t1, $t1, 1	# increment counter for letter b
	add $t4, $zero, $zero	# reset last pressed key
	beq $zero, $zero, check_for_event
	
loop4:	
	addi $t2, $t2, 1	# increment counter for letter c
	add $t4, $zero, $zero	# reset last pressed key
	beq $zero, $zero, check_for_event
	
loop5:
	addi $t3, $t3, 1	# increment counter for letter d
	add $t4, $zero, $zero	# reset last pressed key
	beq $zero, $zero, check_for_event

spaceloop:
	add $a0, $zero, $t0	# used to print # of times the key a was pressed
	addi $v0, $zero, 1	# store 1 in $v0 for integer output
	syscall			# system call 1 (print integer)
	
	la $a0, SPACE		# used to print space between every integer
	add $v0, $zero, 4	# store 4 in $v0 for string output	
	syscall			# system call 4 (print string)
	
	add $a0, $zero, $t1	# used to print # of times the key b was pressed
	addi $v0, $zero, 1	# store 1 in $v0 for integer output
	syscall			# system call 1 (print integer)
	
	la $a0, SPACE		# used to print space between every integer
	add $v0, $zero, 4	# store 4 in $v0 for string output
	syscall			# system call 4 (print string)
	
	add $a0, $zero, $t2	# used to print # of times the key c was pressed
	addi $v0, $zero, 1	# store 1 in $v0 for integer output
	syscall			# system call 1 (print integer)

	la $a0, SPACE		# used to print space between every integer
	add $v0, $zero, 4	# store 4 in $v0 for string output
	syscall			# system call 4 (print string)	
	
	add $a0, $zero, $t3	# used to print # of times the key d was pressed
	addi $v0, $zero, 1	# store 1 in $v0 for integer output
	syscall			# system call 1 (print integer)
	
	la $a0, NEWLINE		# used to print space between every integer
	add $v0, $zero, 4	# store 4 in $v0 for string output
	syscall			# system call 4 (print string)
	
	add $t4, $zero, $zero	# reset last pressed key
	beq $zero, $zero, check_for_event
	
check_for_event:
	beq $t4, LETTER_a, loop2		# check if the pressed key is "a"
	beq $t4, LETTER_b, loop3		# check if the pressed key is "b"
	beq $t4, LETTER_c, loop4		# check if the pressed key is "c"
	beq $t4, LETTER_D, loop5		# check if the pressed key is "d"
	beq $t4, LETTER_space, spaceloop	# check if the space bar is pressed
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)
	beq $s1, $zero, check_for_event

	.kdata

	.ktext 0x80000180
# kernel code obtained from lab files (credited to Michael Zastre)
__kernel_entry:
	mfc0 $k0, $13		# $13 is the "cause" register in Coproc0
	andi $k1, $k0, 0x7c	# bits 2 to 6 are the ExcCode field (0 for interrupts)
	srl  $k1, $k1, 2	# shift ExcCode bits for easier comparison
	beq $zero, $k1, __is_interrupt
	
__is_exception:
	# Something of a placeholder...
	# ... just in case we can't escape the need for handling some exceptions.
	beq $zero, $zero, __exit_exception
	
__is_interrupt:
	andi $k1, $k0, 0x0100	# examine bit 8
	bne $k1, $zero, __is_keyboard_interrupt	 # if bit 8 set, then we have a keyboard interrupt.
	beq $zero, $zero, __exit_exception	# otherwise, we return exit kernel
	
__is_keyboard_interrupt:
	la $k0, 0xffff0004
	lw $t4, 0($k0)	

	la $k0, KEYBOARD_EVENT
	sw $k1, 0($k0)
	
	la $k0, KEYBOARD_COUNTS
	lw $k1, 0($k0)
	addi $k1, $k1, 1
	sw $k1, 0($k0)
	
	beq $zero, $zero, __exit_exception	# Kept here in case we add more handlers.
	
__exit_exception:
	eret	# exit the kernel and restart the .text instruction
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

	
