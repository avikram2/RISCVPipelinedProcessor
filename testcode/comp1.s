
# COPYRIGHT 2020 University of Illinois at Urbana-Champaign
# All rights reserved.

	.file	"comp1.c"
	.option nopic
	.text
	.align	2
	.globl	_start
	.hidden	_start
	.type	_start, @function
_start:
	li	sp,0x84000000
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s10,4(sp)
	li	s10,-553656320
	addi	s10,s10,-257
	call	test_uncorrelated_branches
	mv	s0,a0
	call	test_correlated_branches
	or	s0,s0,a0
	call	test_mixed
	or	s0,s0,a0
	li	a0,12
	call	fib
	beqz	s0,.L43
	li	s10,12247040
	addi	s10,s10,-1107
	j	.L44
.L43:
	li	s10,1611489280
	addi	s10,s10,13
.L44:
.L45:
	j	.L45
	.size	_start, .-_start
	.align	2
	.globl	uncorrelated_branches_kernel
	.hidden	uncorrelated_branches_kernel
	.type	uncorrelated_branches_kernel, @function
uncorrelated_branches_kernel:
	mv	a5,a0
	andi	a0,a0,1
	andi	a4,a5,2
	beqz	a4,.L2
	ori	a0,a0,2
.L2:
	andi	a4,a5,4
	beqz	a4,.L3
	ori	a0,a0,4
.L3:
	andi	a4,a5,8
	beqz	a4,.L4
	ori	a0,a0,8
.L4:
	andi	a4,a5,16
	beqz	a4,.L5
	ori	a0,a0,16
.L5:
	andi	a4,a5,32
	beqz	a4,.L6
	ori	a0,a0,32
.L6:
	andi	a4,a5,64
	beqz	a4,.L7
	ori	a0,a0,64
.L7:
	slli	a5,a5,24
	srai	a5,a5,24
	bgez	a5,.L8
	ori	a0,a0,128
.L8:
	ret
	.size	uncorrelated_branches_kernel, .-uncorrelated_branches_kernel
	.align	2
	.globl	correlated_branches_kernel
	.hidden	correlated_branches_kernel
	.type	correlated_branches_kernel, @function
correlated_branches_kernel:
	mv	a5,a0
	andi	a2,a0,1
	andi	a4,a0,3
	li	a3,3
	beq	a4,a3,.L10
	mv	a4,a2
.L10:
	andi	a3,a5,7
	li	a2,7
	beq	a3,a2,.L11
	mv	a3,a4
.L11:
	andi	a4,a5,15
	li	a2,15
	beq	a4,a2,.L12
	mv	a4,a3
.L12:
	andi	a3,a5,31
	li	a2,31
	beq	a3,a2,.L13
	mv	a3,a4
.L13:
	andi	a4,a5,63
	li	a2,63
	beq	a4,a2,.L14
	mv	a4,a3
.L14:
	andi	a0,a5,127
	li	a3,127
	beq	a0,a3,.L15
	mv	a0,a4
.L15:
	li	a4,255
	bne	a5,a4,.L16
	mv	a0,a5
.L16:
	ret
	.size	correlated_branches_kernel, .-correlated_branches_kernel
	.align	2
	.globl	test_uncorrelated_branches
	.hidden	test_uncorrelated_branches
	.type	test_uncorrelated_branches, @function
test_uncorrelated_branches:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	li	s0,0
	li	s1,255
.L20:
	mv	a0,s0
	call	uncorrelated_branches_kernel
	andi	a0,a0,0xff
	bne	a0,s0,.L21
	addi	s0,s0,1
	andi	s0,s0,0xff
	bne	s0,s1,.L20
	li	a0,0
	j	.L18
.L21:
	li	a0,1
.L18:
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
	.size	test_uncorrelated_branches, .-test_uncorrelated_branches
	.align	2
	.globl	test_correlated_branches
	.hidden	test_correlated_branches
	.type	test_correlated_branches, @function
test_correlated_branches:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	li	s0,0
	li	s1,255
.L26:
	mv	a0,s0
	call	correlated_branches_kernel
	not	a5,s0
	slli	a5,a5,24
	srai	a5,a5,24
	addi	s0,s0,1
	andi	s0,s0,0xff
	and	a5,a5,s0
	addi	a5,a5,-1
	andi	a0,a0,0xff
	andi	a5,a5,0xff
	bne	a0,a5,.L27
	bne	s0,s1,.L26
	li	a0,0
	j	.L24
.L27:
	li	a0,1
.L24:
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
	.size	test_correlated_branches, .-test_correlated_branches
	.align	2
	.globl	test_mixed
	.hidden	test_mixed
	.type	test_mixed, @function
test_mixed:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	sw	s2,0(sp)
	li	s0,0
	li	s2,255
.L32:
	mv	a0,s0
	call	uncorrelated_branches_kernel
	mv	s1,a0
	mv	a0,s0
	call	correlated_branches_kernel
	andi	a0,a0,0xff
	not	a5,s0
	slli	a5,a5,24
	srai	a5,a5,24
	addi	a4,s0,1
	andi	a4,a4,0xff
	and	a5,a5,a4
	addi	a5,a5,-1
	andi	a5,a5,0xff
	andi	s1,s1,0xff
	bne	s1,s0,.L33
	bne	a0,a5,.L34
	mv	s0,a4
	bne	a4,s2,.L32
	li	a0,0
	j	.L30
.L33:
	li	a0,1
	j	.L30
.L34:
	li	a0,1
.L30:
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	lw	s2,0(sp)
	addi	sp,sp,16
	jr	ra
	.size	test_mixed, .-test_mixed
	.align	2
	.globl	fib
	.hidden	fib
	.type	fib, @function
fib:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	mv	s0,a0
	li	a5,1
	ble	a0,a5,.L38
	addi	a0,a0,-1
	call	fib
	mv	s1,a0
	addi	a0,s0,-2
	call	fib
	add	s0,s1,a0
.L38:
	mv	a0,s0
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
	.size	fib, .-fib
	.align	2
	.globl	test_function_call
	.hidden	test_function_call
	.type	test_function_call, @function
test_function_call:
	addi	sp,sp,-16
	sw	ra,12(sp)
	li	a0,12
	call	fib
	li	a0,0
	lw	ra,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	test_function_call, .-test_function_call
	.ident	"GCC: (GNU) 7.2.0"
