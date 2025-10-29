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
		addi 	$10, $0, CandBase
		addi 	$3, $0, 0				# patternIndex = 0;
		addi 	$4, $0, 576				# Icon Size


		# Strategy: right now I'm loading the 
		# nonzero values and looping through until theres a match.
		# Right now its going through the correct option in entirety
		# I need to make it so that it checks all the candidates at once
		# then wait until theres one left and then submit that one
		# The nonzero loop is all correct.
		# I need to change the checking mechanism
		# i need to have Static: 38, Dynamic: 350 (avg), Registers: 11 words
		# rn i'm at 18, 639, 7
		# that means 20 more instructions, 4 more registers approx.
		# 
		# 
		# 
		# 
		
Loop:	lw		$5, PatternBase($3)		# loads the pattern pixel at patternIndex
		beq		$5, $0, Break			# Checks if the pixel is 0: goes to break
		
		#this portion's wrong.
		#if this finds a nonzero, check if its equal to any of the candidates. Then, if its 
		#set register 2 equal to 7, which if its 0 then exit.
		#check all 7 at the same time:
		#load 1, load 576 + 2, load 576 + 3, etc. 
		#if the comparison fails register 2 - 1.
		# then at the end we need some way to record which one is not failed
		
		add		$6, $1, $3			# Calculates the Candidate Index
		lw 		$6, 0($6)			# Loads candidate pixel
		beq 	$5, $6, Break		# checks if pixels aren't equal
	    addi	$1, $1, 576			# updates Candidate
Break:  addi 	$3, $3, 4			# increments i by 4
		bne 	$4, $3, Loop		# Checks if the size has reached the pattern size
Exit:	sub 	$1, $1, $10 		# Finds the raw number of the candidate index.
		div 	$1, $4				# Divides the two to get the candidate
		mflo 	$2					# Stores the answer.
		swi	544						# submit answer and check
		jr	$31						# a return to caller
