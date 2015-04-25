#(*Not successful)


	.data
Result:		.asciiz "Your sorted list is: "
my_list:	.byte 6, 5, 4, 3, 2
NewLine:	.asciiz "\n"
	.text

#LEGEND
	# t0 is my_list
	# t1 is lst[i]
	# t2 is lst[i+1]
	# t3 is hold
	# t4 is while_loop
		# while not sorted
		# while not 1
			# $t4 = 0
	# t5 is for_loop
	# t6 is results
	# t7 is pointer
	# t8 is my_list temp
	# t9 is temp
	# 1 is true
	# 0 is false
		#your code here

main:	
la $t0, my_list									#load the array
la $t8, my_list 								#load the temporary
li $t4, 0									#Assume True
beq $t4, 0, while_loop								#go back to the while loop
while_loop:
	li $t5, 0								#set t5 to 0
	add $t9, $t9, 1
	for_loop:
		add $t5, $t5, 1							#add t5 (your incrementor)
		lb $t1, 0($t0)							#loading first element into address t1
		lb $t2, 1($t0)							#loading secon element into address t2
		bgt $t1, $t2, if_statement					#goto if statement if t1>t2
		addi $t0, $t0, 1						#add t0 (Array incrementor)
		blt $t1, $t2, for_loop		
		if_statement:
		
			li $t4, 0 						#make while loop false			
			move $t3, $t2					 	#start swapping data (Refer to legend)
			move $t2, $t1
			move $t1, $t3
			sb $t1, 0($t0)						#store the first byte
			sb $t2, 1($t0)						#store the secon byte
			addi $t0, $t0, 1					#add t0 (Array incrementor)
	blt $t5, 4, for_loop							#go back to for loop if t5 < 5 (size of array)
	add $t0,$t8,$zero							#reset the array, so we can start with the 1st num
	beq $t4, 0, while_loop							#go back to the while loop
beq $t4, 1, print_fun

print_fun:		
la	$a0, Result		# load address of string to be printed into $a0
li	$v0, 4			# load appropriate system call code into register $v0;
				# code for printing integer is 1 
syscall				# print the string



.data
space:		.asciiz " "

.text

li 	$t5, 5
la	$t0, my_list		#load address "my_list" into t0
for_loop2:			#to print out whole line.
	lb	 $t7, 0($t0)		#add data to t7 from pointer 0
	move 	 $a0, $t7		#move t7 into a0
	li	 $v0, 1			#load for print
	syscall				#syscall
	la	 $a0, space		#load address
	li 	 $v0, 4			#print a string
	syscall
	addi	 $t0, $t0, 1		#increment up 1
add	 $t5, $t5, -1			#decrement	
bgt	 $t5, 0, for_loop2		#branch if t5 > 0

	
li	 $v0, 10	#call to exit
syscall			#syscall

