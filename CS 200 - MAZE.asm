# Sources
# http://stackoverflow.com/questions/27074044/mips-assembly-arrays
# 
# CONSTANTS:
#
# #define GRID_WIDTH 79			
# #define GRID_HEIGHT 23
# #define NORTH 0
# #define EAST 1
# #define SOUTH 2
# #define WEST 3
#==============================================================================
	.data
GRID_WIDTH:	.word	80		# need to add 1 to print as string
GRID_HEIGHT:	.word	23
GRID_SIZE:	.word	1840		# because I can't precalculate it in
					# MIPS like I could in MASM
NORTH:		.word	0
EAST:		.word   1
SOUTH:		.word	2
WEST:		.word	3
RGEN:		.word	1073807359	# a sufficiently large prime for rand
POUND:		.byte	35		# the '#' character
SPACE:		.byte	32		# the ' ' character
NEWLINE:	.byte	10		# the newline character
x_:		.byte	0		#save the x position
y_:		.byte	0		#save the y position

#==============================================================================
# STRING VARIABLES
#
# Think of them as string constants for prompts and such
#==============================================================================

rsdPrompt:	.asciiz "Enter a seed number (1073741824 - 2147483646): "
smErr1:		.asciiz "That number is too small, try again: "
bgErr:		.asciiz "That number is too large, try again: "
newLine:	.asciiz "\n"

#==============================================================================
# GLOBAL VARIABLES
#
# char grid[GRID_WIDTH*GRID_HEIGHT];
#==============================================================================

grid:	.space	1841		# ((79 + 1) * 23) + 1 bytes reserved for grid
rSeed:	.word	0		# a seed for generating a random number

#==============================================================================
# FUNCTION PROTOTYPES:
#==============================================================================
# Only listed here because it is not necessary to forward-declare in assembly
# void ResetGrid();
# int XYToIndex( int x, int y );
# int IsInBounds( int x, int y );
# void Visit( int x, int y );
# void PrintGrid();
# int srand();                  # adding function to get random seed from user
# int rand(int min, int max);	# adding function to get a random from a range

#==============================================================================
# FUNCTIONS:
#==============================================================================
	.text
	.globl main
#==============================================================================
# int main()
# {
#   // Starting point and top-level control.
#   srand( time(0) ); // seed random number generator.
#   ResetGrid();
#   Visit(1,1);
#   PrintGrid();
#   return 0;
# }
#==============================================================================
main:
	sw	$ra, 0($sp)	# save the return address
	jal	srand		# get a random seed
	jal	ResetGrid	# reset the grid to '#'s
	li	$t0, 1		# set up for start of generation at (1,1)
	sb	$t0, x_		# push first param
	sb	$t0, y_	 	# push second param
	#Visit(1,1)
	jal	Visit		# start the recursive generation
	
	jal	PrintGrid	# display the grid
	lw	$ra, 0($sp)	# restore the return address
	li	 $v0, 10	# exit the program
	syscall
	
#==============================================================================
# void ResetGrid()
# {
#   // Fills the grid with walls ('#' characters).
#   for (int i=0; i<GRID_WIDTH*GRID_HEIGHT; ++i)
#   {
#     grid[i] = '#';
#   }
# }
#==============================================================================
ResetGrid:
	# It's a waste do do a stack frame when there are no parameters or
	# return values, so I'll optimize and simply push any register I use
	# onto the stack.  I need 7, a loop counter, a place to store the
	# loop bound for comparison, the base address of the grid, a register
	# to store the character value I will write, a register to store the
	# width of the grid, a register to store the newline character, and
	# finally, a register to hold calculation results.
	
	# save the registers
	sw	$s0, -4($sp)	# $s0 will be the loop counter #RESETGRID
	sw	$s1, -8($sp)	# $s1 will hold the array bound
	sw	$s2, -12($sp)	# $s2 will be the grid base address
	sw	$s3, -16($sp)	# $s3 will hold the character
	sw	$s4, -20($sp)	# $s4 will hold the grid width
	sw      $s5, -24($sp)   # $s5 will hold the newline character
	sw	$s6, -28($sp)	# $s6 used for calculations
	# NOTICE THAT I DON'T BOTHER MOVING THE STACK POINTER
	
	# load the working values
	li	$s0, 1		# initialize the counter
	lw	$s1, GRID_SIZE	# initialize the array bound
	la	$s2, grid	# get the base address
	lb	$s3, POUND	# store the '#' ASCII code
	lw	$s4, GRID_WIDTH # store the grid width
	lb	$s5, NEWLINE	# store the newline ASCII code
  
ResetLoop:
	sb	$s3, 0($s2)	# put a '#' in the grid #RESETLOOP
	addi	$s0, $s0, 1	# increment the loop counter
	addi	$s2, $s2, 1	# point at next char position
	div	$s0, $s4	# divide the counter by grid width
	mfhi	$s6		# get remainder in calculation register
	bnez	$s6, NoNewLine	# keep going
	
	sb	$s5, 0($s2)     # put a newline in the grid
	addi	$s0, $s0, 1	# increment the loop counter
	addi	$s2, $s2, 1	# point at next char position
	
NoNewLine:
	blt	$s0, $s1, ResetLoop	# if less than end, loop again #NONEWLINE
	
	# when we fall out of the loop, restore the registers and return
	lw	$s0, -4($sp)	
	lw	$s1, -8($sp)	
	lw	$s2, -12($sp)	
	lw	$s3, -16($sp)	
	lw	$s4, -20($sp)	
	lw      $s5, -24($sp)   
	lw	$s6, -28($sp)
	# IN A LANGUAGE WITH PUSH/POP, YOU WOULD HAVE TO POP THEM
	# FROM THE STACK IN THE REVERSE ORDER YOU PUSHED THEM.
	
	jr	$ra	# exit the program
	
#===============================================================================

Grid:
	# It's a waste do do a stack frame when there are no parameters or
	# return values, so I'll optimize and simply push any register I use
	# onto the stack.  I need 7, a loop counter, a place to store the
	# loop bound for comparison, the base address of the grid, a register
	# to store the character value I will write, a register to store the
	# width of the grid, a register to store the newline character, and
	# finally, a register to hold calculation results.
	
	# save the registers
	sw	$s0, -4($sp)	# $s0 will be the loop counter #RESETGRID
	sw	$s1, -8($sp)	# $s1 will hold the array bound
	sw	$s2, -12($sp)	# $s2 will be the grid base address
	sw	$s3, -16($sp)	# $s3 will hold the character
	sw	$s4, -20($sp)	# $s4 will hold the grid width
	sw      $s5, -24($sp)   # $s5 will hold the newline character
	sw	$s6, -28($sp)	# $s6 used for calculations
	# NOTICE THAT I DON'T BOTHER MOVING THE STACK POINTER
	
	# load the working values
	la	$s2, grid	# get the base address
	lb	$s3, SPACE	# store the ' ' ASCII code
  
	sw	$s0, -4($sp)	# pull result from XYToIndex and putit into the $s2
	sb	$s3, 0($s0)	# put a ' ' in the grid #RESETLOOP
	
	# when we fall out of the loop, restore the registers and return
	lw	$s0, -4($sp)	
	lw	$s1, -8($sp)	
	lw	$s2, -12($sp)	
	lw	$s3, -16($sp)	
	lw	$s4, -20($sp)	
	lw      $s5, -24($sp)   
	lw	$s6, -28($sp)
	# IN A LANGUAGE WITH PUSH/POP, YOU WOULD HAVE TO POP THEM
	# FROM THE STACK IN THE REVERSE ORDER YOU PUSHED THEM.
	
	jr	$ra	# exit the program
	
		
			
				
					
						
							
								
									
										
											
												
													
														
															
																	
#==============================================================================
# srand()
# 
# Unlike the C++ equivalent, this routine has to ask the user for a seed,
# because we don't have access to a time string. So I borrowed code from a
# linear congruence project to prompt for a large integer and save it as a
# seed for another function that does linear congruence.
#==============================================================================
srand:
	# For this function, we only need to preserve 3 registers.  We use
	# $a0 and $v0 for I/0, and we use $s0 as a scratch register.

	# save the registers
	sw	$v0, -4($sp)	# $v0 will be the service code #SRAND
	sw	$a0, -8($sp)	# $a0 will point to the grid string
	sw	$s0, -12($sp)	# $s0 will hold the input for testing
	
	# prompt for a random seed and get the value
	la	$a0, rsdPrompt
	li	$v0, 4		# print_string
	syscall

input10:
	li	$v0, 5		# read_int INPUT10
	syscall
	li	$s0, 1073741823		# put 2147483646 in t0 for comparison
	bgtu	$v0, $s0, input11	# input bigger than 1073741823?
	la	$a0, smErr1	# no, point to error and
	li	$v0, 4		# print_string
	syscall
	j	input10		# try again

input11:
	li	$s0, 2147483646	# upper bound in register t0 for comparison #INPUT11
	bleu	$v0, $s0, input12	# less than or equal 2147483646?
	la	$a0, bgErr	# no, point to error and
	li	$v0, 4		# print_string
	syscall
	j	input10		# try again

input12:	
	# number is good, save and move on 
	sw	$v0, rSeed #INPUT12
	
	# restore the registers
	lw	$v0, -4($sp)	
	lw	$a0, -8($sp)	
	lw	$s0, -12($sp)

	jr 	$ra		# exit the program

#==============================================================================
# rand(int min, int max)
# 
# This code is stolen from the linear congruence project (relax, I wrote it).
# It uses the rSeed and RGEN values to create a new psuedo-random and a new 
# seed for the next time this routine is called.  It range-fits the psuedo-
# random to the range min-max and returns it.  It does not need to formalize a
# stack frame since it doesn't call any other routines, so we simply set the
# two params and the return into the stack before calling and it begins pushing
# registers onto the stack above -12($sp).  Min is expected to be at -8($sp)
# and max is expected at -12($sp) while the return is at -4($sp).
#==============================================================================
rand:
	# For this function, we only need to preserve 3 registers.  We use
	# $s0 - $s2 as scratch registers.

	# save the registers
	sw	$s0, -16($sp)	# $s0 random #RAND
	sw	$s1, -20($sp)	# $s1 will hold generator and min
	sw	$s2, -24($sp)	# $s2 will hold new seed and max
	
	# linear congruence
	lw	$s1, RGEN	# load the generator
	lw	$s2, rSeed	# last seed
	multu	$s1, $s2	# result goes in hi/lo registers
	mflo	$s2		# lo result is new seed
	mfhi	$s0		# hi result is new random
	sw	$s2, rSeed	# store the seed in memory

	# fit the random into the range
	lw	$s2, -12($sp)	# get the max
	lw	$s1, -8($sp)    # get the min
	sub	$s2, $s2, $s1	# s2 is now range (max - min)
	addiu	$s2, $s2, 1	# increment the range
	divu	$s0, $s2	# remainder is in hi register
	mfhi	$s0		# get it back
	addu	$s0, $s0, $s1	# add the minimum to put it in range
	sw	$s0, -4($sp)	# store the random in the return

	# restore the registers
	lw	$s0, -16($sp)	
	lw	$s1, -20($sp)	
	lw	$s2, -24($sp)

	jr	$ra		# exit the program

#==============================================================================
# int XYToIndex( int x, int y )
# {
#   // Converts the two-dimensional index pair (x,y) into a
#   // single-dimensional index. The result is y * ROW_WIDTH + x.
#   return y * GRID_WIDTH + x;
# }
#
# Like rand, this uses the stack only for getting and returning values.  
# -4($sp) is the return, -8($sp) is x, and -12($sp) is y.
#==============================================================================
XYToIndex:
	# For this function, we only need to preserve 3 registers.  We use
	# $s0 - $s2 as scratch registers.
	
	# save the registers
	sw	$s0, -16($sp)	# $s0 will hold grid width #XYTOIND
	sw	$s1, -20($sp)	# $s1 will hold x
	sw	$s2, -24($sp)	# $s2 will hold y
  
  	# get the values for our calculation
  	lw	$s0, GRID_WIDTH	# load the grid width

  	lb	$s1, x_		# load x
  	lb	$s2, y_		# load y
  	
  	# calculate and store in return
  	multu	$s0, $s2	# result goes in hi/lo registers
  	mflo	$s0		# hopefully only need LO
  	addu	$s0, $s0, $s1	# add x
  	sw	$s0, -4($sp)	# store result in return
  	# we will want to utilize the number that is placed in this SP
  	# it will allow us to put the ' ' in the right place.

  	# restore the registers
	lw	$s0, -16($sp)	
	lw	$s1, -20($sp)	
	lw	$s2, -24($sp)

	jr	$ra	# exit the program
	

#================================================================================
# int IsInBounds( int x, int y )
# {
#   // Returns "true" if x and y are both in-bounds.
#   if (x < 0 || x >= GRID_WIDTH) return false;
#   if (y < 0 || y >= GRID_HEIGHT) return false;
#   return true;
# }
#
# Like rand, this uses the stack only for getting and returning values.  -4($sp)
# is the return, -8($sp) is x, and -12($sp) is y.  Note that because we use a
# width that has an extra character, our first test is actually:
# 	if (x < 0 || x > GRID_WIDTH) return false;
#================================================================================
IsInBounds:
	# For this function, we only need to preserve 3 registers.  We use
	# $s0 - $s2 as scratch registers.
	
	# save the registers
	sw	$s0, -16($sp)	# $s0 will hold bounds for testing and return #ISINBOUNDS
	sw	$s1, -20($sp)	# $s1 will hold x
	sw	$s2, -24($sp)	# $s2 will hold y
  
  	# get the values for our calculation
  	lw	$s1, x_		# load x
  	lw	$s2, y_		# load y
  	
  	# test width
  	lw	$s0, GRID_WIDTH		# load the grid width
  	bgtu	$s1, $s0, OutOfBounds	# catches both >= grid width and < 0
  	
  	# test height
  	lw	$s0, GRID_HEIGHT	# load the grid height
  	bgeu	$s2, $s0, OutOfBounds	# catches both >= grid height and < 0
  	
  	li	$s0, 1		# neither failed, so set true (1)
  	sw	$s0, -4($sp)
  	j	EndBounds
  	
OutOfBounds:
	li	$s0, 0		# something failed, so set false (0) #OUTOFBOUNDS
	sw	$s0, -4($sp)

EndBounds:
  	# restore the registers
	lw	$s0, -16($sp)	#ENDOFBOUNDS
	lw	$s1, -20($sp)	
	lw	$s2, -24($sp)

	jr	$ra	# exit the program
	
#==============================================================================

Visit:
	# first, save the old frame pointer and return address on the stack
	# and point the frame pointer to the bottom of the frame
	sw 	$fp, -12($sp) # save the old frame pointer
	sw 	$ra, -16($sp) # save the return address
	move	$fp, $sp # copy the stack pointer to the frame pointer
	# now we can save any registers we need.
	sw	$s0, -20($sp)	# $s0 will be the loop counter #RESETGRID
	sw	$s1, -24($sp)	# $s1 will hold the array bound
	sw	$s2, -28($sp)	# $s2 will be the grid base address
##	sw	$s3, -32($sp)	# $s3 will hold the character
##	sw	$s4, -36($sp)	# $s4 will hold the grid width
##	sw      $s5, -40($sp)   # $s5 will hold the newline character
##	sw	$s6, -44($sp)	# $s6 used for calculations


	# and make space for any local variables
	#addiu	$sp, $sp, -32 # space for 3 words (32 – 20 = 12 bytes)
	 # and finally we can grab the input parameters
	jal	XYToIndex
	jal	Grid
	## we need to get a number from XYToIndex.
	##We'll pass it into Grid to get position in grid.
	# when done restore the registers
	lw	$s0, -20($sp) # put old $s0 back
	# restore the stack pointer, frame pointer, and return address
	move 	$sp, $fp # point to the beginning of the stack frame
	lw 	$fp, -12($sp) # restore the old frame pointer
	lw 	$ra, -16($sp) # restore the return address
	jr 	$ra # and return

#==============================================================================
# void PrintGrid()
# {
#   // Displays the finished maze to the screen.
#   for (int y=0; y<GRID_HEIGHT; ++y)
#   {
#     for (int x=0; x<GRID_WIDTH; ++x)
#     {
#       cout << grid[XYToIndex(x,y)];
#     }
#     cout << endl;
#   }
# }
#==============================================================================
PrintGrid:

	# This is even easier than the C++ code because I've set the grid up as 
	# one long string so I can simply use a system service to print it to 
	# the console. Doing character by character printing in MASM was more 
	# complicated. We need to preserve 2 registers, $v0 and $a0 used for
	# this system service.

	# save the registers
	sw	$v0, -4($sp)	# $v0 will be the service code #PRINTGRID
	sw	$a0, -8($sp)	# $a0 will point to the grid string
	
	# load the values and print
	li	$v0, 4		# print service
	la	$a0, grid	# string to print
	syscall

	# restore the registers
	lw	$v0, -4($sp)	
	lw	$a0, -8($sp)	

	jr	$ra	# exit the program
