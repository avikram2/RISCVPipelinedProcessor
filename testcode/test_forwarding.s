.align 4
.section .text
.globl _start
_start:
    lw x1, ONE
    lw x2, TWO
    add x3, x1, x2
    add x4, x3, x3

    DONEb:
        beq x0, x0, DONEb

.section .rodata
ONE:    .word 0x00000001
TWO:    .word 0x00000002