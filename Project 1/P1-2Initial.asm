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
		addi 	$10, $0, CandBase		# gets raw index for candBase
		addi 	$3, $0, 0				# patternIndex = 0;
		addi 	$4, $0, 576				# Icon Size 
		
		# i need to have Static: 38, Dynamic: 350 (avg), Registers: 11 words
		# rn i'm at 18, 639, 7
		# that means 20 more instructions, 4 more registers approx.
		# 

		
Loop:	lw		$5, PatternBase($3)		# loads the pattern pixel at patternIndex
		beq		$5, $0, Break			# Checks if the pixel is 0: goes to break
		addi 	$2, $0, 7				# Counter for which ones haven't passed. 

		# Create a bitmask to store the trues and falses of which ones are still fine. Make it somehow remove 
		# which ones aren't valid any more? 
		# Andi 
		#
		#
		

		beq 	$6, $5, Next			# if the candidate is correct, don't minus 1
		addi 	$2, $2, -1
		beq 	$6, $0, Almost			# ends the loop if the match is found
Next:	add		$7, $7, $4				# adds icon size to the candidate to go to the next one.
										# if the $7 is above the size of cand then iterate to next pixel
		j Cand

Break:  addi 	$3, $3, 4			# increments i by 4
		bne 	$4, $3, Loop		# Checks if the size has reached the pattern size
		j Exit
Almost: add 	$1, $7, $0
Exit:	sub 	$1, $1, $10 		# Finds the raw number of the candidate index.
		div 	$1, $4				# Divides the two to get the candidate
		mflo 	$2					# Stores the answer.
		swi	544						# submit answer and check
		jr	$31						# a return to caller
