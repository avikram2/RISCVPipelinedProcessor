	.file	"cp2.c"
	.option nopic
	.text
	.align	1
	.globl	_start
	.type	_start, @function
_start:
	addi	sp,sp,-720
	sw	ra,716(sp)
	sw	s0,712(sp)
	sw	s2,708(sp)
	sw	s3,704(sp)
	sw	s4,700(sp)
	sw	s5,696(sp)
	sw	s10,692(sp)
	addi	s0,sp,720
	li	a5,-553656320
	addi	s10,a5,-257
	li	a5,60
	sw	a5,-624(s0)
	li	a5,1
	sw	a5,-36(s0)
	j	.L2
.L3:
	lw	a5,-36(s0)
	addi	a4,a5,-1
	li	a5,12
	divu	a4,a4,a5
	lw	a5,-36(s0)
	addi	a3,a5,-1
	li	a5,12
	remu	a3,a3,a5
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,2
	add	a5,a5,a3
	slli	a5,a5,2
	addi	a4,s0,-32
	add	a5,a4,a5
	lw	a4,-592(a5)
	mv	a5,a4
	slli	a5,a5,3
	sub	a5,a5,a4
	addi	a3,a5,29
	lw	a4,-36(s0)
	li	a5,12
	divu	a4,a4,a5
	lw	a2,-36(s0)
	li	a5,12
	remu	a2,a2,a5
	li	a5,41
	rem	a3,a3,a5
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,2
	add	a5,a5,a2
	slli	a5,a5,2
	addi	a4,s0,-32
	add	a5,a4,a5
	sw	a3,-592(a5)
	lw	a5,-36(s0)
	addi	a5,a5,1
	sw	a5,-36(s0)
.L2:
	lw	a4,-36(s0)
	li	a5,143
	bleu	a4,a5,.L3
	sw	zero,-36(s0)
	j	.L4
.L5:
	addi	a3,s0,-624
	lw	a4,-36(s0)
	mv	a5,a4
	slli	a5,a5,1
	add	a5,a5,a4
	slli	a5,a5,4
	add	a5,a3,a5
	li	a1,12
	mv	a0,a5
	call	iter
	mv	a5,a0
	mv	a6,a1
	mv	a3,a5
	mv	a4,a6
	lw	a5,-36(s0)
	slli	a5,a5,3
	addi	a2,s0,-32
	add	a5,a2,a5
	sw	a3,-688(a5)
	sw	a4,-684(a5)
	lw	a5,-36(s0)
	addi	a5,a5,1
	sw	a5,-36(s0)
.L4:
	lw	a4,-36(s0)
	li	a5,11
	bleu	a4,a5,.L5
	li	a5,0
	li	a6,0
	sw	a5,-48(s0)
	sw	a6,-44(s0)
	sw	zero,-36(s0)
	j	.L6
.L7:
	lw	a5,-36(s0)
	addi	a5,a5,1
	mv	s2,a5
	li	s3,0
	lw	a5,-36(s0)
	slli	a5,a5,3
	addi	a4,s0,-32
	add	a5,a4,a5
	lw	a6,-684(a5)
	lw	a5,-688(a5)
	mul	a3,s3,a5
	mul	a4,a6,s2
	add	a4,a3,a4
	mul	a3,s2,a5
	mulhu	s5,s2,a5
	mv	s4,a3
	add	a5,a4,s5
	mv	s5,a5
	lw	a3,-48(s0)
	lw	a4,-44(s0)
	add	a5,a3,s4
	mv	a2,a5
	sltu	a2,a2,a3
	add	a6,a4,s5
	add	a4,a2,a6
	mv	a6,a4
	sw	a5,-48(s0)
	sw	a6,-44(s0)
	lw	a5,-36(s0)
	addi	a5,a5,1
	sw	a5,-36(s0)
.L6:
	lw	a4,-36(s0)
	li	a5,11
	bleu	a4,a5,.L7
	lw	a4,-48(s0)
	li	a5,76505088
	addi	a5,a5,-96
	bne	a4,a5,.L8
	lw	a4,-44(s0)
	li	a5,18
	bne	a4,a5,.L8
	li	a5,1611489280
	addi	a5,a5,13
	j	.L9
.L8:
	li	a5,195936256
	addi	a5,a5,222
.L9:
	mv	s10,a5
.L10:
	j	.L10
	.size	_start, .-_start
	.align	1
	.globl	gcd
	.type	gcd, @function
gcd:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-36(s0)
	bnez	a5,.L12
	lw	a5,-40(s0)
	bnez	a5,.L12
	li	a5,1
	j	.L13
.L12:
	lw	a4,-36(s0)
	lw	a5,-40(s0)
	bge	a4,a5,.L15
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	lw	a5,-40(s0)
	sw	a5,-36(s0)
	lw	a5,-20(s0)
	sw	a5,-40(s0)
	j	.L15
.L17:
	lw	a4,-36(s0)
	lw	a5,-40(s0)
	rem	a5,a4,a5
	sw	a5,-20(s0)
	lw	a5,-40(s0)
	sw	a5,-36(s0)
	lw	a5,-20(s0)
	sw	a5,-40(s0)
.L15:
	lw	a5,-36(s0)
	beqz	a5,.L16
	lw	a5,-40(s0)
	bnez	a5,.L17
.L16:
	lw	a5,-36(s0)
	beqz	a5,.L18
	lw	a5,-36(s0)
	j	.L13
.L18:
	lw	a5,-40(s0)
.L13:
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	gcd, .-gcd
	.align	1
	.globl	lcm
	.type	lcm, @function
lcm:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s2,36(sp)
	sw	s3,32(sp)
	sw	s4,28(sp)
	sw	s5,24(sp)
	sw	s6,20(sp)
	sw	s7,16(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-36(s0)
	mv	s4,a5
	srai	a5,a5,31
	mv	s5,a5
	lw	a1,-40(s0)
	lw	a0,-36(s0)
	call	gcd
	mv	a4,a0
	lw	a5,-40(s0)
	div	a5,a5,a4
	mv	s2,a5
	srai	a5,a5,31
	mv	s3,a5
	mul	a4,s5,s2
	mul	a5,s3,s4
	add	a5,a4,a5
	mul	a4,s4,s2
	mulhu	s7,s4,s2
	mv	s6,a4
	add	a5,a5,s7
	mv	s7,a5
	mv	a5,s6
	mv	a6,s7
	mv	a0,a5
	mv	a1,a6
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s2,36(sp)
	lw	s3,32(sp)
	lw	s4,28(sp)
	lw	s5,24(sp)
	lw	s6,20(sp)
	lw	s7,16(sp)
	addi	sp,sp,48
	jr	ra
	.size	lcm, .-lcm
	.align	1
	.globl	iter
	.type	iter, @function
iter:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-40(s0)
	bnez	a5,.L23
	li	a5,-1
	li	a6,-1
	j	.L24
.L23:
	lw	a5,-36(s0)
	lw	a5,0(a5)
	sw	a5,-32(s0)
	srai	a5,a5,31
	sw	a5,-28(s0)
	li	a5,1
	sw	a5,-20(s0)
	j	.L25
.L26:
	lw	a3,-32(s0)
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	mv	a1,a5
	mv	a0,a3
	call	lcm
	sw	a0,-32(s0)
	sw	a1,-28(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L25:
	lw	a4,-20(s0)
	lw	a5,-40(s0)
	blt	a4,a5,.L26
	lw	a5,-32(s0)
	lw	a6,-28(s0)
.L24:
	mv	a0,a5
	mv	a1,a6
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	iter, .-iter
	.align	1
	.globl	__udivmodsi4
	.type	__udivmodsi4, @function
__udivmodsi4:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	li	a5,1
	sw	a5,-20(s0)
	sw	zero,-24(s0)
	j	.L28
.L30:
	lw	a5,-40(s0)
	slli	a5,a5,1
	sw	a5,-40(s0)
	lw	a5,-20(s0)
	slli	a5,a5,1
	sw	a5,-20(s0)
.L28:
	lw	a4,-40(s0)
	lw	a5,-36(s0)
	bgeu	a4,a5,.L31
	lw	a5,-20(s0)
	beqz	a5,.L31
	lw	a5,-40(s0)
	bgez	a5,.L30
	j	.L31
.L33:
	lw	a4,-36(s0)
	lw	a5,-40(s0)
	bltu	a4,a5,.L32
	lw	a4,-36(s0)
	lw	a5,-40(s0)
	sub	a5,a4,a5
	sw	a5,-36(s0)
	lw	a4,-24(s0)
	lw	a5,-20(s0)
	or	a5,a4,a5
	sw	a5,-24(s0)
.L32:
	lw	a5,-20(s0)
	srli	a5,a5,1
	sw	a5,-20(s0)
	lw	a5,-40(s0)
	srli	a5,a5,1
	sw	a5,-40(s0)
.L31:
	lw	a5,-20(s0)
	bnez	a5,.L33
	lw	a5,-44(s0)
	beqz	a5,.L34
	lw	a5,-36(s0)
	j	.L35
.L34:
	lw	a5,-24(s0)
.L35:
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	__udivmodsi4, .-__udivmodsi4
	.align	1
	.globl	__divsi3
	.type	__divsi3, @function
__divsi3:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	zero,-20(s0)
	lw	a5,-36(s0)
	bgez	a5,.L37
	lw	a5,-36(s0)
	sub	a5,zero,a5
	sw	a5,-36(s0)
	lw	a5,-20(s0)
	seqz	a5,a5
	andi	a5,a5,0xff
	sw	a5,-20(s0)
.L37:
	lw	a5,-40(s0)
	bgez	a5,.L38
	lw	a5,-40(s0)
	sub	a5,zero,a5
	sw	a5,-40(s0)
	lw	a5,-20(s0)
	seqz	a5,a5
	andi	a5,a5,0xff
	sw	a5,-20(s0)
.L38:
	lw	a5,-36(s0)
	lw	a4,-40(s0)
	li	a2,0
	mv	a1,a4
	mv	a0,a5
	call	__udivmodsi4
	mv	a5,a0
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	beqz	a5,.L39
	lw	a5,-24(s0)
	sub	a5,zero,a5
	sw	a5,-24(s0)
.L39:
	lw	a5,-24(s0)
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	__divsi3, .-__divsi3
	.align	1
	.globl	__modsi3
	.type	__modsi3, @function
__modsi3:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	zero,-20(s0)
	lw	a5,-36(s0)
	bgez	a5,.L42
	lw	a5,-36(s0)
	sub	a5,zero,a5
	sw	a5,-36(s0)
	li	a5,1
	sw	a5,-20(s0)
.L42:
	lw	a5,-40(s0)
	bgez	a5,.L43
	lw	a5,-40(s0)
	sub	a5,zero,a5
	sw	a5,-40(s0)
.L43:
	lw	a5,-36(s0)
	lw	a4,-40(s0)
	li	a2,1
	mv	a1,a4
	mv	a0,a5
	call	__udivmodsi4
	mv	a5,a0
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	beqz	a5,.L44
	lw	a5,-24(s0)
	sub	a5,zero,a5
	sw	a5,-24(s0)
.L44:
	lw	a5,-24(s0)
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	__modsi3, .-__modsi3
	.align	1
	.globl	__udivsi3
	.type	__udivsi3, @function
__udivsi3:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a5,-20(s0)
	lw	a4,-24(s0)
	li	a2,0
	mv	a1,a4
	mv	a0,a5
	call	__udivmodsi4
	mv	a5,a0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	__udivsi3, .-__udivsi3
	.align	1
	.globl	__umodsi3
	.type	__umodsi3, @function
__umodsi3:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a5,-20(s0)
	lw	a4,-24(s0)
	li	a2,1
	mv	a1,a4
	mv	a0,a5
	call	__udivmodsi4
	mv	a5,a0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	__umodsi3, .-__umodsi3
	.align	1
	.globl	__muldi3
	.type	__muldi3, @function
__muldi3:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-40(s0)
	sw	a1,-36(s0)
	sw	a2,-48(s0)
	sw	a3,-44(s0)
	li	a5,0
	li	a6,0
	sw	a5,-24(s0)
	sw	a6,-20(s0)
	j	.L51
.L54:
	lw	a5,-40(s0)
	andi	t1,a5,1
	lw	a5,-36(s0)
	andi	t2,a5,0
	mv	a5,t1
	or	a5,a5,t2
	beqz	a5,.L52
	lw	a3,-24(s0)
	lw	a4,-20(s0)
	lw	a1,-48(s0)
	lw	a2,-44(s0)
	add	a5,a3,a1
	mv	a0,a5
	sltu	a0,a0,a3
	add	a6,a4,a2
	add	a4,a0,a6
	mv	a6,a4
	sw	a5,-24(s0)
	sw	a6,-20(s0)
.L52:
	lw	a5,-36(s0)
	slli	a5,a5,31
	lw	a4,-40(s0)
	srli	a4,a4,1
	or	a5,a4,a5
	sw	a5,-40(s0)
	lw	a5,-36(s0)
	srli	a5,a5,1
	sw	a5,-36(s0)
	lw	a5,-48(s0)
	srli	a5,a5,31
	lw	a4,-44(s0)
	slli	a4,a4,1
	or	a5,a4,a5
	sw	a5,-44(s0)
	lw	a5,-48(s0)
	slli	a5,a5,1
	sw	a5,-48(s0)
.L51:
	lw	a5,-40(s0)
	lw	a4,-36(s0)
	or	a5,a5,a4
	bnez	a5,.L54
	lw	a5,-24(s0)
	lw	a6,-20(s0)
	mv	a0,a5
	mv	a1,a6
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	__muldi3, .-__muldi3
	.ident	"GCC: (GNU) 7.2.0"
