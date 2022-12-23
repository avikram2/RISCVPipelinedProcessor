.align 4
.section .text
.globl _start

_start:

    la x8, ZERO
    addi x1, x1, 12
    nop
    nop
    nop

    addi x1, x1, -5
    nop
    nop
    nop

    addi x1, x1, 0
    nop
    nop
    nop

    sw x1, aacus, x15

    andi x2, x8, 0x00000F
    nop
    nop
    nop

    sw x2, joiner, x15
    nop
    nop
    nop

    lw x3, DEEB
    nop
    nop
    nop
    lw x4, LEAF
    nop
    nop
    nop
    lw x5, D22D
    nop
    nop
    nop
    lw x6, LIFE
    nop
    nop
    nop

    add x3, x3, x4
    nop
    nop
    nop

    add x3, x3, x3
    nop
    nop
    nop

    sw x3, calcx, x15

    and x4, x5, x3
    nop
    nop
    nop

    sw x4, joiner, x15

    not x5, x5
    nop
    nop
    nop

    sw x5, duh, x15

    lw x6, FOED
    nop
    nop
    nop

    lw x7, FOED
    nop
    nop
    nop

    slli x6, x6, 8
    nop
    nop
    nop

    srli x7, x7, 3
    nop
    nop
    nop

    srai x6, x6, 6
    nop
    nop
    nop

    sw x6, fivespd, x15
    nop
    nop
    nop

    sw x7, fivespd, x15
    nop
    nop
    nop

    lw x1, ZERO
    lw x2, ZERO
    lw x3, D22D
    lw x4, LIFE
    lw x5, FOED
    lw x6, DEEB
    lw x7, LEAF

    lw x1, BOMB
    nop
    nop
    nop

    la x2, HOWHIGH
    nop
    nop
    nop
    jalr x0, x2, 0

    nop
    nop
    nop

    lw x1, GOOF
    nop
    nop
    nop

HOWHIGH:
    sw x1, dunk, x15
    nop
    nop
    nop

    lw x2, DEEB
    nop
    nop
    nop

    sw x2, SPOT1, x15
    lw x3, FOED
    lw x4, LEAF
    nop
    nop
    nop
    sw x3, SPOT2, x15
    sw x4, SPOT3, x15
    lw x5, GOOD
    nop
    nop
    nop
    sw x5, SPOT4, x15
    nop
    nop
    nop

    lw x5, SPOT1
    lw x4, SPOT2
    lw x3, SPOT3
    lw x2, SPOT4
    sw x5, SPOT4, x15
    sw x4, SPOT4, x15
    sw x3, SPOT4, x15
    sw x2, SPOT4, x15
    nop
    nop
    nop
    add x2, x2, x3
    nop
    nop
    nop
    add x3, x4, x5
    nop
    nop
    nop
    add x2, x2, x3
    nop
    nop
    nop

    addi x3, x8,1
    nop
    nop
    nop

    la x16, ZOOP
    sb x6, 1(x16)
    lw x4, ZOOP

    sb x7, BEAD, x15
    lw x3, BEAD
    nop
    nop
    nop
    sw x3, chew, x15
    sw x4, chew, x15
    add x3, x3, x4

    lw x4, ZERO

    jal x7,  MUDDLE

    sw x4, MUDPIE, x15

    la x5, MUDDLER
    nop
    nop
    nop
    jalr x7, x5, 0

    sw x5, MUDPIE, x15

    addi x6, x8, 1
    nop
    nop
    nop
    la x17, COOKIE
    lb x6, 1(x17)
    nop

    lb x7, COOKIE
    nop
    sw x6, crumb, x15
    nop
    sw x7, crumb, x15
    nop
    nop
    nop
    add x6, x6, x7

    jal x7, HOPE

    sw x6, FUN, x15

    lw x1,ZERO
    lw x2,ZERO
    lw x3,ZERO
    lw x4,GOOD
    lw x5,GOOD
    lw x6,GOOD

    lw x1, GAME
    nop
    nop
    nop

    sw x4, RESULT, x15
    nop
    nop
    nop
    lw x2, RESULT

    sw x1, GOOF, x15
    sw x2, GOOF, x15
    nop

    andi x3, x3, 0
    blt x0, x3, DOH
    bgt x0, x3, DOH
    bne x0, x3, DOH
    beq x0, x3, WOOHOO
    bge x0, x3, DOH
    beq x0, x0, DOH

DOH:
    addi x3, x3, 4

WOOHOO:
    addi x3, x3, 6
    andi x4,x4,0
    beq x0, x3, SOFAR
    addi x3, x3, 1

SOFAR:
    addi x3, x3, 6
    andi x4,x4,0

    bne x0, x4, DOH2

    nop
    nop
    nop
    addi x4, x4, 10
    nop
    blt x0, x4, SOGOOD
DOH2:
    addi x3, x3, 6
    beq x0, x0, GetOverHere
SOGOOD:
    addi x3, x3, 3
    nop
    nop
    nop
GetOverHere:
    add x3, x3, x4
    nop
    nop
    nop
    sw x3, GOOF, x15


    sw x1, SPOT1, x15
    sw x2, SPOT2, x15
    sw x3, SPOT3, x15

    la x1, Beg1
END_m:
    jalr x0, x1, 0

.balign 256
ZERO:   .word 0x00000000
ZOOP :  .word 0x0000700F
BEAD :  .word 0xBEADBEAD
FUN :   .word HOPE
DEEB:   .word 0xDEEBDEEB
LEAF:   .word 0x00001EAF
D22D:   .word 0xD22DD22D
LIFE:   .word 0x00000042
FOED:   .word 0xF0EDF0ED
BOMB:   .word 0xB006B006
GOOF:   .word 0x0000600F
dunk:   .word 0xdddddddd
RESULT: .word 0x00000000
GOOD:   .word 0x0000600D
COOKIE: .word 0xD0CAD0CA
FOOB:   .word 0xF00BF00B
aacus:  .word 0xFFFFFFFF

joiner: .word 0x00001010
calcx:  .word 0x00001234
fivespd:.word 0x89218921
duh:    .word 0x99999999
chew:   .word 0xcccccccc
crumb:  .word 0x00006969
GAME:   .word 0xba11ba11

SPOT1:  .word 0x88888888
SPOT2:  .word 0xABCDABCD
SPOT3:  .word 0x00000110
SPOT4:  .word 0xABBAABBA

TEST:   .word GAME
DONE:   .word RESULT
MUDPIE: .word 0x00000000
BLUNDER:    .word Beg1

.balign 256
MUDDLE:
    nop
    nop
    nop
    addi x4, x4,14
    jalr x0, x7, 0

MUDDLER:

    lw x5, LIFE
    jalr x0, x7, 0

HOPE:
    lw x1,GOOD
    lw x2,GOOD
    lw x3,GOOD
    lw x4,GOOD
    lw x5,GOOD
    lw x6,GOOD
    jalr x0, x7, 0







Beg1:
    la x8, BlackHole
    andi x1, x1, 0
    andi x2, x2, 0
    andi x3, x3, 0
    addi x3, x3, 13
    addi x2, x2, 0x0000B





    add x1, x2, x3
    addi x4, x1, 3

    slli x2, x2, 3
    not x5, x3
    andi x3, x2, 15

    nop
    nop
    add x5, x3, x3

    addi x1, x4, 5
    addi x1, x4, 10
    addi x1, x4, 14
    andi x2, x1, -1

    sw x2, BlackHole, x15
    sw x5, BlackHole, x15

    la x10, BlackHole
    addi x10, x10, 4
    sw x2, 0(x10) #exception here PC 0xffffffff8000065c

    lw x3, Photostat
    lw x3, LdThis
    sw x3, Photostat, x15

    lw x3, nosedive
    addi x4, x3, 11

    lw x3, tailspin
    srl x4, x4, 1
    addi x5, x3, 7

    lw x1, quark
    addi x5, x5, 12
    addi x1, x4, 12
    addi x2, x3, 12

    sw x1, beancounter, x15
    sw x2, beancounter, x15
    sw x3, beancounter, x15
    sw x4, beancounter, x15
    sw x5, beancounter, x15

    addi x5, x1, 0
    addi x6, x3, 0
    addi x7, x4, 0

    andi x1, x1, 0
    andi x3, x3, 0
    andi x4, x4, 0
    addi x1, x1, 8
    addi x3, x3, 2
    addi x4, x4, 2

    blt x0, x4, T1
    addi x3, x3, 1
T1:
    addi x1, x1, 9
    bgt x0, x1, T2
    addi x4, x4, 1


    lw x2, SPOT1
    lw x6, SPOT2
    lw x7, SPOT3

    la x8, BlackHole
    andi x3, x3, 0
    andi x4, x4, 0
    nop
    addi x3, x3, 2
    addi x4, x4, 3

T2:
    lw x1, pessimist
    bgt x0, x1, T3
    addi x3, x3, 1
T3:
    lw x1, optimist
    beq x0, x1, T4
    addi x4, x4, 1
T4:
    lw x1, pessimist
    bge x0, x1, T5
    addi x3, x3, 1
T5:
    lw x1, quark
    bge x0, x1, T6
    addi x4, x4, 1
T6:
    andi x1, x8, 0

    la x1, BlackHole
    bne x0, x1, T7
    addi x3, x3, 1

T7:
    sw x3, cc1, x15
    sw x4, cc2, x15

    andi x1, x1, 0
    andi x5, x5, 0

    addi x1, x1, -1
    bgt x0, x1, T10
    addi x5, x5, 1
    addi x1, x1, -7
T10:
    add x5, x1, x5
    nop
    nop
    nop
    sw x5, acorn, x15
    addi x8, x5, 0

    andi x5, x5, 0

    la x1, GetHere
    jalr x0, x1, 0
    addi x5, x5, 1

GetHere:
    add x5, x8, x5
    nop
    nop
    nop
    lw x1, FUN
    la x8, BlackHole
    sw x5, BlackHole, x15

    beq x0, x0, MoneyMoney

.balign 256
BlackHole:  .word 0
WormHole:   .word 0
LdThis:     .word 0xabdaabda
Photostat:  .word 0
nosedive:   .word 0x9A4D9A4D
tailspin:   .word 0x00003DAC
compass:    .word quark
beancounter:    .word 0xfaddfadd
pessimist:  .word 0xFB03FB03
optimist:   .word 0x00000111
gloomy:     .word pessimist
cc1:        .word 0xf00ff00f
cc2:        .word 0xf00ff00f
acorn:      .word 0x00000FEE
quark:      .word 0x0000276C
payout:     .word MoneyMoney

.balign 256
MoneyMoney:

    andi x7, x7, 0
    andi x6, x6, 0
    andi x5, x5, 0
    andi x4, x4, 0
    andi x3, x3, 0
    andi x2, x2, 0
    andi x1, x1, 0
    andi x8, x8, 0


    la x1, M00
    lw x2, Counter2
    lw x3, TWOFIVESIX
FillM1:
    sw x2, 0(x1)
    addi x2, x2, -7
    addi x1, x1, 4
    addi x3, x3, -1
    blt x0, x3, FillM1

    la x4, M00
    lw x2, TWOFIVESIX
    add x4, x2, x4
    lw x3, Counter2
    andi x1, x1, 0
    andi x2, x2, 0

FILLM2:
    jal x7,  CalAddress
    add x6, x5, x4
    sw  x3, 0(x6)
    addi x3, x3, -2
    jal x7,  CalNEXT2
    addi x5, x1, 0
    ble x0, x5, FILLM2

    la x4,  M00
    lw x2, TWOFIVESIX
    add x4, x2, x4
    add x4, x2, x4
    lw x3, Counter2
    andi x1, x1, 0
    andi x2, x2, 0
FILLM3:
    jal x7,  CalAddress
    add x6, x5, x4
    sw  x3, 0(x6)
    addi x3, x3, -5
    jal x7,  CalNEXT3
    addi x5, x1, 0
    ble x0, x5, FILLM3

    la x3, M00
    lw x4, TWOFIVESIX
    add x4, x3, x4
    andi x6, x6, 0

Continue1_2:

    lw x1, X2
    lw x2, Y2
    jal x7,  CalAddress
    add x7, x5, x4
    lw x6, 0(x7)
    jal x7,  CalNEXT3
    sw x1, X2, x15
    sw x2, Y2, x15
    
    lw x1, XX1
    lw x2, Y1
    jal x7,  CalAddress
    add x5, x5, x3
    lw x7, 0(x5)
    add x6, x6, x7
    sw x6, 0(x5)
    
    jal x7,  CalNEXT2
    addi x7, x1, 0
    bgt x0, x7, Done3
    sw x1, XX1, x15
    sw x2, Y1, x15
    
    beq x0, x0, Continue1_2
Done3:

    andi x1, x1, 0
    sw  x1, XX1, x15
    sw x1, X2, x15
    sw  x1, Y1, x15
    sw  x1, Y2, x15
    
    la x3,  M00
    lw x4, TWOFIVESIX
    add x4, x4, x4
    add x4, x3, x4
    andi x6, x6, 0

Continue1_3:

    lw x1, X2
    lw x2, Y2
    jal x7,  CalAddress
    add x7, x5, x3
    lw x6, 0(x7)
    jal x7,  CalNEXT1
    sw x1, X2, x15
    sw x2, Y2, x15
    
    lw x1, XX1
    lw x2, Y1
    jal x7,  CalAddress
    add x5, x5, x4
    lw x7, 0(x5)
    add x6, x6, x7
    sw x6, 0(x5)
    
    jal x7,  CalNEXT3
    addi x7, x1, 0
    bgt x0, x7, Done4
    sw x1, XX1, x15
    sw x2, Y1, x15
    
    beq x0, x0, Continue1_3
Done4:

    beq x0, x0, CHECKSUM

CalNEXT1:

    addi x5, x1, -15
    beq x0, x5, YTEST
    addi x1, x1, 1
    beq x0, x0, SKip

YTEST:
    addi x5, x2, -15
    beq x0, x5, DoneFor
    addi x2, x2, 1
    andi x1, x1, 0
    beq x0, x0, SKip

DoneFor:
    andi x1, x1, 0
    addi x1, x1, -1

SKip:
    jalr x0, x7, 0

CalNEXT2:

    addi x5, x2, -15
    beq x0, x5, XTEST
    addi x2, x2, 1
    beq x0, x0, SKip1

XTEST:
    addi x5, x1, -15
    beq x0, x5, Done1
    addi x1, x1, 1
    andi x2, x2, 0
    beq x0, x0, SKip1

Done1:
    andi x1, x1, 0
    addi x1, x1, -1

SKip1:
    jalr x0, x7, 0

CalNEXT3:

    sw x3, TEMP3, x15
    
    addi x3, x1, -15
    beq x0, x3, DRow
    addi x3, x2, 0
    beq x0, x3, DRow1
    lw x3, NEGONEFIVE
    addi x3, x1, -15
    beq x0, x3, DRow
    
    addi x1, x1, 1
    addi x2, x2, -1
    beq x0, x0, SKIP2

DRow1:
    addi x2, x1, 1
    andi x1, x1, 0
    beq x0, x0, SKIP2

DRow:
    addi x3, x2, -15
    beq x0, x3, Done2

    addi x1, x2, 1
    andi x2, x2, 0
    addi x2, x2, 15
    beq x0, x0, SKIP2

Done2:
    andi x1, x1, 0
    addi x1, x1, -1

SKIP2:
    lw x3, TEMP3
    jalr x0, x7, 0

CalAddress:
    slli x5, x2, 5
    add x5, x1, x5
    slli x5, x5, 2
    jalr x0, x7, 0

CHECKSUM:

    la  x1, M00
    lw x4, TWOFIVESIX
    add x4, x4, x4
    add x1, x4, x1
    andi x7, x7, 0
    andi x6, x6, 0
    andi x5, x5, 0
    andi x4, x4, 0

    lw  x2, ONEFOURTHREE
LoopRowsA:
    lw  x3, 0(x1)
    add x4, x3, x4
    addi x1, x1, 4
    addi x2, x2, -1
    ble x0, x2, LoopRowsA
    
    slli x4,x4,2
    
    lw  x2, ONEFOURTHREE
LoopRowsB:
    lw  x3, 0(x1)
    add x5, x3, x5
    addi x1, x1, 4
    addi x2, x2, -1
    ble x0, x2, LoopRowsB

    slli x5,x5,2
    
    lw  x2, ONEFOURTHREE
LoopRowsC:
    lw  x3, 0(x1)
    add x6, x3, x6
    addi x1, x1, 4
    addi x2, x2, -1
    ble x0, x2, LoopRowsC
    
    slli x6,x6,2
    
    lw  x2, ONEFOURTHREE
LoopRowsD:
    lw  x3, 0(x1)
    add x7, x3, x7
    addi x1, x1, 4
    addi x2, x2, -1
    ble x0, x2, LoopRowsD
    
    and x3, x3,x7
    not x7,x7
    
    
    
    HALT:
    beq x0, x0, HALT


.section .rodata
.balign 256
XX1:             .word    0x00000000
Y1:             .word    0x00000000
X2:             .word    0x00000000
Y2:             .word    0x00000000
TEMP1:          .word    0x00000000
TEMP2:          .word    0x00000000
TEMP3:          .word    0x00000000
TEMP4:          .word    0x00000000
TWOFIVESIX:     .word       256
UpperMemStart:  .word    0xF000F000
Counter1:       .word    0x00000FFF
Counter2:       .word    0x00004A3F
ONEFOURTHREE:   .word        63
NEGONEFIVE:     .word       -15
Mask:           .word    0x000000FF


M00:    .word           0x00000000
M01:    .word           0x00000000
M02:    .word           0x00000000
M03:    .word           0x00000000
M04:    .word           0x00000000
M05:    .word           0x00000000
M06:    .word           0x00000000
M07:    .word           0x00000000
M08:    .word           0x00000000
M09:    .word           0x00000000
M0A:    .word           0x00000000
M0B:    .word           0x00000000
M0C:    .word           0x00000000
M0D:    .word           0x00000000
M0E:    .word           0x00000000
M0F:    .word           0x00000000

M10:    .word           0x00000000
M11:    .word           0x00000000
M12:    .word           0x00000000
M13:    .word           0x00000000
M14:    .word           0x00000000
M15:    .word           0x00000000
M16:    .word           0x00000000
M17:    .word           0x00000000
M18:    .word           0x00000000
M19:    .word           0x00000000
M1A:    .word           0x00000000
M1B:    .word           0x00000000
M1C:    .word           0x00000000
M1D:    .word           0x00000000
M1E:    .word           0x00000000
M1F:    .word           0x00000000

M20:    .word           0x00000000
M21:    .word           0x00000000
M22:    .word           0x00000000
M23:    .word           0x00000000
M24:    .word           0x00000000
M25:    .word           0x00000000
M26:    .word           0x00000000
M27:    .word           0x00000000
M28:    .word           0x00000000
M29:    .word           0x00000000
M2A:    .word           0x00000000
M2B:    .word           0x00000000
M2C:    .word           0x00000000
M2D:    .word           0x00000000
M2E:    .word           0x00000000
M2F:    .word           0x00000000

M30:    .word           0x00000000
M31:    .word           0x00000000
M32:    .word           0x00000000
M33:    .word           0x00000000
M34:    .word           0x00000000
M35:    .word           0x00000000
M36:    .word           0x00000000
M37:    .word           0x00000000
M38:    .word           0x00000000
M39:    .word           0x00000000
M3A:    .word           0x00000000
M3B:    .word           0x00000000
M3C:    .word           0x00000000
M3D:    .word           0x00000000
M3E:    .word           0x00000000
M3F:    .word           0x00000000

M40:    .word           0x00000000
M41:    .word           0x00000000
M42:    .word           0x00000000
M43:    .word           0x00000000
M44:    .word           0x00000000
M45:    .word           0x00000000
M46:    .word           0x00000000
M47:    .word           0x00000000
M48:    .word           0x00000000
M49:    .word           0x00000000
M4A:    .word           0x00000000
M4B:    .word           0x00000000
M4C:    .word           0x00000000
M4D:    .word           0x00000000
M4E:    .word           0x00000000
M4F:    .word           0x00000000

M50:    .word           0x00000000
M51:    .word           0x00000000
M52:    .word           0x00000000
M53:    .word           0x00000000
M54:    .word           0x00000000
M55:    .word           0x00000000
M56:    .word           0x00000000
M57:    .word           0x00000000
M58:    .word           0x00000000
M59:    .word           0x00000000
M5A:    .word           0x00000000
M5B:    .word           0x00000000
M5C:    .word           0x00000000
M5D:    .word           0x00000000
M5E:    .word           0x00000000
M5F:    .word           0x00000000

M60:    .word           0x00000000
M61:    .word           0x00000000
M62:    .word           0x00000000
M63:    .word           0x00000000
M64:    .word           0x00000000
M65:    .word           0x00000000
M66:    .word           0x00000000
M67:    .word           0x00000000
M68:    .word           0x00000000
M69:    .word           0x00000000
M6A:    .word           0x00000000
M6B:    .word           0x00000000
M6C:    .word           0x00000000
M6D:    .word           0x00000000
M6E:    .word           0x00000000
M6F:    .word           0x00000000

M70:    .word           0x00000000
M71:    .word           0x00000000
M72:    .word           0x00000000
M73:    .word           0x00000000
M74:    .word           0x00000000
M75:    .word           0x00000000
M76:    .word           0x00000000
M77:    .word           0x00000000
M78:    .word           0x00000000
M79:    .word           0x00000000
M7A:    .word           0x00000000
M7B:    .word           0x00000000
M7C:    .word           0x00000000
M7D:    .word           0x00000000
M7E:    .word           0x00000000
M7F:    .word           0x00000000

M80:    .word           0x00000000
M81:    .word           0x00000000
M82:    .word           0x00000000
M83:    .word           0x00000000
M84:    .word           0x00000000
M85:    .word           0x00000000
M86:    .word           0x00000000
M87:    .word           0x00000000
M88:    .word           0x00000000
M89:    .word           0x00000000
M8A:    .word           0x00000000
M8B:    .word           0x00000000
M8C:    .word           0x00000000
M8D:    .word           0x00000000
M8E:    .word           0x00000000
M8F:    .word           0x00000000

M90:    .word           0x00000000
M91:    .word           0x00000000
M92:    .word           0x00000000
M93:    .word           0x00000000
M94:    .word           0x00000000
M95:    .word           0x00000000
M96:    .word           0x00000000
M97:    .word           0x00000000
M98:    .word           0x00000000
M99:    .word           0x00000000
M9A:    .word           0x00000000
M9B:    .word           0x00000000
M9C:    .word           0x00000000
M9D:    .word           0x00000000
M9E:    .word           0x00000000
M9F:    .word           0x00000000

MA0:    .word           0x00000000
MA1:    .word           0x00000000
MA2:    .word           0x00000000
MA3:    .word           0x00000000
MA4:    .word           0x00000000
MA5:    .word           0x00000000
MA6:    .word           0x00000000
MA7:    .word           0x00000000
MA8:    .word           0x00000000
MA9:    .word           0x00000000
MAA:    .word           0x00000000
MAB:    .word           0x00000000
MAC:    .word           0x00000000
MAD:    .word           0x00000000
MAE:    .word           0x00000000
MAF:    .word           0x00000000

MB0:    .word           0x00000000
MB1:    .word           0x00000000
MB2:    .word           0x00000000
MB3:    .word           0x00000000
MB4:    .word           0x00000000
MB5:    .word           0x00000000
MB6:    .word           0x00000000
MB7:    .word           0x00000000
MB8:    .word           0x00000000
MB9:    .word           0x00000000
MBA:    .word           0x00000000
MBB:    .word           0x00000000
MBC:    .word           0x00000000
MBD:    .word           0x00000000
MBE:    .word           0x00000000
MBF:    .word           0x00000000

MC0:    .word           0x00000000
MC1:    .word           0x00000000
MC2:    .word           0x00000000
MC3:    .word           0x00000000
MC4:    .word           0x00000000
MC5:    .word           0x00000000
MC6:    .word           0x00000000
MC7:    .word           0x00000000
MC8:    .word           0x00000000
MC9:    .word           0x00000000
MCA:    .word           0x00000000
MCB:    .word           0x00000000
MCC:    .word           0x00000000
MCD:    .word           0x00000000
MCE:    .word           0x00000000
MCF:    .word           0x00000000

MD0:    .word           0x00000000
MD1:    .word           0x00000000
MD2:    .word           0x00000000
MD3:    .word           0x00000000
MD4:    .word           0x00000000
MD5:    .word           0x00000000
MD6:    .word           0x00000000
MD7:    .word           0x00000000
MD8:    .word           0x00000000
MD9:    .word           0x00000000
MDA:    .word           0x00000000
MDB:    .word           0x00000000
MDC:    .word           0x00000000
MDD:    .word           0x00000000
MDE:    .word           0x00000000
MDF:    .word           0x00000000

ME0:    .word           0x00000000
ME1:    .word           0x00000000
ME2:    .word           0x00000000
ME3:    .word           0x00000000
ME4:    .word           0x00000000
ME5:    .word           0x00000000
ME6:    .word           0x00000000
ME7:    .word           0x00000000
ME8:    .word           0x00000000
ME9:    .word           0x00000000
MEA:    .word           0x00000000
MEB:    .word           0x00000000
MEC:    .word           0x00000000
MED:    .word           0x00000000
MEE:    .word           0x00000000
MEF:    .word           0x00000000

MF0:    .word           0x00000000
MF1:    .word           0x00000000
MF2:    .word           0x00000000
MF3:    .word           0x00000000
MF4:    .word           0x00000000
MF5:    .word           0x00000000
MF6:    .word           0x00000000
MF7:    .word           0x00000000
MF8:    .word           0x00000000
MF9:    .word           0x00000000
MFA:    .word           0x00000000
MFB:    .word           0x00000000
MFC:    .word           0x00000000
MFD:    .word           0x00000000
MFE:    .word           0x00000000
MFF:    .word           0x00000000





N00:    .word           0x00000000
N01:    .word           0x00000000
N02:    .word           0x00000000
N03:    .word           0x00000000
N04:    .word           0x00000000
N05:    .word           0x00000000
N06:    .word           0x00000000
N07:    .word           0x00000000
N08:    .word           0x00000000
N09:    .word           0x00000000
N0A:    .word           0x00000000
N0B:    .word           0x00000000
N0C:    .word           0x00000000
N0D:    .word           0x00000000
N0E:    .word           0x00000000
N0F:    .word           0x00000000

N10:    .word           0x00000000
N11:    .word           0x00000000
N12:    .word           0x00000000
N13:    .word           0x00000000
N14:    .word           0x00000000
N15:    .word           0x00000000
N16:    .word           0x00000000
N17:    .word           0x00000000
N18:    .word           0x00000000
N19:    .word           0x00000000
N1A:    .word           0x00000000
N1B:    .word           0x00000000
N1C:    .word           0x00000000
N1D:    .word           0x00000000
N1E:    .word           0x00000000
N1F:    .word           0x00000000

N20:    .word           0x00000000
N21:    .word           0x00000000
N22:    .word           0x00000000
N23:    .word           0x00000000
N24:    .word           0x00000000
N25:    .word           0x00000000
N26:    .word           0x00000000
N27:    .word           0x00000000
N28:    .word           0x00000000
N29:    .word           0x00000000
N2A:    .word           0x00000000
N2B:    .word           0x00000000
N2C:    .word           0x00000000
N2D:    .word           0x00000000
N2E:    .word           0x00000000
N2F:    .word           0x00000000

N30:    .word           0x00000000
N31:    .word           0x00000000
N32:    .word           0x00000000
N33:    .word           0x00000000
N34:    .word           0x00000000
N35:    .word           0x00000000
N36:    .word           0x00000000
N37:    .word           0x00000000
N38:    .word           0x00000000
N39:    .word           0x00000000
N3A:    .word           0x00000000
N3B:    .word           0x00000000
N3C:    .word           0x00000000
N3D:    .word           0x00000000
N3E:    .word           0x00000000
N3F:    .word           0x00000000

N40:    .word           0x00000000
N41:    .word           0x00000000
N42:    .word           0x00000000
N43:    .word           0x00000000
N44:    .word           0x00000000
N45:    .word           0x00000000
N46:    .word           0x00000000
N47:    .word           0x00000000
N48:    .word           0x00000000
N49:    .word           0x00000000
N4A:    .word           0x00000000
N4B:    .word           0x00000000
N4C:    .word           0x00000000
N4D:    .word           0x00000000
N4E:    .word           0x00000000
N4F:    .word           0x00000000

N50:    .word           0x00000000
N51:    .word           0x00000000
N52:    .word           0x00000000
N53:    .word           0x00000000
N54:    .word           0x00000000
N55:    .word           0x00000000
N56:    .word           0x00000000
N57:    .word           0x00000000
N58:    .word           0x00000000
N59:    .word           0x00000000
N5A:    .word           0x00000000
N5B:    .word           0x00000000
N5C:    .word           0x00000000
N5D:    .word           0x00000000
N5E:    .word           0x00000000
N5F:    .word           0x00000000

N60:    .word           0x00000000
N61:    .word           0x00000000
N62:    .word           0x00000000
N63:    .word           0x00000000
N64:    .word           0x00000000
N65:    .word           0x00000000
N66:    .word           0x00000000
N67:    .word           0x00000000
N68:    .word           0x00000000
N69:    .word           0x00000000
N6A:    .word           0x00000000
N6B:    .word           0x00000000
N6C:    .word           0x00000000
N6D:    .word           0x00000000
N6E:    .word           0x00000000
N6F:    .word           0x00000000

N70:    .word           0x00000000
N71:    .word           0x00000000
N72:    .word           0x00000000
N73:    .word           0x00000000
N74:    .word           0x00000000
N75:    .word           0x00000000
N76:    .word           0x00000000
N77:    .word           0x00000000
N78:    .word           0x00000000
N79:    .word           0x00000000
N7A:    .word           0x00000000
N7B:    .word           0x00000000
N7C:    .word           0x00000000
N7D:    .word           0x00000000
N7E:    .word           0x00000000
N7F:    .word           0x00000000

N80:    .word           0x00000000
N81:    .word           0x00000000
N82:    .word           0x00000000
N83:    .word           0x00000000
N84:    .word           0x00000000
N85:    .word           0x00000000
N86:    .word           0x00000000
N87:    .word           0x00000000
N88:    .word           0x00000000
N89:    .word           0x00000000
N8A:    .word           0x00000000
N8B:    .word           0x00000000
N8C:    .word           0x00000000
N8D:    .word           0x00000000
N8E:    .word           0x00000000
N8F:    .word           0x00000000

N90:    .word           0x00000000
N91:    .word           0x00000000
N92:    .word           0x00000000
N93:    .word           0x00000000
N94:    .word           0x00000000
N95:    .word           0x00000000
N96:    .word           0x00000000
N97:    .word           0x00000000
N98:    .word           0x00000000
N99:    .word           0x00000000
N9A:    .word           0x00000000
N9B:    .word           0x00000000
N9C:    .word           0x00000000
N9D:    .word           0x00000000
N9E:    .word           0x00000000
N9F:    .word           0x00000000

NA0:    .word           0x00000000
NA1:    .word           0x00000000
NA2:    .word           0x00000000
NA3:    .word           0x00000000
NA4:    .word           0x00000000
NA5:    .word           0x00000000
NA6:    .word           0x00000000
NA7:    .word           0x00000000
NA8:    .word           0x00000000
NA9:    .word           0x00000000
NAA:    .word           0x00000000
NAB:    .word           0x00000000
NAC:    .word           0x00000000
NAD:    .word           0x00000000
NAE:    .word           0x00000000
NAF:    .word           0x00000000

NB0:    .word           0x00000000
NB1:    .word           0x00000000
NB2:    .word           0x00000000
NB3:    .word           0x00000000
NB4:    .word           0x00000000
NB5:    .word           0x00000000
NB6:    .word           0x00000000
NB7:    .word           0x00000000
NB8:    .word           0x00000000
NB9:    .word           0x00000000
NBA:    .word           0x00000000
NBB:    .word           0x00000000
NBC:    .word           0x00000000
NBD:    .word           0x00000000
NBE:    .word           0x00000000
NBF:    .word           0x00000000

NC0:    .word           0x00000000
NC1:    .word           0x00000000
NC2:    .word           0x00000000
NC3:    .word           0x00000000
NC4:    .word           0x00000000
NC5:    .word           0x00000000
NC6:    .word           0x00000000
NC7:    .word           0x00000000
NC8:    .word           0x00000000
NC9:    .word           0x00000000
NCA:    .word           0x00000000
NCB:    .word           0x00000000
NCC:    .word           0x00000000
NCD:    .word           0x00000000
NCE:    .word           0x00000000
NCF:    .word           0x00000000

ND0:    .word           0x00000000
ND1:    .word           0x00000000
ND2:    .word           0x00000000
ND3:    .word           0x00000000
ND4:    .word           0x00000000
ND5:    .word           0x00000000
ND6:    .word           0x00000000
ND7:    .word           0x00000000
ND8:    .word           0x00000000
ND9:    .word           0x00000000
NDA:    .word           0x00000000
NDB:    .word           0x00000000
NDC:    .word           0x00000000
NDD:    .word           0x00000000
NDE:    .word           0x00000000
NDF:    .word           0x00000000

NE0:    .word           0x00000000
NE1:    .word           0x00000000
NE2:    .word           0x00000000
NE3:    .word           0x00000000
NE4:    .word           0x00000000
NE5:    .word           0x00000000
NE6:    .word           0x00000000
NE7:    .word           0x00000000
NE8:    .word           0x00000000
NE9:    .word           0x00000000
NEA:    .word           0x00000000
NEB:    .word           0x00000000
NEC:    .word           0x00000000
NED:    .word           0x00000000
NEE:    .word           0x00000000
NEF:    .word           0x00000000

NF0:    .word           0x00000000
NF1:    .word           0x00000000
NF2:    .word           0x00000000
NF3:    .word           0x00000000
NF4:    .word           0x00000000
NF5:    .word           0x00000000
NF6:    .word           0x00000000
NF7:    .word           0x00000000
NF8:    .word           0x00000000
NF9:    .word           0x00000000
NFA:    .word           0x00000000
NFB:    .word           0x00000000
NFC:    .word           0x00000000
NFD:    .word           0x00000000
NFE:    .word           0x00000000
NFF:    .word           0x00000000


O00:    .word           0x00000000
O01:    .word           0x00000000
O02:    .word           0x00000000
O03:    .word           0x00000000
O04:    .word           0x00000000
O05:    .word           0x00000000
O06:    .word           0x00000000
O07:    .word           0x00000000
O08:    .word           0x00000000
O09:    .word           0x00000000
O0A:    .word           0x00000000
O0B:    .word           0x00000000
O0C:    .word           0x00000000
O0D:    .word           0x00000000
O0E:    .word           0x00000000
O0F:    .word           0x00000000

O10:    .word           0x00000000
O11:    .word           0x00000000
O12:    .word           0x00000000
O13:    .word           0x00000000
O14:    .word           0x00000000
O15:    .word           0x00000000
O16:    .word           0x00000000
O17:    .word           0x00000000
O18:    .word           0x00000000
O19:    .word           0x00000000
O1A:    .word           0x00000000
O1B:    .word           0x00000000
O1C:    .word           0x00000000
O1D:    .word           0x00000000
O1E:    .word           0x00000000
O1F:    .word           0x00000000

O20:    .word           0x00000000
O21:    .word           0x00000000
O22:    .word           0x00000000
O23:    .word           0x00000000
O24:    .word           0x00000000
O25:    .word           0x00000000
O26:    .word           0x00000000
O27:    .word           0x00000000
O28:    .word           0x00000000
O29:    .word           0x00000000
O2A:    .word           0x00000000
O2B:    .word           0x00000000
O2C:    .word           0x00000000
O2D:    .word           0x00000000
O2E:    .word           0x00000000
O2F:    .word           0x00000000

O30:    .word           0x00000000
O31:    .word           0x00000000
O32:    .word           0x00000000
O33:    .word           0x00000000
O34:    .word           0x00000000
O35:    .word           0x00000000
O36:    .word           0x00000000
O37:    .word           0x00000000
O38:    .word           0x00000000
O39:    .word           0x00000000
O3A:    .word           0x00000000
O3B:    .word           0x00000000
O3C:    .word           0x00000000
O3D:    .word           0x00000000
O3E:    .word           0x00000000
O3F:    .word           0x00000000

O40:    .word           0x00000000
O41:    .word           0x00000000
O42:    .word           0x00000000
O43:    .word           0x00000000
O44:    .word           0x00000000
O45:    .word           0x00000000
O46:    .word           0x00000000
O47:    .word           0x00000000
O48:    .word           0x00000000
O49:    .word           0x00000000
O4A:    .word           0x00000000
O4B:    .word           0x00000000
O4C:    .word           0x00000000
O4D:    .word           0x00000000
O4E:    .word           0x00000000
O4F:    .word           0x00000000

O50:    .word           0x00000000
O51:    .word           0x00000000
O52:    .word           0x00000000
O53:    .word           0x00000000
O54:    .word           0x00000000
O55:    .word           0x00000000
O56:    .word           0x00000000
O57:    .word           0x00000000
O58:    .word           0x00000000
O59:    .word           0x00000000
O5A:    .word           0x00000000
O5B:    .word           0x00000000
O5C:    .word           0x00000000
O5D:    .word           0x00000000
O5E:    .word           0x00000000
O5F:    .word           0x00000000

O60:    .word           0x00000000
O61:    .word           0x00000000
O62:    .word           0x00000000
O63:    .word           0x00000000
O64:    .word           0x00000000
O65:    .word           0x00000000
O66:    .word           0x00000000
O67:    .word           0x00000000
O68:    .word           0x00000000
O69:    .word           0x00000000
O6A:    .word           0x00000000
O6B:    .word           0x00000000
O6C:    .word           0x00000000
O6D:    .word           0x00000000
O6E:    .word           0x00000000
O6F:    .word           0x00000000

O70:    .word           0x00000000
O71:    .word           0x00000000
O72:    .word           0x00000000
O73:    .word           0x00000000
O74:    .word           0x00000000
O75:    .word           0x00000000
O76:    .word           0x00000000
O77:    .word           0x00000000
O78:    .word           0x00000000
O79:    .word           0x00000000
O7A:    .word           0x00000000
O7B:    .word           0x00000000
O7C:    .word           0x00000000
O7D:    .word           0x00000000
O7E:    .word           0x00000000
O7F:    .word           0x00000000

O80:    .word           0x00000000
O81:    .word           0x00000000
O82:    .word           0x00000000
O83:    .word           0x00000000
O84:    .word           0x00000000
O85:    .word           0x00000000
O86:    .word           0x00000000
O87:    .word           0x00000000
O88:    .word           0x00000000
O89:    .word           0x00000000
O8A:    .word           0x00000000
O8B:    .word           0x00000000
O8C:    .word           0x00000000
O8D:    .word           0x00000000
O8E:    .word           0x00000000
O8F:    .word           0x00000000

O90:    .word           0x00000000
O91:    .word           0x00000000
O92:    .word           0x00000000
O93:    .word           0x00000000
O94:    .word           0x00000000
O95:    .word           0x00000000
O96:    .word           0x00000000
O97:    .word           0x00000000
O98:    .word           0x00000000
O99:    .word           0x00000000
O9A:    .word           0x00000000
O9B:    .word           0x00000000
O9C:    .word           0x00000000
O9D:    .word           0x00000000
O9E:    .word           0x00000000
O9F:    .word           0x00000000

OA0:    .word           0x00000000
OA1:    .word           0x00000000
OA2:    .word           0x00000000
OA3:    .word           0x00000000
OA4:    .word           0x00000000
OA5:    .word           0x00000000
OA6:    .word           0x00000000
OA7:    .word           0x00000000
OA8:    .word           0x00000000
OA9:    .word           0x00000000
OAA:    .word           0x00000000
OAB:    .word           0x00000000
OAC:    .word           0x00000000
OAD:    .word           0x00000000
OAE:    .word           0x00000000
OAF:    .word           0x00000000

OB0:    .word           0x00000000
OB1:    .word           0x00000000
OB2:    .word           0x00000000
OB3:    .word           0x00000000
OB4:    .word           0x00000000
OB5:    .word           0x00000000
OB6:    .word           0x00000000
OB7:    .word           0x00000000
OB8:    .word           0x00000000
OB9:    .word           0x00000000
OBA:    .word           0x00000000
OBB:    .word           0x00000000
OBC:    .word           0x00000000
OBD:    .word           0x00000000
OBE:    .word           0x00000000
OBF:    .word           0x00000000

OC0:    .word           0x00000000
OC1:    .word           0x00000000
OC2:    .word           0x00000000
OC3:    .word           0x00000000
OC4:    .word           0x00000000
OC5:    .word           0x00000000
OC6:    .word           0x00000000
OC7:    .word           0x00000000
OC8:    .word           0x00000000
OC9:    .word           0x00000000
OCA:    .word           0x00000000
OCB:    .word           0x00000000
OCC:    .word           0x00000000
OCD:    .word           0x00000000
OCE:    .word           0x00000000
OCF:    .word           0x00000000

OD0:    .word           0x00000000
OD1:    .word           0x00000000
OD2:    .word           0x00000000
OD3:    .word           0x00000000
OD4:    .word           0x00000000
OD5:    .word           0x00000000
OD6:    .word           0x00000000
OD7:    .word           0x00000000
OD8:    .word           0x00000000
OD9:    .word           0x00000000
ODA:    .word           0x00000000
ODB:    .word           0x00000000
ODC:    .word           0x00000000
ODD:    .word           0x00000000
ODE:    .word           0x00000000
ODF:    .word           0x00000000

OE0:    .word           0x00000000
OE1:    .word           0x00000000
OE2:    .word           0x00000000
OE3:    .word           0x00000000
OE4:    .word           0x00000000
OE5:    .word           0x00000000
OE6:    .word           0x00000000
OE7:    .word           0x00000000
OE8:    .word           0x00000000
OE9:    .word           0x00000000
OEA:    .word           0x00000000
OEB:    .word           0x00000000
OEC:    .word           0x00000000
OED:    .word           0x00000000
OEE:    .word           0x00000000
OEF:    .word           0x00000000

OF0:    .word           0x00000000
OF1:    .word           0x00000000
OF2:    .word           0x00000000
OF3:    .word           0x00000000
OF4:    .word           0x00000000
OF5:    .word           0x00000000
OF6:    .word           0x00000000
OF7:    .word           0x00000000
OF8:    .word           0x00000000
OF9:    .word           0x00000000
OFA:    .word           0x00000000
OFB:    .word           0x00000000
OFC:    .word           0x00000000
OFD:    .word           0x00000000
OFE:    .word           0x00000000
OFF:    .word           0x00000000


