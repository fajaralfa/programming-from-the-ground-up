#PURPOSE: program that return the factorial of a value

.section .data

.section .text

.globl _start
_start:
    pushl $5 # push first argument
    call factorial # call factorial func
    addl $4, %esp # move stack pointer back to where it is
    movl %eax, %ebx # store return value %eax to %ebx

    movl $1, %eax # exit system call
    int $0x80

.type factorial,@function
factorial:
    pushl %ebp # push old base pointer
    movl %esp, %ebp # make copy of sp on bp
    movl 8(%ebp), %eax # copy first argument to %eax (hold current result of factorial)

factorial_loop:
    cmpl $1, 8(%ebp)
    je end_factorial

    decl 8(%ebp)
    imull 8(%ebp), %eax
    jmp factorial_loop

end_factorial:
    movl %ebp, %esp
    popl %ebp
    ret
