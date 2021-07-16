#################################################################
# CDA3100 - Assignment 1			       		  #
#						       		  #
# The following code is provided by the professor.     	  #
# DO NOT MODIFY any code above the STUDENT_CODE label. 	  #
#						       		  #
# The professor will not troubleshoot any changes to this code. #
#################################################################

	.data
	.align 0

	# Define strings used in each of the printf statements
msg1:	.asciiz "Welcome to Prime Tester\n\n"
msg2:	.asciiz "Enter a number between 0 and 100: "
msg3:	.asciiz "Error: Invalid input for Prime Tester\n"
msg4:	.asciiz "The entered number is prime\n"
msg5:	.asciiz "The entered number is not prime\n"
ec_msg:	.asciiz " is prime\n" 		# Reserved for use in extra credit

	.align 2	
	.text
	.globl main

	# The following macros are provided to simplify the program code
	# A macro can be thought of as a cross between a function and a constant
	# The assembler will copy the macro's code to each use in the program code
	
	# Display the %integer to the user
	# Reserved for extra credit
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
	
	# Compute the square root of the %value
	# Result stored in the floating-point register $f2
	.macro calc_sqrt (%value)
		mtc1.d %value, $f2	# Copy integer %value to floating-point processor
		cvt.d.w $f2, $f2	# Convert integer %value to double
		sqrt.d $f2, $f2		# Calculate the square root of the %value
	.end_macro 
	
	# Determine if the %value is less-than or equal-to the current square root value in register $f2
	# Result stored in the register $v1
	.macro slt_sqrt (%value)
		mtc1.d %value, $f4	# Copy integer %value to floating-point processor
		cvt.d.w $f4, $f4	# Convert integer %value to double
		c.lt.d $f4, $f2		# Test if %value is less-than square root
		bc1t less_than_or_equal	# If less-than, go to less_than_or_equal label
		c.eq.d $f4, $f2		# Test if %value is equal-to square root
		bc1t less_than_or_equal	# If equal-to, go to less_than_or_equal label
		li $v1, 0		# Store a 0 in register $v1 to indicate greater-than condition
		j end_macro		# Go to the end_macro label
less_than_or_equal: 	
		li $v1, 1		# Store a 1 in register $v1 to indicate less-than or equal-to condition
end_macro: 
	.end_macro

main:
	# This series of instructions
	# 1. Displays the welcome message
	# 2. Displays the input prompt
	# 3. Reads input from the user
	display_string msg1	# Display welcome message
	display_string msg2	# Display input prompt
	li $v0, 5		# Prepare the system for keyboard input
	syscall			# System reads user input from keyboard
	move $a1, $v0		# Store the user input in register $a0
	j student_code 		# Go to the student_code label

error:	
	display_string msg3	# Display error message
	j exit
isprime:
	display_string msg4	# Display is prime message
	j exit
notprime:
	display_string msg5	# Display not prime message
exit:
	li $v0, 10	# Prepare to terminate the program
	syscall		# Terminate the program
	
#################################################################
# The code above is provided by the professor.     		  #
# DO NOT MODIFY any code above the STUDENT_CODE label. 	  #
#						       		  #
# The professor will not troubleshoot any changes to this code. #
#################################################################

# Place all your code below the student_code label
# Kymberlee Sables 
student_code:	
	beq $a1, -1, extra_credit	# if user's input is -1, jump to extra_credit label 

	slt $t0, $a1, $zero	# check if user input ($a1) is less than zero - stores 1 if less than zero
	beq $t0, 1, error	# if $t0 is equal to one, jump to error label
	
	sgt $t1, $a1, 100	# check if user input ($a1) is greater than one hundred - stores 1 if greater than one hundred	
	beq $t1, 1, error 	# if $t0 is equal to one, jump to error label
	
	li $t2, 2		# loading 2 into the $t2 register
	slt $t3, $a1, $t2 	# check if user input ($a1) is less than 2 - stores 1 if less than 2
	beq $t3, 1, notprime	# if $t3 is equal to one, jump to notprime label
	
	sgt $t4, $a1, $t2	# check if user input is greater than 2
	beq $t4, 1, else_if	# if user input is greater than 2, jump to else_if

else_if:
	beq $a1, $t2, isprime 		# if user input is equal to 2, display isprime result 
	div $a1, $t2			# if user input is NOT 2, divide the user input by 2
	mfhi $t5			# take the modulus of the result from previous div operation
	beq $t5, $zero, notprime	# if the modulus is equal to 0, display notprime result
	bne $t5, $zero, else		# if the modulus is NOT eqaul to zero, jump to else label
		
else:		
	li $t6, 3			# initial for loop counter	
	calc_sqrt($a1)			# calculating the square root of user input	
	slt_sqrt($t6)			# testing to see if the for loop counter is less than or equal to the square root of user input
	beq $v1, 0, isprime  		# if the result of slt_sqrt macro is 0, display isprime result
	beq $v1, 1, if_inside_for	# if the result of slt_sqrt macro is 1, jump to if_inside_for
		
if_inside_for:	
	slt_sqrt($t6)			# testing to see if the for loop counter is less than or equal to the square root of user input
	beq $v1, 0, isprime  		# if the result of slt_sqrt macro is 0, display isprime result
	
	div $a1, $t6			# dividing the user input by the for loop counter
	mfhi $t7			# retrieving the modulus result of the division operator
	beq $t7, $zero, notprime	# if modulus result is zero, display notprime result
	bne $t7, $zero, add_two		# if modulus result is NOT zero, jump to add_two label
	
add_two:
	addi $t6, $t6, 2		# if modulus result is NOT zero, increment counter by 2 
	j if_inside_for			# jump back to if_inside_for loop
	
extra_credit:	

	
			
	
	

	
	
	

	
		
		    		




