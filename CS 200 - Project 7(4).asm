	.data
initVal: 	.word 0 #for first math problem
rand:		.word 0 #for second math problem
low_val: 	.word 0
hi_val: 	.word 0
amt_nums: 	.word 0

#=========== The Prompts =============#
Prompt1: 	.asciiz "Seed Value: "
Prompt2: 	.asciiz "Low val: "
Prompt3: 	.asciiz "Hi  val: "
Prompt4: 	.asciiz "Amount of Numbers to display:"
Result: 	.asciiz "\nYour Result: "


	.text
main:

#==========================================================================#
	#get all the variables into their proper addresses
	li	$v0, 4		# print_string
	la	$a0, Prompt1	#Seed Value
	syscall
	li 	$v0, 5		#syscall to read an int
	syscall
	sw 	$v0, initVal	# Store a word
	
#==========================================================================#
	li	$v0, 4		# print_string
	la	$a0, Prompt2	#low num in address t1
	syscall
	li 	$v0, 5		#syscall to read an int
	syscall
	sw	$v0, low_val

#==========================================================================#
	li	$v0, 4		# print_string
	la	$a0, Prompt3	#high num in address t1
	syscall
	li 	$v0, 5		#syscall to read an int
	syscall
	sw	$v0, hi_val
	
#==========================================================================#
	li	$v0, 4		# print_string
	la	$a0, Prompt4	#amt of nums in address t1
	syscall
	li 	$v0, 5		#syscall to read an int
	syscall
	sw	$v0, amt_nums

#==========================================================================#

				#very carefully figuring out what each
				#register is, so as to not overwrite one	
					#$t0 for initVal
					#$t1 for rand
					#$t2 for hi_val
					#$t3 for low_val
					#$t4 for m_val
					#$t5 for incrementer					
					#$t6 for amt_nums
					#$t7 for temp use	**
#begin loop
lw $t6, amt_nums	#for i in range($t6:$t5)
li $t5, 0		#the incrementer

load:
	#loading all the data into their respective registers
		lw 	$t0, initVal	# load initVal into $t0
		lw 	$t3, low_val
		lw 	$t2, hi_val
		move	$t1, $t0	# $t1 = $t0; make rand and initVal the same
math:
			sub	$t4,$t2,$t3		#t4 = t2 - t3 ; m_val

	#mathy stuff! woop woop!
	#    math1
	#    t1 = (t2*t1 + t3) % t4

		mult	$t2, $t1
		mflo	$t7
		add 	$t7, $t7, $t3
		div 	$t7, $t4
		mflo	$t1
	#    math2
	#    initVal1 = (rand % (hi_val - low_val + 1)) + low_val
	#    t0 = (t1 % (t2 - t3 + 1)) + t3

		sub 	$t0, $t2, $t3	#t0 = (t1 % (t0 + 1)) + t3
		add 	$t0, $t0, 1	#t0 = (t1 % (t0)) + t3
		div 	$t1, $t0	#t0 = (t0) + t3
		mfhi	$t0		#t0 result
		add 	$t0, $t0, $t3	#t0 = (t0) + t3

printing:
	#time to print some stuff.
		la	$a0, Result		# load address of string to be printed into $a0
		li	$v0, 4			# load appropriate system call code into register $v0;
						# code for printing integer is 1 
		syscall				# print the string
		move	$a0, $t0		# move integer to be printed into $a0:  $a0 = $t4
		li 	$v0, 1			# print the integer
		syscall
	


#end for loop
	# increment up one.
add 	$t5, $t5, 1	# $t5 += 1; or $t5 = $t5 + 1
blt 	$t5, $t6, math	#if  $t5 < t6 goto math



		li $v0, 10    #syscall to exit
	        syscall
