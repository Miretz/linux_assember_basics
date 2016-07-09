# PURPOSE: Program to illustrate how functions work.
#          This Program will compute the value of
#          2^3 + 5^2
#

# Everything in the main program is stored in registers,
# so the data section doesn't have anything.

# NOTE!!! this is 32-bit assembly
# To compile and run on a 64-bit machine use the following commands:
# 
# as power.s -o power.o --32
# ld power.o -o power -melf_i386
# ./power
# echo $?

 .section .data

 .section .text

 .globl _start
_start:
 pushl $3          # push the second argument
 pushl $2          # push the first argument
 call  power       # call the function
 addl  $8, %esp    # move the stack pointer back

 pushl %eax        # save the first answer before
                   # calling the next function
 
 pushl $2          # push the second argument
 pushl $5          # push the first argument
 call  power       # call the function
 addl  $8, %esp    # move the stack pointer back
 
 popl  %ebx        # the second answer is already in %eax
                   # we saved the first answer onto the stack
                   # now we can just pop it out into %ebx
 
 addl  %eax, %ebx  # add them together
                   # the result is in %ebx
 mov   $1, %eax    # exit (%ebx is returned)
 int   $0x80

# PURPOSE: This function is used to compute the value of a number
#          raised to a power.
#
# INPUT:   First Argument - the base number
#          Second Argument - the power to raise it to
#
# OUTPUT:  Will give the result as a return value
# 
# NOTES:   The power must be 1 or greater
#
# VARIABLES: 
#          %ebx - holds the base number
#          %ecx - holds the power
#          -4(%ebp) - holds the current result
#          %eax is used for temporary storage
#

 .type power, @function
power:
 pushl %ebp             # save old base pointer
 movl  %esp, %ebp       # make stack pointer the base pointer
 subl  $4, %esp         # get room for local storage
 movl  8(%ebp), %ebx    # put first argument in %ebx
 movl  12(%ebp), %ecx   # put second argument in %ecx
 movl  %ebx, -4(%ebp)   # store current result
 
power_loop_start:
 cmpl  $1, %ecx         # if the power is 1, we are done 
 je    end_power        
 movl  -4(%ebp), %eax   # move the current result into %eax
 imull %ebx, %eax       # multiply result by the base number
 movl  %eax, -4(%ebp)   # store the current result
 decl  %ecx             # decrease the power
 jmp   power_loop_start # run for the next power

end_power:
 movl -4(%ebp), %eax    # move return value to %eax
 movl %ebp, %esp        # restore the stack pointer
 popl %ebp              # restore the base pointer
 ret













 
