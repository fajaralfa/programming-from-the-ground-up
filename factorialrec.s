# PURPOSE: get factorial of a given number using recursive function

.section .data

.section .text

.globl _start
_start:
    pushl $5 # push first argument
    call factorial # call factorial func
    addl $4, %esp # move stack pointer back to where it is
    movl %eax, %ebx
    movl $1, %eax # exit system call
    int $0x80

.type factorial,@function
factorial:
    pushl %ebp # push old base pointer
    movl %esp, %ebp # make copy of sp on bp
    movl 8(%ebp), %eax # copy first argument to %eax 
    cmpl $1, %eax
    je end_factorial
    decl %eax
    pushl %eax
    call factorial
    movl 8(%ebp), %ebx
    imull %ebx, %eax # multiply the current param with return value

end_factorial:
    movl %ebp, %esp # standard return procedure
    popl %ebp
    ret

