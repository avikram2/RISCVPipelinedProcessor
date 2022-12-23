
# COPYRIGHT 2020 University of Illinois at Urbana-Champaign
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

	.file	"comp2.c"
	.option nopic
	.globl	__modsi3
	.text
	.align	2
	.globl	_start
	.hidden	_start
	.type	_start, @function
_start:
	li	sp,0x84000000
	addi	sp,sp,-704
	sw	ra,700(sp)
	sw	s0,696(sp)
	sw	s1,692(sp)
	sw	s2,688(sp)
	sw	s3,684(sp)
	sw	s4,680(sp)
	sw	s5,676(sp)
	sw	s10,672(sp)
	li	s10,-553656320
	addi	s10,s10,-257
	li	a5,60
	sw	a5,96(sp)
	li	s1,1
	li	s2,144
.L26:
	addi	s4,s1,-1
	li	a1,12
	mv	a0,s1
	call	__udivsi3
	mv	s0,a0
	li	a1,12
	mv	a0,s1
	call	__umodsi3
	slli	a4,s0,1
	add	a4,a4,s0
	slli	a5,a4,2
	mv	a4,a5
	add	s0,a5,a0
	slli	s0,s0,2
	addi	a5,sp,672
	add	s0,a5,s0
	li	a1,12
	mv	a0,s4
	call	__udivsi3
	mv	s3,a0
	li	a1,12
	mv	a0,s4
	call	__umodsi3
	slli	a4,s3,1
	add	a4,a4,s3
	slli	a5,a4,2
	mv	a4,a5
	add	a5,a5,a0
	slli	a5,a5,2
	addi	a4,sp,672
	add	a5,a4,a5
	lw	a5,-576(a5)
	slli	a0,a5,3
	sub	a0,a0,a5
	li	a1,41
	addi	a0,a0,29
	call	__modsi3
	sw	a0,-576(s0)
	addi	s1,s1,1
	bne	s1,s2,.L26
	addi	s0,sp,96
	mv	s3,sp
	addi	s2,sp,672
	mv	s1,s3
.L27:
	li	a1,12
	mv	a0,s0
	call	iter
	sw	a0,0(s1)
	sw	a1,4(s1)
	addi	s0,s0,48
	addi	s1,s1,8
	bne	s0,s2,.L27
	li	s0,1
	li	s2,0
	li	s1,0
	li	s4,0
	li	s5,13
.L36:
	lw	a2,0(s3)
	lw	a3,4(s3)
	mv	a0,s0
	mv	a1,s2
	call	__muldi3
	add	a4,s1,a0
	sltu	a5,a4,s1
	add	a3,s4,a1
	add	a5,a5,a3
	mv	a3,a5
	mv	s1,a4
	mv	s4,a5
	addi	s3,s3,8
	addi	a5,s0,1
	sltu	a4,a5,s0
	mv	s0,a5
	add	s2,a4,s2
	bne	a5,s5,.L36
	bnez	s2,.L36
	li	a5,76505088
	addi	a5,a5,-96
	bne	s1,a5,.L33
	li	a5,18
	beq	a3,a5,.L37
.L33:
	li	a5,195936256
	addi	a5,a5,222
	j	.L29
.L37:
	li	a5,1611489280
	addi	a5,a5,13
.L29:
	mv	s10,a5
.L31:
	j	.L31
	.size	_start, .-_start
	.align	2
	.globl	gcd
	.hidden	gcd
	.type	gcd, @function
gcd:
	or	a5,a0,a1
	beqz	a5,.L8
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	mv	s1,a1
	bge	a0,a1,.L3
	mv	a5,a0
	mv	a0,a1
	mv	s1,a5
.L3:
	beqz	a0,.L9
	bnez	s1,.L4
	mv	s1,a0
	j	.L5
.L6:
	mv	a1,s0
	mv	a0,s1
	call	__modsi3
	mv	s1,s0
	mv	s0,a0
.L7:
	bnez	s0,.L6
	j	.L5
.L8:
	li	a0,1
	ret
.L9:
	mv	a0,s1
	j	.L1
.L5:
	mv	a0,s1
	j	.L1
.L4:
	mv	a1,s1
	call	__modsi3
	mv	s0,a0
	j	.L7
.L1:
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
	.size	gcd, .-gcd
	.globl	__divsi3
	.globl	__muldi3
	.align	2
	.globl	lcm
	.hidden	lcm
	.type	lcm, @function
lcm:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	mv	s0,a0
	mv	s1,a1
	call	gcd
	mv	a1,a0
	mv	a0,s1
	call	__divsi3
	mv	a2,s0
	srai	a3,s0,31
	srai	a1,a0,31
	call	__muldi3
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
	.size	lcm, .-lcm
	.align	2
	.globl	iter
	.hidden	iter
	.type	iter, @function
iter:
	beqz	a1,.L19
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	mv	s1,a0
	mv	a5,a1
	lw	a0,0(a0)
	srai	a1,a0,31
	li	a4,1
	ble	a5,a4,.L16
	addi	s0,s1,4
	slli	a5,a5,2
	add	s1,s1,a5
.L18:
	lw	a1,0(s0)
	call	lcm
	addi	s0,s0,4
	bne	s0,s1,.L18
	j	.L16
.L19:
	li	a0,-1
	li	a1,-1
	ret
.L16:
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
	.size	iter, .-iter
	.globl	__udivsi3
	.globl	__umodsi3
	.align	2
	.globl	__udivmodsi4
	.hidden	__udivmodsi4
	.type	__udivmodsi4, @function
__udivmodsi4:
	bgeu	a1,a0,.L48
	bltz	a1,.L49
	li	a5,1
.L44:
	slli	a1,a1,1
	slli	a5,a5,1
	bgtu	a0,a1,.L41
	mv	a4,a5
	beqz	a5,.L43
	j	.L42
.L41:
	beqz	a5,.L50
	bgez	a1,.L44
.L42:
	li	a4,0
.L46:
	bltu	a0,a1,.L45
	sub	a0,a0,a1
	or	a4,a4,a5
.L45:
	srli	a5,a5,1
	srli	a1,a1,1
	bnez	a5,.L46
	j	.L43
.L50:
	mv	a4,a5
.L43:
	bnez	a2,.L39
	mv	a0,a4
	ret
.L48:
	li	a5,1
	j	.L42
.L49:
	li	a5,1
	j	.L42
.L39:
	ret
	.size	__udivmodsi4, .-__udivmodsi4
	.align	2
	.globl	__divsi3
	.hidden	__divsi3
	.type	__divsi3, @function
__divsi3:
	addi	sp,sp,-16
	sw	ra,12(sp)
	bgez	a0,.L54
	sub	a0,zero,a0
	bltz	a1,.L55
	j	.L60
.L57:
	sub	a0,zero,a0
	j	.L53
.L60:
	li	a2,0
	call	__udivmodsi4
	j	.L57
.L59:
	li	a2,0
	call	__udivmodsi4
	j	.L53
.L54:
	bgez	a1,.L59
	li	a2,0
	sub	a1,zero,a1
	call	__udivmodsi4
	j	.L57
.L55:
	li	a2,0
	sub	a1,zero,a1
	call	__udivmodsi4
.L53:
	lw	ra,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	__divsi3, .-__divsi3
	.align	2
	.globl	__modsi3
	.hidden	__modsi3
	.type	__modsi3, @function
__modsi3:
	addi	sp,sp,-16
	sw	ra,12(sp)
	bgez	a0,.L63
	srai	a5,a1,31
	xor	a1,a5,a1
	li	a2,1
	sub	a1,a1,a5
	sub	a0,zero,a0
	call	__udivmodsi4
	sub	a0,zero,a0
	j	.L62
.L63:
	srai	a5,a1,31
	xor	a1,a5,a1
	li	a2,1
	sub	a1,a1,a5
	call	__udivmodsi4
.L62:
	lw	ra,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	__modsi3, .-__modsi3
	.align	2
	.globl	__udivsi3
	.hidden	__udivsi3
	.type	__udivsi3, @function
__udivsi3:
	addi	sp,sp,-16
	sw	ra,12(sp)
	li	a2,0
	call	__udivmodsi4
	lw	ra,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	__udivsi3, .-__udivsi3
	.align	2
	.globl	__umodsi3
	.hidden	__umodsi3
	.type	__umodsi3, @function
__umodsi3:
	addi	sp,sp,-16
	sw	ra,12(sp)
	li	a2,1
	call	__udivmodsi4
	lw	ra,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	__umodsi3, .-__umodsi3
	.align	2
	.globl	__muldi3
	.hidden	__muldi3
	.type	__muldi3, @function
__muldi3:
	mv	a7,a0
	mv	t1,a1
	mv	a5,a0
	or	a5,a0,a1
	beqz	a5,.L76
	li	a0,0
	li	a1,0
.L75:
	andi	a5,a7,1
	beqz	a5,.L73
	add	a5,a0,a2
	sltu	a0,a5,a0
	add	a4,a1,a3
	add	a1,a0,a4
	mv	a4,a1
	mv	a0,a5
.L73:
	slli	a4,t1,31
	srli	a5,a7,1
	or	a5,a4,a5
	srli	t3,t1,1
	mv	a7,a5
	mv	t1,t3
	srli	a6,a2,31
	slli	a4,a3,1
	mv	a3,a6
	or	a3,a6,a4
	slli	a2,a2,1
	mv	a4,a5
	or	a4,a5,t3
	bnez	a4,.L75
	ret
.L76:
	ret
	.size	__muldi3, .-__muldi3
	.ident	"GCC: (GNU) 7.2.0"
