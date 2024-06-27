#PRINT HELLO WORLD

.section .data

teks:
    .ascii "Hello World\n"

.section .text

.globl _start

_start:
    movl $1, %ebx
    movl $teks, %ecx
    movl $12, %edx
    movl $4, %eax
    int $0x80
    movl $1, %ebx
    movl $teks, %ecx
    movl $12, %edx
    movl $4, %eax
    int $0x80
    movl $1, %eax
    int $0x80
