.section .data
teks:
    .ascii "hey diddle diddle!"

.section .bss

.equ BUFFER_DATA_LENGTH, 20
.lcomm BUFFER_DATA, BUFFER_DATA_LENGTH

.section .text

