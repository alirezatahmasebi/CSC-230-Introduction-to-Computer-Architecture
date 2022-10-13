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
	
	.globl main
	.text	
main:
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 0x00ff0000
	jal draw_bitmap_box
	
	addi $a0, $zero, 11
	addi $a1, $zero, 6
	addi $a2, $zero, 0x00ffff00
	jal draw_bitmap_box
	
	addi $a0, $zero, 8
	addi $a1, $zero, 8
	addi $a2, $zero, 0x0099ff33
	jal draw_bitmap_box
	
	addi $a0, $zero, 2
	addi $a1, $zero, 3
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_box

	addi $v0, $zero, 10
	syscall
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box

draw_bitmap_box:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal start	 # draw upper leftmost pixel box (2x2)
	add $a0, $a0, 2	 # row = row + 2 (move down by 2 rows) 
	jal start	 # draw lower leftmost pixel box (2x2)
	add $a1, $a1, 2  # column = column + 2 (move right by 2 columns) 
	add $a0, $a0, -2 # row = row - 2 (move up by 2 rows) 
	jal start	 # draw upper rightmost pixel box (2x2)
	add $a0, $a0, 2  # row = row + 2 (move down by 2 rows) 
	jal start	 # draw lower rightmost pixel box (2x2)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
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

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
