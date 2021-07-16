#################################################################
# CDA3100 - Assignment 2			       		  #
#						       		  #
# DO NOT MODIFY any code above the STUDENT_CODE label. 	  # 
#################################################################
	.data
	.align 0
msg0:	.asciiz "Statistical Calculator!\n"
msg1:	.asciiz "-----------------------\n"
msg2:	.asciiz "Average: "
msg3:	.asciiz "Maximum: "
msg4:	.asciiz "Median:  "
msg5:	.asciiz "Minimum: "
msg6:	.asciiz "Sum:     "
msg7:	.asciiz "\n"
	.align 2
array:	.word 91, 21, 10, 56, 35, 21, 99, 33, 13, 80, 79, 66, 52, 6, 4, 53, 67, 91, 67, 90
size:	.word 20
	.text
	.globl main
	# Display the floating-point (%double) value in register (%register) to the user
	.macro display_double (%register)
		li $v0, 3		# Prepare the system for output
		mov.d $f12, %register	# Set the integer to display
		syscall			# System displays the specified integer
	.end_macro
	
	# Display the %integer value to the user
	.macro display_integer (%integer)
		li $v0, 1			# Prepare the system for output
		add $a0, $zero, %integer	# Set the integer to display
		syscall				# System displays the specified integer
	.end_macro
	
	# Display the %string to the user
	.macro display_string (%string)
		li $v0, 4		# Prepare the system for output
		la $a0, %string		# Set the string to display
		syscall			# System displays the specified string
	.end_macro

	# Perform floating-point division %value1 / %value2
	# Result stored in register specified by %register
        .macro fp_div (%register, %value1, %value2)
 		mtc1.d %value1, $f28		# Copy integer %value1 to floating-point processor
		mtc1.d %value2, $f30		# Copy integer %value2 to floating-point processor
		cvt.d.w $f28, $f28		# Convert integer %value1 to double
		cvt.d.w $f30, $f30		# Convert integer %value2 to double
		div.d %register, $f28, $f30	# Divide %value1 by %value2 (%value1 / %value2)
	.end_macro				# Quotient stored in the specified register (%register)
	
main:
	la $a0, array		# Store memory address of array in register $a0
	lw $a1, size		# Store value of size in register $a1
	jal getMax		# Call the getMax procedure
	add $s0, $v0, $zero	# Move maximum value to register $s0
	jal getMin		# Call the getMin procedure
	add $s1, $v0, $zero	# Move minimum value to register $s1
	jal calcSum		# Call the calcSum procedure
	add $s2, $v0, $zero	# Move sum value to register $s2
	jal calcAverage		# Call the calcAverage procedure (result is stored in floating-point register $f2
	jal sort		# Call the sort procedure
	jal calcMedian		# Call the calcMedian procedure (result is stored in floating-point register $f4
	add $a1, $s0, $zero	# Add maximum value to the argumetns for the displayStatistics procedure
	add $a2, $s1, $zero	# Add minimum value to the argumetns for the displayStatistics procedure
	add $a3, $s2, $zero	# Add sum value to the argumetns for the displayStatistics procedure
	jal displayStatistics	# Call the displayResults procedure
exit:	li $v0, 10		# Prepare to terminate the program
	syscall			# Terminate the program
	
# Display the computed statistics
# $a1 - Maximum value in the array
# $a2 - Minimum value in the array
# $a3 - Sum of the values in the array
displayStatistics:
	display_string msg0
	display_string msg1
	display_string msg6
	display_integer	$a3	# Sum
	display_string msg7
	display_string msg5
	display_integer $a2	# Minimum
	display_string msg7
	display_string msg3
	display_integer $a1	# Maximum
	display_string msg7
	display_string msg2
	display_double $f2	# Average
	display_string msg7
extra_credit:
	display_string msg4
	display_double $f4	# Median
	display_string msg7
	jr $ra
#################################################################
# DO NOT MODIFY any code above the STUDENT_CODE label. 	  #
#################################################################

# Place all your code in the procedures provided below the student_code label
# Kymberlee Sables
student_code:

# Calculate the average of the values stored in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in floating-point register $f2
calcAverage:
	add $s2, $v0, $zero	# getting the result of v0 and storing it in a saved register
	
	fp_div $f2, $s2, $a1	# Perform floating-point division on registers $rs and $rt ($rs / $rt)
	jr $ra			# Return to calling procedure
	
################################################################################

# Calculate the median of the values stored in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in floating-point register $f4
calcMedian:

	#fp_div $f4, $rs, $rt	# Perform floating-point division on registers $rs and $rt ($rs / $rt)
	jr $ra			# Return to calling procedure
	
################################################################################

# Calculate the sum of the values stored in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in register $v0
calcSum:
	la $t0, ($a0)	# loading array into t0
	la $t1, ($a1)	# loading array size into t1
	li $t2, 0	# counter i for the 'for loop'
	
sumloop:
	slt $t3, $t2, $t1    		# if the counter i is less than the array size
	beq $t3, $zero, endsumloop     # if the counter is greater than or equal to array size, jump to endsumloop
	
	lw $t4, ($t0)			# getting the current index of the array
	addi $t0, $t0, 4		# incrementing the index i of the array
	
	add $t5, $t5, $t4		# adding the value of the current index of the array to the total sum
	addi $t2, $t2, 1		# incrementing the counter i of the array
	
	j sumloop			# jump back to top of loop if condition not yet met
	
endsumloop:    
	add $v0, $t5, $zero		# storing result in register v0
	jr $ra				# Return to calling procedure
	


################################################################################

# Return the maximum value in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in register $v0
getMax:
	la $t6, ($a0)	# loading array into t6
	la $t7, ($a1)	# loading array size into t7
	li $t8, 1	# counter i for the 'for loop'
	
	lw $t0, 0($t6)	# loading initial max value
	lw $t1, 4($t6)	# loading initial value to compare to max
	
maxloop:
	slt $t9, $t8, $t7    		# if the counter i is less than the array size
	beq $t9, $zero, endmaxloop     # if the counter is greater than or equal to array size, jump to endmaxloop
	
	blt $t0, $t1, if_maxloop	# if the value in t0 is less than the value in t1, jump to if
	bgt $t0, $t1, else_maxloop	# if the value in t0 is greater than the value in t1, jump to else
	
if_maxloop:
	add $t4, $t1, $zero		# store value of t1 in t4
	addi $t6, $t6, 4		# increment array index
	addi $t8, $t8, 1		# increment counter
	add $t1, $t4, $zero		# store value of t4 into t1
	lw $t0, ($t6)			# load value of next array index in t0
	j maxloop			# jump back to the loop
	
else_maxloop:
	add $t4, $t0, $zero		# store value of t0 in t4
	addi $t6, $t6, 4		# increment array index
	addi $t8, $t8, 1		# increment counter
	add $t1, $t4, $zero		# store value of t4 into t1
	lw $t0, ($t6)			# load value of next array index in t0
	j maxloop			# jump back to the loop
		
endmaxloop:	
	add $s4, $t4, $zero		# store value of t4 in s4 to ensure it will not change	
	add $v0, $s4, $zero		# store s4 into v0 in order to display the value					
	jr $ra				# Return to calling procedure
	

	
################################################################################

# Return the minimum value in the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
# Result MUST be stored in register $v0
getMin:
	la $t6, ($a0)	# loading array into t6
	la $t7, ($a1)	# loading array size into t7
	li $t8, 1	# counter i for the 'for loop'
	
	lw $t0, 0($t6)	# loading initial min value
	lw $t1, 4($t6)	# loading initial value to compare to min
	
minloop:
	slt $t9, $t8, $t7    		# if the counter i is less than the array size	
	beq $t9, $zero, endminloop     # if the counter is greater than or equal to array size, jump to endminloop
	
	blt $t0, $t1, if_minloop	# if the value in t0 is less than the value in t1, jump to if
	bgt $t0, $t1, else_minloop	# if the value in t0 is greater than the value in t1, jump to else
	
if_minloop:
	add $t4, $t0, $zero		# store value of t0 in t4
	addi $t6, $t6, 4		# increment array index
	addi $t8, $t8, 1		# increment counter
	add $t0, $t4, $zero		# load value of next array index in t0
	lw $t1, ($t6)			# load value of next array index in t1
	j minloop			# jump back to the loop
	
else_minloop:
	add $t4, $t1, $zero		# store value of t1 in t4
	addi $t6, $t6, 4		# increment array index
	addi $t8, $t8, 1		# increment counter
	add $t0, $t4, $zero		# load value of next array index in t0
	lw $t1, ($t6)			# load value of next array index in t1
	j minloop			# jump back to the loop
		
endminloop:	
	add $s5, $t4, $zero		# store value of t4 in s5 to ensure it will not change	
	add $v0, $s5, $zero		# store s5 into v0 in order to display the value	
	jr $ra				# Return to calling procedure
	
################################################################################

# Perform the Selection Sort algorithm to sort the array
# $a0 - Memory address of the array
# $a1 - Size of the array (number of values)
sort:
	
	jr $ra	# Return to calling procedure

################################################################################

# Swap the values in the specified positions of the array
# $a0 - Memory address of the array
# $a1 - Index position of first value to swap
# $a2 - Index position of second value to swap
swap:
	
	jr $ra	# Return to calling procedure
