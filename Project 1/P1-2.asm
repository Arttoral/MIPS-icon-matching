
#=================================================================
# Copyright 2024 Georgia Tech.  All rights reserved.
# The materials provided by the instructor in this course are for
# the use of the students currently enrolled in the course.
# Copyrighted course materials may not be further disseminated.
# This file must not be made publicly available anywhere.
# =================================================================

# HW2-2
# Student Name: Sahil Makim
# Date: 10-5-2024
#
#     I c o n   M a t c h
#
# This routine determines which of eight candidate icons matches a pattern icon.
#
#===========================================================================
# CHANGE LOG: brief description of changes made from P1-2-shell.asm
# to this version of code.
# Date  Modification
# 10/5 Created version 1 loop of pixel search, looping through the pixels in the pattern until a non zero value is found.
# 10/7 Attempted to create the candidate checking logic. 
# Scrapped the candidate checking logic with the elimination and moved to candidate by candidate checking for only nonzero.
# Recoded C loop to find correct working logic. C code successfully implemented efficient logic: Transfering to MIPS.
# 10/16 Mips code fully optmized for reduced linage, however dynamic instructions above needed value
# 10/17 MIPS code finished, changed logic one last time
# 10/18 MIPS Tweaking code for better numbers.
#===========================================================================

.data
CandBase: 	    .alloc 1152
PatternBase:	.alloc 144

.text
IconMatch:	addi	$1, $0, CandBase	# point to base of Candidates
	############################################################
	#      For debugging only: set $2 to -1 before swi 584 to  #
	#      allow previously generated puzzle to be loaded in   #
	       #addi    $2, $0, -1              
	############################################################
	    swi	584					        # generate puzzle icons
		addi 	$3, $0, 0				# patternIndex = 0;
		addi 	$4, $0, 576				# Icon Size
Loop:	lw		$5, PatternBase($3)		# loads the pattern pixel at patternIndex
		beq		$5, $0, Break			# Checks if the pixel is 0: goes to break
		add		$7, $1, $3				# Calculates the Candidate Index of cand 0
		addi 	$8, $0, 1				# The counter for the number of matches 
		addi 	$9, $0, 8				# The counter for the number of candidates left to check 

Cand:	lw 		$6, 0($7)			# Loads candidate pixel	
		bne		$6, $5, Skip		# Skips adding the value to $2 if they're different
		addi	$2, $7, 0			# If the value is same add it to $2
		addi    $8, $8, -1			# Counts number of matches
Skip:	addi 	$7, $7, 576			# Next Candidate index
		addi	$9, $9, -1			# increment of num candidates
		bne		$9, $0, Cand		# Loop 8 times
		beq		$8, $0, Exit		# if there is only one candidate left exit

Break:  addi 	$3, $3, 4			# increments i by 4
		bne 	$4, $3, Loop		# Checks if the size has reached the pattern size

Exit:	sub 	$2, $2, $1 		# Finds the raw number of the candidate index.
		div 	$2, $4				# Divides the two to get the candidate
		mflo 	$2					# Stores the answer.
		swi	544						# submit answer and check
		jr	$31						# a return to caller
