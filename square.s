#PURPOSE: return square of a given number

.section .data

.section .text

.globl _start

_start:
    pushl $6 # push the only argument
    call square # call function
    addl $4, %esp # restore the stack pos

    movl $36, %ecx
    pushl %eax # push second argument (actual)
    pushl %ecx # push first argument (expected)
    call test_square
    addl $8, %esp

    movl %eax, %ebx # copy the result

    movl $1, %eax # exit
    int $0x80

.type square,@function
square:
    pushl %ebp # keep track of old base pointer
    movl %esp, %ebp # copy stack pointer to base pointer
    movl 8(%ebp), %eax # get the parameter
    imull %eax, %eax # multiply with itself

    movl %ebp, %esp # return procedure
    popl %ebp
    ret

.type test_square,@function
test_square:
    pushl %ebp # keep track of old base pointer
    movl %esp, %ebp # copy stack pointer to base pointer
    movl 8(%ebp), %eax # get first argument (expected)
    movl 12(%ebp), %ebx # get second argument (actual)

    cmpl %eax, %ebx
    jg test_square_not_equal
    jl test_square_not_equal

    # if the test equal
    movl $1, %eax # 1 if success
    movl %ebp, %esp # return procedure
    popl %ebp
    ret

test_square_not_equal:
    movl $0, %eax # 0 if failed
    movl %ebp, %esp # return procedure
    popl %ebp
    ret
