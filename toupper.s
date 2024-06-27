#PURPOSE: convert an input file to output with uppercased letter

# 1) open input file
# 2) open output file
# 3) while not at the end of he input file
#   a) read part of file into buffer
#   b) go through each byte
#           if byte is a lower-case letter, convert it
#   c) write the buffer to output

.section .data

# CONSTANTS

# syscall
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# options for open
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

# standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# linux system call interrupt
.equ LINUX_SYSCALL, 0x80
.equ END_OF_FILE, 0
.equ NUMBER_ARGUMENTS, 2


.section .bss

# BUFFER
.equ BUFFER_SIZE, 200
.lcomm BUFFER_DATA, BUFFER_SIZE
.equ FD_DATA_SIZE, 8
.lcomm FD_DATA, FD_DATA_SIZE

.section .text

#STACK POSITIONS
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4 # descriptor input file 
.equ ST_FD_OUT, -8 # descriptor output file 
.equ ST_ARGC, 0 # this thing is not used
.equ ST_ARGV_0, 4 # program name
.equ ST_ARGV_1, 8 # input file
.equ ST_ARGV_2, 12 # output file

.globl _start
_start:
    movl %esp, %ebp
    subl $ST_SIZE_RESERVE, %esp # make room for another stack storage
    
# CATATAN: fd = file descriptor
open_files:
#open_fd_in:
#    movl $SYS_OPEN, %eax
#    movl ST_ARGV_1(%ebp), %ebx 
#    movl $O_RDONLY, %ecx
#    int $LINUX_SYSCALL

store_fd_in:
    movl $0, %edi
    movl $STDIN, FD_DATA(,%edi,4)
    movl $1, %edi
    movl $STDOUT, FD_DATA(,%edi,8)

#open_fd_out:
#    movl $SYS_OPEN, %eax
#    movl ST_ARGV_2(%ebp), %ebx
#    movl $O_CREAT_WRONLY_TRUNC, %ecx
#    movl $0666, %edx
#    int $LINUX_SYSCALL

store_fd_out:

read_loop_begin:
    movl $SYS_READ, %eax # system call number to read file
    movl FD_DATA(,%edi,4), %ebx # copy the file descriptor
    movl $BUFFER_DATA, %ecx # buffer address
    movl $BUFFER_SIZE, %edx # buffer size
    int $LINUX_SYSCALL # system call

    cmpl $END_OF_FILE, %eax
    jle end_loop

continue_read_loop:
    pushl $BUFFER_DATA
    pushl %eax
    call convert_to_upper
    popl %eax
    addl $4, %esp
    movl %eax, %edx
    movl $SYS_WRITE, %eax
    movl FD_DATA(,%edi,8), %ebx
    movl $BUFFER_DATA, %ecx
    int $LINUX_SYSCALL
    jmp read_loop_begin

end_loop:
    #movl $SYS_CLOSE, %eax
    #movl ST_FD_OUT(%ebp), %ebx
    #int $LINUX_SYSCALL
    #movl $SYS_CLOSE, %eax
    #movl ST_FD_IN(%ebp), %ebx
    #int $LINUX_SYSCALL

    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL

.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'
.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

.type convert_to_upper,@function

convert_to_upper:
    pushl %ebp # standard function thing
    movl %esp, %ebp

    movl ST_BUFFER(%ebp), %eax
    movl ST_BUFFER_LEN(%ebp), %ebx
    movl $0, %edi
    cmpl $0, %ebx
    je end_convert_loop

convert_loop:
    movb (%eax,%edi,1), %cl

    cmpb $LOWERCASE_A, %cl
    jl next_byte
    cmpb $LOWERCASE_Z, %cl
    jg next_byte

    addb $UPPER_CONVERSION, %cl
    movb %cl, (%eax,%edi,1)

next_byte:
    incl %edi
    cmpl %edi, %ebx
    jne convert_loop

end_convert_loop:
    movl %ebp, %esp
    popl %ebp
    ret
