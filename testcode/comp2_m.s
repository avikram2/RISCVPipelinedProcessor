
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
	sw	s10,680(sp)
	li	s10,-553656320
	addi	s10,s10,-257
	li	a5,60
	sw	a5,96(sp)
	li	a3,1
	li	a0,12
	li	t1,41
	li	a7,144
.L22:
	addi	a4,a3,-1
	divu	a5,a3,a0
	remu	a1,a3,a0
	slli	a2,a5,1
	add	a2,a2,a5
	slli	a5,a2,2
	mv	a2,a5
	add	a5,a5,a1
	slli	a5,a5,2
	addi	a2,sp,672
	add	a5,a2,a5
	divu	a6,a4,a0
	remu	a2,a4,a0
	slli	a1,a6,1
	add	a1,a1,a6
	slli	a4,a1,2
	mv	a1,a4
	add	a4,a4,a2
	slli	a4,a4,2
	addi	a2,sp,672
	add	a4,a2,a4
	lw	a2,-576(a4)
	slli	a4,a2,3
	sub	a4,a4,a2
	addi	a4,a4,29
	rem	a4,a4,t1
	sw	a4,-576(a5)
	addi	a3,a3,1
	bne	a3,a7,.L22
	addi	s1,sp,96
	mv	s0,sp
	addi	s3,sp,672
	mv	s2,s0
.L23:
	li	a1,12
	mv	a0,s1
	call	iter
	sw	a0,0(s2)
	sw	a1,4(s2)
	addi	s1,s1,48
	addi	s2,s2,8
	bne	s1,s3,.L23
	li	a5,1
	li	a0,0
	li	a3,0
	li	a4,0
	li	a7,13
.L32:
	lw	a1,0(s0)
	mul	a2,a1,a0
	lw	a6,4(s0)
	mul	a6,a6,a5
	add	a2,a2,a6
	mul	t1,a1,a5
	mulhu	a1,a1,a5
	add	a2,a2,a1
	mv	a1,a2
	add	a1,a3,t1
	sltu	a3,a1,a3
	add	a6,a4,a2
	add	a4,a3,a6
	mv	a6,a4
	mv	a3,a1
	addi	s0,s0,8
	addi	a2,a5,1
	sltu	a1,a2,a5
	mv	a5,a2
	add	a0,a1,a0
	bne	a2,a7,.L32
	bnez	a0,.L32
	li	a5,76505088
	addi	a5,a5,-96
	bne	a3,a5,.L29
	li	a5,18
	beq	a4,a5,.L33
.L29:
	li	a5,195936256
	addi	a5,a5,222
	j	.L25
.L33:
	li	a5,1611489280
	addi	a5,a5,13
.L25:
	mv	s10,a5
.L27:
	j	.L27
	.size	_start, .-_start
	.align	2
	.globl	gcd
	.hidden	gcd
	.type	gcd, @function
gcd:
	or	a5,a0,a1
	beqz	a5,.L8
	bge	a0,a1,.L3
	mv	a5,a0
	mv	a0,a1
	mv	a1,a5
.L3:
	beqz	a0,.L9
	bnez	a1,.L4
	mv	a1,a0
	j	.L5
.L6:
	rem	a4,a1,a5
	mv	a1,a5
	mv	a5,a4
.L7:
	bnez	a5,.L6
	j	.L5
.L8:
	li	a0,1
	ret
.L9:
	mv	a0,a1
	ret
.L5:
	mv	a0,a1
	ret
.L4:
	rem	a5,a0,a1
	j	.L7
	.size	gcd, .-gcd
	.align	2
	.globl	lcm
	.hidden	lcm
	.type	lcm, @function
lcm:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	mv	s1,a0
	mv	s0,a1
	call	gcd
	div	a0,s0,a0
	srai	a1,a0,31
	srai	a5,s1,31
	mul	a1,a1,s1
	mul	a5,a5,a0
	add	a1,a1,a5
	mulhu	a5,a0,s1
	add	a1,a1,a5
	mv	a5,a1
	mul	a0,a0,s1
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
	beqz	a1,.L15
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s1,4(sp)
	mv	s1,a0
	mv	a5,a1
	lw	a0,0(a0)
	srai	a1,a0,31
	li	a4,1
	ble	a5,a4,.L12
	addi	s0,s1,4
	slli	a5,a5,2
	add	s1,s1,a5
.L14:
	lw	a1,0(s0)
	call	lcm
	addi	s0,s0,4
	bne	s0,s1,.L14
	j	.L12
.L15:
	li	a0,-1
	li	a1,-1
	ret
.L12:
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
	.size	iter, .-iter
	.align	2
	.globl	__udivmodsi4
	.hidden	__udivmodsi4
	.type	__udivmodsi4, @function
__udivmodsi4:
	bgeu	a1,a0,.L44
	bltz	a1,.L45
	li	a5,1
.L40:
	slli	a1,a1,1
	slli	a5,a5,1
	bgtu	a0,a1,.L37
	mv	a4,a5
	beqz	a5,.L39
	j	.L38
.L37:
	beqz	a5,.L46
	bgez	a1,.L40
.L38:
	li	a4,0
.L42:
	bltu	a0,a1,.L41
	sub	a0,a0,a1
	or	a4,a4,a5
.L41:
	srli	a5,a5,1
	srli	a1,a1,1
	bnez	a5,.L42
	j	.L39
.L46:
	mv	a4,a5
.L39:
	bnez	a2,.L35
	mv	a0,a4
	ret
.L44:
	li	a5,1
	j	.L38
.L45:
	li	a5,1
	j	.L38
.L35:
	ret
	.size	__udivmodsi4, .-__udivmodsi4
	.align	2
	.globl	__divsi3
	.hidden	__divsi3
	.type	__divsi3, @function
__divsi3:
	addi	sp,sp,-16
	sw	ra,12(sp)
	bgez	a0,.L50
	sub	a0,zero,a0
	bltz	a1,.L51
	j	.L56
.L53:
	sub	a0,zero,a0
	j	.L49
.L56:
	li	a2,0
	call	__udivmodsi4
	j	.L53
.L55:
	li	a2,0
	call	__udivmodsi4
	j	.L49
.L50:
	bgez	a1,.L55
	li	a2,0
	sub	a1,zero,a1
	call	__udivmodsi4
	j	.L53
.L51:
	li	a2,0
	sub	a1,zero,a1
	call	__udivmodsi4
.L49:
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
	bgez	a0,.L59
	srai	a5,a1,31
	xor	a1,a5,a1
	li	a2,1
	sub	a1,a1,a5
	sub	a0,zero,a0
	call	__udivmodsi4
	sub	a0,zero,a0
	j	.L58
.L59:
	srai	a5,a1,31
	xor	a1,a5,a1
	li	a2,1
	sub	a1,a1,a5
	call	__udivmodsi4
.L58:
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
	beqz	a5,.L72
	li	a0,0
	li	a1,0
.L71:
	andi	a5,a7,1
	beqz	a5,.L69
	add	a5,a0,a2
	sltu	a0,a5,a0
	add	a4,a1,a3
	add	a1,a0,a4
	mv	a4,a1
	mv	a0,a5
.L69:
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
	bnez	a4,.L71
	ret
.L72:
	ret
	.size	__muldi3, .-__muldi3
	.ident	"GCC: (GNU) 7.2.0"
