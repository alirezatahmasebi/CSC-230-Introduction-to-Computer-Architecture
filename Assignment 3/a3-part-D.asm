# This code assumes the use of the "Bitmap Display" tool.
#
# Tool settings must be:
#   Unit Width in Pixels: 32
#   Unit Height in Pixels: 32
#   Display Width in Pixels: 512
#   Display Height in Pixels: 512
#   Based Address for display: 0x10010000 (static data)
#
# In effect, this produces a bitmap display of 16x16 pixels.


	.include "bitmap-routines.asm"

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
BOX_ROW:
	.word	0x0
BOX_COLUMN:
	.word	0x0

	.eqv LETTER_a 97
	.eqv LETTER_d 100
	.eqv LETTER_w 119
	.eqv LETTER_x 120
	.eqv BOX_COLOUR 0x0099ff33
	
	.globl main
	
	.text	
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	# initialize variables
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, BOX_COLOUR	
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	jal draw_bitmap_box
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
	la $s1, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s2, 0($s1)
	ori $s2, $s2, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s2, 0($s1)
	add $t5, $zero, $zero
	add $t7, $zero, $zero
	beq $zero, $zero, check_for_event
	
loop2:
	addi $a2, $zero, 0x00000000	
	jal draw_bitmap_box
	addi $a2, $zero, BOX_COLOUR	
	addi $a1, $a1, -1
	jal draw_bitmap_box
	add $t7, $zero, $zero
	beq $zero, $zero, check_for_event
	
loop3:
	addi $a2, $zero, 0x00000000	
	jal draw_bitmap_box
	addi $a2, $zero, BOX_COLOUR	
	addi $a1, $a1, 1
	jal draw_bitmap_box
	add $t7, $zero, $zero
	beq $zero, $zero, check_for_event	
	
loop4:
	addi $a2, $zero, 0x00000000	
	jal draw_bitmap_box
	addi $a2, $zero, BOX_COLOUR	
	addi $a0, $a0, -1
	jal draw_bitmap_box
	add $t7, $zero, $zero
	beq $zero, $zero, check_for_event
	
loop5:
	addi $a2, $zero, 0x00000000	
	jal draw_bitmap_box
	addi $a2, $zero, BOX_COLOUR	
	addi $a0, $a0, 1
	jal draw_bitmap_box
	add $t7, $zero, $zero
	beq $zero, $zero, check_for_event

check_for_event:
	beq $t7, LETTER_a, loop2 # take action if the key "a" is pressed (move the box left)
	beq $t7, LETTER_d, loop3 # take action if the key "d" is pressed (move the box right)
	beq $t7, LETTER_w, loop4 # take action if the key "w" is pressed (move the box up)
	beq $t7, LETTER_x, loop5 # take action if the key "x" is pressed (move the box down)
	addi $t5, $t5, 1
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)
	beq $s1, $zero, check_for_event

	# Should never, *ever* arrive at this point
	# in the code.	

	addi $v0, $zero, 10
	syscall

# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box

draw_bitmap_box:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	jal start	 # draw upper leftmost pixel box (2x2)
	add $a0, $a0, 2	 # row = row + 2 (move down by 2 rows) 
	jal start	 # draw lower leftmost pixel box (2x2)
	add $a1, $a1, 2  # column = column + 2 (move right by 2 columns) 
	add $a0, $a0, -2 # row = row - 2 (move up by 2 rows) 
	jal start	 # draw upper rightmost pixel box (2x2)
	add $a0, $a0, 2  # row = row + 2 (move down by 2 rows) 
	jal start	 # draw lower rightmost pixel box (2x2)
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 16
start:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	add $s0, $zero, $a0 # save a duplicate (backup copy) of the row number
	add $s1, $zero, $a1 # save a duplicate (backup copy) of the column number
	jal set_pixel	    # display upper leftmost pixel
	addi $a0, $a0, 1    # row = row + 1 (move down by 1 row)
	jal set_pixel       # display lower leftmost pixel
	add $a0, $zero, $s0 # restore the row number
	addi $a1, $a1, 1    # column = column + 1 (move right by 1 column)
	jal set_pixel       # display upper rightmost pixel
	addi $a0, $a0, 1    # row = row + 1 (move down by 1 row)
	jal set_pixel       # display lower rightmost pixel
	add $a0, $zero, $s0 # restore the row number 
	add $a1, $zero, $s1 # restore the column number
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
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
	lw $t7, 0($k0)	

	la $k0, KEYBOARD_EVENT
	sw $k1, 0($k0)
	
	la $k0, KEYBOARD_COUNTS
	lw $k1, 0($k0)
	addi $k1, $k1, 1
	sw $k1, 0($k0)
	
	beq $zero, $zero, __exit_exception	# Kept here in case we add more handlers.
	
__exit_exception:
	eret


.data

# Any additional .text area "variables" that you need can
# be added in this spot. The assembler will ensure that whatever
# directives appear here will be placed in memory following the
# data items at the top of this file.

KEYBOARD_COUNTS:
	.space  128
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
	
